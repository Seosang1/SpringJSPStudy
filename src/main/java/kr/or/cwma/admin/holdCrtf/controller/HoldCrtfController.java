package kr.or.cwma.admin.holdCrtf.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.fee.service.FeeService;
import kr.or.cwma.admin.holdCrtf.service.HoldCrtfService;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfProgrsVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.ExcelUtil;
import kr.or.cwma.skill.user.service.UserService;

/**
 * 보유증명서 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/holdCrtf")
public class HoldCrtfController{

	@Autowired
	private HoldCrtfService holdCrtfService;
	
	@Autowired
	private CmmnCdService cmmnCdService;

	@Autowired
	private JssfcInfoService jssfcInfoService;
	
	@Autowired
	private FeeService feeService;
	
	@Autowired
	private UserService userService;
	
	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		req.setAttribute("payList", cmmnCdService.selectCmmnCdChildList("PAYM0000")); //결제코드
		return "admin/holdCrtf/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		if(lvo.getRoleSn() > 1)
			vo.setChrgBrffc(lvo.getDdcAstcCd());
		
		map.put("list", holdCrtfService.selectHoldCrtfList(vo));
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
	public void excelDown(HttpServletRequest req, HttpServletResponse res, HoldCrtfVO vo) throws SQLException, IOException{
		ExcelUtil.createXls(holdCrtfService.selectHoldCrtfListXls(vo), "엑셀파일",res);
	}

	/**
	 * 상세조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="view.do")
	public String view(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		UserInfoVO uvo = new UserInfoVO();
		HoldCrtfVO eo = holdCrtfService.selectHoldCrtfView(vo);
		
		req.setAttribute("eo", eo);
		uvo.setBizno(eo.getBizno());
		req.setAttribute("corpEo", userService.selectCorpInfo(uvo));
		req.setAttribute("progList", holdCrtfService.selectHoldCrtfProgrsList(vo));
		
		uvo.setBizno(eo.getApplcntBizno());
		if("HCSE0001".equals(eo.getSe()))
			req.setAttribute("applEo", userService.selectCorpInfo(uvo));
		else
			req.setAttribute("applEo", userService.selectDminsttInfo(uvo));
		return "admin/holdCrtf/view";
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", holdCrtfService.selectHoldCrtfView(vo));
		
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("HCSE0000")); //구분코드
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("HCCL0000")); //분류코드
		req.setAttribute("gradList", cmmnCdService.selectCmmnCdChildList("GRAD0000")); //등급코드
		req.setAttribute("officList", cmmnCdService.selectCmmnCdChildList("HCPO0000")); //등급코드
		req.setAttribute("payList", cmmnCdService.selectCmmnCdChildList("PAYM0000")); //결제코드
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
		req.setAttribute("fee", feeService.selectFeeView(null)); //수수료
		return "admin/holdCrtf/form";
	}

	/**
	 * 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="insert.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid HoldCrtfVO vo, BindingResult result) throws SQLException, IOException{
		int cnt = 0;
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();

		if(!result.hasErrors()){
			vo.setRgstId(lvo.getUserId());
			vo.setChrgBrffc(lvo.getDdcAstcCd());
			vo.setChrgId(lvo.getUserId());
			cnt = holdCrtfService.insertHoldCrtf(vo, null);
			map.put("vo", vo);
			
			if(cnt > 0)
				sttus = HttpStatus.OK;
			else{
				tmp.put("field", "");
				tmp.put("defaultMessage", "발급가능한 근로자가 없습니다.");
				errors.add(tmp);
				map.put("errors", errors);
			}

		}else{
			map.put("errors", result.getFieldErrors());
		}

		return new ResponseEntity<>(map, sttus);
	}

	/**
	 * 수정 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, HoldCrtfVO vo, BindingResult result) throws SQLException, IOException{
		int cnt = 0;
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();

		if(!result.hasErrors()){
			vo.setRgstId(lvo.getUserId());
			holdCrtfService.updateHoldCrtf(vo, null);
			map.put("vo", vo);
			
			if(cnt > 0)
				sttus = HttpStatus.OK;
			else{
				tmp.put("field", "");
				tmp.put("defaultMessage", "발급가능한 근로자가 없습니다.");
				errors.add(tmp);
				map.put("errors", errors);
			}

		}else{
			map.put("errors", result.getFieldErrors());
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
	public String delete(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		holdCrtfService.deleteHoldCrtf(vo);
		return "redirect:/holdCrtf/list.do";
	}
	
	/**
	 * 사업자정보조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="corpInfo.do")
	public ResponseEntity<Map<String, Object>> corpInfo(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!StringUtils.isEmpty(req.getParameter("applcntBizno")))
			vo.setBizno(req.getParameter("applcntBizno"));
			
		map.put("corpEo", userService.selectCorpInfo(vo));
		map.put("dminsttEo", userService.selectDminsttInfo(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 공사정보조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="cntrctInfoList.do")
	public ResponseEntity<Map<String, Object>> cntrctInfoList(HttpServletRequest req, CntrctInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", holdCrtfService.selectCntrctList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 근로자정보조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="labrrInfoList.do")
	public ResponseEntity<Map<String, Object>> labrrInfoList(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", holdCrtfService.selectLabrrList(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 발급동의 근로자 정보 조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="issuAgreInfo.do")
	public ResponseEntity<Map<String, Object>> issuAgreInfo(HttpServletRequest req, IssuAgreVO vo, JssfcInfoVO jvo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		jvo.setSearchIhidnumByWorkYm(vo.getIhidnum());
		map.put("eo", holdCrtfService.selectIssuAgreView(vo));
		map.put("jssfcList", jssfcInfoService.selectJssfcInfoList(jvo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 진행상태 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="insertProgrs.do")
	public ResponseEntity<Map<String, Object>> insertProgrs(HttpServletRequest req, @Valid HoldCrtfProgrsVO vo, BindingResult result) throws SQLException{
		String msg = "";
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();

		if(!result.hasErrors()){
			vo.setRgstId(lvo.getUserId());
			vo.setRgstBrffc(lvo.getDdcAstcCd());
			msg = holdCrtfService.insertHoldCrtfProgrs(vo);
			
			if(StringUtils.isEmpty(msg))
				sttus = HttpStatus.OK;
			
			tmp.put("field", "");
			tmp.put("defaultMessage", msg);
			errors.add(tmp);
			map.put("errors", errors);
		}else{
			map.put("errors", result.getFieldErrors());
		}
		
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 리포트 팝업
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="rptPop.do")
	public String rptPop(HttpServletRequest req, @ModelAttribute("vo") HoldCrtfIssuVO vo) throws SQLException {
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		String serverType = System.getProperty("server");
		if("admin".equals(serverType)) {
			req.setAttribute("ozServer", "https://mplus.cw.or.kr");	//운영서버는 contextPath oz60
		}else {
			req.setAttribute("ozServer", "http://192.168.209.161");
		}
		/* 파일 다운로드시 파일명에 추가 */
		req.setAttribute("brffcNm", uvo.getBrffcNm());
		
		if("건설근로자보유증명서".equals(req.getParameter("title"))){
			holdCrtfService.insertHoldCrtfIssu(vo);
		}
		
		return "admin/holdCrtf/rptPop";
	}
	
	/**
	 * 발급대장 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="issuList.do", method=RequestMethod.GET)
	public String issuList(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		req.setAttribute("ddcAsctList", holdCrtfService.selectDdcAsctList(lvo));
		return "admin/holdCrtf/issuList";
	}
	

	/**
	 * 발급대장 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="issuList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> issuListPost(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", holdCrtfService.selectIssuList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
