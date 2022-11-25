package kr.or.cwma.admin.admin.controller;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.admin.service.AdminService;
import kr.or.cwma.admin.admin.vo.AdminVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;

/**
 * 관리자 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/admin")
public class AdminController{

	@Autowired
	private AdminService adminService;

	@Autowired
	private CmmnCdService cmmnCdService;
	
	/**
	 * 관리자 목록 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, AdminVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("ADPT0000")); 
		return "admin/admin/list";
	}

	/**
	 * 관리자 목록조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, AdminVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", adminService.selectAdminList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 관리자 등록/수정폼
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, AdminVO vo) throws SQLException{
		if(StringUtils.isNotEmpty(vo.getUserId()))
			req.setAttribute("eo", adminService.selectAdminView(vo));
		return "admin/admin/form";
	}
	
	/**
	 * 관리자 등록
	 * @param req
	 * @param vo
	 * @param result
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="insert.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid AdminVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!result.hasErrors()){
			if(null != adminService.selectAdminView(vo)) {
				map.put("errors", "중복된 아이디 입니다.");
			}else {
				adminService.insertAdmin(vo);
			}
		} else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 관리자 수정
	 * @param req
	 * @param vo
	 * @param result
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, @Valid AdminVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!result.hasErrors()){
			adminService.updateAdmin(vo);
		} else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 관리자 삭제
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="delete.do")
	public String delete(HttpServletRequest req, AdminVO vo) throws SQLException{
		adminService.deleteAdmin(vo);
		return "redirect:/admin/admin/list.do";
	}

}
