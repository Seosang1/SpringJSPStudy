package kr.or.cwma.common.util;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import com.microsoft.sqlserver.jdbc.StringUtils;

import Kisinfo.Check.IPIN2Client;
import NiceID.Check.CPClient;
import common.NameCheck;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.vo.NiceIdVO;
import kr.or.cwma.skill.user.service.UserService;

@Component
public class NiceIdUtil{
	@Value("#{prop['niceId.id']}")
	private String authId; //본인인증 id
	
	@Value("#{prop['niceId.pwd']}")
	private String authPwd; //본인인증 pwd
	
	@Value("#{prop['niceId.ipinId']}")
	private String ipinId; //ipin id
	
	@Value("#{prop['niceId.ipinPwd']}")
	private String ipinPwd; //ipin pwd
	
	@Value("#{prop['niceId.juminId']}")
	private String juminId; //실명확인 id
	
	@Value("#{prop['niceId.juminPwd']}")
	private String juminPwd; //실명확인 pwd
	
	@Value("#{prop['niceId.ipinId']}")
	private String foreignId; //외국인실명확인 id
	
	@Value("#{prop['niceId.ipinPwd']}")
	private String foreignPwd; //외국인실명확인 pwd
	
	@Autowired
	UserService userService;
	
	/**
	 * 인증요청문자생성
	 * @param req
	 * @param vo
	 */
	public void makeReqString(HttpServletRequest req, NiceIdVO vo){
		int iReturn = 0;
		String msg = "", result = "", reqStr ="";
		
		CPClient niceCheck = new CPClient();
		IPIN2Client pClient = new IPIN2Client();
	
		vo.setReqNo(niceCheck.getRequestNO(String.valueOf(System.currentTimeMillis())));
		
		if(!StringUtils.isEmpty(vo.getJumin1()) && !StringUtils.isEmpty(vo.getJumin2()) && !StringUtils.isEmpty(vo.getNm()))
			msg = chkJumin(vo);
		
		if(StringUtils.isEmpty(msg)){
			// 입력될 plain 데이타를 만든다.
			if("I".equals(vo.getType())){
				iReturn = pClient.fnRequest(ipinId, ipinPwd, vo.getReqNo(), vo.getRetUrl());
				
			}else{
				reqStr = "7:REQ_SEQ" + vo.getReqNo().getBytes().length + ":" + vo.getReqNo() +
					"8:SITECODE" + authId.getBytes().length + ":" + authId +
					"9:AUTH_TYPE" + vo.getType().getBytes().length + ":" + vo.getType() +
					"7:RTN_URL" + vo.getRetUrl().getBytes().length + ":" + vo.getRetUrl() +
					"7:ERR_URL" + vo.getRetUrl().getBytes().length + ":" + vo.getRetUrl() +
					"11:POPUP_GUBUN" + vo.getCancelAt().getBytes().length + ":" + vo.getCancelAt() +
					"9:CUSTOMIZE" + vo.getMobileAt().getBytes().length + ":" + vo.getMobileAt() + 
					"6:GENDER" + vo.getGender().getBytes().length + ":" + vo.getGender();
				
				iReturn = niceCheck.fnEncode(authId, authPwd, reqStr);
			}
			
			if(iReturn == 0){
				if("I".equals(vo.getType()))
					result = pClient.getCipherData();
				else
					result = niceCheck.getCipherData();
				
			}else if(iReturn == -1)
				msg = "암호화 시스템 에러입니다.";
			
			else if(iReturn == -2)
				msg = "암호화 처리오류입니다.";
			
			else if(iReturn == -3)
				msg = "암호화 데이터 오류입니다.";
			
			else if(iReturn == -9)
				msg = "입력 데이터 오류입니다.";
			
			else
				msg = "알수 없는 에러 입니다. iReturn : " + iReturn;
		}
	
		vo.setRetCd(iReturn);
		vo.setMsg(msg);
		vo.setResult(result);
		req.getSession().setAttribute("NiceIdVO", vo);
	}
	
	
	/**
	 * 인증결과값 파싱 및 세션에 저장
	 * @param req
	 * @param vo
	 * @throws SQLException 
	 */
	public void parseResString(HttpServletRequest req, NiceIdVO vo) throws SQLException{
		int iReturn = 0;
		String msg = "", result = req.getParameter("EncodeData");
		Map<String, String> map;
		CorpInfoVO cvo;
		UserInfoVO uvo = new UserInfoVO();
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		NiceIdVO reqvo = (NiceIdVO)req.getSession().getAttribute("NiceIdVO");
		
		CPClient niceCheck = new CPClient();
		IPIN2Client pClient = new IPIN2Client();

		if("I".equals(vo.getType()))
			result = req.getParameter("enc_data");

		result = requestReplace(result);

		if("I".equals(vo.getType()))
			iReturn = pClient.fnResponse(ipinId, ipinPwd, result);
		else
			iReturn = niceCheck.fnDecode(authId, authPwd, result);

		if(("I".equals(vo.getType()) && iReturn == 1) || (!"I".equals(vo.getType()) && iReturn == 0)){

			if("I".equals(vo.getType())){
				uvo.setNm(pClient.getName());
				uvo.setGender(pClient.getGenderCode());
				uvo.setIhidnum1(pClient.getBirthDate());
				uvo.setCiValue(pClient.getCoInfo1());
				vo.setReqNo(pClient.getCPRequestNO());

			}else{
				map = niceCheck.fnParse(niceCheck.getPlainData());
				uvo.setNm(map.get("NAME"));
				uvo.setGender(map.get("GENDER"));
				uvo.setIhidnum1(map.get("BIRTHDATE"));
				uvo.setMoblphonNo(map.get("MOBILE_NO"));
				uvo.setCiValue(map.get("CI"));
				vo.setReqNo(map.get("REQ_SEQ"));

			}

			if(!reqvo.getReqNo().equals(vo.getReqNo())){
				msg = "세션값 불일치 오류입니다.";
				uvo = null;
				
			}else if(reqvo.getRefUrl().indexOf("findPw.do") >= 0 && !uvo.getNm().equals(reqvo.getNm())){
				msg = "입력하신정보와 인증정보가 일치하지 않습니다";
				uvo = null;
				
			}else{
				uvo.setBizno(reqvo.getBizno1());
				
				if(!StringUtils.isEmpty(uvo.getBizno()))
					uvo.setBizno(uvo.getBizno().concat("-").concat(reqvo.getBizno2()));
				
				if(!StringUtils.isEmpty(uvo.getBizno()))
					uvo.setBizno(uvo.getBizno().concat("-").concat(reqvo.getBizno3()));
				
				cvo = userService.selectCorpInfo(uvo);
				
				if(reqvo.getRefUrl().indexOf("certification.do") >= 0 && "USSE0003".equals(reqvo.getSe()) && (cvo == null || StringUtils.isEmpty(cvo.getBizno()))){
					msg = "입력하신 사업자등록번호로 업체정보를 찾을 수 없습니다.\n다시 한번 확인 후 회원가입 해주시기 바랍니다.";
					
				}else{
					if(lvo == null || StringUtils.isEmpty(lvo.getUserId()))
						lvo = uvo;
					
					lvo.setRetSysTime(System.currentTimeMillis());
					lvo.setSe(reqvo.getSe());
					lvo.setAuthVO(uvo);
					lvo.setBizno(uvo.getBizno());
					lvo.setNiceVO(reqvo);
					
					if(!StringUtils.isEmpty(reqvo.getJumin1()))
						lvo.setIhidnum(reqvo.getJumin1().concat("-").concat(reqvo.getJumin2()));
					
					req.getSession().setAttribute("loginInfo", lvo);
				}
			}

		}else if(iReturn == -1)
			msg = "복호화 시스템 오류입니다.";
		else if(iReturn == -4)
			msg = "복호화 처리 오류입니다.";
		else if(iReturn == -5)
			msg = "복호화 해쉬 오류입니다.";
		else if(iReturn == -6)
			msg = "복호화 데이터 오류입니다.";
		else if(iReturn == -9)
			msg = "입력 데이터 오류입니다.";
		else if(iReturn == -12)
			msg = "사이트 패스워드 오류입니다.";
		else
			msg = "알수 없는 에러 입니다. iReturn : " + iReturn;

		vo.setMsg(msg);
		vo.setRetCd(iReturn);
		req.getSession().removeAttribute("NiceIdVO");
	}
	
