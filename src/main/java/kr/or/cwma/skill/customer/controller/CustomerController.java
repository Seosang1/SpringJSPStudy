package kr.or.cwma.skill.customer.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.survey.service.SurveyInfoService;
import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.skill.customer.service.CustomerService;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;

/**
 * 고객센터 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/customer")
public class CustomerController{
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private SurveyInfoService surveyService;
	
	@Autowired
	private CustomerService customerService;
	
	@Autowired
	private UserInfoService userInfoService;

	/**
	 * 이용안내
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="guidance.do", method=RequestMethod.GET)
	public String guidance(HttpServletRequest req){
		return "skill/customer/guidance";
	}
	
	/**
	 * 자주하는 질문 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="faqList.do", method=RequestMethod.GET)
	public String faqList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo){
		return "skill/customer/faqList";
	}

	/**
	 * 온라인상담
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="online.do", method=RequestMethod.GET)
	public String online(HttpServletRequest req){
		return "skill/customer/online";
	}

	/**
	 * 온라인상담 - 입력 폼
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaForm.do", method=RequestMethod.GET)
	public String qnaForm(HttpServletRequest req) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //상담유형
		return "skill/customer/qnaForm";
	}
	
	/**
	 * 온라인상담 - 등록
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaInsert.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, MultipartHttpServletRequest multi, @Valid BbsVO vo, BindingResult result) throws SQLException{
		String msg = "";
		HttpStatus sttus =  HttpStatus.OK;
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> err = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();
		

		if(!result.hasErrors()){
			try{
				vo.setSe("BSSE0003");
				vo.setSmsRecptnAgreAt("Y");
				customerService.insertBbs(vo, multi);
				
			}catch(IOException e){
				err.put("field", "file");
				msg = e.getMessage();
			}
			
		}else{
			map.put("errors", result.getFieldErrors());
			sttus = HttpStatus.BAD_REQUEST;
		}
		
		if(StringUtils.isNotEmpty(msg)){
			err.put("defaultMessage", msg);
			errors.add(err);
			map.put("errors", errors);
			sttus = HttpStatus.BAD_REQUEST;
		}

		return new ResponseEntity<>(map, sttus);
	}

	/**
	 * 설문조사 - 목록 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="surveyList.do", method=RequestMethod.GET)
	public String surveyList(HttpServletRequest req) throws SQLException{
		return "skill/customer/surveyList";
	}
	
	/**
	 * 설문조사 - 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="surveyList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> surveyListPost(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		vo.setUseAt("Y");
		vo.setChkId(uvo.getUserId());
		
		if(StringUtils.isEmpty(uvo.getUserId())){
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe()))
				vo.setChkId(uvo.getAuthVO().getCiValue());
			else
				vo.setChkId(uvo.getDnValue());
		}
		
		map.put("list", surveyService.selectSurveyInfoList(vo));
		map.put("vo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 설문조사 - 상세조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="surveyForm.do")
	public String surveyForm(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		vo.setChkId(uvo.getUserId());
		
		if(StringUtils.isEmpty(uvo.getUserId())){
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe()))
				vo.setChkId(uvo.getAuthVO().getCiValue());
			else
				vo.setChkId(uvo.getDnValue());
		}

		SurveyInfoVO eo = customerService.selectSurveyStatus(vo);
		
		if(!"Y".equals(eo.getDisplayAt()) || !StringUtils.isEmpty(eo.getChkId()))
			return "redirect:/skill/customer/surveyList.do";
		
		req.setAttribute("eo", surveyService.selectSurveyInfoView(vo));
		
		return "skill/customer/surveyForm";
	}
	
	/**
	 * 설문조사 - 등록
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="surveyInsert.do")
	public ResponseEntity<Map<String, Object>> surveyInsert(HttpServletRequest req, SurveyAnswrrVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");

		if(!StringUtils.isEmpty(uvo.getUserId()))
			vo.setAnswrrId(uvo.getUserId());
		
		else{
			if("USSE0001".equals(uvo.getSe()) || "USSE0003".equals(uvo.getSe()))
				vo.setAnswrrId(uvo.getAuthVO().getCiValue());
			else
				vo.setAnswrrId(uvo.getDnValue());
		}
		
		customerService.insertSurveyAnswer(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 발급동의 페이지
	 * @param req
	 * @return String
	 * @throws SQLException
	 */
	@RequestMapping(value="issueAgree.do")
	public String issueAgree(HttpServletRequest req) throws SQLException{
		return "skill/customer/issueAgree";
	}
	
}
