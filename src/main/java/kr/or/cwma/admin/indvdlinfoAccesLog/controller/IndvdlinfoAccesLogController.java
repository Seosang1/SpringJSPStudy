package kr.or.cwma.admin.indvdlinfoAccesLog.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.indvdlinfoAccesLog.service.IndvdlinfoAccesLogService;
import kr.or.cwma.admin.indvdlinfoAccesLog.vo.IndvdlinfoAccesLogVO;
import kr.or.cwma.common.util.ExcelUtil;

/**
 * 접속기록관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/indvdlinfoAccesLog")
public class IndvdlinfoAccesLogController{

	@Autowired
	private IndvdlinfoAccesLogService indvdlinfoAccesLogService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, IndvdlinfoAccesLogVO vo) throws SQLException{
		req.setAttribute("menuList", indvdlinfoAccesLogService.selectMenuList());
		return "admin/indvdlinfoAccesLog/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, IndvdlinfoAccesLogVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", indvdlinfoAccesLogService.selectIndvdlinfoAccesLogList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
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
	public void excelDown(HttpServletRequest req, HttpServletResponse res, IndvdlinfoAccesLogVO vo) throws SQLException, IOException{
		ExcelUtil.createXls(indvdlinfoAccesLogService.selectIndvdlinfoAccesLogListXls(vo), "엑셀파일",res);
	}
}
