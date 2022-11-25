package kr.or.cwma.common.controller;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 공통파일관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="common/attchFileInfo")
public class AttchFileInfoController{

	@Autowired
	private AttchFileInfoService attchFileInfoService;

	/**
	 * 등록 
	 * @param req 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do")
	public ResponseEntity<Map<String, Object>> list(HttpServletRequest req, AttchFileInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", attchFileInfoService.selectAttchFileInfoList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
