package kr.or.cwma.common.util;

import java.security.cert.CertificateException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.skill.user.mapper.UserMapper;
import signgate.core.provider.SignGATE;
import signgate.crypto.util.Base64Util;
import signgate.crypto.util.CertUtil;
import signgate.crypto.util.CipherUtil;
import signgate.crypto.util.FileUtil;
import signgate.crypto.util.InvalidBase64Exception;
import signgate.crypto.util.SignUtil;

@Service
public class KICACertUtil {
	@Value("#{prop['cert.kmCert']}")
	String kmCert;

	@Value("#{prop['cert.kmPri']}")
	String kmPri;

	@Value("#{prop['cert.crl']}")
	String crl;
	
	@Autowired
	UserMapper userMapper;
	
	public String getCertInfo(UserInfoVO vo){
		int nRemainDays = 0;
		byte[] binPasswd = null, binSessionKey = null, binRndNum = null;
		String msg = "", strOriginalMessage = "", strSubjectDn = null;
		
		CertUtil cert = null;
		SignUtil sign = new SignUtil();
		CipherUtil cipher = new CipherUtil();
		Map<String, String> dnMap = new HashMap<String, String>();
		Map<String, String> oidMap;
		
		try{
			binSessionKey = CipherUtil.decryptRSA(FileUtil.readBytesFromFileName(kmPri), "signgate1!", vo.getEncServerKey());

			if(binSessionKey == null)
				msg = "대칭키 복호화에 실패하였습니다.";

			if(StringUtils.isEmpty(msg)){
				cipher.decryptInit(binSessionKey);
				binPasswd = cipher.decryptUpdate(Base64Util.decode(vo.getEncPassword()));
				
				if(!StringUtils.isEmpty(vo.getEncRndNum()))
					binRndNum = cipher.decryptUpdate(Base64Util.decode(vo.getEncRndNum()));
				
				cipher.decryptFinal();
				
				if(binPasswd == null)
					msg = cipher.getErrorMsg();
				
				if(binRndNum == null && !StringUtils.isEmpty(vo.getEncRndNum()))
					msg = cipher.getErrorMsg();
			}

			if(StringUtils.isEmpty(msg)){
				strOriginalMessage = new String(binPasswd).concat(vo.getSignChk());
				sign.verifyInit(vo.getSignCert().getBytes());
				sign.verifyUpdate(strOriginalMessage.getBytes());

				if(!sign.verifyFinal(Base64Util.decode(vo.getSignValue())))
					msg = sign.getErrorMsg();
			}

		}catch(Exception e){
			msg = e.toString();

		}
		
		// 사용자의 전자서명용 인증서에서 각종 정보를 구한다.
		try{
			if(StringUtils.isEmpty(msg)){
				cert = new CertUtil(vo.getSignCert().getBytes());
				strSubjectDn = cert.getSubjectDN();
				cert.getNotBefore();
				cert.getNotAfter();
				cert.getSerialNumber();
				cert.getPolicyOid();
				nRemainDays = cert.getRemainDay();
				//String[] test = new String[]{cert.getType(), cert.getPolicyOid(), cert.getIssuerDN()};

				for(String dn : strSubjectDn.split(",")){
					if(!StringUtils.isEmpty(dn) && dn.split("=") != null && dn.split("=").length == 2)
						dnMap.put(dn.split("=")[0], dn.split("=")[1]);
				}
				
				oidMap = userMapper.selectOid(cert.getPolicyOid());

				if(oidMap == null || StringUtils.isEmpty(oidMap.get("OID")) || ("USSE0004".equals(vo.getSe()) && "PERSONAL".equals(oidMap.get("SE_CD")))){
					msg = "허용되지 않는 정책의 인증서입니다.";

				}else if(nRemainDays < 1){
					msg = "유효기간이 만료된 인증서입니다.";

				}else{
					if(!StringUtils.isEmpty(vo.getEncRndNum()) && oidMap.get("SE_CD").equals("CORP") && !cert.isValidUser(new String(binPasswd).replaceAll("-", ""), new String(binRndNum)))
						msg = "사용자 본인확인 검사에 실패하였습니다\n사업자등록번호를 확인해주세요";

					else if(!cert.isValid(true, crl))
						msg = cert.getErrorMsg();

					else{
						vo.setBizno(new String(binPasswd));
						vo.setDnValue(strSubjectDn);
						vo.setRetSysTime(System.currentTimeMillis());
					}
				}
			}

		}catch (CertificateException | SQLException e) {
			msg = "올바른 인증서가 아닙니다.";
		}

		return msg;
	}
	
