package kr.or.cwma.admin.trgetRoleRelate.controller;
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

import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.common.vo.DeptVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.trgetRoleRelate.service.TrgetRoleRelateService;
import kr.or.cwma.admin.trgetRoleRelate.vo.TrgetRoleRelateVO;

@Controller
@RequestMapping(value="admin/trgetRoleRelate")
public class TrgetRoleRelateController{

	@Autowired
	private TrgetRoleRelateService trgetRoleRelateService;
	
	@Autowired
	private CommonService commonService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, TrgetRoleRelateVO vo) throws SQLException{
		return "admin/trgetRoleRelate/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, TrgetRoleRelateVO vo) throws SQLException{
		UserVO uvo = new UserVO();
		DeptVO dvo = new DeptVO();
		
		Map<String, Object> map = new HashMap<String, Object>();
		if("TRSE0001".equals(vo.getSe())){
			uvo.setUserName(vo.getSearchWord());
			map.put("list", commonService.selectUserList(uvo));
		}else{
			dvo.setDeptName(vo.getSearchWord());
			map.put("list", commonService.selectDeptList(dvo));
		}
		
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 권한부여
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, TrgetRoleRelateVO vo) throws SQLException{
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		
		vo.setRgstId(lvo.getUserId());
		trgetRoleRelateService.updateTrgetRoleRelate(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 권한삭제
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="delete.do")
	public ResponseEntity<Map<String, Object>> delete(HttpServletRequest req, TrgetRoleRelateVO vo) throws SQLException{
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		
		vo.setRgstId(lvo.getUserId());
		trgetRoleRelateService.deleteTrgetRoleRelate(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
