package kr.or.cwma.admin.menuInfo.controller;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.menuInfo.service.MenuInfoService;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;

/**
 * 메뉴관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/menuInfo")
public class MenuInfoController{

	@Autowired
	private MenuInfoService menuInfoService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, MenuInfoVO vo) throws SQLException{
		return "admin/menuInfo/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, MenuInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", menuInfoService.selectMenuInfoList(vo));
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
	public String view(HttpServletRequest req, MenuInfoVO vo) throws SQLException{
		req.setAttribute("eo", menuInfoService.selectMenuInfoView(vo));
		return "admin/menuInfo/view";
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, MenuInfoVO vo) throws SQLException{
		if(vo.getMenuSn() > 0)
			req.setAttribute("eo", menuInfoService.selectMenuInfoView(vo));
		return "admin/menuInfo/form";
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid MenuInfoVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			menuInfoService.insertMenuInfo(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		map.put("eo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 수정 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, MenuInfoVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setChgId(uvo.getUserId());
			menuInfoService.updateMenuInfo(vo);
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
	public String delete(HttpServletRequest req, MenuInfoVO vo) throws SQLException{
		menuInfoService.deleteMenuInfo(vo);
		return "redirect:/admin/menuInfo/list.do";
	}
	
	/**
	 * 메뉴관리 순서변경
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws Exception
	 */
	@RequestMapping(value="updateOrdr.do")
	public ResponseEntity<Map<String, Object>> updateOrdr(HttpServletRequest req, @RequestBody MenuInfoVO vo){
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			menuInfoService.updateMenuInfoOrdr(vo);
		}catch(SQLException e){
			map.put("errMsg", e.getMessage());
			return new ResponseEntity<>(map, HttpStatus.INTERNAL_SERVER_ERROR);
		}
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
