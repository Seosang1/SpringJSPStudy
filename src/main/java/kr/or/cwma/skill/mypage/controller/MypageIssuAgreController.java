package kr.or.cwma.skill.mypage.controller;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.common.enums.CrtfIssuSanctnId;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.issuAgre.service.IssuAgreService;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.skill.mypage.service.MypageService;
import kr.or.cwma.skill.user.service.UserService;

/**
 * 마이페이지 발급동의신청 컨트롤러
 */
@Controller
@RequestMapping(value="skill/mypage")
public class MypageIssuAgreController {
	@Autowired
	MypageService mypageService;

	@Autowired
	CommonService commonService;
	
	@Autowired
	IssuAgreService issuAgreService;
	
	@Autowired
	SanctnService sanctnService;
	
	@Autowired
	UserInfoService userInfoService;
	
	@Autowired
	UserService userService;
	
	@Autowired
	JssfcInfoService jssfcInfoService;
	
	/**
	 * 마이페이지 발급동의신청 조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="selectIssuAgre.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectIssuAgre(HttpServletRequest req, IssuAgreVO vo) throws SQLException{
		
		boolean success = false;
		String msg = "";
		IssuAgreVO ivo = null;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		Map<String, Object> map = new HashMap<String, Object>();

		if(!StringUtils.isEmpty(uvo.getIhidnum())) {
			vo.setIhidnum(uvo.getIhidnum());//주민
			vo.setDeleteAt("N");
			ivo = issuAgreService.selectIssuAgre(vo);
			success = true;
		}else {
			msg = "마이페이지 접근확인 후 조회가 가능합니다.";
		}
		map.put("ivo", ivo);
		map.put("msg", msg);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 마이페이지 발급동의신청 수정(재동의)
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="updateIssuAgre.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> updateIssuAgre(HttpServletRequest req, IssuAgreVO vo) throws SQLException{

		String msg = "발급동의신청 수정을 실패했습니다.";
		boolean success = false;
		
		Map<String, Object> map = new HashMap<String, Object>();

		if(vo.getSn() != null && vo.getSn() > 0) {
			int result = issuAgreService.updateIssuAgre(vo);
			if(result > 0) {
				success = true;
			}
		}
		
		map.put("msg",msg);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	
	/**
	 * 마이페이지 발급동의신청 취소
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="deleteIssuAgre.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> deleteIssuAgre(HttpServletRequest req, IssuAgreVO vo) throws SQLException{

		String msg = "발급동의신청 삭제를 실패했습니다.";
		boolean success = false;
		
		Map<String, Object> map = new HashMap<String, Object>();

		if(vo.getSn() != null && vo.getSn() > 0) {
			int result = issuAgreService.deleteIssuAgre(vo);
			if(result > 0) {
				success = true;
				msg = "취소되었습니다.";
			}
		}
		
		map.put("msg",msg);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 발급동의신청 등록
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="insertIssuAgre.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertIssuAgre(HttpServletRequest req, IssuAgreVO vo) throws SQLException {
		
		String msg = "발급동의신청을 실패했습니다.";
		boolean success = false;
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 발급동의신청 현황 조회
		vo.setIhidnum(lvo.getIhidnum());
		vo.setDeleteAt("N");
		IssuAgreVO ivoInfo = issuAgreService.selectIssuAgre(vo);
			
		if(ivoInfo == null) {
			
			// 등록
			issuAgreService.insertIssuAgre(vo);
			
			// 발급 시 전결 처리
			SanctnVO sanctnVO = new SanctnVO();
			
			sanctnVO.setDocNo(vo.getSn());		// 결재 고유번호
			sanctnVO.setSanctnKnd("ARCS0003");	//발급동의신청
			sanctnVO.setRgstId(CrtfIssuSanctnId.getValue(commonService.getDdcAsctCdByCnstwkLocplcAddr(lvo.getAdres())));
			sanctnService.insertSanctnProgrsMain(sanctnVO);
			
			sanctnVO.setSanctnSttus("APRV0002");
			sanctnVO.setSanctnResn("발급동의신청 전결처리");
			sanctnService.insertSanctnProgrs(sanctnVO);
			sanctnVO.setSanctnSttus("APRV0005");
			sanctnService.insertSanctnProgrs(sanctnVO);
			
			// 접수번호 생성
			IssuAgreVO vo2 = new IssuAgreVO();
			vo2.setSn(vo.getSn());
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String rceptNoFront = sdf.format(new Date());
			String rceptNo = rceptNoFront.substring(2, 4) + "-" + rceptNoFront.substring(4, 8) + "-";
			int rceptCnt = issuAgreService.selectIssuAgreRceptNoCnt(rceptNo);
			rceptNo = rceptNo + String.format("%04d", rceptCnt);
			vo2.setRceptNo(rceptNo);
			issuAgreService.updateIssuAgreRceptNo(vo2);// 접수번호 등록
			
			success = true;
			msg = "신청완료 되었습니다.";
			
		}else {
			msg = "유효한 발급동의신청 이력이 존재합니다.";
		}
		
		map.put("msg",msg);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 마이페이지 발급동의신청 폼
	 * @param req
	 * @return String
	 * @throws SQLException
	 */
	@RequestMapping(value="issuAgreForm.do", method=RequestMethod.GET)
	public String issuAgreForm(HttpServletRequest req) throws SQLException{
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		JssfcInfoVO jssfc = new JssfcInfoVO();
		jssfc.setSearchIhidnumByWorkYm(lvo.getIhidnum());

		int issAgreRst = 0;
		// 개인회원 여부
		if(!"USSE0001".equals(lvo.getSe())){
			return "redirect:/skill/mypage/index.do";
		}
		
		// 접근 여부 체크
		issAgreRst = isPossible(req);
		if(issAgreRst != 0) {
			return "redirect:/skill/mypage/index.do?issAgreRst=" + issAgreRst;
		}
		
		return "skill/mypage/issuAgreForm";
	}
	

