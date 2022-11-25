package kr.or.cwma.admin.conectIp.controller;
import java.sql.SQLException;
import java.util.ArrayList;
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

import kr.or.cwma.admin.conectIp.service.ConectIpService;
import kr.or.cwma.admin.conectIp.vo.ConectIpVO;

/**
 * 접속IP관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/conectIp")
public class ConectIpController{

	@Autowired
	private ConectIpService conectIpService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, ConectIpVO vo) throws SQLException{
		return "admin/conectIp/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, ConectIpVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", conectIpService.selectConectIpList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid ConectIpVO vo, BindingResult result) throws SQLException{
		HttpStatus sttus =  HttpStatus.OK;
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> err = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();
		
		if(!result.hasErrors()){
			if(conectIpService.selectConectIpListCnt(vo) > 0) {
				err.put("field", "ip");
				err.put("defaultMessage", "이미 등록된 IP입니다");
				errors.add(err);
				map.put("errors", errors);
				sttus = HttpStatus.BAD_REQUEST;
				
			}else 
				conectIpService.insertConectIp(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			sttus = HttpStatus.BAD_REQUEST;
		}

		return new ResponseEntity<>(map, sttus);
	}

	/**
	 * 삭제 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="delete.do")
	public String delete(HttpServletRequest req, ConectIpVO vo) throws SQLException{
		conectIpService.deleteConectIp(vo);
		return "redirect:/admin/conectIp/list.do";
	}

}
