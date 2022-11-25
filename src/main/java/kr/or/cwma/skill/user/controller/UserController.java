package kr.or.cwma.skill.user.controller;
import java.io.IOException;
import java.net.URLEncoder;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.softcamp.scsk.e2e.e2eMain;

import kr.or.cwma.admin.clmserEdu.service.ClmserEduService;
import kr.or.cwma.admin.clmserEdu.vo.UserClmserEduRelVO;
import kr.or.cwma.admin.smsSendHist.service.SmsSendHistService;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.DminsttInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.CryptUtil;
import kr.or.cwma.common.util.KICACertUtil;
import kr.or.cwma.common.util.NiceIdUtil;
import kr.or.cwma.common.vo.NiceIdVO;
import kr.or.cwma.skill.user.service.UserService;
import kr.or.cwma.skill.userSnsAuthor.service.UserSnsAuthorService;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;
import signgate.crypto.util.CertUtil;
import signgate.crypto.util.FileUtil;

/**
 * 회원 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/user")
public class UserController{
	@Value("#{prop['cert.kmCert']}")
	String kmCert;

	@Autowired
	NiceIdUtil niceIdUtil;
	
	@Autowired
	KICACertUtil certUtil;
	
	@Autowired
	UserInfoService userInfoService;
	
	@Autowired
	UserService userService;

	@Autowired
	UserSnsAuthorService userSnsAuthorService;
	
	@Autowired
	SmsSendHistService smsSendHistService;
	
	@Autowired
	ClmserEduService clmserEduService;
	
	/**
	 * 로그인 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws Exception 
	 * @throws IOException 
	 */
	@RequestMapping(value="login.do", method=RequestMethod.GET)
	public String login(HttpServletRequest req) throws IOException, Exception{
		String retUrl = (String)req.getSession().getAttribute("refUrl");
		
		if(!StringUtils.isEmpty(retUrl)){
			req.getSession().removeAttribute("refUrl");
			return "redirect:/skill/user/login.do?retUrl=".concat(URLEncoder.encode(retUrl, "UTF-8"));
		}
		//req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/user/login";
	}
	
	/**
	 * 로그인
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="login.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> loginPost(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		int e2eSeed = 0;
		String msg = "", pwE2e = req.getParameter("_ExtE2E123_password");
		String serverType = System.getProperty("server");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		e2eMain e2e = null;
		
		if(req.getSession().getAttribute("e2eSeed") != null){
			e2eSeed = (Integer)req.getSession().getAttribute("e2eSeed");
			e2e = new e2eMain(e2eSeed);
			
		}
		
		if(!StringUtils.isEmpty(pwE2e))
			vo.setPassword(e2eMain.getDecEncData(pwE2e));
		
		if(("USSE0002".equals(vo.getSe()) || "USSE0004".equals(vo.getSe()))){
			if("Y".equals(req.getParameter("isMobile")))
				msg = certUtil.getCertInfoForMobile(vo);
			else
				msg = certUtil.getCertInfo(vo);
		}
		
		if(StringUtils.isEmpty(msg)) {
			if("USSE0001".equals(vo.getSe()) && vo.getUserSnsAuthorVO() != null && "Y".equals(vo.getUserSnsAuthorVO().getAuthYn())) {
				msg = userService.snsLogin(req, vo);// SNS 인증 로그인
			}else {
				msg = userService.login(req, vo);
			}
			
		}
		
		if(StringUtils.isEmpty(msg)){
			map.put("retMethod", req.getSession().getAttribute("refMethod"));
			req.getSession().removeAttribute("refMethod");			
			sttus = HttpStatus.OK;
		}

		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 비회원 로그인 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws Exception 
	 * @throws IOException 
	 */
	@RequestMapping(value="loginAuth.do", method=RequestMethod.GET)
	public String loginAuth(HttpServletRequest req) throws IOException, Exception{
		req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/user/loginAuth";
	}
	
	/**
	 * 비회원 로그인
	 * @param ses
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="loginAuth.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> loginAuthPost(HttpSession ses) throws IOException, Exception{
		String msg = "", retUrl = "", retMethod = "";
		CorpInfoVO cvo;
		DminsttInfoVO dvo;
		UserInfoVO vo = (UserInfoVO)ses.getAttribute("loginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		if(vo == null || StringUtils.isEmpty(vo.getSe())){
			msg = "인증 후 이용해주세요";

		}else if("USSE0002".equals(vo.getSe()) && !StringUtils.isEmpty(vo.getDnValue())){
			cvo = userService.selectCorpInfo(vo);
			if(cvo == null || StringUtils.isEmpty(cvo.getBizno()))
				msg = "입력하신 사업자등록번호로 업체정보를 찾을 수 없습니다.\n다시 한번 확인 후 로그인 해주시기 바랍니다.";
			else
				vo.setCorpInfoVO(cvo);

		}else if("USSE0003".equals(vo.getSe())){
			cvo = userService.selectCorpInfo(vo);
			if(cvo == null || StringUtils.isEmpty(cvo.getBizno()))
				msg = "입력하신 사업자등록번호로 업체정보를 찾을 수 없습니다.\n다시 한번 확인 후 로그인 해주시기 바랍니다.";
			else
				vo.setCorpInfoVO(cvo);
			
		}else if("USSE0004".equals(vo.getSe()) && !StringUtils.isEmpty(vo.getDnValue())){
			dvo = userService.selectDminsttInfo(vo);
			if(dvo == null || StringUtils.isEmpty(dvo.getBizno()))
				msg = "입력하신 사업자등록번호로 수요기관정보를 찾을 수 없습니다.\n다시 한번 확인 후 로그인 해주시기 바랍니다.";
			else
				vo.setDminsttInfoVO(dvo);
			
		}else {
			UserClmserEduRelVO ucvo = new UserClmserEduRelVO();
			ucvo.setIhidnum(vo.getIhidnum());
			UserClmserEduRelVO uceo = clmserEduService.selectUserClmserEduRelView(ucvo);
			if(uceo != null) {
				vo.setClmserEduComplAt(uceo.getComplAt());
			}
		}
			
		
		if(!StringUtils.isEmpty(msg)){
			vo = null;
			
		}else{
			retUrl = (String)ses.getAttribute("refUrl");
			retMethod = (String)ses.getAttribute("refMethod");
			vo.setLogin(true);
			ses.removeAttribute("refUrl");
			ses.removeAttribute("refMethod");
			sttus = HttpStatus.OK;
		}
		
		ses.setAttribute("loginInfo", vo);
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		map.put("retUrl", retUrl);
		map.put("retMethod", retMethod);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 회원가입 - 회원선택 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="type.do")
	public String type(HttpServletRequest req){
		return "skill/user/type";
	}

	/**
	 * 회원가입 - 회원약관 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="stipulation.do")
	public String stipulation(HttpServletRequest req){
		if(StringUtils.isEmpty(req.getParameter("se")))
			return "redirect:/skill/user/type.do";
		
		return "skill/user/stipulation";
	}
	
	/**
	 * 회원가입 - 본인인증 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws Exception 
	 * @throws IOException 
	 */
	@RequestMapping(value="certification.do")
	public String certification(HttpServletRequest req) throws IOException, Exception{
		
		if(StringUtils.isEmpty(req.getParameter("se")))
			return "redirect:/skill/user/type.do";
		
		return "skill/user/certification";
	}
	
	/**
	 * 회원가입 - 정보입력 페이지
	 * @param ses
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpSession ses, UserInfoVO uvo) throws SQLException{
		String ret = "skill/user/form";
		UserInfoVO vo = (UserInfoVO)ses.getAttribute("loginInfo");
		
		// 선택약관동의 체크(SNS,온라인상담)
		vo.setStplatAgreAt(!StringUtils.isEmpty(uvo.getStplatAgreAt()) ? uvo.getStplatAgreAt() : "N");
		
		if(vo == null)
			ret = "redirect:/skill/user/type.do";
		
		else if(("USSE0001".equals(vo.getSe()) || "USSE0003".equals(vo.getSe())) && (vo.getAuthVO() == null || StringUtils.isEmpty(vo.getAuthVO().getNm())))
			ret = "redirect:/skill/user/type.do";
			
		else if(("USSE0002".equals(vo.getSe()) || "USSE0004".equals(vo.getSe())) && StringUtils.isEmpty(vo.getDnValue()))
			ret = "redirect:/skill/user/type.do";
		
		else if("USSE0002".equals(vo.getSe()) || "USSE0003".equals(vo.getSe()))
			vo.setCorpInfoVO(userService.selectCorpInfo(vo));
			
		else if("USSE0004".equals(vo.getSe()))
			vo.setDminsttInfoVO(userService.selectDminsttInfo(vo));
			
		return ret;
	}
	
	/**
	 * 회원가입 - 가입완료 페이지
	 * @param req
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="join.do")
	public String join(HttpServletRequest req){
		return "skill/user/join";
	}
	
	/**
	 * 회원가입 - 아이디 중복체크
	 * @param req
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="checkId.do")
	public ResponseEntity<Map<String, Object>> checkId(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("vo", userInfoService.selectUserInfoView(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 회원가입 - 등록
	 * @param req
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="insert.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid UserInfoVO vo, BindingResult result) throws SQLException, NoSuchAlgorithmException{
		FieldError err;
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		
		Iterator<FieldError> iter;
		List<FieldError> list = new ArrayList<FieldError>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		UserSnsAuthorVO snsVo = vo.getUserSnsAuthorVO();
		
		if(result.hasErrors()){
			iter = result.getFieldErrors().iterator();
			
			while(iter.hasNext()){
				err = iter.next();
				
				if(!"USSE0001".equals(vo.getSe())){
					if("password".equals(err.getField()))
						continue;
				}
				
				list.add(err);
			}
		}
		
		if(list.size() > 0) {
			map.put("errors", list);
			
		}else {
			sttus = HttpStatus.OK;
			
			// 회원 SNS 인증 존재 체크
			String msg = "";
			boolean snsAuthResult = false;
			if("USSE0001".equals(vo.getSe()) && snsVo != null && "Y".equals(snsVo.getAuthYn())) {
				if(StringUtils.isEmpty(snsVo.getSnsId())) {
					msg = "SNS 계정 정보를 가져오지 못했습니다. 다시 연동 시도해주세요.";
					map.put("msg", msg);
				}else {
					UserSnsAuthorVO snsVOInfo = userSnsAuthorService.selectUserSnsAuthorView(snsVo);// se snsId 2개 조회
					if(snsVOInfo!= null && !StringUtils.isEmpty(snsVOInfo.getSnsId())) {
						msg = "이미 존재하는 SNS 계정 입니다. 다른 계정으로 연동해주세요.";
						map.put("msg", msg);
					}else {
						snsAuthResult = true;
					}
				}
			}
			
			if(StringUtils.isEmpty(msg)) {
				vo.setCiValue(lvo.getCiValue());
				vo.setDnValue(lvo.getDnValue());
				vo.setNm(lvo.getNm());
				vo.setBizno(lvo.getBizno());
				
				// 약관동의 여부
				String advrtsInfoPrcuseAgreAt = !StringUtils.isEmpty(vo.getAdvrtsInfoPrcuseAgreAt()) ? vo.getAdvrtsInfoPrcuseAgreAt() : "N";
				String stplatAgreAt = !StringUtils.isEmpty(vo.getStplatAgreAt()) ? vo.getStplatAgreAt() : "N";
				String stplatSnsAgreAt = "N".equals(stplatAgreAt) && "Y".equals(snsVo.getAuthYn()) ? "Y" :  stplatAgreAt;
				
				vo.setAdvrtsInfoPrcuseAgreAt(advrtsInfoPrcuseAgreAt);//광고정보활용동의여부
				vo.setStplatOnlineCnsltAgreAt(stplatAgreAt);//온라인 상담 동의 여부
				vo.setStplatSnsAgreAt(stplatSnsAgreAt);//SNS 동의 여부
				
				userService.insertUserInfo(vo);
				smsSendHistService.sendSmsAuto("SSSE0001", vo.getMoblphonNo(), vo.getNm(), null);
				map.put("userId", vo.getUserId());
				
				if(snsAuthResult) {
					// SNS 계정 연동 등록
					snsVo.setUserId(vo.getUserId());
					userSnsAuthorService.insertUserSnsAuthor(snsVo);
				}
			}
		}

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 대리인 공제계약목록조회
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="ddcJoinList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> ddcJoinList(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", userService.selectDdcJoinList(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 공동인증서 등록 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws Exception 
	 * @throws IOException 
	 */
	@RequestMapping(value="addCert.do", method=RequestMethod.GET)
	public String addCert(HttpServletRequest req, UserInfoVO vo) throws IOException, Exception{
		req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/user/addCert";
	}
	
	/**
	 * 공동인증서 등록 - 사용자조회
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="addCertUserView.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> addCertUserView(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("eo", userService.selectUserInfoForAddCert(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 공동인증서 등록
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="addCert.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> addCertPost(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		vo.setBizno(lvo.getBizno());
		vo.setDnValue(lvo.getDnValue());
		vo.setRgstId(vo.getUserId());
		vo.setChgId(vo.getUserId());
		userService.updateAddCert(vo);
		req.getSession().removeAttribute("loginInfo");
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 아이디찾기 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="findId.do", method=RequestMethod.GET)
	public String findId(HttpServletRequest req, UserInfoVO vo) throws IOException, Exception{
		req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/user/findId";
	}
	
	/**
	 * 아이디찾기
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="findId.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> findIdPost(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		map.put("eo", userService.selectJoinUser(uvo));
		req.getSession().removeAttribute("loginInfo");
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 패스워드찾기 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="findPw.do", method=RequestMethod.GET)
	public String findPw(HttpServletRequest req, UserInfoVO vo){
		return "skill/user/findPw";
	}
	
	/**
	 * 비밀번호찾기
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="findPw.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> findPwPost(HttpServletRequest req, @Valid UserInfoVO vo, BindingResult result) throws SQLException, NoSuchAlgorithmException{
		FieldError err;
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		
		Iterator<FieldError> iter;
		List<FieldError> list = new ArrayList<FieldError>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if(result.hasErrors()){
			iter = result.getFieldErrors().iterator();
			
			while(iter.hasNext()){
				err = iter.next();
				if("password".equals(err.getField()))
					list.add(err);
			}
		}
		
		if(list.size() > 0) {
			map.put("errors", list);
			
		}else {
			vo.setCiValue(lvo.getCiValue());
			vo.setNm(lvo.getNm());
			
			userService.updateUserPassword(vo);
			map.put("userId", vo.getUserId());
			sttus = HttpStatus.OK;
		}
		
		req.getSession().removeAttribute("loginInfo");
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 재사용 비밀번호 여부 확인 
	 * @param req
	 * @param vo
	 * @return
	 * @throws SQLException
	 * @throws NoSuchAlgorithmException
	 */
	@RequestMapping(value="findPwChk.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> findPwChk(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		
		boolean success = false;
		Map<String, Object> map = new HashMap<String, Object>();
		
		String ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
		UserInfoVO eo = userInfoService.selectUserInfoView(vo);
		
		//개인회원
		if("USSE0001".equals(eo.getSe())){
			if(eo != null && ps.equals(eo.getPassword())) {
				success = true;
			}
		}
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 나이스아이디 본인인증
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="niceAuth.do")
	public String niceAuth(HttpServletRequest req, @ModelAttribute("vo") NiceIdVO vo){
		vo.setRetUrl(req.getScheme().concat("://").concat(req.getServerName()).concat(":").concat(String.valueOf(req.getServerPort())).concat(req.getContextPath()).concat("/skill/user/niceResultPop.do"));
		vo.setRefUrl(req.getHeader("referer"));
		niceIdUtil.makeReqString(req, vo);
		return "skill/user/niceAuth";
	}
	
	/**
	 * 나이스아이디 본인인증 결과
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="niceResultPop.do")
	public String niceResult(HttpServletRequest req, @ModelAttribute("vo") NiceIdVO vo) throws SQLException{
		UserInfoVO uvo = new UserInfoVO();
		UserInfoVO uvo2 = new UserInfoVO();
		NiceIdVO reqvo = (NiceIdVO)req.getSession().getAttribute("NiceIdVO");
		
		if(reqvo != null) {
			vo.setType(reqvo.getType());
			niceIdUtil.parseResString(req, vo);
			
			if(StringUtils.isEmpty(vo.getMsg())){
				uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
				uvo2.setCiValue(uvo.getAuthVO().getCiValue());
				req.setAttribute("eo", userService.selectJoinUser(uvo2));
			}
			
		}else {
			vo.setMsg("세션값 불일치 오류입니다.");
			
		}
		
		return "skill/user/niceResult";
	}
	
	/**
	 * 한국정보인증 인증키
	 * @param res
	 * @throws Exception 
	 */
	@RequestMapping(value="getKicaCert.do")
	public String getkicaCert(HttpServletRequest req) throws Exception{
		req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/user/kicaCert";
	}
	
	/**
	 * 한국정보인증 공인인증
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="kicaAuth.do")
	public ResponseEntity<Map<String, Object>> kicaAuth(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		String msg = "";
		String serverType = System.getProperty("server");
		String refUrl = req.getHeader("referer");
		
		UserInfoVO eo;
		CorpInfoVO cvo;
		DminsttInfoVO dvo;
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		if("Y".equals(req.getParameter("isMobile")))
			msg = certUtil.getCertInfoForMobile(vo);
		else
			msg = certUtil.getCertInfo(vo);
		
		if(StringUtils.isEmpty(msg)){
			if(lvo == null)
				lvo = vo;
			
			eo = userService.selectJoinUser(vo);
			map.put("eo", eo);
			
			if(eo == null && refUrl.indexOf("certification.do") >= 0){
				if("USSE0002".equals(vo.getSe()) && !StringUtils.isEmpty(vo.getDnValue())){
					cvo = userService.selectCorpInfo(vo);
					if(cvo == null || StringUtils.isEmpty(cvo.getBizno()))
						msg = "입력하신 사업자등록번호로 업체정보를 찾을 수 없습니다.\n다시 한번 확인 후 회원가입 해주시기 바랍니다.";
					
				}else if("USSE0004".equals(vo.getSe()) && !StringUtils.isEmpty(vo.getDnValue())){
					dvo = userService.selectDminsttInfo(vo);
					if(dvo == null || StringUtils.isEmpty(dvo.getBizno()))
						msg = "입력하신 사업자등록번호로 수요기관정보를 찾을 수 없습니다.\n다시 한번 확인 후 회원가입 해주시기 바랍니다.";
				}
				
				if(StringUtils.isEmpty(msg)){
					lvo.setRetSysTime(vo.getRetSysTime());
					req.getSession().setAttribute("loginInfo", lvo);
					sttus = HttpStatus.OK;
				}
				
			}else{
				lvo.setRetSysTime(vo.getRetSysTime());
				lvo.setDnValue(vo.getDnValue());
				req.getSession().setAttribute("loginInfo", lvo);
				sttus = HttpStatus.OK;
			}
			
		}

		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 로그아웃
	 * @param req
	 * @return String 
	 */
	@RequestMapping(value="logout.do")
	public String logout(HttpServletRequest req){
		req.getSession().removeAttribute("loginInfo");
		req.getSession().removeAttribute("refUrl");
		req.getSession().removeAttribute("refMethod");
		return "redirect:/index.do";
	}
}
