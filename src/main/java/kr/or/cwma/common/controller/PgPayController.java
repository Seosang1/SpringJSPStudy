package kr.or.cwma.common.controller;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.PgPayService;
import kr.or.cwma.common.util.EncryptUtil;
import kr.or.cwma.common.util.StringUtil;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * PG결제 컨트롤러
 */
@Controller
@RequestMapping(value="common/pgPay")
public class PgPayController{

	static final Logger LOG = LoggerFactory.getLogger(PgPayController.class);
	
	@Value("#{prop['pg.licenseKey']}")
	String licenseKey;
	
	@Value("#{prop['pg.aes256Key']}")
	String aesKey;
	
	@Value("#{prop['pg.pgMid']}")
	String pgMid;
	
	@Value("#{prop['pg.paymentServer']}")
	String paymentServer;
	
	@Value("#{prop['pg.cancelServer']}")
	String cancelServer;
	
	@Autowired
	private PgPayService pgPayService;
	
	@SuppressWarnings("unchecked")
	@RequestMapping(value="pgPayEnc.do")
	public ResponseEntity<JSONObject> pgPayEnc(HttpServletRequest request) throws Exception {
		/** 해쉬 및 aes256암호화 후 리턴 될 json */
		JSONObject rsp = new JSONObject();

		
		
		/** SHA256 해쉬 파라미터 */
//		String mchtId       = StringUtil.isNull(request.getParameter("mchtId"));
		
		String method       = StringUtil.isNull(request.getParameter("method"));
		String mchtTrdNo    = StringUtil.isNull(request.getParameter("mchtTrdNo"));
		String trdDt        = StringUtil.isNull(request.getParameter("trdDt"));
		String trdTm        = StringUtil.isNull(request.getParameter("trdTm"));
		String trdAmt       = StringUtil.isNull(request.getParameter("plainTrdAmt"));

		/**
	    ===== MID(상점아이디) =====
	    상점아이디는 세틀뱅크에서 상점으로 발급하는 상점의 고유한 식별자입니다.
	    테스트환경에서의 MID는 다음과 같습니다.
	        nx_mid_il : 문화/도서/해피/스마트문상/틴캐시/계좌이체/가상계좌/티머니
	        nxca_jt_il : 신용카드 결제
	        nxhp_pl_il : 휴대폰 일반결제
	        nxhp_pl_ma : 휴대폰 월 자동 결제
	        nxpt_kt_il : 포인트 결제
	        nxva_sb_il : 010가상계좌
	    상용서비스시에는 세틀뱅크에서 발급한 상점 고유 MID를 설정하십시오.
	*/
		/*dev 일때만 필요 Start */
		if(method.equals("card")){
		    pgMid = "nxca_jt_il";
	    }else if(method.equals("bank")){
	    	pgMid = "nx_mid_il";
	    }else if(method.equals("mobile")){
	    	pgMid = "nxhp_pl_il";
	    }
		String mchtId       = pgMid;
		/*dev 일때만 필요 End */
		
		/** AES256 암호화 파라미터 */
		HashMap<String,String> params = new HashMap<String,String>();
		params.put("trdAmt",            trdAmt);
		params.put("mchtCustNm",        StringUtil.isNull(request.getParameter("plainMchtCustNm")));
		params.put("cphoneNo",          StringUtil.isNull(request.getParameter("plainCphoneNo")));
		params.put("email",             StringUtil.isNull(request.getParameter("plainEmail")));
		params.put("mchtCustId",        StringUtil.isNull(request.getParameter("plainMchtCustId")));
		params.put("taxAmt",            StringUtil.isNull(request.getParameter("plainTaxAmt")));
		params.put("vatAmt",            StringUtil.isNull(request.getParameter("plainVatAmt")));
		params.put("taxFreeAmt",        StringUtil.isNull(request.getParameter("plainTaxFreeAmt")));
		params.put("svcAmt",            StringUtil.isNull(request.getParameter("plainSvcAmt")));
		params.put("clipCustNm",        StringUtil.isNull(request.getParameter("plainClipCustNm")));
		params.put("clipCustCi",        StringUtil.isNull(request.getParameter("plainClipCustCi")));
		params.put("clipCustPhoneNo",   StringUtil.isNull(request.getParameter("plainClipCustPhoneNo")));


		/*============================================================================================================================================
		 *  SHA256 해쉬 처리
		 *조합 필드 : 상점아이디 + 결제수단 + 상점주문번호 + 요청일자 + 요청시간 + 거래금액(평문) + 라이센스키
		 *============================================================================================================================================*/
		String hashPlain = String.format("%s%s%s%s%s%s%s", mchtId, method, mchtTrdNo, trdDt, trdTm, trdAmt, licenseKey);
		String hashCipher ="";
		/** SHA256 해쉬 처리 */
		try{
		    hashCipher = EncryptUtil.digestSHA256(hashPlain);//해쉬 값
		}catch(Exception e){
		    LOG.error("["+mchtTrdNo+"][SHA256 HASHING] Hashing Fail! : " + e.toString());
		    throw e;
		}finally{
		    LOG.info("["+mchtTrdNo+"][SHA256 HASHING] Plain Text["+hashPlain+"] ---> Cipher Text["+hashCipher+"]");
		    rsp.put("hashCipher", hashCipher); // sha256 해쉬 결과 저장
		}

		/*============================================================================================================================================
		 *  AES256 암호화 처리(AES-256-ECB encrypt -> Base64 encoding)
		 *============================================================================================================================================ */
		try{
		    for (Map.Entry<String, String> entry : params.entrySet()) {
		        String key   = entry.getKey();
//		        String value =  entry.getValue();
		        
		        String aesPlain = params.get(key);
		        if( !("".equals(aesPlain))){
		            byte[] aesCipherRaw = EncryptUtil.aes256EncryptEcb(aesKey, aesPlain);
		            String aesCipher = EncryptUtil.encodeBase64(aesCipherRaw);
		            
		            params.put(key, aesCipher);//암호화된 데이터로 세팅
		            LOG.info("["+mchtTrdNo+"][AES256 Encrypt] "+key+"["+aesPlain+"] ---> ["+aesCipher+"]");
		        }
		    }

		}catch(Exception e){
		    LOG.error("["+mchtTrdNo+"][AES256 Encrypt] AES256 Fail! : " + e.toString());
		    throw e;
		}finally{
//			rsp = (JSONObject) params;
			String encParamsString = JSONObject.toJSONString(params); //aes256 암호화 결과 저장
			JSONParser parser = new JSONParser();
			JSONObject encParams = (JSONObject) parser.parse(encParamsString);

		    rsp.put("encParams", encParams);
		    rsp.put("pgMid", pgMid);
		    rsp.put("paymentServer", paymentServer);
		    rsp.put("cancelServer", cancelServer);
		    System.out.println(rsp);
		}
		/* 결과 리턴 */
//		out.println(rsp);
		
		return new ResponseEntity<>(rsp, HttpStatus.OK);
	}
	
