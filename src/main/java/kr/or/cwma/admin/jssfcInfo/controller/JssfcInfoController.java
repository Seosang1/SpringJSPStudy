package kr.or.cwma.admin.jssfcInfo.controller;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.careerStdr.service.CareerStdrService;
import kr.or.cwma.admin.careerStdr.vo.CareerStdrVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoHistManageService;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoHistService;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoHistManageVO;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

@Controller
@RequestMapping(value="admin/jssfcInfo")
public class JssfcInfoController{

	@Autowired
	private JssfcInfoHistService jssfcInfoHistService;
	
	@Autowired
	private JssfcInfoService jssfcInfoService;
	
	@Autowired
	private JssfcInfoHistManageService jssfcInfoHistManageService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private CareerStdrService careerStdrService;

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do")
	public String list(HttpServletRequest req, JssfcInfoVO vo) throws SQLException{
		List<JssfcInfoVO> list = jssfcInfoHistService.selectJssfcInfoHistList(new JssfcInfoVO());
		
		if(list == null || list.size() == 0)
			list = jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO());
		
		req.setAttribute("list", list);
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("JISE0000")); //직종구분코드
		
		return "admin/jssfcInfo/list";
	}

	/**
	 * 이력조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="histList.do")
	public ResponseEntity<Map<String, Object>> histList(HttpServletRequest req, JssfcInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", jssfcInfoHistManageService.selectJssfcInfoHistManageList(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, JssfcInfoVO vo) throws SQLException{
		req.setAttribute("eo", jssfcInfoHistService.selectJssfcInfoHistView(vo));
		return "admin/jssfcInfo/form";
	}

	/**
	 * 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="insert.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid JssfcInfoHistManageVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(lvo.getUserId());
			jssfcInfoHistManageService.insertJssfcInfoHistManage(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 경력기준(자격, 교육, 포상) 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="careerStdrList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerStdrList(HttpServletRequest req, CareerStdrVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", careerStdrService.selectCareerStdrList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 경력기준(자격, 교육, 포상) 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="careerStdrForm.do")
	public String careerStdrForm(HttpServletRequest req, CareerStdrVO vo) throws SQLException{
		req.setAttribute("eo", careerStdrService.selectCareerStdrView(vo));
		return "admin/careerStdr/form";
	}

	/**
	 * 경력기준(자격, 교육, 포상) 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="careerStdrInsert.do")
	public ResponseEntity<Map<String, Object>> careerStdrInsert(HttpServletRequest req, @Valid CareerStdrVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();

		if(!result.hasErrors()){
			careerStdrService.insertCareerStdr(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
