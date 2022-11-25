package kr.or.cwma.admin.banner.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.banner.service.BannerService;
import kr.or.cwma.admin.banner.vo.BannerVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.common.service.FileService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

@Controller
@RequestMapping(value="admin/banner")
public class BannerController{

	@Autowired
	private BannerService bannerService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private FileService fileService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.GET)
	public String list(HttpServletRequest req, BannerVO vo) throws SQLException{
		return "admin/banner/list";
	}

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, BannerVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", bannerService.selectBannerList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 상세조회 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="view.do")
	public String view(HttpServletRequest req, BannerVO vo) throws SQLException{
		req.setAttribute("eo", bannerService.selectBannerView(vo));
		return "admin/banner/view";
	}

	/**
	 * 등록/수정 폼 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="form.do")
	public String form(HttpServletRequest req, BannerVO vo) throws SQLException{
		if(vo.getSn() > 0)
			req.setAttribute("eo", bannerService.selectBannerView(vo));
		
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("PBTR0000")); //타겟코드
		return "admin/banner/form";
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req,MultipartHttpServletRequest multi, @Valid BannerVO vo, BindingResult result) throws SQLException, IOException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			List<AttchFileInfoVO> list = fileService.upload(multi);
			vo.setFileVO1(list);
			bannerService.insertBanner(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
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
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, BannerVO vo, BindingResult result) throws SQLException, IOException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setChgId(uvo.getUserId());
			bannerService.updateBanner(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 삭제 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="delete.do")
	public String delete(HttpServletRequest req, BannerVO vo) throws SQLException{
		bannerService.deleteBanner(vo);
		return "redirect:/admin/banner/list.do";
	}

}
