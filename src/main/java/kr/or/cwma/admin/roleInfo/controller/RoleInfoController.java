package kr.or.cwma.admin.roleInfo.controller;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.roleInfo.service.RoleInfoService;
import kr.or.cwma.admin.roleInfo.vo.RoleInfoVO;


/**
 * 역할정보 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/roleInfo")
public class RoleInfoController{

	@Autowired
	private RoleInfoService roleInfoService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		return "admin/roleInfo/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", roleInfoService.selectRoleInfoList(vo));
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
	public String view(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		req.setAttribute("eo", roleInfoService.selectRoleInfoView(vo));
		return "admin/roleInfo/view";
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		if(vo.getRoleSn() > 0)
			req.setAttribute("eo", roleInfoService.selectRoleInfoView(vo));
		return "admin/roleInfo/form";
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid RoleInfoVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			roleInfoService.insertRoleInfo(vo);
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
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, RoleInfoVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setChgId(uvo.getUserId());
			roleInfoService.updateRoleInfo(vo);
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
	public String delete(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		roleInfoService.deleteRoleInfo(vo);
		return "redirect:/admin/roleInfo/list.do";
	}
	
	/**
	 * 역할별 권한목록 조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="authorList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> roleList(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", roleInfoService.selectAuthorRoleRelateList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 권한관계 수정
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="updateAuthor.do")
	public ResponseEntity<Map<String, Object>> updateRole(HttpServletRequest req, RoleInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		roleInfoService.updateAuthorRoleRelate(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
