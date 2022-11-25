package kr.or.cwma.admin.batchLog.controller;
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

import kr.or.cwma.admin.batchLog.service.BatchLogService;
import kr.or.cwma.admin.batchLog.vo.BatchLogVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.common.util.ExcelUtil;

@Controller
@RequestMapping(value="admin/batchLog")
public class BatchLogController{

	@Autowired
	private BatchLogService batchLogService;
	
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
	public String list(HttpServletRequest req, BatchLogVO vo) throws SQLException{
		req.setAttribute("batchCd", batchLogService.selectBatchCdList());
		req.setAttribute("resultCd", cmmnCdService.selectCmmnCdChildList("BTST0000"));
		return "admin/batchLog/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, BatchLogVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", batchLogService.selectBatchLogList(vo));
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
	public void excelDown(HttpServletRequest req, HttpServletResponse res, BatchLogVO vo) throws SQLException, IOException{
		ExcelUtil.createXls(batchLogService.selectBatchLogListXls(vo), "연계정보", res);
	}

	/**
	 * 상세조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="view.do")
	public String view(HttpServletRequest req, BatchLogVO vo) throws SQLException{
		req.setAttribute("eo", batchLogService.selectBatchLogView(vo));
		return "admin/batchLog/view";
	}

}