	public String getCertInfoForMobile(UserInfoVO vo){
		int nRemainDays = 0;
		byte[] binPasswd = null;
		String msg = "", strSubjectDn = null;
		
		CertUtil cert = null;
		SignUtil sign = new SignUtil("SHA256withRSA");
		CipherUtil cipher = new CipherUtil("RSA");
		Map<String, String> dnMap = new HashMap<String, String>();
		Map<String, String> oidMap;
		
		try{
			SignGATE.addProvider();
			
			sign.verifyInit(Base64Util.decode(vo.getSignCert()));
			sign.verifyUpdate(vo.getSignChk().getBytes());
			cipher.decryptInit(FileUtil.readBytesFromFileName(kmPri), "signgate1!");

			if(!sign.verifyFinal(Base64Util.decode(vo.getSignValue())))
				msg = sign.getErrorMsg();
			
			if(!StringUtils.isEmpty(vo.getEncRndNum())){
				binPasswd = cipher.decryptUpdate(Base64Util.decode(vo.getEncRndNum()));
				cipher.decryptFinal();
			}

		}catch(Exception e){
			msg = e.toString();

		}
		
		// 사용자의 전자서명용 인증서에서 각종 정보를 구한다.
		try{
			if(StringUtils.isEmpty(msg)){
				cert = new CertUtil(Base64Util.decode(vo.getSignCert()));
				strSubjectDn = cert.getSubjectDN();
				cert.getNotBefore();
				cert.getNotAfter();
				cert.getSerialNumber();
				cert.getPolicyOid();
				nRemainDays = cert.getRemainDay();
				//String[] test = new String[]{cert.getType(), cert.getPolicyOid(), cert.getIssuerDN()};
				
				for(String dn : strSubjectDn.split(",")){
					if(!StringUtils.isEmpty(dn) && dn.split("=") != null && dn.split("=").length == 2)
						dnMap.put(dn.split("=")[0], dn.split("=")[1]);
				}
				
				oidMap = userMapper.selectOid(cert.getPolicyOid());

				if(oidMap == null || StringUtils.isEmpty(oidMap.get("OID")) || ("USSE0004".equals(vo.getSe()) && "PERSONAL".equals(oidMap.get("SE_CD")))){
					msg = "허용되지 않는 정책의 인증서입니다.";

				}else if(nRemainDays < 1){
					msg = "유효기간이 만료된 인증서입니다.";

				}else{
					if(!StringUtils.isEmpty(vo.getEncRndNum()) && oidMap.get("SE_CD").equals("CORP") && !cert.isValidUser(vo.getSignChk().replaceAll("-", ""), Base64Util.encode(binPasswd)))
						msg = "사용자 본인확인 검사에 실패하였습니다\n사업자등록번호를 확인해주세요";

					else if(!cert.isValid(true, crl))
						msg = cert.getErrorMsg();

					else{
						vo.setBizno(vo.getSignChk());
						vo.setDnValue(strSubjectDn);
						vo.setRetSysTime(System.currentTimeMillis());
					}
				}
			}

		}catch (CertificateException | SQLException | InvalidBase64Exception e) {
			msg = "올바른 인증서가 아닙니다.";
			
		}

		return msg;
	}
}
