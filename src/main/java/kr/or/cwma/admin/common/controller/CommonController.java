package kr.or.cwma.admin.common.controller;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.bbs.service.BbsService;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.common.vo.ExcelDwldHistVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.common.util.CommonUtils;
import kr.or.cwma.admin.common.vo.CommonVO;

/**
 * 공통 컨트롤러
 * @author sichoi
 */
@Controller("adminCommonController")
public class CommonController{
	
	@Autowired
	private BbsService bbsService;

	@Autowired
	private CommonService commonService;
	
	/**
	 * SSO인증 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/sso/index.do", method=RequestMethod.GET)
	public String ssoIndex(HttpServletRequest req) throws Exception{
		return "redirect:/admin/index.do";
	}
	
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/index.do", method=RequestMethod.GET)
	public String index(HttpServletRequest req) throws Exception{
		BbsVO vo = new BbsVO();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		//게시판 변수
		vo.setNumOfPage(5);
		vo.setSe("BSSE0001");
        CommonVO commonVO = new CommonVO();
        req.setAttribute("vsitCntTotal", commonService.selectCountVisit(commonVO));
        commonVO.setNowTime(CommonUtils.getTimeNow());
        commonVO.setPrevTime(CommonUtils.getDateNow()+" 00:00:00");
		req.setAttribute("vsitCntToday", commonService.selectCountVisit(commonVO));
		req.setAttribute("noticeList", bbsService.selectBbsList(vo));
		req.setAttribute("qnaCnt", commonService.selectQnaCnt());
		return "admin/index";
	}
	
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean.do", method=RequestMethod.GET)
	public String bean(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean1.do", method=RequestMethod.GET)
	public String bean1(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean2.do", method=RequestMethod.GET)
	public String bean2(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean3.do", method=RequestMethod.GET)
	public String bean3(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean4.do", method=RequestMethod.GET)
	public String bean4(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean5.do", method=RequestMethod.GET)
	public String bean5(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean6.do", method=RequestMethod.GET)
	public String bean6(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean7.do", method=RequestMethod.GET)
	public String bean7(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean8.do", method=RequestMethod.GET)
	public String bean8(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean9.do", method=RequestMethod.GET)
	public String bean9(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean10.do", method=RequestMethod.GET)
	public String bean10(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/admin/bean11.do", method=RequestMethod.GET)
	public String bean11(HttpServletRequest req) throws Exception{
		return "admin/bean";
	}
	
	/**
	 * 로그인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception
	 * @throws IOException
	 */
	@RequestMapping(value="/admin/login.do", method=RequestMethod.GET)
	public String loginForm(HttpServletRequest req) throws IOException, Exception{
		return "admin/login/login";
	}

	/**
	 * 로그인처리
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 * @throws NoSuchAlgorithmException
	 */
	@RequestMapping(value="/admin/login.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> login(HttpServletRequest req, UserVO vo) throws SQLException, NoSuchAlgorithmException{
		String msg = "";
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		
		msg = commonService.login(req, vo);
		sttus = HttpStatus.OK;

		tmp.put("field", "");
		tmp.put("defaultMessage", msg);
		result.add(tmp);
		map.put("errors", result);
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 로그아웃
	 * @param req
	 * @param vo
	 * @param ses
	 * @return String
	 * @throws Exception
	 */
	@RequestMapping(value="/admin/logout.do")
	public String logout(HttpServletRequest req, UserVO vo, HttpSession ses){
		ses.removeAttribute("adminLoginInfo");
		ses.removeAttribute("adminMenuList");
		ses.removeAttribute("adminGrantList");
		ses.removeAttribute("allowIp");
		return "redirect:/admin/login.do";
	}

	/**
	 * 엑셀다운이력 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="/admin/insertExcelDwldHist.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid ExcelDwldHistVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			commonService.insertExcelDwldHist(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