	/**
	 * 마이페이지 발급동의신청 폼 사업자등록번호 조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="getCorpInfo.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> corpInfo(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		
		String msg = "등록되지 않은 사업자등록번호입니다.";
		boolean success = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		CorpInfoVO cvo = null;
		
		// 개인회원
		if(!StringUtils.isEmpty(vo.getBizno())){
			cvo = userService.selectCorpInfo(vo);
			success = (cvo != null) ? true : false; 
		}
		
		map.put("msg",msg);
		map.put("cvo",cvo);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 공사 리스트 조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="getCnstwkList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> getCnstwkList(HttpServletRequest req, UserInfoVO vo) throws SQLException {
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		
		vo.setBizno(vo.getBizno());
		vo.setIhidnum(lvo.getIhidnum());
		
		map.put("cnstwkList", issuAgreService.selectCntrctList(vo));
		map.put("vo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 마이페이지 발급동의신청 폼 접근 가능 여부
	 * @param req
	 * @return int
	 * @throws SQLException
	 */
	public int isPossible(HttpServletRequest req) throws SQLException{
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		int issAgreRst = 0;
		IssuAgreVO vo = new IssuAgreVO();
		JssfcInfoVO jssfc = new JssfcInfoVO();
		
		jssfc.setSearchIhidnumByWorkYm(lvo.getIhidnum());
		
		List<JssfcInfoVO> issuJssfcList = jssfcInfoService.selectJssfcInfoList(jssfc);//직종코드
		
		vo.setIhidnum(lvo.getIhidnum());
		vo.setDeleteAt("N");
		IssuAgreVO ivoInfo = issuAgreService.selectIssuAgre(vo);
		
		if(issuJssfcList == null || issuJssfcList.size() == 0) {
			issAgreRst = 1;
		
		}else if(ivoInfo != null){
			issAgreRst = 2;
		}
		
		if(issAgreRst == 0) {
			req.setAttribute("eo", userInfoService.selectUserInfoView(lvo));// 상세조회
			req.setAttribute("issuJssfcList", issuJssfcList);// 직종코드
		}
			
		return issAgreRst;
	}
}
