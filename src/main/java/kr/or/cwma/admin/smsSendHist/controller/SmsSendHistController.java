package kr.or.cwma.admin.smsSendHist.controller;
import java.sql.SQLException;
import java.util.HashMap;
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

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.smsSendHist.service.SmsSendHistService;
import kr.or.cwma.admin.smsSendHist.vo.SmsSendHistVO;

@Controller
@RequestMapping(value="admin/smsSendHist")
public class SmsSendHistController{

	@Autowired
	private SmsSendHistService smsSendHistService;
	
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
	public String list(HttpServletRequest req, SmsSendHistVO vo) throws SQLException{
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("SSSE0000")); //구분코드
		req.setAttribute("sttusList", cmmnCdService.selectCmmnCdChildList("SSST0000")); //상태코드
		return "admin/smsSendHist/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, SmsSendHistVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", smsSendHistService.selectSmsSendHistList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, SmsSendHistVO vo) throws SQLException{
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("SSSE0000")); //구분코드
		req.setAttribute("sttusList", cmmnCdService.selectCmmnCdChildList("SSST0000")); //상태코드
		
		if(vo.getSn() > 0)
			req.setAttribute("eo", smsSendHistService.selectSmsSendHistView(vo));
		return "admin/smsSendHist/form";
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid SmsSendHistVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();

		if(!result.hasErrors()){
			smsSendHistService.sendSms(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
