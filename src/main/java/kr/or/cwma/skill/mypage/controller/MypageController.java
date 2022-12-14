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
 * ??????????????? ????????????
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
	 * ??????????????? ????????? ?????????
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

				// ????????? ?????? ????????? ??????
				int cnt = mypageService.selectCntrctListCnt(uvo);

				if ("USSE0003".equals(uvo.getSe()) && cnt == 0) {
					retPage = "skill/mypage/indexAuth";// ????????? ????????????
				} else {
					req.setAttribute("gradList", mypageService.selectGradList(uvo));
					req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("AGSE0000")); // ??????????????????
				}

			} else {
				req.setAttribute("gradList", mypageService.selectGradListForDminstt(uvo));
				req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("AGSE0000")); // ??????????????????
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
	 * ????????????
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
	 * ???????????? ??????
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
		
		// ????????? ???
		if(!StringUtils.isEmpty(uvo.getUserId())) {
			vo.setUserId(uvo.getUserId());
			eo = userInfoService.selectUserInfoView(vo);
		
			if(!ps.equals(eo.getPassword()))
				msg = "??????????????? ???????????? ????????????";
			
			else if(StringUtils.isEmpty(uvo.getIhidnum()) && (StringUtils.isEmpty(uvo.getNiceVO().getJumin1()) || StringUtils.isEmpty(uvo.getNiceVO().getJumin2())))
				msg = "??????????????? ????????????";
			
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
			
		// ???????????? ???	
		}else {
			if(StringUtils.isEmpty(uvo.getIhidnum()) && (StringUtils.isEmpty(uvo.getNiceVO().getJumin1()) || StringUtils.isEmpty(uvo.getNiceVO().getJumin2()))) {
				msg = "????????? ??????????????? ????????????";
				
			}else {
				vo.setIhidnum(uvo.getNiceVO().getJumin1().concat("-").concat(uvo.getNiceVO().getJumin2()));
				uvo.setIhidnum(vo.getIhidnum());
				uvo.setMyPageLogin(true);
				
				// ?????????????????? ??????
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
	 * ????????? ???????????? ???????????????
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaList.do")
	public String qnaList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //????????????
		return "skill/mypage/qnaList";
	}
	
	/**
	 * ????????? ???????????? ????????????
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
	 * ????????? ???????????? ???????????????
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
			req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //????????????
			
		}
		
		return retPage;
	}
	
	/**
	 * ????????? ???????????? ????????????
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
	 * ????????? ???????????? ??????
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
			msg = "???????????? ?????????????????????";
		}
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * ????????? ???????????? ??????
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
			msg = "???????????? ?????????????????????";
		
		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * ?????????????????? ?????? ?????????
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
	 * ???????????? ?????? ?????????
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
	 * ?????? ??????
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
		
		//??????
		if(vo.getSe().equals("USSE0001")){
			ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
			
			if(!ps.equals(eo.getPassword()))
				msg = "??????????????? ???????????? ????????????";
			else
				lvo.setRetSysTime(System.currentTimeMillis());
		
		//?????????
		}else if(vo.getSe().equals("USSE0003")){
			if(!lvo.getAuthVO().getCiValue().equals(eo.getCiValue()))
				msg = "???????????? ???????????? ????????????. ?????? ??????????????????";
			
		//?????????, ????????????
		}else{
			if(!lvo.getDnValue().equals(eo.getDnValue()))
				msg = "???????????? ???????????? ????????????. ?????? ??????????????????";
			
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
	 * ?????????????????? ?????????
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
			List<CmmnCdVO> cmmnList = cmmnCdService.selectCmmnCdChildList("SNSE0000");// SNS?????? ?????? ??????


			// ?????? SNS ?????? ??????
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
	 * ??????????????????
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
			// ????????? ??????
			vo.setEmailRecptnAgreAt(!StringUtils.isEmpty(vo.getEmailRecptnAgreAt()) ? vo.getEmailRecptnAgreAt() : "N");
			vo.setSmsRecptnAgreAt(!StringUtils.isEmpty(vo.getSmsRecptnAgreAt()) ? vo.getSmsRecptnAgreAt() : "N");
			
			vo.setUserId(lvo.getUserId());
			userInfoService.updateUserInfo(vo);
			
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ??????????????????
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
	 * ???????????? ?????????
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
	 * ????????????
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
			// ?????? SNS ??????
			snsVo.setUserId(lvo.getUserId());
			userSnsAuthorService.deleteUserSnsAuthor(snsVo);

			// ?????? ??????
			vo.setUserId(lvo.getUserId());
			userInfoService.deleteUserInfo(vo);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ???????????????(????????????) ?????????
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEdu.do")
	public String clmserEdu(HttpServletRequest req) throws SQLException{
		return "skill/mypage/clmserEdu";
	}
	
	/**
	 * ??????????????? ??????
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEduList.do")
	public String clmserEduList(HttpServletRequest req, @ModelAttribute("vo") ClmserEduVO vo) throws SQLException{
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		// ???????????? ?????? ??????
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
	 * ??????????????? ??????
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
			tmp.put("defaultMessage", "?????? ???????????? ????????? ????????????.");
			result.add(tmp);
			map.put("errors", result);
			
		}else {
			mypageService.insertClmserEduSurveyAnswer(vo, evo);
			uvo.setClmserEduComplAt("Y");
		}
		
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * ????????? ?????? ????????? ?????????
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="testReportPop.do")
	public String testReportPop() throws SQLException{
		return "skill/mypage/testReportPop";
	}

	/**
	 * SNS?????? ??????
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

		// ????????????
		if ("USSE0001".equals(lvo.getSe()) && snsVo != null && "Y".equals(snsVo.getAuthYn())) {

			if (!StringUtils.isEmpty(snsVo.getSe()) && !StringUtils.isEmpty(snsVo.getSnsId())) {
				snsVo.setUserId(lvo.getUserId());
				int result = userSnsAuthorService.insertUserSnsAuthor(snsVo);
				if (result > 0) {
					success = true;
					// ?????? SNS ??????
					if(!"Y".equals(lvo.getStplatSnsAgreAt())) {
						UserInfoVO insertvo = new UserInfoVO();
						insertvo.setUserId(lvo.getUserId());
						insertvo.setStplatSnsAgreAt("Y");
						userInfoService.updateUserInfo(insertvo);//???????????? ??????
					}
					
				} else {
					msg = "SNS ??????????????? ??????????????????.";
				}
			} else {
				msg = "SNS ??????????????? ???????????? ????????????. ?????? ??????????????????.";
			}
		} else {
			msg = "SNS ??????????????? ???????????? ????????????. ?????? ??????????????????.";
		}

		map.put("msg", msg);
		map.put("success", success);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * SNS?????? ????????????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 * @throws NoSuchAlgorithmException
	 */
	@RequestMapping(value = "deleteUserSnsAuthor.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> deleteUserSnsAuthor(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException {

		String msg = "SNS ??????????????? ??????????????????.";
		boolean success = false;

		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");
		UserSnsAuthorVO snsVo = vo.getUserSnsAuthorVO();

		// ????????????
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
	 * ??????????????? ????????? ?????????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value = "getAgentList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getAgentList(HttpServletRequest req, UserCntrctRelateVO vo) throws SQLException {
		String msg = "????????? ????????? ??????????????????.";
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

			List<CmmnCdVO> seList = cmmnCdService.selectCmmnCdChildList("AGSE0000");// ??????????????????
			String se = null;// ????????????
			for (CmmnCdVO cmmnCdVO : seList) {
				if (cmmnCdVO.getCdNm().equals(vo.getSeNm())) {
					vo.setSe(cmmnCdVO.getCdId());
					se = cmmnCdVO.getCdId();
				}
			}

			// ????????????
			if ("USSE0002".equals(lvo.getSe()) && !StringUtils.isEmpty(se)) {
				if ("AGSE0001".equals(se)) {
					cntrctInfo = mypageService.selectCntrctInfo(uvo);// ?????? ??????(????????????)
				} else {
					cntrctInfo = mypageService.selectCntrctWorkInfo(uvo);// ?????? ??????(????????????)
				}
			}

			// ????????? ?????? ??????
			if (cntrctInfo != null) {
				cntrctInfo.setDminsttNm(lvo.getCorpInfoVO().getCorpNm() != null ? lvo.getCorpInfoVO().getCorpNm() : lvo.getDminsttInfoVO().getDminsttNm());
				cntrctInfo.setDminsttTel(lvo.getCorpInfoVO().getTelNo() != null ? lvo.getCorpInfoVO().getTelNo() : lvo.getDminsttInfoVO().getTelNo());

				list = userCntrctRelateService.selectUserCntrctRelateList(vo);
				success = true;
			}

			map.put("se", se);// ????????????
			map.put("codeList", cmmnCdService.selectCmmnCdChildList("AGAU0000"));// ????????????

		}

		map.put("msg", msg);
		map.put("success", success);
		map.put("cntrctInfo", cntrctInfo);
		map.put("list", list);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * ??????????????? ????????? ?????? ??????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value = "updateAgentAuthor.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateAgentAuthor(HttpServletRequest req, UserCntrctRelateVO vo) throws SQLException {
		String msg = "????????? ?????? ????????? ??????????????????.";
		Integer result = 0;
		boolean success = false;

		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");// ?????????

		UserInfoVO tmp;
		if (vo.getList() != null) {
			for (UserCntrctRelateVO agentVo : vo.getList()) {
				// ?????? ?????? ??????
				if (!StringUtils.isEmpty(agentVo.getAuthorCd())) {
					result = 0;
					tmp = new UserInfoVO();
					tmp.setUserId(agentVo.getUserId());
					
					UserInfoVO eo = userInfoService.selectUserInfoView(tmp);// ?????????
					if (eo != null) {
						agentVo.setDdcJoinNo(vo.getDdcJoinNo());
						agentVo.setSe(vo.getSe());
						
						// ?????? ????????????
						UserCntrctRelateVO ucrVo = userCntrctRelateService.selectUserCntrctRelate(agentVo);
						if(ucrVo == null){
							// ????????? ?????? ?????? ??????
							int cnt = userCntrctRelateService.isUserCntrctRelate(agentVo);
							if (cnt == 0) {
								result = userCntrctRelateService.insertUserCntrctRelate(agentVo);// ??????
								
							} else {
								result = userCntrctRelateService.updateUserCntrctRelate(agentVo);// ??????
							}
							
							// ???????????? ??? ?????? ??????
							if (result > 0 && "AGAU0001".equals(agentVo.getAuthorCd())) {
								String corpNm = lvo.getCorpInfoVO().getCorpNm() != null ? lvo.getCorpInfoVO().getCorpNm() : lvo.getDminsttInfoVO().getDminsttNm();
								smsSendHistService.sendSmsAuto("SSSE0010", eo.getMoblphonNo(), eo.getNm(), corpNm);
							}
						}
					}
				}
			}

			success = true;
			msg = "????????? ????????? ?????????????????????.";
		}

		map.put("msg", msg);
		map.put("success", success);

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * ????????????/???????????? ???????????? ??????(?????????/????????????)
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value = "getCntrctList.do", method = RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getCntrctList(HttpServletRequest req, UserInfoVO vo) throws SQLException {
		String msg = "????????? ????????? ??????????????????.";
		boolean success = false;

		List<CntrctInfoVO> cntrctList = null;
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO) req.getSession().getAttribute("loginInfo");

		vo.setBizno(lvo.getBizno());
		vo.setSe(lvo.getSe());
		vo.setUserId(lvo.getUserId());
		// ????????? | ?????????
		if ("USSE0002".equals(lvo.getSe()) || "USSE0003".equals(lvo.getSe())) {
			cntrctList = mypageService.selectCntrctList(vo);

			// ????????????
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
