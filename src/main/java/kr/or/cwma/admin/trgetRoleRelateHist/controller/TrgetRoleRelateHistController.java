package kr.or.cwma.admin.trgetRoleRelateHist.controller;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.roleInfo.service.RoleInfoService;
import kr.or.cwma.admin.roleInfo.vo.RoleInfoVO;
import kr.or.cwma.admin.trgetRoleRelateHist.service.TrgetRoleRelateHistService;
import kr.or.cwma.admin.trgetRoleRelateHist.vo.TrgetRoleRelateHistVO;

@Controller
@RequestMapping(value="admin/trgetRoleRelateHist")
public class TrgetRoleRelateHistController{

	@Autowired
	private TrgetRoleRelateHistService trgetRoleRelateHistService;
	
	@Autowired
	private RoleInfoService roleInfoService;
	
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
	public String list(HttpServletRequest req, TrgetRoleRelateHistVO vo) throws SQLException{
		req.setAttribute("roleList", roleInfoService.selectRoleInfoList(new RoleInfoVO()));//권한코드
		req.setAttribute("codeList", cmmnCdService.selectCmmnCdChildList("THCS0000")); //유형코드
		return "admin/trgetRoleRelateHist/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, TrgetRoleRelateHistVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("list", trgetRoleRelateHistService.selectTrgetRoleRelateHistList(vo));
		map.put("vo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
