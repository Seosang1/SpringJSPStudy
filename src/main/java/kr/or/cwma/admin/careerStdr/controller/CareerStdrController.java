package kr.or.cwma.admin.careerStdr.controller;
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

import kr.or.cwma.admin.careerStdr.service.CareerStdrService;
import kr.or.cwma.admin.careerStdr.vo.CareerStdrVO;
import kr.or.cwma.admin.common.vo.UserVO;

/**
 * 경력기준관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/careerStdr")
public class CareerStdrController{
	
	@Autowired
	private CareerStdrService careerStdrService;

	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> list(HttpServletRequest req, CareerStdrVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", careerStdrService.selectCareerStdrList(vo));
		if("CSSE0002".equals(vo.getSe())){
			vo.setSe("CSSE0004");
			map.put("list1", careerStdrService.selectCareerStdrList(vo));
			vo.setSe("CSSE0005");
			map.put("list2", careerStdrService.selectCareerStdrList(vo));
			vo.setSe("CSSE0006");
			map.put("list3", careerStdrService.selectCareerStdrList(vo));
		}
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
	public String form(HttpServletRequest req, CareerStdrVO vo) throws SQLException{
		String ret = "admin/careerStdr/form";
		req.setAttribute("eo", careerStdrService.selectCareerStdrView(vo));
		if("CSSE0002".equals(vo.getSe())){
			vo.setSe("CSSE0004");
			req.setAttribute("eo1", careerStdrService.selectCareerStdrView(vo));
			vo.setSe("CSSE0005");
			req.setAttribute("eo2", careerStdrService.selectCareerStdrView(vo));
			vo.setSe("CSSE0006");
			req.setAttribute("eo3", careerStdrService.selectCareerStdrView(vo));
			ret = "admin/careerStdr/rewardForm"; 
		}
		
		return ret;
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid CareerStdrVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			careerStdrService.insertCareerStdr(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