	/**
	 * 실명인증
	 * @param vo
	 * @return String
	 */
	public String chkJumin(NiceIdVO vo) {
		String rtn = "", msg = "";
		NameCheck nameCheck = new NameCheck();

		if("123490".indexOf(String.valueOf(vo.getJumin2().charAt(0))) > -1)
			vo.setJuminType("L");
		else
			vo.setJuminType("F");
		
		nameCheck.setChkName(vo.getNm());
		rtn = nameCheck.setJumin(vo.getJumin1()+vo.getJumin2()+("L".equals(vo.getJuminType())?juminPwd:foreignPwd));
		
		//정상처리인 경우
		if("0".equals(rtn)){
			nameCheck.setSiteCode("L".equals(vo.getJuminType())?juminId:foreignId);
			nameCheck.setTimeOut(30000);
			rtn = nameCheck.getRtn().trim();
		}
			
		// 실명인증 결과코드 확인
		if("1".equals(rtn))
			msg = "";
		else if("2".equals(rtn))
			msg = "성명불일치 오류: 주민번호와 성명이 일치하지 않습니다.\nwww.niceid.co.kr 에서 실명정보를 재등록하시거나 NICE 고객센터(1600-1522)로 문의해주십시오.";
		else if("3".equals(rtn))
			msg = "자료없음 오류: 주민번호가 조회되지 않습니다.\nwww.niceid.co.kr 에서 실명정보를 등록하시거나  NICE 고객센터(1600-1522)로 문의해주십시오.";
		else if("5".equals(rtn))
			msg = "주민번호 체크썸 오류: 주민번호 생성규칙에 맞지 않는 주민번호입니다.";
		else if("9".equals(rtn))
			msg = "입력정보 오류: 입력정보가 누락되었거나 정상이 아닙니다.\n입력된 사이트코드, 패스워드, 주민번호, 성명 정보를 확인해주시기 바랍니다.\n일부 고객만 발생하는 경우 부정사용으로 인한 차단 오류입니다. 차단 처리는 일정 시간이 지나면 자동으로 해제됩니다.";
		else if("10".equals(rtn))
			msg = "사이트 코드 오류: 사이트코드를 대문자로 입력해주십시오.\n사이트코드가 정상인 경우 내/외국인 설정 관련 오류입니다. (예:내국인 인증 계약 후 외국인 인증)\n내/외국인 설정에 맞게 이용한 경우 NICE 계약/관리 담당자에게 정확한 설정 상태를 문의해주십시오.";
		else if("11".equals(rtn))
			msg = "정지된 사이트 오류: 서비스 계약이 정지된 사이트입니다. NICE 계약/관리 담당자에게 문의해주십시오.";
		else if("12".equals(rtn))
			msg = "패스워드 불일치 오류: 사이트 패스워드가 일치하지 않습니다. NICE 전산 담당자에게 문의해주십시오.";
		else if("21".equals(rtn))
			msg = "입력정보 형식 오류: 입력정보의 자릿수를 확인해주십시오. (주민번호:13자리, 패스워드: 8자리)";
		else if("31".equals(rtn) || "32".equals(rtn) || "34".equals(rtn) || "44".equals(rtn))
			msg = "통신오류: 당사 서비스 IP를 방화벽에 등록해주십시오.\nIP:203.234.219.72\nport:81~85(총 5개 모두 등록)";
		else if("50".equals(rtn))
			msg = "명의도용차단 오류: 명의도용차단 서비스 이용 중인 주민번호입니다.\nwww.credit.co.kr에서 명의도용차단 서비스 해제 후 재시도 하시거나 NICE고객센터(1600-1522)로 문의해주십시오.";
		else if("60".equals(rtn) || "61".equals(rtn) || "62".equals(rtn) || "63".equals(rtn))
			msg = "네트워크 장애: 당사 서비스 IP와의 연결상태를 확인해주십시오.\nIP:203.234.219.72\nport:81~85(총 5개)";
		else
			msg = "기타 오류: 리턴코드 문서에 기재된 내용을 확인해주십시오.\n코드가 문서에 기재되어 있지 않은 경우 NICE 전산담당자에게 문의해주십시오.";

		return msg;
	}
	
	/**
	 * 결과값 문자열 정리
	 * @param paramValue
	 * @return String
	 */
	public String requestReplace(String paramValue){
		String str = paramValue;
		
		if(str != null){
			str = str.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
			str = str.replaceAll("\\*", "");
			str = str.replaceAll("\\?", "");
			str = str.replaceAll("\\[", "");
			str = str.replaceAll("\\{", "");
			str = str.replaceAll("\\(", "");
			str = str.replaceAll("\\)", "");
			str = str.replaceAll("\\^", "");
			str = str.replaceAll("\\$", "");
			str = str.replaceAll("'", "");
			str = str.replaceAll("@", "");
			str = str.replaceAll("%", "");
			str = str.replaceAll(";", "");
			str = str.replaceAll(":", "");
			str = str.replaceAll("-", "");
			str = str.replaceAll("#", "");
			str = str.replaceAll("--", "");
			str = str.replaceAll("-", "");
			str = str.replaceAll(",", "");
		}
		
		return str;
	}
}