	/**
	 * PG 결제 후 결과
	 * @param request
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value="pgPayNoti.do")
	public String pgPayNoti(HttpServletRequest request, HashMap<String, Object> params) throws SQLException {
		boolean resp=false;

		/** 노티 수신 파라미터 */
		String outStatCd        = request.getParameter("outStatCd"      ) == null ? "" : request.getParameter("outStatCd"); 
		String trdNo            = request.getParameter("trdNo"          ) == null ? "" : request.getParameter("trdNo"); 
		String method           = request.getParameter("method"         ) == null ? "" : request.getParameter("method"); 
		String bizType          = request.getParameter("bizType"        ) == null ? "" : request.getParameter("bizType"); 
		String mchtId           = request.getParameter("mchtId"         ) == null ? "" : request.getParameter("mchtId"); 
		String mchtTrdNo        = request.getParameter("mchtTrdNo"      ) == null ? "" : request.getParameter("mchtTrdNo"); 
		String mchtCustNm       = request.getParameter("mchtCustNm"     ) == null ? "" : request.getParameter("mchtCustNm"); 
		String mchtName         = request.getParameter("mchtName"       ) == null ? "" : request.getParameter("mchtName"); 
		String pmtprdNm         = request.getParameter("pmtprdNm"       ) == null ? "" : request.getParameter("pmtprdNm"); 
		String trdDtm           = request.getParameter("trdDtm"         ) == null ? "" : request.getParameter("trdDtm"); 
		String trdAmt           = request.getParameter("trdAmt"         ) == null ? "" : request.getParameter("trdAmt"); 
		String billKey          = request.getParameter("billKey"        ) == null ? "" : request.getParameter("billKey"); 
		String billKeyExpireDt  = request.getParameter("billKeyExpireDt") == null ? "" : request.getParameter("billKeyExpireDt"); 
		String bankCd           = request.getParameter("bankCd"         ) == null ? "" : request.getParameter("bankCd"); 
		String bankNm           = request.getParameter("bankNm"         ) == null ? "" : request.getParameter("bankNm"); 
		String cardCd           = request.getParameter("cardCd"         ) == null ? "" : request.getParameter("cardCd"); 
		String cardNm           = request.getParameter("cardNm"         ) == null ? "" : request.getParameter("cardNm"); 
		String telecomCd        = request.getParameter("telecomCd"      ) == null ? "" : request.getParameter("telecomCd"); 
		String telecomNm        = request.getParameter("telecomNm"      ) == null ? "" : request.getParameter("telecomNm"); 
		String vAcntNo          = request.getParameter("vAcntNo"        ) == null ? "" : request.getParameter("vAcntNo"); 
		String expireDt         = request.getParameter("expireDt"       ) == null ? "" : request.getParameter("expireDt"); 
		String AcntPrintNm      = request.getParameter("AcntPrintNm"    ) == null ? "" : request.getParameter("AcntPrintNm"); 
		String dpstrNm          = request.getParameter("dpstrNm"        ) == null ? "" : request.getParameter("dpstrNm"); 
		String email            = request.getParameter("email"          ) == null ? "" : request.getParameter("email"); 
		String mchtCustId       = request.getParameter("mchtCustId"     ) == null ? "" : request.getParameter("mchtCustId"); 
		String cardNo           = request.getParameter("cardNo"         ) == null ? "" : request.getParameter("cardNo"); 
		String cardApprNo       = request.getParameter("cardApprNo"     ) == null ? "" : request.getParameter("cardApprNo"); 
		String instmtMon        = request.getParameter("instmtMon"      ) == null ? "" : request.getParameter("instmtMon"); 
		String instmtType       = request.getParameter("instmtType"     ) == null ? "" : request.getParameter("instmtType"); 
		String phoneNoEnc       = request.getParameter("phoneNoEnc"     ) == null ? "" : request.getParameter("phoneNoEnc"); 
		String orgTrdNo         = request.getParameter("orgTrdNo"       ) == null ? "" : request.getParameter("orgTrdNo"); 
		String orgTrdDt         = request.getParameter("orgTrdDt"       ) == null ? "" : request.getParameter("orgTrdDt"); 
		String mixTrdNo         = request.getParameter("mixTrdNo"       ) == null ? "" : request.getParameter("mixTrdNo"); 
		String mixTrdAmt        = request.getParameter("mixTrdAmt"      ) == null ? "" : request.getParameter("mixTrdAmt"); 
		String payAmt           = request.getParameter("payAmt"         ) == null ? "" : request.getParameter("payAmt"); 
		String csrcIssNo        = request.getParameter("csrcIssNo"      ) == null ? "" : request.getParameter("csrcIssNo"); 
		String cnclType         = request.getParameter("cnclType"       ) == null ? "" : request.getParameter("cnclType"); 
		String mchtParam        = request.getParameter("mchtParam"      ) == null ? "" : request.getParameter("mchtParam"); 
		String pktHash          = request.getParameter("pktHash"        ) == null ? "" : request.getParameter("pktHash"); 

