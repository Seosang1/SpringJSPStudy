package kr.or.cwma.admin.issuAgre.controller;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.issuAgre.service.IssuAgreService;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.skill.mypage.service.MypageService;
import kr.or.cwma.skill.user.service.UserService;

/**
 * 회원관리 발급동의신청 컨트롤러
 */
@Controller
@RequestMapping(value="admin/issuAgre")
public class IssuAgreController {
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
	
	@Autowired
	AttchFileInfoService attchFileInfoService;
	
	/**
	 * 회원관리 발급동의신청 조회
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="selectIssuAgre.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> selectIssuAgre(HttpServletRequest req, IssuAgreVO vo) throws SQLException{
		boolean success = false;
		IssuAgreVO ivo = null;
		Map<String, Object> map = new HashMap<String, Object>();

		if(!StringUtils.isEmpty(vo.getIhidnum())) {
			ivo = issuAgreService.selectIssuAgre(vo);
			success = true;
		}
		
		map.put("ivo", ivo);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 회원관리 발급동의신청 수정(재동의)
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
	 * 회원관리 발급동의신청 취소
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
	 * 발급동의신청 등록(태블릿서명/등록)
	 *  - 등록 : deleteAt = 'N'
	 *  - 태블릿서명 : deleteAt = 'Y'
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="insertIssuAgre.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> insertIssuAgre(HttpServletRequest req, IssuAgreVO vo) throws SQLException {
		
		String msg = "";
		boolean success = false;
		boolean isUdt = false;
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		
		// 주민등록번호 여부
		if(!StringUtils.isEmpty(vo.getIhidnum())) {
			vo.setJssfcNo(vo.getSelectJssfcNo());
			vo.setIhidnum(vo.getIhidnum());
			// 발급동의신청 현황 조회
			IssuAgreVO ivoInfo = issuAgreService.selectIssuAgreInfo(vo);
			
			if(ivoInfo != null) {
				if("N".equals(ivoInfo.getDeleteAt())) {
					msg = "유효한 발급동의신청 이력이 존재합니다.";
				
				// 태블릿서명 후 등록 여부
				}else if("Y".equals(ivoInfo.getDeleteAt()) && vo.getSn() != null && vo.getSn().equals(ivoInfo.getSn())) {
					isUdt = true;
				}
			}
			
			if(StringUtils.isEmpty(msg)) {
				// 수정 
				if(isUdt) {
					vo.setSn(ivoInfo.getSn());
					issuAgreService.updateIssuAgre(vo);
					
				}else {
					issuAgreService.insertIssuAgre(vo);
					
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
				}
				
				// 발급 시 전결 처리
				if(!"Y".equals(vo.getDeleteAt())) {
					SanctnVO sanctnVO = new SanctnVO();
					
					sanctnVO.setDocNo(vo.getSn());		// 결재 고유번호
					sanctnVO.setSanctnKnd("ARCS0003");	//발급동의신청
					sanctnVO.setRgstId(uvo.getUserId());
					sanctnService.insertSanctnProgrsMain(sanctnVO);
					
					sanctnVO.setSanctnSttus("APRV0002");
					sanctnVO.setSanctnResn("발급동의신청 전결처리");
					sanctnService.insertSanctnProgrs(sanctnVO);
					sanctnVO.setSanctnSttus("APRV0005");
					sanctnService.insertSanctnProgrs(sanctnVO);
				}
				
				success = true;
				msg = "신청완료 되었습니다.";
				
				//파일첨부
				attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSn(), "ATCH0013");
			}
		}
		
		map.put("sn", vo.getSn());// 태블릿서명 참고
		map.put("msg",msg);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 회원관리 발급동의신청 폼 사업자등록번호 조회
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
		String msg = "데이터 조회에 실패했습니다.";
		boolean success = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(!StringUtils.isEmpty(vo.getBizno())) {
			vo.setBizno(vo.getBizno());
			
			map.put("cnstwkList", issuAgreService.selectCntrctList(vo));
			map.put("vo", vo);
			success = true;
			
		}else {
			msg = "사업자등록번호를 조회해주세요.";
		}
		
		map.put("msg",msg);
		map.put("success", success);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 발급동의 신청서 리포트팝업
	 * @param req
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value="issuAgrePreViewReportPop.do", method=RequestMethod.POST)
	public String issuAgrePreViewReportPop(HttpServletRequest req, IssuAgreVO vo) throws SQLException {
		String returnPage = "admin/userInfo/issuAgrePreViewReportPop";
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		String serverType = System.getProperty("server");
		if("live".equals(serverType)) {
			req.setAttribute("ozServer", "");	//운영서버는 contextPath oz60
		}else {
			req.setAttribute("ozServer", "http://192.168.209.161");
		}

		String fileName = "건설근로자보유증명서발급동의서";

		/* 파일 다운로드시 파일명에 추가 */
		req.setAttribute("fileName", fileName);
		req.setAttribute("brffcNm", uvo.getBrffcNm());
		
		req.setAttribute("no", vo.getSn());

		
		return returnPage;
	}
	
	
}
