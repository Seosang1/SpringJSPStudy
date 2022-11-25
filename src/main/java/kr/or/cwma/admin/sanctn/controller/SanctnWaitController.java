package kr.or.cwma.admin.sanctn.controller;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.service.HoldCrtfService;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.Agncy;
import kr.or.cwma.admin.sanctn.vo.SanctnSearchVO;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.skill.user.service.UserService;

/**
 * 결재대기 컨트롤러
 * @author PCNDEV
 *
 */
@Controller
@RequestMapping(value="admin/sanctnWait")
public class SanctnWaitController {

	static final Logger LOG = LoggerFactory.getLogger(SanctnWaitController.class);
	
	@Autowired
	SanctnService sanctnService;
	
	@Autowired
	CareerDeclareService careerDeclareService;

	@Autowired
	private JssfcInfoService jssfcInfoService;
	
	@Autowired
	HoldCrtfService holdCrtfService;
	
	@Autowired
	UserService userService;

	@Autowired
	CmmnCdService cmmnCdService;
	
	@Autowired
	CrtfIssuService crtfIssuService;
	/**
	 * 결재대기 목록
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="list.do")
	public String list(HttpServletRequest req, @ModelAttribute("vo") SanctnSearchVO vo) {
		
		req.setAttribute("ddcAsctList", sanctnService.selectCwmaDdcAsctInfoList());
		return "admin/sanctn/wait/list";
	}
	
	/**
	 * 결재대기 목록
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, @ModelAttribute("vo") SanctnSearchVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		//결재 쿼리 목록 구분
		vo.setSanctnList("WAIT");
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		vo.setSanctnId(uvo.getUserId());
		
		if(!"01100".equals(uvo.getDdcAstcCd())) {
			vo.setChrgBrffc(uvo.getDdcAstcCd());
		}
		
		map.put("list", sanctnService.selectSanctnList(vo));
		map.put("vo", vo);
				
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 결재진행 상세페이지
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value="view.do")
	public String view(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareVO careerDeclareVO) throws SQLException {
		String returnPage = "admin/sanctn/wait/view";
		String knd = req.getParameter("sanctnKnd");
		
		SanctnVO sanctnVO2 = new SanctnVO();
		CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(careerDeclareVO);
		
		// caType의 종류에 따라 신청서 페이지 변경
		if(null !=eo && !StringUtils.isEmpty(eo.getSe())){
			if("CASE0002".equals(eo.getSe())){
				returnPage = "admin/sanctn/wait/view2";
			}
		}
		
		// 보유증명서 발급신청
		if("ARCS0005".equals(knd)){
			returnPage = "admin/sanctn/wait/view3";
			UserInfoVO uvo = new UserInfoVO();
			HoldCrtfVO hvo = new HoldCrtfVO();
			hvo.setSn(careerDeclareVO.getCareerNo());
			
			HoldCrtfVO heo = holdCrtfService.selectHoldCrtfView(hvo);
			
			uvo.setBizno(heo.getBizno());
			req.setAttribute("corpEo", userService.selectCorpInfo(uvo));
			req.setAttribute("progList", holdCrtfService.selectHoldCrtfProgrsList(hvo));
			
			uvo.setBizno(heo.getApplcntBizno());
			if("HCSE0001".equals(heo.getSe()))
				req.setAttribute("applEo", userService.selectCorpInfo(uvo));
			else
				req.setAttribute("applEo", userService.selectDminsttInfo(uvo));
			
			req.setAttribute("eo", heo);
			
			sanctnVO2.setCareerNo(Long.valueOf(heo.getSn()).intValue());
			sanctnVO2.setSanctnKnd("ARCS0005");
			req.setAttribute("sanctnStatus", sanctnService.selectSanctnStatus(sanctnVO2));
			
		}else if("ARCS0002".equals(knd)) {	//등급증명서 발급신청
			returnPage = "admin/sanctn/wait/crtfIssuView";
			CrtfIssuVO crtfIssuVO = new CrtfIssuVO(); 
			crtfIssuVO.setReqstNo(careerDeclareVO.getCareerNo());
			req.setAttribute("relateList", cmmnCdService.selectCmmnCdChildList("RELA0000"));
			req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
			req.setAttribute("eo", crtfIssuService.selectCrtfReqView(crtfIssuVO)); //신청정보
			sanctnVO2.setCareerNo(careerDeclareVO.getCareerNo());
			sanctnVO2.setSanctnKnd("ARCS0002");
			req.setAttribute("sanctnStatus", sanctnService.selectSanctnStatus(sanctnVO2));
		}else{
			//주민번호 분할
			String[] jumin = eo.getIhidnum().split("-");
			eo.setJumin1(jumin[0]);
			eo.setJumin2(jumin[1]);
			
			//전화번호 분할
			try {
				String[] tel = eo.getMbtlnum().split("-");
				eo.setTel1(tel[0]);
				eo.setTel2(tel[1]);
				eo.setTel3(tel[2]);
			} catch (ArrayIndexOutOfBoundsException e) {
				if(LOG.isDebugEnabled())
					LOG.debug("전화번호 에러 : " + e.getMessage());
			}
			
			eo.setCntcType("view");
			if("CASE0002".equals(eo.getSe())){
				req.setAttribute("workList", careerDeclareService.selectIhidnumWorkExpert(eo));
				careerDeclareVO.setKcomwelSe("상용");
				req.setAttribute("workCmclList", careerDeclareService.selectIhidnumWorkKcomwel(eo));
				careerDeclareVO.setKcomwelSe("일용");
				req.setAttribute("workDlyList", careerDeclareService.selectIhidnumWorkKcomwel(eo));
				req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
				
			}else{
				req.setAttribute("licenseList", careerDeclareService.selectIhidnumLicense(eo));
				req.setAttribute("eduList", careerDeclareService.selectIhidnumEdu(eo));
				req.setAttribute("rewardList", careerDeclareService.selectIhidnumReward(eo));
				
			}
			
			sanctnVO2.setCareerNo(careerDeclareVO.getCareerNo());
			sanctnVO2.setSanctnKnd("ARCS0001");
			req.setAttribute("eo", eo);
			req.setAttribute("sanctnStatus", sanctnService.selectSanctnStatus(sanctnVO2));
		}
	
		return returnPage;
	}

	/**
	 * 대리결재 목록
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="selectAgncyMember.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> agncyList(HttpServletRequest req, @ModelAttribute("vo") Agncy vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		vo.setRgstId(uvo.getUserId());
		
		if("search".equals(vo.getSe()))
			map.put("list", sanctnService.selectSearchAgncyMember(vo));
		else
			map.put("list", sanctnService.selectAgncMember(vo));
		
		map.put("vo", vo);
				
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 대리결제 처리
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="agncy.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> agncy(HttpServletRequest req, @ModelAttribute("vo") Agncy vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		vo.setRgstId(uvo.getUserId());
		
		if(vo.getAgncyNo() != null)
			sanctnService.deleteAgncMember(vo);
		else
			sanctnService.insertAgncMember(vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 결재대기상태 입력
	 * @param req
	 * @param careerDeclareVO
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="progrs.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> progrsPost(HttpServletRequest req, @ModelAttribute("vo") SanctnVO vo) throws SQLException {
		// 일괄처리 결재로 인하여 객체화
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		return new ResponseEntity<>(sanctnService.progrsSanctn(uvo, vo), HttpStatus.OK);
	}
	
	/**
	 * 결재대기상태 입력
	 * @param req
	 * @param careerDeclareVO
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="progrsList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> progrsListPost(HttpServletRequest req, SanctnVO vo) throws SQLException {
		// 일괄처리 결재로 인하여 객체화
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		for(SanctnVO vo2 : vo.getSanctnVO()) {
			vo2.setRgstId(uvo.getUserId());
			sanctnService.progrsSanctn(uvo, vo2);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
