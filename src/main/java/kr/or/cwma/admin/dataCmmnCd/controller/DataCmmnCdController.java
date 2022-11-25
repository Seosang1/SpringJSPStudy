package kr.or.cwma.admin.dataCmmnCd.controller;
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

import kr.or.cwma.admin.dataCmmnCd.service.DataCmmnCdService;
import kr.or.cwma.admin.dataCmmnCd.vo.DataCmmnCdVO;

/**
 * 코드관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/dataCmmnCd")
public class DataCmmnCdController{

	@Autowired
	private DataCmmnCdService dataCmmnCdService;

	/**
	 * 코드관리 목록 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, DataCmmnCdVO vo){
		return "admin/dataCmmnCd/list";
	}

	/**
	 * 코드관리 목록조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, DataCmmnCdVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", dataCmmnCdService.selectCmmnCdList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 코드관리 등록/수정폼
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, DataCmmnCdVO vo) throws SQLException{
		if(StringUtils.isNotEmpty(vo.getCdId()))
			req.setAttribute("eo", dataCmmnCdService.selectCmmnCdView(vo));
		return "admin/dataCmmnCd/form";
	}
	
	/**
	 * 코드관리 등록
	 * @param req
	 * @param vo
	 * @param result
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="insert.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid DataCmmnCdVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!result.hasErrors()){
			dataCmmnCdService.insertCmmnCd(vo);
		} else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 코드관리 수정
	 * @param req
	 * @param vo
	 * @param result
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, @Valid DataCmmnCdVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!result.hasErrors()){
			dataCmmnCdService.updateCmmnCd(vo);
		} else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 코드관리 삭제
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="delete.do")
	public String delete(HttpServletRequest req, DataCmmnCdVO vo) throws SQLException{
		dataCmmnCdService.deleteCmmnCd(vo);
		return "redirect:/admin/dataCmmnCd/list.do";
	}

}