		System.out.println("params ::::::::::::::::::"+params);
		
		/* 응답 파라미터 List에 저장 */
		ArrayList<String> noti = new ArrayList<String>();
		noti.add("거래상태:"+ outStatCd);
		noti.add("거래번호:"+ trdNo);
		noti.add("결제수단:"+ method);
		noti.add("업무구분:"+ bizType);
		noti.add("상점아이디:"+ mchtId);
		noti.add("상점거래번호:"+ mchtTrdNo);
		noti.add("주문자명:"+ mchtCustNm);
		noti.add("상점한글명:"+ mchtName);
		noti.add("상품명:"+ pmtprdNm);
		noti.add("거래일시:"+ trdDtm);
		noti.add("거래금액:"+ trdAmt);
		noti.add("자동결제키:"+ billKey);
		noti.add("자동결제키 유효기간:"+ billKeyExpireDt);
		noti.add("은행코드:"+ bankCd);
		noti.add("은행명:"+ bankNm);
		noti.add("카드사코드:"+ cardCd);
		noti.add("카드명:"+ cardNm);
		noti.add("이통사코드:"+ telecomCd);
		noti.add("이통사명:"+ telecomNm);
		noti.add("가상계좌번호:"+ vAcntNo);
		noti.add("가상계좌 입금만료일시:"+ expireDt);
		noti.add("통장인자명:"+ AcntPrintNm);
		noti.add("입금자명:"+ dpstrNm);
		noti.add("고객이메일:"+ email);
		noti.add("상점고객아이디:"+ mchtCustId);
		noti.add("카드번호:"+ cardNo);
		noti.add("카드승인번호:"+ cardApprNo);
		noti.add("할부개월수:"+ instmtMon);
		noti.add("할부타입:"+ instmtType);
		noti.add("휴대폰번호(암호화):"+ phoneNoEnc);
		noti.add("원거래번호:"+ orgTrdNo);
		noti.add("원거래일자:"+ orgTrdDt);
		noti.add("복합결제 거래번호:"+ mixTrdNo);
		noti.add("복합결제 금액:"+ mixTrdAmt);
		noti.add("실결제금액:"+ payAmt);
		noti.add("현금영수증 승인번호:"+ csrcIssNo);
		noti.add("취소거래타입:"+ cnclType);
		noti.add("기타주문정보:"+ mchtParam);
		noti.add("해쉬값:"+ pktHash); //서버에서 전달된 해쉬 값

