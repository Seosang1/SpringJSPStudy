package kr.or.cwma.skill.mypage.controller;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.bbs.service.BbsService;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.clmserEdu.service.ClmserEduService;
import kr.or.cwma.admin.clmserEdu.vo.ClmserEduVO;
import kr.or.cwma.admin.clmserEdu.vo.UserClmserEduRelVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.smsSendHist.service.SmsSendHistService;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserCntrctRelateVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.CryptUtil;
import kr.or.cwma.common.util.NiceIdUtil;
import kr.or.cwma.common.vo.NiceIdVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;
import kr.or.cwma.skill.mypage.service.MypageService;
import kr.or.cwma.skill.userCntrctRelate.service.UserCntrctRelateService;
import kr.or.cwma.skill.userSnsAuthor.service.UserSnsAuthorService;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;
import signgate.crypto.util.CertUtil;
import signgate.crypto.util.FileUtil;

/**
 * 마이페이지 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/mypage")
public class MypageController{
	@Value("#{prop['cert.kmCert']}")
	String kmCert;

	@Autowired
	BbsService bbsService;
	
	@Autowired
	MypageService mypageService;
	
	@Autowired
	UserInfoService userInfoService;
	
	@Autowired
	NiceIdUtil niceIdUtil;
	
	@Autowired
	CmmnCdService cmmnCdService;
	
	@Autowired
	CareerDeclareService careerDeclareService;
	
	@Autowired
	private ClmserEduService clmserEduService;

	@Autowired
	UserSnsAuthorService userSnsAuthorService;

	@Autowired
	UserCntrctRelateService userCntrctRelateService;

	@Autowired
	SmsSendHistService smsSendHistService;
	
	@Autowired
	CrtfIssuService crtfIssuService;

	/**
	 * 마이페이지 인덱스 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="index.do", method=RequestMethod.GET)
	public String index(HttpServletRequest req) throws SQLException{
		String retPage = "skill/mypage/index";
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		CareerDeclareVO careerDeclareVO = new CareerDeclareVO();
		CrtfIssuVO cvo = new CrtfIssuVO();
		
		List<CareerDeclareVO> licenseList, eduList, rewardList;
		
		if(uvo.getSe().equals("USSE0001")){
			if(!StringUtils.isEmpty(uvo.getIhidnum())){
				careerDeclareVO.setCntcType("mypage");
				careerDeclareVO.setNm(uvo.getNm());
				careerDeclareVO.setJumin1(uvo.getIhidnum().split("-")[0]);
				careerDeclareVO.setJumin2(uvo.getIhidnum().split("-")[1]);
				cvo.setIssuTrgterIhidnum(uvo.getIhidnum());

				req.setAttribute("eo", mypageService.selectUserBasicInfo(uvo));
				req.setAttribute("workEo", mypageService.selectUserWorkDay(uvo));
				req.setAttribute("gradEo", crtfIssuService.searchCrtfHistory(cvo));
				
				licenseList = careerDeclareService.selectIhidnumLicense(careerDeclareVO);
				eduList = careerDeclareService.selectIhidnumEdu(careerDeclareVO);
				rewardList = careerDeclareService.selectIhidnumReward(careerDeclareVO);
				
				req.setAttribute("license", licenseList);
				req.setAttribute("licenseCnt", licenseList.size());
				req.setAttribute("edu", eduList);
				req.setAttribute("eduCnt", eduList.size());
				req.setAttribute("reward", rewardList);
				req.setAttribute("rewardCnt", rewardList.size());
			}
			
		}else{
			retPage = "skill/mypage/indexCorp";
			if(uvo.getSe().equals("USSE0002") || uvo.getSe().equals("USSE0003")){

				// 대리인 공사 카운트 조회
				int cnt = mypageService.selectCntrctListCnt(uvo);

				if ("USSE0003".equals(uvo.getSe()) && cnt == 0) {
					retPage = "skill/mypage/indexAuth";// 대리인 승인대기
				} else {
					req.setAttribute("gradList", mypageService.selectGradList(uvo));
					req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("AGSE0000")); // 공사분류코드
				}

			} else {
				req.setAttribute("gradList", mypageService.selectGradListForDminstt(uvo));
				req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("AGSE0000")); // 공사분류코드
				req.setAttribute("cntrctList", mypageService.selectCntrctListForDminstt(uvo));
			}

			req.setAttribute("isAgent", "USSE0002".equals(uvo.getSe()) ? true : false);
		}
		
		if(null != req.getParameter("mainJssfc")) {
			req.setAttribute("mainJssfc", "0");
		}
		
		return retPage;
	}
	
	/**
	 * 실명인증
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>>
	 */
	@RequestMapping(value="juminAuth.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> juminAuth(HttpServletRequest req, NiceIdVO vo){
		String msg = "";
		HttpStatus sttus = HttpStatus.OK;
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		vo.setNm(uvo.getNm());
		msg = niceIdUtil.chkJumin(vo);
		
		if(!StringUtils.isEmpty(msg))
			sttus = HttpStatus.BAD_REQUEST;
		
		else{
			uvo.setNiceVO(new NiceIdVO());
			uvo.getNiceVO().setJumin1(vo.getJumin1());
			uvo.getNiceVO().setJumin2(vo.getJumin2());
			
		}
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 주민번호 입력
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="updateJumin.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateJumin(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		String msg = "";
		String ps = !StringUtils.isEmpty(vo.getPassword()) ? CryptUtil.encriptSHA512(vo.getPassword().trim()) : "";
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		UserInfoVO eo;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		// 회원일 때
		if(!StringUtils.isEmpty(uvo.getUserId())) {
			vo.setUserId(uvo.getUserId());
			eo = userInfoService.selectUserInfoView(vo);
		
			if(!ps.equals(eo.getPassword()))
				msg = "비밀번호가 일치하지 않습니다";
			
			else if(StringUtils.isEmpty(uvo.getIhidnum()) && (StringUtils.isEmpty(uvo.getNiceVO().getJumin1()) || StringUtils.isEmpty(uvo.getNiceVO().getJumin2())))
				msg = "실명확인을 해주세요";
			
			else if(StringUtils.isEmpty(uvo.getIhidnum())){
				vo.setIhidnum(uvo.getNiceVO().getJumin1().concat("-").concat(uvo.getNiceVO().getJumin2()));
				mypageService.updateUserIhidnum(vo);
				
				uvo.setIhidnum(vo.getIhidnum());
				uvo.setMyPageLogin(true);
				sttus = HttpStatus.OK;
				
			}else if(!StringUtils.isEmpty(uvo.getIhidnum())){
				uvo.setMyPageLogin(true);
				sttus = HttpStatus.OK;
			}
			
		// 비회원일 때	
		}else {
			if(StringUtils.isEmpty(uvo.getIhidnum()) && (StringUtils.isEmpty(uvo.getNiceVO().getJumin1()) || StringUtils.isEmpty(uvo.getNiceVO().getJumin2()))) {
				msg = "비회원 실명확인을 해주세요";
				
			}else {
				vo.setIhidnum(uvo.getNiceVO().getJumin1().concat("-").concat(uvo.getNiceVO().getJumin2()));
				uvo.setIhidnum(vo.getIhidnum());
				uvo.setMyPageLogin(true);
				
				// 최초교육이수 여부
				UserClmserEduRelVO evo = new UserClmserEduRelVO();
				evo.setIhidnum(vo.getIhidnum());
				UserClmserEduRelVO evoInfo = clmserEduService.selectUserClmserEduRelView(evo);
				String eduComplAt = (evoInfo != null && "Y".equals(evoInfo.getComplAt())) ? evoInfo.getComplAt() : "N";
				uvo.setClmserEduComplAt(eduComplAt);
				
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
	 * 온라인 상담내역 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaList.do")
	public String qnaList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //상담유형
		return "skill/mypage/qnaList";
	}
	
	/**
	 * 온라인 상담내역 목록조회
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> qnaListPost(HttpServletRequest req, BbsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if(!StringUtils.isEmpty(uvo.getUserId()))
			vo.setRgstId(uvo.getUserId());
		
		else{
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe()))
				vo.setRgstId(uvo.getAuthVO().getCiValue());
			else
				vo.setRgstId(uvo.getDnValue());
		}
		
		vo.setSe("BSSE0003");
		
		map.put("list", bbsService.selectBbsList(vo));
		map.put("vo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 온라인 상담내역 수정페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaForm.do")
	public String qnaForm(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		String retPage = "skill/mypage/qnaForm";
		BbsVO eo;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if(!StringUtils.isEmpty(uvo.getUserId()))
			vo.setRgstId(uvo.getUserId());
		
		else{
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe()))
				vo.setRgstId(uvo.getAuthVO().getCiValue());
			else
				vo.setRgstId(uvo.getDnValue());
		}
		
		vo.setSe("BSSE0003");
		eo = mypageService.selectQnaView(vo);
		
		if(eo == null || StringUtils.isEmpty(eo.getSj()))
			retPage = "redirect:/index.do";
		
		else if(!StringUtils.isEmpty(eo.getAnswer()))
			retPage = "redirect:/index.do";
		
		else{
			req.setAttribute("eo", eo);
			req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //상담유형
			
		}
		
		return retPage;
	}
	
	/**
	 * 온라인 상담내역 상세조회
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaView.do")
	public String qnaView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		BbsVO eo;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if(!StringUtils.isEmpty(uvo.getUserId()))
			vo.setRgstId(uvo.getUserId());
		
		else{
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe()))
				vo.setRgstId(uvo.getAuthVO().getCiValue());
			else
				vo.setRgstId(uvo.getDnValue());
		}
		
		vo.setSe("BSSE0003");
		eo = mypageService.selectQnaView(vo);
		
		if(eo == null || StringUtils.isEmpty(eo.getSj()))
			return "redirect:/index.do";
			
		req.setAttribute("eo", eo);
		return "skill/mypage/qnaView";
	}
	
	/**
	 * 온라인 상담내역 수정
	 * @param req
	 * @param multi
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="qnaUpdate.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> qnaUpdate(HttpServletRequest req, MultipartHttpServletRequest multi, BbsVO vo) throws SQLException, IOException{
		String msg = "";
		BbsVO eo;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		HttpStatus sttus = HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		if(!StringUtils.isEmpty(uvo.getUserId())){
			vo.setRgstId(uvo.getUserId());
			vo.setChgId(uvo.getUserId());
		
		}else{
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe())){
				vo.setRgstId(uvo.getAuthVO().getCiValue());
				vo.setChgId(uvo.getAuthVO().getCiValue());
			}else{
				vo.setRgstId(uvo.getDnValue());
				vo.setChgId(uvo.getDnValue());
			}
		}
		
		vo.setSe("BSSE0003");
		eo = mypageService.selectQnaView(vo);
		
		if(eo != null && !StringUtils.isEmpty(eo.getSj()))
			bbsService.updateBbs(vo, multi);
		else{
			sttus = HttpStatus.BAD_REQUEST;
			msg = "본인글만 수정가능합니다";
		}
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 온라인 상담내역 삭제
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaDelete.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> qnaDelete(HttpServletRequest req, BbsVO vo) throws SQLException{
		String msg = "";
		BbsVO eo;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		vo.setRgstId(uvo.getUserId());
		eo = mypageService.selectQnaView(vo);
		
		if(eo != null && !StringUtils.isEmpty(eo.getSj())) {
			bbsService.deleteBbs(vo);
			sttus = HttpStatus.OK;
		}else
			msg = "본인글만 삭제가능합니다";
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 회원정보변경 인증 페이지
	 * @param req 
	 * @return String 
	 * @throws Exception 
	 * @throws IOException 
	 */
	@RequestMapping(value="userForm.do", method=RequestMethod.GET)
	public String userForm(HttpServletRequest req) throws IOException, Exception{
		req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/mypage/userAuth";
	}
	
	/**
	 * 회원탈퇴 인증 페이지
	 * @param req 
	 * @return String 
	 * @throws Exception 
	 * @throws IOException 
	 */
	@RequestMapping(value="userBye.do", method=RequestMethod.GET)
	public String userBye(HttpServletRequest req) throws IOException, Exception{
		req.setAttribute("kmCertPem", CertUtil.derToPem(FileUtil.readBytesFromFileName(kmCert)).replaceAll("\n", ""));
		return "skill/mypage/userAuth";
	}
	
	/**
	 * 회원 인증
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="userAuth.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> userAuth(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		String msg = "";
		String ps = "";
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		UserInfoVO eo;
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");

		vo.setUserId(lvo.getUserId());
		eo = userInfoService.selectUserInfoView(vo);		
		
		//개인
		if(vo.getSe().equals("USSE0001")){
			ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
			
			if(!ps.equals(eo.getPassword()))
				msg = "비밀번호가 일치하지 않습니다";
			else
				lvo.setRetSysTime(System.currentTimeMillis());
		
		//대리인
		}else if(vo.getSe().equals("USSE0003")){
			if(!lvo.getAuthVO().getCiValue().equals(eo.getCiValue()))
				msg = "인증서가 일치하지 않습니다. 다시 확인해주세요";
			
		//사업자, 수요기관
		}else{
			if(!lvo.getDnValue().equals(eo.getDnValue()))
				msg = "인증서가 일치하지 않습니다. 다시 확인해주세요";
			
		}
		
		if(StringUtils.isEmpty(msg))
			sttus = HttpStatus.OK;
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 회원정보변경 페이지
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="userForm.do", method=RequestMethod.POST)
	public String userFormPost(HttpServletRequest req) throws SQLException{
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		long authTime = (System.currentTimeMillis() - uvo.getRetSysTime())/1000/60;
		
		if(authTime > 5)
			return "redirect:/skill/mypage/userForm.do";
		else {
			List<CmmnCdVO> cmmnList = cmmnCdService.selectCmmnCdChildList("SNSE0000");// SNS구분 코드 조회


			// 회원 SNS 정보 조회
			UserSnsAuthorVO snsVo;
			for (CmmnCdVO cmmnCdVO : cmmnList) {
				snsVo = new UserSnsAuthorVO();
				snsVo.setUserId(uvo.getUserId());
				snsVo.setSe(cmmnCdVO.getCdId());
				req.setAttribute(cmmnCdVO.getCdNm(), userSnsAuthorService.selectUserSnsAuthorView(snsVo));
			}

			req.setAttribute("eo", userInfoService.selectUserInfoView(uvo));
		}
		
		return "skill/mypage/userForm";
	}
	
	/**
	 * 회원정보변경
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="updateUserInfo.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateUserInfo(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		long authTime = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		authTime = (System.currentTimeMillis() - lvo.getRetSysTime())/1000/60;
		
		if(authTime > 5)
			map.put("timeout", true);
		
		else{
			// 유효성 체크
			vo.setEmailRecptnAgreAt(!StringUtils.isEmpty(vo.getEmailRecptnAgreAt()) ? vo.getEmailRecptnAgreAt() : "N");
			vo.setSmsRecptnAgreAt(!StringUtils.isEmpty(vo.getSmsRecptnAgreAt()) ? vo.getSmsRecptnAgreAt() : "N");
			
			vo.setUserId(lvo.getUserId());
			userInfoService.updateUserInfo(vo);
			
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 비밀번호변경
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="updateUserPass.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateUserPass(HttpServletRequest req, @Valid UserInfoVO vo, BindingResult result) throws SQLException, NoSuchAlgorithmException{
		long authTime = 0;

		FieldError err;
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		
		Iterator<FieldError> iter;
		List<FieldError> list = new ArrayList<FieldError>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		authTime = (System.currentTimeMillis() - lvo.getRetSysTime())/1000/60;
		
		if(authTime > 5)
			map.put("timeout", true);
		
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
			
		}else{
			vo.setUserId(lvo.getUserId());
			mypageService.updateUserPassword(vo);
			sttus = HttpStatus.OK;
		}
		
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 회원탈퇴 페이지
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="userBye.do", method=RequestMethod.POST)
	public String userByePost(HttpServletRequest req) throws SQLException{
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		long authTime = (System.currentTimeMillis() - uvo.getRetSysTime())/1000/60;
		
		if(authTime > 5)
			return "redirect:/skill/mypage/userBye.do";
		
		return "skill/mypage/userBye";
	}
	
	/**
	 * 회원탈퇴
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws NoSuchAlgorithmException 
	 */
	@RequestMapping(value="deleteUserInfo.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> deleteUserInfo(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		long authTime = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		UserSnsAuthorVO snsVo = new UserSnsAuthorVO();
		
		authTime = (System.currentTimeMillis() - lvo.getRetSysTime())/1000/60;
		
		if(authTime > 5)
			map.put("timeout", true);

		else {
			// 회원 SNS 탈퇴
			snsVo.setUserId(lvo.getUserId());
			userSnsAuthorService.deleteUserSnsAuthor(snsVo);

			// 회원 탈퇴
			vo.setUserId(lvo.getUserId());
			userInfoService.deleteUserInfo(vo);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 맞춤형교육(최초교육) 페이지
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEdu.do")
	public String clmserEdu(HttpServletRequest req) throws SQLException{
		return "skill/mypage/clmserEdu";
	}
	
	/**
	 * 맞춤형교육 목록
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEduList.do")
	public String clmserEduList(HttpServletRequest req, @ModelAttribute("vo") ClmserEduVO vo) throws SQLException{
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		// 설문완료 여부 체크
		UserClmserEduRelVO evo = new UserClmserEduRelVO();
		evo.setIhidnum(uvo.getIhidnum());
		
		vo.setSe("CESE0001");
		vo.setIhidnum(uvo.getIhidnum());
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("CESE0000"));
		req.setAttribute("list", clmserEduService.selectClmserEduList(vo));
		req.setAttribute("serveyVo", clmserEduService.selectUserClmserEduRelView(evo));
		
		return "skill/mypage/clmserEduList";
	}
	
	/**
	 * 맞춤형교육 등록
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEduInsert.do")
	public ResponseEntity<Map<String, Object>> surveyInsert(HttpServletRequest req, UserClmserEduRelVO evo, SurveyAnswrrVO vo) throws SQLException{
		HttpStatus sttus = HttpStatus.OK;
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		UserClmserEduRelVO eo;

		vo.setAnswrrId(uvo.getIhidnum());
		evo.setIhidnum(uvo.getIhidnum());
		eo = clmserEduService.selectUserClmserEduRelView(evo);
		
		if(eo != null && eo.getSn() > 0){
			sttus = HttpStatus.BAD_REQUEST;
			tmp.put("field", "");
			tmp.put("defaultMessage", "이미 이수하신 이력이 있습니다.");
			result.add(tmp);
			map.put("errors", result);
			
		}else {
			mypageService.insertClmserEduSurveyAnswer(vo, evo);
			uvo.setClmserEduComplAt("Y");
		}
		
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 프린터 출력 테스트 페이지
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="testReportPop.do")
	public String testReportPop() throws SQLException{
		return "skill/mypage/testReportPop";
	}

	/**
	 * SNS계정 연동
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 * @throws NoSuchAlgorithmException
	 */
	@RequestMapping(value = "insertUserSnsAuthor.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertUserSnsAuthor(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException {
		String msg = "";
		boolean success = false;

		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");
		UserSnsAuthorVO snsVo = vo.getUserSnsAuthorVO();

		// 개인회원
		if ("USSE0001".equals(lvo.getSe()) && snsVo != null && "Y".equals(snsVo.getAuthYn())) {

			if (!StringUtils.isEmpty(snsVo.getSe()) && !StringUtils.isEmpty(snsVo.getSnsId())) {
				snsVo.setUserId(lvo.getUserId());
				int result = userSnsAuthorService.insertUserSnsAuthor(snsVo);
				if (result > 0) {
					success = true;
					// 약관 SNS 동의
					if(!"Y".equals(lvo.getStplatSnsAgreAt())) {
						UserInfoVO insertvo = new UserInfoVO();
						insertvo.setUserId(lvo.getUserId());
						insertvo.setStplatSnsAgreAt("Y");
						userInfoService.updateUserInfo(insertvo);//회원정보 수정
					}
					
				} else {
					msg = "SNS 연동하기를 실패했습니다.";
				}
			} else {
				msg = "SNS 인증정보가 존재하지 않습니다. 다시 인증해주세요.";
			}
		} else {
			msg = "SNS 인증정보가 존재하지 않습니다. 다시 인증해주세요.";
		}

		map.put("msg", msg);
		map.put("success", success);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * SNS계정 연동해제
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 * @throws NoSuchAlgorithmException
	 */
	@RequestMapping(value = "deleteUserSnsAuthor.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> deleteUserSnsAuthor(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException {

		String msg = "SNS 연동해제를 실패했습니다.";
		boolean success = false;

		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");
		UserSnsAuthorVO snsVo = vo.getUserSnsAuthorVO();

		// 개인회원
		if ("USSE0001".equals(lvo.getSe()) && snsVo != null && !StringUtils.isEmpty(snsVo.getSe())) {
			snsVo.setUserId(lvo.getUserId());

			int result = userSnsAuthorService.deleteUserSnsAuthor(snsVo);
			if (result > 0) {
				success = true;
			}
		}

		map.put("msg", msg);
		map.put("success", success);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 마이페이지 대리인 리스트
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value = "getAgentList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getAgentList(HttpServletRequest req, UserCntrctRelateVO vo) throws SQLException {
		String msg = "데이터 조회에 실패했습니다.";
		boolean success = false;

		UserInfoVO uvo = new UserInfoVO();
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");
		CntrctInfoVO cntrctInfo = null;
		List<UserCntrctRelateVO> list = null;

		if (!StringUtils.isEmpty(vo.getDdcJoinNo())) {
			vo.setBizno(lvo.getBizno());
			uvo.setBizno(lvo.getBizno());
			uvo.setDdcJoinNo(vo.getDdcJoinNo());

			List<CmmnCdVO> seList = cmmnCdService.selectCmmnCdChildList("AGSE0000");// 분류구분코드
			String se = null;// 분류코드
			for (CmmnCdVO cmmnCdVO : seList) {
				if (cmmnCdVO.getCdNm().equals(vo.getSeNm())) {
					vo.setSe(cmmnCdVO.getCdId());
					se = cmmnCdVO.getCdId();
				}
			}

			// 공사정보
			if ("USSE0002".equals(lvo.getSe()) && !StringUtils.isEmpty(se)) {
				if ("AGSE0001".equals(se)) {
					cntrctInfo = mypageService.selectCntrctInfo(uvo);// 공사 조회(퇴직공제)
				} else {
					cntrctInfo = mypageService.selectCntrctWorkInfo(uvo);// 공사 조회(고용보험)
				}
			}

			// 대리인 목록 조회
			if (cntrctInfo != null) {
				cntrctInfo.setDminsttNm(lvo.getCorpInfoVO().getCorpNm() != null ? lvo.getCorpInfoVO().getCorpNm() : lvo.getDminsttInfoVO().getDminsttNm());
				cntrctInfo.setDminsttTel(lvo.getCorpInfoVO().getTelNo() != null ? lvo.getCorpInfoVO().getTelNo() : lvo.getDminsttInfoVO().getTelNo());

				list = userCntrctRelateService.selectUserCntrctRelateList(vo);
				success = true;
			}

			map.put("se", se);// 분류코드
			map.put("codeList", cmmnCdService.selectCmmnCdChildList("AGAU0000"));// 권한코드

		}

		map.put("msg", msg);
		map.put("success", success);
		map.put("cntrctInfo", cntrctInfo);
		map.put("list", list);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 마이페이지 대리인 권한 변경
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value = "updateAgentAuthor.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateAgentAuthor(HttpServletRequest req, UserCntrctRelateVO vo) throws SQLException {
		String msg = "대리인 권한 수정에 실패했습니다.";
		Integer result = 0;
		boolean success = false;

		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");// 사업주

		UserInfoVO tmp;
		if (vo.getList() != null) {
			for (UserCntrctRelateVO agentVo : vo.getList()) {
				// 권한 선택 여부
				if (!StringUtils.isEmpty(agentVo.getAuthorCd())) {
					result = 0;
					tmp = new UserInfoVO();
					tmp.setUserId(agentVo.getUserId());
					
					UserInfoVO eo = userInfoService.selectUserInfoView(tmp);// 대리인
					if (eo != null) {
						agentVo.setDdcJoinNo(vo.getDdcJoinNo());
						agentVo.setSe(vo.getSe());
						
						// 권한 상세조회
						UserCntrctRelateVO ucrVo = userCntrctRelateService.selectUserCntrctRelate(agentVo);
						if(ucrVo == null){
							// 대리인 권한 등록 여부
							int cnt = userCntrctRelateService.isUserCntrctRelate(agentVo);
							if (cnt == 0) {
								result = userCntrctRelateService.insertUserCntrctRelate(agentVo);// 등록
								
							} else {
								result = userCntrctRelateService.updateUserCntrctRelate(agentVo);// 수정
							}
							
							// 권한승인 시 문자 발송
							if (result > 0 && "AGAU0001".equals(agentVo.getAuthorCd())) {
								String corpNm = lvo.getCorpInfoVO().getCorpNm() != null ? lvo.getCorpInfoVO().getCorpNm() : lvo.getDminsttInfoVO().getDminsttNm();
								smsSendHistService.sendSmsAuto("SSSE0010", eo.getMoblphonNo(), eo.getNm(), corpNm);
							}
						}
					}
				}
			}

			success = true;
			msg = "대리인 권한이 수정되었습니다.";
		}

		map.put("msg", msg);
		map.put("success", success);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 퇴직공제/고용보험 공사목록 조회(사업주/수요기관)
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value = "getCntrctList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getCntrctList(HttpServletRequest req, UserInfoVO vo) throws SQLException {
		String msg = "데이터 조회에 실패했습니다.";
		boolean success = false;

		List<CntrctInfoVO> cntrctList = null;
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");

		vo.setBizno(lvo.getBizno());
		vo.setSe(lvo.getSe());
		vo.setUserId(lvo.getUserId());
		// 대리인 | 사업주
		if ("USSE0002".equals(lvo.getSe()) || "USSE0003".equals(lvo.getSe())) {
			cntrctList = mypageService.selectCntrctList(vo);

			// 수요기관
		} else if ("USSE0004".equals(lvo.getSe())) {
			cntrctList = mypageService.selectCntrctListForDminstt(vo);
		}

		if (cntrctList != null) {
			success = true;
			map.put("cntrctList", cntrctList);
			map.put("vo", vo);
		}

		map.put("msg", msg);
		map.put("success", success);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
