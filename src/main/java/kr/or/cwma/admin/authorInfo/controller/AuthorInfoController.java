package kr.or.cwma.admin.authorInfo.controller;
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

import kr.or.cwma.admin.authorInfo.service.AuthorInfoService;
import kr.or.cwma.admin.authorInfo.vo.AuthorInfoVO;
import kr.or.cwma.admin.authorInfo.vo.MenuAuthorRelateVO;
import kr.or.cwma.admin.common.vo.UserVO;

/**
 * 권한정보 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/authorInfo")
public class AuthorInfoController{

	@Autowired
	private AuthorInfoService authorInfoService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, AuthorInfoVO vo) throws SQLException{
		return "admin/authorInfo/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, AuthorInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", authorInfoService.selectAuthorInfoList(vo));
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
	public String view(HttpServletRequest req, AuthorInfoVO vo) throws SQLException{
		req.setAttribute("eo", authorInfoService.selectAuthorInfoView(vo));
		return "admin/authorInfo/view";
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, AuthorInfoVO vo) throws SQLException{
		if(StringUtils.isNotEmpty(vo.getAuthorCd()))
			req.setAttribute("eo", authorInfoService.selectAuthorInfoView(vo));
		return "admin/authorInfo/form";
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid AuthorInfoVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			authorInfoService.insertAuthorInfo(vo);
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
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, AuthorInfoVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			vo.setChgId(uvo.getUserId());
			authorInfoService.updateAuthorInfo(vo);
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
	public String delete(HttpServletRequest req, AuthorInfoVO vo) throws SQLException{
		authorInfoService.deleteAuthorInfo(vo);
		return "redirect:/admin/authorInfo/list.do";
	}
	
	/**
	 * 권한별 메뉴목록
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="menuList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> menuList(HttpServletRequest req, MenuAuthorRelateVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", authorInfoService.selectMenuAuthorRelateList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 메뉴권한관계 수정
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="updateMenu.do")
	public String updateMenu(HttpServletRequest req, AuthorInfoVO vo) throws SQLException{
		authorInfoService.updateMenuAuthorRelate(vo);
		return "redirect:/admin/authorInfo/list.do";
	}

}