		/** 해쉬 조합 필드 
		 *  결과코드 + 거래일시 + 상점아이디 + 가맹점거래번호 + 거래금액 + 라이센스키 */
		String hashPlain = String.format("%s%s%s%s%s%s", outStatCd, trdDtm, mchtId, mchtTrdNo, trdAmt, licenseKey);
		String hashCipher ="";

		/** SHA256 해쉬 처리 */
		try{
		    hashCipher = EncryptUtil.digestSHA256(hashPlain);//해쉬 값
		}catch(Exception e){
		    LOG.error("["+mchtTrdNo+"][SHA256 HASHING] Hashing Fail! : " + e.toString());
		}finally{
		    LOG.info("["+mchtTrdNo+"][SHA256 HASHING] Plain Text["+hashPlain+"] ---> Cipher Text["+hashCipher+"]");
		}

		/**
		    hash데이타값이 맞는 지 확인 하는 루틴은 세틀뱅크에서 받은 데이타가 맞는지 확인하는 것이므로 꼭 사용하셔야 합니다
		    정상적인 결제 건임에도 불구하고 노티 페이지의 오류나 네트웍 문제 등으로 인한 hash 값의 오류가 발생할 수도 있습니다.
		    그러므로 hash 오류건에 대해서는 오류 발생시 원인을 파악하여 즉시 수정 및 대처해 주셔야 합니다. 
		    그리고 정상적으로 데이터를 처리한 경우에도 세틀뱅크에서 응답을 받지 못한 경우는 결제결과가 중복해서 나갈 수 있으므로 관련한 처리도 고려되어야 합니다
		*/
		if (hashCipher.equals(pktHash)) {
		    LOG.info("["+ mchtTrdNo + "][SHA256 Hash Check] hashCipher[" + hashCipher + "] pktHash[" + pktHash + "] equals?[TRUE]");
		    if ("0021".equals(outStatCd)){
		        LOG.info("["+ mchtTrdNo + "][Success] params:" + String.join("|", noti));
		        resp = notiSuccess(noti);
		        resp = notiSuccess(params);
		    }
		    else if ("0051".equals(outStatCd)){
		        LOG.info("["+ mchtTrdNo + "][Wait For Deposit] params:" + String.join("|", noti));
		        resp = notiWaitingPay(noti);
		    }
		    else{
		        LOG.info("["+ mchtTrdNo + "][Undefined Code] outStatCd:"+ outStatCd );
		        resp = false;
		    }
		}
		else {
		    LOG.info("["+ mchtTrdNo + "][SHA256 Hash Check] hashCipher[" + hashCipher + "] pktHash[" + pktHash + "] equals?[FALSE]");
		    resp = notiHashError(noti);
		} 
		String result = "";
		// OK, FAIL문자열은 세틀뱅크로 전송되어야 하는 값이므로 변경하거나 삭제하지마십시오.
		if (resp){
			result = "OK";
		    LOG.info("["+ mchtTrdNo + "][Result] OK");
		}
		else{
			result = "FAIL";
		    LOG.info("["+ mchtTrdNo + "][Result] FAIL");
		}
		return result;
//		return "skill/mypage/crtfIssu/docConfirm";
	}
	
	@RequestMapping(value="pgPayNext.do")
	public String pgPayNext(HttpServletRequest request) throws SQLException {
		/** 응답 파라미터 세팅 */
		Map<String,String> RES_PARAMS = new LinkedHashMap<String,String>();
		RES_PARAMS.put("mchtId",            StringUtil.isNull(request.getParameter("mchtId")));             //상점아이디
		RES_PARAMS.put("outStatCd",         StringUtil.isNull(request.getParameter("outStatCd")));          //결과코드
		RES_PARAMS.put("outRsltCd",         StringUtil.isNull(request.getParameter("outRsltCd")));          //거절코드
		RES_PARAMS.put("outRsltMsg",        StringUtil.isNull(request.getParameter("outRsltMsg")));         //결과메세지
		RES_PARAMS.put("method",            StringUtil.isNull(request.getParameter("method")));             //결제수단
		RES_PARAMS.put("mchtTrdNo",         StringUtil.isNull(request.getParameter("mchtTrdNo")));          //상점주문번호
		RES_PARAMS.put("mchtCustId",        StringUtil.isNull(request.getParameter("mchtCustId")));         //상점고객아이디
		RES_PARAMS.put("trdNo",             StringUtil.isNull(request.getParameter("trdNo")));              //세틀뱅크 거래번호
		RES_PARAMS.put("trdAmt",            StringUtil.isNull(request.getParameter("trdAmt")));             //거래금액
		RES_PARAMS.put("mchtParam",         StringUtil.isNull(request.getParameter("mchtParam")));          //상점 예약필드
		RES_PARAMS.put("authDt",            StringUtil.isNull(request.getParameter("authDt")));             //승인일시
		RES_PARAMS.put("authNo",            StringUtil.isNull(request.getParameter("authNo")));             //승인번호
		RES_PARAMS.put("reqIssueDt",     	StringUtil.isNull(request.getParameter("reqIssueDt")));       	//채번요청일시
		RES_PARAMS.put("intMon",            StringUtil.isNull(request.getParameter("intMon")));             //할부개월수
		RES_PARAMS.put("fnNm",              StringUtil.isNull(request.getParameter("fnNm")));               //카드사명
		RES_PARAMS.put("fnCd",              StringUtil.isNull(request.getParameter("fnCd")));               //카드사코드
		RES_PARAMS.put("pointTrdNo",        StringUtil.isNull(request.getParameter("pointTrdNo")));         //포인트거래번호
		RES_PARAMS.put("pointTrdAmt",       StringUtil.isNull(request.getParameter("pointTrdAmt")));        //포인트거래금액
		RES_PARAMS.put("cardTrdAmt",        StringUtil.isNull(request.getParameter("cardTrdAmt")));         //신용카드결제금액
		RES_PARAMS.put("vtlAcntNo",         StringUtil.isNull(request.getParameter("vtlAcntNo")));          //가상계좌번호
		RES_PARAMS.put("expireDt",          StringUtil.isNull(request.getParameter("expireDt")));           //입금기한
		RES_PARAMS.put("cphoneNo",          StringUtil.isNull(request.getParameter("cphoneNo")));           //휴대폰번호
		RES_PARAMS.put("billKey",           StringUtil.isNull(request.getParameter("billKey")));            //자동결제키
	
		//AES256 복호화 필요 파라미터
		String[] DECRYPT_PARAMS = {"mchtCustId", "trdAmt", "pointTrdAmt", "cardTrdAmt", "vtlAcntNo", "cphoneNo"};
	
		/** ======================================================================
		        AES256 복호화 처리(Base64 decoding -> AES-256-ECB decrypt )
		    ======================================================================   */
		try{
		    for(int i=0; i < DECRYPT_PARAMS.length; i++){
		        if( RES_PARAMS.containsKey(DECRYPT_PARAMS[i]) ){
		            String aesCipher = (RES_PARAMS.get(DECRYPT_PARAMS[i])).trim();
		            if( !("".equals(aesCipher))){
		                byte[] aesCipherRaw = EncryptUtil.decodeBase64(aesCipher);
		                String aesPlain = new String(EncryptUtil.aes256DecryptEcb(aesKey, aesCipherRaw), "UTF-8");
		                
		                RES_PARAMS.put(DECRYPT_PARAMS[i], aesPlain);//복호화된 데이터로 세팅
		                LOG.info("["+RES_PARAMS.get("mchtTrdNo")+"][AES256 Decrypt] "+DECRYPT_PARAMS[i]+"["+aesCipher+"] ---> ["+aesPlain+"]");
		                
		                /*DB저장 확인*/
		                HashMap<String, Object> payResult = pgPayService.selectPgPayCheck(RES_PARAMS);
		                
		            }
		        }
		    }
		}catch(Exception e){
		    LOG.error("[" + RES_PARAMS.get("mchtTrdNo") + "][AES256 Decrypt] AES256 Decrypt Fail! : " + e.toString());
		}
	
		//응답 파라미터 로깅
		StringBuffer logStr = new StringBuffer();
		logStr.append("["+RES_PARAMS.get("mchtTrdNo")+"][Response Data] ");
		for (Map.Entry<String, String> entry : RES_PARAMS.entrySet()) {
		    logStr.append(entry.getKey()+"("+entry.getValue()+") ");
		}
		LOG.info(logStr.toString());
		
		return "common/popup/pgReceive";
	}
	
	boolean notiSuccess(List<String> noti){
	       /* TODO : 관련 로직 추가 */
	       
	    return true;
	}
	boolean notiSuccess(HashMap<String, Object> params) throws SQLException{
		pgPayService.insertPgPay(params);
	    return true;
	}
	/** 입금대기시 처리할 로직을 작성하여 주세요. */
	boolean notiWaitingPay(List<String> noti){
	       /* TODO : 관련 로직 추가 */
	       
	       return true;
	}   

	   /** 노티 수신중 해시 체크 에러가 생긴 경우 처리할 로직을 작성하여 주세요. */
	boolean notiHashError(List<String> noti){
	       /* TODO : 관련 로직 추가 */
	       
	       return false;
	}
}
