package kr.or.cwma.admin.clmserEdu.controller;
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

import kr.or.cwma.admin.clmserEdu.service.ClmserEduService;
import kr.or.cwma.admin.clmserEdu.vo.ClmserEduVO;
import kr.or.cwma.admin.clmserEdu.vo.UserClmserEduRelVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.smsSendHist.service.SmsSendHistService;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;

/**
 * 맞춤형교육 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/clmserEdu")
public class ClmserEduController{

	@Autowired
	private ClmserEduService clmserEduService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private SmsSendHistService smsSendHistService;
	
	@Autowired
	private UserInfoService userInfoService;

	/**
	 * 목록페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do")
	public String list(HttpServletRequest req, @ModelAttribute("vo") ClmserEduVO vo) throws SQLException{
		if(StringUtils.isEmpty(vo.getSe()))
			vo.setSe("CESE0001");
		
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("CESE0000"));
		req.setAttribute("list", clmserEduService.selectClmserEduList(vo));
		return "admin/clmserEdu/list";
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
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, @Valid ClmserEduVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();

		if(!result.hasErrors()){
			clmserEduService.insertClmserEdu(vo);
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
	 */
	@RequestMapping(value="update.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, ClmserEduVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();

		if(!result.hasErrors()){
			clmserEduService.updateClmserEdu(vo);
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
	public String delete(HttpServletRequest req, ClmserEduVO vo) throws SQLException{
		clmserEduService.deleteClmserEdu(vo);
		return "redirect:list.do";
	}

	/**
	 * 문자발송
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="sendSms.do")
	public ResponseEntity<Map<String, Object>> sendSms(HttpServletRequest req, ClmserEduVO vo, BindingResult result) throws SQLException{
		String mobile = req.getParameter("mobile");
		HttpStatus sttus = HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> err = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();
		
		UserInfoVO uvo = new UserInfoVO();
		uvo.setIhidnum(vo.getIhidnum());
		UserMainJssfcVO mvo = userInfoService.selectPersonalUserInfoView(uvo);
		
		if(mvo == null) {
			err.put("defaultMessage", "기능등급 및 이력사항이 존재하지 않아 맞춤형 교육 문자발송이 불가합니다.");
			errors.add(err);
			map.put("errors", errors);
			sttus = HttpStatus.BAD_REQUEST;
		}else {
			if(!StringUtils.isEmpty(mobile)) {
				if(mvo.getUserInfoVO() == null) {
					mvo.setUserInfoVO(new UserInfoVO()); 
				}
				mvo.getUserInfoVO().setMoblphonNo(mobile);
			}
			
			if(StringUtils.isEmpty(mvo.getUserInfoVO().getMoblphonNo())){
				err.put("defaultMessage", "핸드폰번호가 없습니다");
				errors.add(err);
				map.put("errors", errors);
				sttus = HttpStatus.BAD_REQUEST;
			}else
				smsSendHistService.sendSmsAuto("SSSE0009", mvo.getUserInfoVO().getMoblphonNo(), mvo.getNm(), null);
		}
		
		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 사용자 이수 이력 등록
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="insertUserClmserEduRel.do")
	public ResponseEntity<Map<String, Object>> insertUserClmserEduRel(HttpServletRequest req, UserClmserEduRelVO vo, BindingResult result) throws SQLException{
		HttpStatus sttus = HttpStatus.OK;
		
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> list = new ArrayList<Map<String, String>>();
		
		UserClmserEduRelVO eo;

		if(!result.hasErrors()){
			eo = clmserEduService.selectUserClmserEduRelView(vo);
			
			if(eo != null && eo.getSn() > 0){
				sttus = HttpStatus.BAD_REQUEST;
				tmp.put("field", "");
				tmp.put("defaultMessage", "이수완료자는 등록할 수 없습니다.");
				list.add(tmp);
				map.put("errors", result);
				
			}else {
				clmserEduService.insertUserClmserEduRel(vo);
			}
			
		}else{
			map.put("errors", result.getFieldErrors());
			sttus = HttpStatus.BAD_REQUEST;
		}

		return new ResponseEntity<>(map, sttus);
	}

}
