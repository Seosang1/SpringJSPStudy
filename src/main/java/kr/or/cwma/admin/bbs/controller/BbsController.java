package kr.or.cwma.admin.bbs.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.bbs.service.BbsService;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.FileService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 게시판 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/bbs")
public class BbsController{

	@Autowired
	private BbsService bbsService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	
	/**
	 * 공지사항 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="noticeList.do")
	public String noticeList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BNSE0000")); //공지사항분류
		return "admin/bbs/noticeList";
	}
	
	/**
	 * 자료실 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="dataList.do")
	public String dataList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BDSE0000")); //자료실분류
		return "admin/bbs/dataList";
	}
	
	/**
	 * 온라인 상담내역 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaList.do")
	public String qnaList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //상담유형
		return "admin/bbs/qnaList";
	}
	
	/**
	 * 자주하는 질문 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="faqList.do")
	public String faqList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BFCL0000")); //구분
		return "admin/bbs/faqList";
	}
	
	/**
	 * 파일관리 목록페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="fileList.do")
	public String fileList(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		return "admin/bbs/fileList";
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
		vo.setAdmin(true);
		map.put("list", bbsService.selectBbsList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 공지사항 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="noticeForm.do")
	public String noticeForm(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BNSE0000")); //공지사항
		
		return "admin/bbs/noticeForm";
	}

	/**
	 * 자료실 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="dataForm.do")
	public String dataForm(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BDSE0000")); //자료실분류
		
		return "admin/bbs/dataForm";
	}

	/**
	 * 온라인 상담내역 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaForm.do")
	public String qnaForm(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //상담유형
		return "admin/bbs/qnaForm";
	}
	
	/**
	 * 자주하는 질문 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="faqForm.do")
	public String faqForm(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BFCL0000")); //자주하는 질문 분류
		
		return "admin/bbs/faqForm";
	}
	
	/**
	 * 파일관리 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="fileForm.do")
	public String fileForm(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		return "admin/bbs/fileForm";
	}
	
	/**
	 * 공지사항 등록/수정 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="noticeView.do")
	public String noticeView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BNSE0000")); //공지사항 대상
		
		return "admin/bbs/noticeView";
	}

	/**
	 * 자료실 등록/수정 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="dataView.do")
	public String dataView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BDSE0000")); //자료실분류
		
		return "admin/bbs/dataView";
	}

	/**
	 * 온라인 상담내역 등록/수정 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="qnaView.do")
	public String qnaView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BQCL0000")); //상담유형
		return "admin/bbs/qnaView";
	}
	
	/**
	 * 자주하는 질문 등록/수정 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="faqView.do")
	public String faqView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("BFCL0000")); //자주하는 질문 분류
		
		return "admin/bbs/faqView";
	}
	
	/**
	 * 자주하는 질문 등록/수정 상세보기 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="fileView.do")
	public String fileView(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bbsService.selectBbsView(vo));
		return "admin/bbs/fileView";
	}

	/**
	 * 등록 
	 * @param req 
	 * @param vo 
	 * @param result
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="insert.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, MultipartHttpServletRequest multi, @Valid BbsVO vo, BindingResult result) throws SQLException{
		String msg = "";
		HttpStatus sttus =  HttpStatus.OK;
		
		BbsVO tvo = new BbsVO();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> err = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			tvo.setSe(vo.getSe());
			tvo.setNoticeAt("Y");
			
			if("Y".equals(vo.getNoticeAt()) && bbsService.selectBbsListCnt(tvo) >= 5){
				err.put("field", "noticeAt");
				msg = "공지설정은 5개까지 설정가능합니다";
			}
			
			if(StringUtils.isEmpty(msg)){
				try{
					vo.setRgstId(uvo.getUserId());
					List<AttchFileInfoVO> list = fileService.upload(multi);
					vo.setFileVO(list);
					bbsService.insertBbs(vo, req);
				}catch(IOException e){
					err.put("field", "file");
					msg = e.getMessage();
				}
			}
			
		}else{
			map.put("errors", result.getFieldErrors());
			sttus = HttpStatus.BAD_REQUEST;
		}
		
		if(StringUtils.isNotEmpty(msg)){
			err.put("defaultMessage", msg);
			errors.add(err);
			map.put("errors", errors);
			sttus = HttpStatus.BAD_REQUEST;
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
	public ResponseEntity<Map<String, Object>> update(MultipartHttpServletRequest req,MultipartHttpServletRequest multi, @Valid BbsVO vo, BindingResult result) throws SQLException, IOException{
		String msg = "";
		HttpStatus sttus =  HttpStatus.OK;
		
		BbsVO tvo = new BbsVO();
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> err = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			tvo.setSe(vo.getSe());
			tvo.setNoticeAt("Y");
			
			if("Y".equals(vo.getNoticeAt()) && bbsService.selectBbsListCnt(tvo) >= 5){
				err.put("field", "noticeAt");
				msg = "공지설정은 5개까지 설정가능합니다";
			}
			
			if(StringUtils.isEmpty(msg)){
				try{
					vo.setRgstId(uvo.getUserId());
					vo.setChgId(uvo.getUserId());
					List<AttchFileInfoVO> list = fileService.upload(multi);
					vo.setFileVO(list);
					bbsService.updateBbs(vo, req);
				}catch(IOException e){
					err.put("field", "file");
					msg = e.getMessage();
				}
			}
			
		}else{
			map.put("errors", result.getFieldErrors());
			sttus = HttpStatus.BAD_REQUEST;
		}

		if(StringUtils.isNotEmpty(msg)){
			err.put("defaultMessage", msg);
			errors.add(err);
			map.put("errors", errors);
			sttus = HttpStatus.BAD_REQUEST;
		}

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 답변
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="updateAnswer.do")
	public ResponseEntity<Map<String, Object>> updateAnswer(HttpServletRequest req, BbsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		vo.setAnswerId(uvo.getUserId());
		bbsService.updateBbsAnswer(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 삭제 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value={"delete.do", "deleteQna.do"})
	public ResponseEntity<Map<String, Object>> delete(HttpServletRequest req, BbsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		bbsService.deleteBbs(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * SMS발송
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="sendSMS.do")
	public ResponseEntity<Map<String, Object>> sendSMS(HttpServletRequest req, @ModelAttribute("vo") BbsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		bbsService.executeSms(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
