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
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.service.HoldCrtfService;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.issuAgre.service.IssuAgreService;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.SanctnSearchVO;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.skill.user.service.UserService;

/**
 * 결재완료 컨트롤러
 * @author PCNDEV
 *
 */
@Controller
@RequestMapping(value="admin/sanctnCompt")
public class SanctnComptController {
	static final Logger LOG = LoggerFactory.getLogger(SanctnComptController.class);
	
	@Autowired
	private SanctnService sanctnService;
	
	@Autowired
	private CareerDeclareService careerDeclareService;
	
	@Autowired
	private CrtfIssuService crtfIssuService;
	
	@Autowired
	private JssfcInfoService jssfcInfoService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private IssuAgreService issuAgreService;
	
	@Autowired
	private HoldCrtfService holdCrtfService;
	
	@Autowired
	private UserService userService;

	/**
	 * 결재완료 목록
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="list.do")
	public String list(HttpServletRequest req, @ModelAttribute("vo") SanctnSearchVO vo) {
		
		req.setAttribute("ddcAsctList", sanctnService.selectCwmaDdcAsctInfoList());
		return "admin/sanctn/compt/list";
	}
	
	/**
	 * 결재완료 목록
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="list.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> listPost(HttpServletRequest req, @ModelAttribute("vo") SanctnSearchVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		//결재 쿼리 목록 구분
		vo.setSanctnList("COMPT");
		
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
	public String view(HttpServletRequest req, @ModelAttribute("vo") SanctnSearchVO vo) throws SQLException {
		String returnPage = "admin/sanctn/compt/view";
		
		if(vo.getCareerNo() != null) {
			
			CareerDeclareVO careerDeclareVO = new CareerDeclareVO();
			careerDeclareVO.setCareerNo(vo.getCareerNo());
			
			CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(careerDeclareVO);
			
			// caType의 종류에 따라 신청서 페이지 변경
			if(!StringUtils.isEmpty(eo.getSe())){
				if("CASE0002".equals(eo.getSe())){
					returnPage = "admin/sanctn/compt/view2";
				}
			}
			
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
			
			SanctnVO sanctnVO2 = new SanctnVO();
			sanctnVO2.setCareerNo(careerDeclareVO.getCareerNo());
			sanctnVO2.setSanctnKnd("ARCS0005");
			req.setAttribute("eo", eo);
			req.setAttribute("sanctnStatus", sanctnService.selectSanctnStatus(sanctnVO2));
		}else {
			// 발급동의신청
			if("ARCS0003".equals(vo.getSanctnKnd())){
				returnPage = "admin/sanctn/compt/view4";

				IssuAgreVO issuAgreVO = new IssuAgreVO();
				issuAgreVO.setDocNo(vo.getReqstNo());
				req.setAttribute("eo", issuAgreService.selectIssuAgreView(issuAgreVO)); //발급동의신청상세
				
			// 보유증명서 발급신청
			}else if("ARCS0005".equals(vo.getSanctnKnd())){
				returnPage = "admin/sanctn/compt/view5";
				UserInfoVO uvo = new UserInfoVO();
				HoldCrtfVO hvo = new HoldCrtfVO();
				hvo.setSn(vo.getReqstNo());
				
				HoldCrtfVO eo = holdCrtfService.selectHoldCrtfView(hvo);
				
				req.setAttribute("eo", eo);
				uvo.setBizno(eo.getBizno());
				req.setAttribute("corpEo", userService.selectCorpInfo(uvo));
				req.setAttribute("progList", holdCrtfService.selectHoldCrtfProgrsList(hvo));
				
				uvo.setBizno(eo.getApplcntBizno());
				if("HCSE0001".equals(eo.getSe()))
					req.setAttribute("applEo", userService.selectCorpInfo(uvo));
				else
					req.setAttribute("applEo", userService.selectDminsttInfo(uvo));
				
				SanctnVO sanctnVO2 = new SanctnVO();
				sanctnVO2.setCareerNo(Long.valueOf(eo.getSn()).intValue());
				sanctnVO2.setSanctnKnd("ARCS0005");
				req.setAttribute("sanctnStatus", sanctnService.selectSanctnStatus(sanctnVO2));
				
			}else {
				returnPage = "admin/sanctn/compt/view3";

				CrtfIssuVO crtfIssuVO = new CrtfIssuVO();
				crtfIssuVO.setReqstNo(vo.getReqstNo());
				//신청자와의 관계 공통코드
				CmmnCdVO cmmVo = new CmmnCdVO();
				cmmVo.setParntsCdId("RELA0000");
				cmmVo.setNumOfPage(999);
				req.setAttribute("relateList", cmmnCdService.selectCmmnCdList(cmmVo));
				req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
				req.setAttribute("eo", crtfIssuService.selectCrtfReqView(crtfIssuVO)); //직종코드
			}
		}
		return returnPage;
	}

}
