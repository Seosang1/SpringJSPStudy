package kr.or.cwma.admin.userInfo.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.clmserEdu.service.ClmserEduService;
import kr.or.cwma.admin.clmserEdu.vo.ClmserEduVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.indvdlinfoAccesLog.service.IndvdlinfoAccesLogService;
import kr.or.cwma.admin.indvdlinfoAccesLog.vo.IndvdlinfoAccesLogVO;
import kr.or.cwma.admin.issuAgre.service.IssuAgreService;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;
import kr.or.cwma.common.util.ExcelUtil;

/**
 * 회원관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/userInfo")
public class UserInfoController{

	@Autowired
	private UserInfoService userInfoService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private JssfcInfoService jssfcInfoService;
	
	@Autowired
	private ClmserEduService clmserEduService;
	
	@Autowired
	private IssuAgreService issuAgreService;
	
	@Autowired
	private CrtfIssuService crtfIssuService;
	
	@Autowired
	private IndvdlinfoAccesLogService indvdlinfoAccesLogService;

	/**
	 * 목록페이지 - 개인
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="personalList.do", method=RequestMethod.GET)
	public String personalList(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		req.setAttribute("gradList", cmmnCdService.selectCmmnCdChildList("GRAD0000")); //등급코드
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
		return "admin/userInfo/personalList";
	}
	
	/**
	 * 목록페이지 - 사업자
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="companyList.do", method=RequestMethod.GET)
	public String companyList(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		return "admin/userInfo/companyList";
	}
	
	/**
	 * 목록페이지 - 대리인
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="agentList.do", method=RequestMethod.GET)
	public String agentList(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		return "admin/userInfo/agentList";
	}

	/**
	 * 목록페이지 - 수요기관
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="dminsttList.do", method=RequestMethod.GET)
	public String dminsttList(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		return "admin/userInfo/dminsttList";
	}
	
	/**
	 * 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", userInfoService.selectUserInfoList(vo));
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
	public void excelDown(HttpServletRequest req, HttpServletResponse res, UserInfoVO vo) throws SQLException, IOException{
		ExcelUtil.createXls(userInfoService.selectUserInfoListXls(vo), "회원정보", res);
	}

	/**
	 * 등록/수정 폼 - 개인
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="personalForm.do")
	public String personalForm(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		ClmserEduVO cevo = new ClmserEduVO();
		JssfcInfoVO jvo = new JssfcInfoVO();
		JssfcInfoVO jvo2 = new JssfcInfoVO();
		IssuAgreVO ivo = new IssuAgreVO();
		IndvdlinfoAccesLogVO ialvo = new IndvdlinfoAccesLogVO();
		
		jvo.setSearchIhidnum(vo.getIhidnum());
		cevo.setSe("CESE0001");
		cevo.setIhidnum(vo.getIhidnum());
		
		jvo2.setSearchIhidnumByWorkYm(vo.getIhidnum());
		ivo.setIhidnum(vo.getIhidnum());
		ivo.setDeleteAt("N");
		
		ialvo.setSe("IALS0004");
		ialvo.setMenuSn(98);
		ialvo.setIhidnum(vo.getIhidnum());
		
		req.setAttribute("eo", userInfoService.selectPersonalUserInfoView(vo));
		req.setAttribute("cmclList", userInfoService.selectPersonalUserCmclList(vo));
		req.setAttribute("dlyList", userInfoService.selectPersonalUserDlyList(vo));
		req.setAttribute("licenseList", userInfoService.selectPersonalUserLicenseList(vo));
		req.setAttribute("eduList", userInfoService.selectPersonalUserEduList(vo));
		req.setAttribute("rewardList", userInfoService.selectPersonalUserRewardList(vo));
		req.setAttribute("clmserEduList", clmserEduService.selectClmserEduList(cevo));
		req.setAttribute("clmserEduVO", cevo);
		req.setAttribute("gradList", cmmnCdService.selectCmmnCdChildList("GRAD0000")); //등급코드
		req.setAttribute("ddcerSnList", userInfoService.selectUserCnsltDdcerSnList(vo)); //신피공제자번호
		req.setAttribute("cnsltSeList", userInfoService.selectUserCnsltHistSeList()); //상담이력구분코드
		req.setAttribute("cnsltTrgtList", userInfoService.selectUserCnsltHistTrgtList()); //상담이력대상코드
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(jvo)); //직종코드
		req.setAttribute("ivo", issuAgreService.selectIssuAgre(ivo));//발급동의신청
		req.setAttribute("issuJssfcList", jssfcInfoService.selectJssfcInfoList(jvo2)); //직종코드(근무이력 3개월 이내)
		indvdlinfoAccesLogService.insertIndvdlinfoAccesLog(ialvo, req);
		
		return "admin/userInfo/personalForm";
	}
	
	/**
	 * 등급조회
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="userGrad.do")
	public ResponseEntity<Map<String, Object>> userGrad(HttpServletRequest req, UserMainJssfcVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		CrtfIssuVO cvo = new CrtfIssuVO();
		cvo.setIssuTrgterIhidnum(vo.getIhidnum());
		cvo.setJssfcNo(vo.getJssfcNo());
		map.put("eo", crtfIssuService.searchCrtfHistory(cvo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 등록/수정 폼 - 사업주
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="companyForm.do")
	public String companyForm(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		req.setAttribute("eo", userInfoService.selectUserInfoView(vo));
		return "admin/userInfo/companyForm";
	}
	
	/**
	 * 등록/수정 폼 - 대리인
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="agentForm.do")
	public String agentForm(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		req.setAttribute("eo", userInfoService.selectUserInfoView(vo));
		return "admin/userInfo/agentForm";
	}

	/**
	 * 등록/수정 폼 - 수요기관
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="dminsttForm.do")
	public String dminsttForm(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		req.setAttribute("eo", userInfoService.selectUserInfoView(vo));
		return "admin/userInfo/dminsttForm";
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
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		UserVO lvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		
		vo.setChgId(lvo.getUserId());
		vo.setRgstId(lvo.getUserId());
		userInfoService.updateUserInfo(vo);
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
	public String delete(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		userInfoService.deleteUserInfo(vo);
		return "redirect:/userInfo/list.do";
	}
	
	/**
	 * 상담내역 목록조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="cnsltHistList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> cnsltHistList(HttpServletRequest req, UserCnsltHistVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", userInfoService.selectUserCnsltHistList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 상담내역 등록 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="insertCnsltHist.do")
	public ResponseEntity<Map<String, Object>> insertCnsltHist(HttpServletRequest req, UserCnsltHistVO vo, BindingResult result) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			userInfoService.executeUserCnsltHist(vo);
		}else{
			map.put("errors", result.getFieldErrors());
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		return new ResponseEntity<>(map, HttpStatus.OK);
	}

}
