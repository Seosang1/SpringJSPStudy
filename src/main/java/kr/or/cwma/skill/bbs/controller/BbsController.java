package kr.or.cwma.skill.bbs.controller;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.bbs.service.BbsService;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.PageUtil;

/**
 * 게시판 컨트롤러
 * @author sichoi
 */
@Controller("skill.BbsController")
@RequestMapping(value="skill/bbs")
public class BbsController{

	@Autowired
	private BbsService bbsService;
	
	/**
	 * 공지사항 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="noticeList.do", method=RequestMethod.GET)
	public String noticeList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo){
		return "skill/bbs/noticeList";
	}
	
	/**
	 * 자료실 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="dataList.do", method=RequestMethod.GET)
	public String dataList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo){
		return "skill/bbs/dataList";
	}

	/**
	 * 목록조회 - AJAX
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, BbsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		vo.setDisplayAt("Y");
		
		if(uvo != null && !StringUtils.isEmpty(uvo.getSe()) && "BSSE0001".equals(vo.getSe())){
			if("USSE0001".equals(uvo.getSe()) || "USSE0002".equals(uvo.getSe()))
				vo.setCl(uvo.getSe().replace("USSE", "BNSE"));
			else if("USSE0003".equals(uvo.getSe()))
				vo.setCl("BNSE0002");
			else
				vo.setCl("BNSE0003");
		}
			
		map.put("list", bbsService.selectBbsList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	
	/**
	 * 공지사항 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="noticeView.do")
	public String noticeView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException, UnsupportedEncodingException{
		vo.setQueryStr(PageUtil.getQueryString(req, new String[]{"sn"}));
		
		if(vo.getSn() > 0) {
			vo.setSe("BSSE0001");
			vo.setDisplayAt("Y");
			bbsService.updateBbsRdcnt(vo);
			req.setAttribute("eo", bbsService.selectBbsView(vo));
			req.setAttribute("list", bbsService.selectBbsPrevNextList(vo));
		}
		
		return "skill/bbs/noticeView";
	}

	/**
	 * 자료실 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value="dataView.do")
	public String dataView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException, UnsupportedEncodingException{
		vo.setQueryStr(PageUtil.getQueryString(req, new String[]{"sn"}));
		
		if(vo.getSn() > 0) {
			vo.setSe("BSSE0002");
			vo.setDisplayAt("Y");
			bbsService.updateBbsRdcnt(vo);
			req.setAttribute("eo", bbsService.selectBbsView(vo));
			req.setAttribute("list", bbsService.selectBbsPrevNextList(vo));
		}
		
		return "skill/bbs/dataView";
	}

	/**
	 * 다운로드횟수 추가 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="updateDwldCo.do")
	public ResponseEntity<Map<String, Object>> updateDwldCo(HttpServletRequest req, BbsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		bbsService.updateBbsDwldCo(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
