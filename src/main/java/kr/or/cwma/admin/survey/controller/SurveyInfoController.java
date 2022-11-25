package kr.or.cwma.admin.survey.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.survey.service.SurveyInfoService;
import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.common.util.ExcelUtil;

@Controller
@RequestMapping(value="admin/survey")
public class SurveyInfoController{

	@Autowired
	private SurveyInfoService surveyService;
	
	@Autowired
	private CmmnCdService cmmnCdService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		return "admin/survey/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", surveyService.selectSurveyInfoList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 상세조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="view.do")
	public String view(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		req.setAttribute("eo", surveyService.selectSurveyInfoView(vo));
		return "admin/survey/view";
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		if(vo.getSurveySn() > 0) {
			SurveyInfoVO eo = surveyService.selectSurveyInfoView(vo);
			req.setAttribute("eo", eo);
		}
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("SQTY0000")); //설문문항유형
		return "admin/survey/form";
	}

	/**
	 * 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="insert.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid SurveyInfoVO vo, BindingResult result) throws SQLException, IOException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			surveyService.insertSurveyInfo(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 수정 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, @Valid SurveyInfoVO vo, BindingResult result) throws SQLException, IOException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			vo.setChgId(uvo.getUserId());
			surveyService.updateSurveyInfo(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 삭제 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="delete.do")
	public String delete(HttpServletRequest req, SurveyInfoVO vo) throws SQLException{
		surveyService.deleteSurveyInfo(vo);
		return "redirect:/admin/survey/list.do";
	}

	/**
	 * 엑셀다운 
	 * @param req 
	 * @param res 
	 * @param vo 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="excelDown.do", method=RequestMethod.POST)
	public void excelDown(HttpServletRequest req, HttpServletResponse res, SurveyInfoVO vo) throws SQLException, IOException{
		ExcelUtil.createXls(surveyService.selectSurveyInfoListXls(vo), "설문정보", res);
	}
}
