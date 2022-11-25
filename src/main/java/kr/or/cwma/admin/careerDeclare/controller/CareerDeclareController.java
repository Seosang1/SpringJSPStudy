package kr.or.cwma.admin.careerDeclare.controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareProgsVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareSearchVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.indvdlinfoAccesLog.service.IndvdlinfoAccesLogService;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;
import kr.or.cwma.common.util.ExcelUtil;


/**
 * 경력인정신고 관리자 컨트롤러
 * @author PCNDEV
 *
 */
@Controller
@RequestMapping(value="admin/careerDeclare")
public class CareerDeclareController {
	
	static final Logger LOG = LoggerFactory.getLogger(CareerDeclareController.class);
	
	@Autowired
	CareerDeclareService careerDeclareService;
	
	@Autowired
	CmmnCdService cmmnCdService;
	
	@Autowired
	private UserInfoService userInfoService;

	@Autowired
	private JssfcInfoService jssfcInfoService;
	
	@Autowired
	SanctnService sanctnService;
	
	@Autowired
	IndvdlinfoAccesLogService indvdlinfoAccesLogService;
	
	/**
	 * 경력인정신고 / 근로직종확인 입력 폼
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclare.do")
	public String careerDeclareForm(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareVO careerDeclareVO) throws SQLException {
		String returnPage = "admin/careerDeclare/careerDeclare";
		
		CmmnCdVO cmmVo = new CmmnCdVO();
		UserInfoVO uvo = new UserInfoVO();
		UserMainJssfcVO umvo = new UserMainJssfcVO();
		
		// caType의 종류에 따라 신청서 페이지 변경
		if(!StringUtils.isEmpty(careerDeclareVO.getSe())){
			if("CASE0002".equals(careerDeclareVO.getSe())){
				returnPage = "admin/careerDeclare/careerDeclare2";
			}
		}else {
			careerDeclareVO.setSe("CASE0001");
		}
			
		//신청자와의 관계 공통코드
		cmmVo.setParntsCdId("RELA0000");
		cmmVo.setNumOfPage(999);
		req.setAttribute("relateList", cmmnCdService.selectCmmnCdList(cmmVo));
		
		if(!StringUtils.isEmpty(careerDeclareVO.getJumin1())) {
			if(!StringUtils.isEmpty(careerDeclareVO.getJumin2())) {
				careerDeclareVO.setIhidnum(careerDeclareVO.getJumin1() + "-" + careerDeclareVO.getJumin2());
				CareerDeclareVO eo = careerDeclareService.selectIhidnum(careerDeclareVO);
				
				uvo.setIhidnum(careerDeclareVO.getIhidnum());
				umvo = userInfoService.selectPersonalUserInfoView(uvo);
				
				if(eo != null) {
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
					
					req.setAttribute("eo", eo);
					req.setAttribute("umvo", umvo);
					
					if(StringUtils.isEmpty(careerDeclareVO.getNm())) {
						careerDeclareVO.setNm(eo.getNm());
					}
					careerDeclareVO.setCntcType("req");
					if(umvo != null && umvo.getUserInfoVO() != null && "Y".equals(umvo.getUserInfoVO().getClmserEduComplAt())){
						if("CASE0002".equals(careerDeclareVO.getSe())){
//							req.setAttribute("workList", careerDeclareService.selectIhidnumWorkExpert(careerDeclareVO));
//							careerDeclareVO.setKcomwelSe("상용");
//							req.setAttribute("workCmclList", careerDeclareService.selectIhidnumWorkKcomwel(careerDeclareVO));
//							careerDeclareVO.setKcomwelSe("일용");
//							req.setAttribute("workDlyList", careerDeclareService.selectIhidnumWorkKcomwel(careerDeclareVO));
							
							req.setAttribute("workDlyList", careerDeclareService.selectWorkDly(careerDeclareVO));	//일용
							req.setAttribute("workCmclList", careerDeclareService.selectWorkCmcl(careerDeclareVO));	//상용
							req.setAttribute("workList", careerDeclareService.selectWorkCareer(careerDeclareVO));	//퇴직공제
							req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
							
						}else{
							req.setAttribute("licenseList", careerDeclareService.selectIhidnumLicense(careerDeclareVO));
							req.setAttribute("eduList", careerDeclareService.selectIhidnumEdu(careerDeclareVO));
							req.setAttribute("rewardList", careerDeclareService.selectIhidnumReward(careerDeclareVO));
						}
					}else {
						eo = new CareerDeclareVO();
						eo.setJumin1(careerDeclareVO.getJumin1());
						req.setAttribute("eo", eo);
						
					}
				}else {
					if(LOG.isDebugEnabled())
						LOG.debug(careerDeclareVO.getJumin1());
					
					eo = new CareerDeclareVO();
					eo.setJumin1(careerDeclareVO.getJumin1());
					req.setAttribute("eo", eo);
				}
			}
		}
		
		return returnPage;
	}
	
	/**
	 * 경력인정신고 / 근로직종확인 View
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareView.do")
	public String careerDeclareView(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareVO careerDeclareVO) throws SQLException {
		String returnPage = "admin/careerDeclare/careerDeclareView";
		
		CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(careerDeclareVO);
		
		// caType의 종류에 따라 신청서 페이지 변경
		if(!StringUtils.isEmpty(careerDeclareVO.getSe())){
			if("CASE0002".equals(careerDeclareVO.getSe())){
				returnPage = "admin/careerDeclare/careerDeclareView2";
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
		
		careerDeclareVO.setCntcType("view");
		if("CASE0002".equals(careerDeclareVO.getSe())){
			req.setAttribute("workList", careerDeclareService.selectIhidnumWork(careerDeclareVO));
			careerDeclareVO.setKcomwelSe("상용");
			req.setAttribute("workCmclList", careerDeclareService.selectIhidnumWorkKcomwel(careerDeclareVO));
			careerDeclareVO.setKcomwelSe("일용");
			req.setAttribute("workDlyList", careerDeclareService.selectIhidnumWorkKcomwel(careerDeclareVO));
			req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
		}else{
			req.setAttribute("licenseList", careerDeclareService.selectIhidnumLicense(careerDeclareVO));
			req.setAttribute("eduList", careerDeclareService.selectIhidnumEdu(careerDeclareVO));
			req.setAttribute("rewardList", careerDeclareService.selectIhidnumReward(careerDeclareVO));
		}
		
		req.setAttribute("eo", eo);
		
		return returnPage;
	}
	
	/**
	 * 신고내역관리 입력
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException, IOException 
	 */
	@RequestMapping(value="careerDeclareIns.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareIns(HttpServletRequest req, @Valid CareerDeclareVO vo, BindingResult result) throws SQLException, IOException{
		HttpStatus sttus =  HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		UserInfoVO uivo = new UserInfoVO();
		
		vo.setRgstId(uvo.getUserId());
		//현장구분 - PC/모바일(사용자)·방문(관리자)
		vo.setSptSe("SPTS0002");
		
		UserCnsltHistVO cnsltHist = new UserCnsltHistVO();
		cnsltHist.setIhidnum(vo.getJumin1() + "-" + vo.getJumin2());
		uivo.setIhidnum(cnsltHist.getIhidnum());
		
		if("CASE0001".equals(vo.getSe())) {
			cnsltHist.setCn("경력인정신청 (방문)");
		}else {
			cnsltHist.setCn("근로직종확인 신청 (방문)");
		}
		cnsltHist.setSe("2");
		cnsltHist.setSkillAt("1");
		
		if("RELA0001".equals(vo.getRelate()))
			cnsltHist.setTrgt("1");
		else if("RELA0003".equals(vo.getRelate()))
			cnsltHist.setTrgt("2");
		else
			cnsltHist.setTrgt("3");
		
		cnsltHist.setRgstId(uvo.getUserId());
		
		List<CmmnCdVO> ddcerList = userInfoService.selectUserCnsltDdcerSnList(uivo);
		
		if(ddcerList != null && ddcerList.size() > 0 && !"Y".equals(vo.getDeleteAt())){
			cnsltHist.setDdcerSn(ddcerList.get(0).getCdId());
			userInfoService.executeUserCnsltHist(cnsltHist);
		}
		
		vo.setChrgBrffc(uvo.getDdcAstcCd());
		careerDeclareService.insertCareerDeclare(vo, null);
		
		map.put("careerNo", vo.getCareerNo() );

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 신고내역관리
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="careerDeclareList.do")
	public String careerDeclareList(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareSearchVO careerDeclareSearchVO) throws SQLException {
		req.setAttribute("sptsList", cmmnCdService.selectCmmnCdChildList("SPTS0000"));
		req.setAttribute("capgList", cmmnCdService.selectCmmnCdChildList("CAPG0000"));
		req.setAttribute("ddcAsctList", sanctnService.selectCwmaDdcAsctInfoList()); //지사센터목록
		return "admin/careerDeclare/list";
	}
	
	/**
	 * 신고내역관리
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="careerDeclareList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareListPost(HttpServletRequest req, CareerDeclareSearchVO careerDeclareSearchVO) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		List<CareerDeclareVO> list = null;
		
		if(!"01100".equals(uvo.getDdcAstcCd()))
			careerDeclareSearchVO.setChrgBrffc(uvo.getDdcAstcCd());
		
		careerDeclareSearchVO.setTotalCnt(careerDeclareService.selectCareerDeclareListCnt(careerDeclareSearchVO));
		list = careerDeclareService.selectCareerDeclareList(careerDeclareSearchVO);
		indvdlinfoAccesLogService.insertIndvdlinfoAccesLog(list, req);
		
		map.put("list", list);
		map.put("vo", careerDeclareSearchVO);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 신고내역관리 진행리스트
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareProgsList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareProgsList(HttpServletRequest req, CareerDeclareProgsVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("progsList", careerDeclareService.selectCareerDeclareProgsList(vo));
		map.put("progsVo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	

	/**
	 * 신고내역관리 진행리스트
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareProgsIns.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareProgsIns(HttpServletRequest req, CareerDeclareProgsVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		vo.setRgstId(uvo.getUserId());
		
		CareerDeclareProgsVO vo2 = new CareerDeclareProgsVO();
		vo2.setProgrsSttus("CAPG0002");
		vo2.setCareerNo(vo.getCareerNo());
		vo2.setRgstId(uvo.getUserId());
		vo2.setProgrsDe(vo.getProgrsDe());
		if(careerDeclareService.chkProgrsSttus(vo2) == 0 && !"CAPG0002".equals(vo.getProgrsSttus()))
			careerDeclareService.insertCareerDeclareProgs(vo2);
		
		careerDeclareService.insertCareerDeclareProgs(vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 경력인정신고 / 근로직종확인 입력 폼
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareForm.do", method=RequestMethod.POST)
	public String careerDeclareFormUpd(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareVO careerDeclareVO) throws SQLException {
		String returnPage = "admin/careerDeclare/careerDeclareForm";
		
		CmmnCdVO cmmVo = new CmmnCdVO();
		
		//신청자와의 관계 공통코드
		cmmVo.setParntsCdId("RELA0000");
		cmmVo.setNumOfPage(999);
		req.setAttribute("relateList", cmmnCdService.selectCmmnCdList(cmmVo));
		
		CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(careerDeclareVO);
		
		// caType의 종류에 따라 신청서 페이지 변경
		
		if(!StringUtils.isEmpty(eo.getSe())){
			if("CASE0002".equals(eo.getSe())){
				returnPage = "admin/careerDeclare/careerDeclareForm2";
			}
		}
		
		if(!eo.getSe().equals(careerDeclareVO.getSe()) && !StringUtils.isEmpty(careerDeclareVO.getSe())) {
			if("CASE0002".equals(careerDeclareVO.getSe())){
				returnPage = "admin/careerDeclare/careerDeclareForm2";
			}else {
				returnPage = "admin/careerDeclare/careerDeclareForm";
			}
		}
		
		if(eo != null) {
			
			//주민번호 분할
			String[] jumin = eo.getIhidnum().split("-");
			eo.setJumin1(jumin[0]);
			eo.setJumin2(jumin[1]);
			try {
				String[] email = eo.getEmail().split("@");
				eo.setEmail1(email[0]);
				eo.setEmail2(email[1]);
			}catch (ArrayIndexOutOfBoundsException e) {
				if(LOG.isDebugEnabled())
					LOG.debug(e.getMessage());
			}
			
			//전화번호 분할
			try {
				if(!StringUtils.isEmpty(eo.getMbtlnum())) {
					String[] tel = eo.getMbtlnum().split("-");
					eo.setTel1(tel[0]);
					eo.setTel2(tel[1]);
					eo.setTel3(tel[2]);
				}
			} catch (ArrayIndexOutOfBoundsException e) {
				if(LOG.isDebugEnabled())
					LOG.debug("전화번호 에러 : " + e.getMessage());
			}
			
			try {
				if(!StringUtils.isEmpty(eo.getBizno())) {
					String[] biz = eo.getBizno().split("-");
					eo.setBizno1(biz[0]);
					eo.setBizno2(biz[1]);
					eo.setBizno3(biz[2]);
				}
			} catch (ArrayIndexOutOfBoundsException e) {
				if(LOG.isDebugEnabled())
					LOG.debug("사업자등록번호 에러 : " + e.getMessage());
			}
			
			try {
				if(!StringUtils.isEmpty(eo.getJurirno())) {
					String[] jurirno = eo.getJurirno().split("-");
					eo.setJurirno1(jurirno[0]);
					eo.setJurirno2(jurirno[1]);
				}
			} catch (ArrayIndexOutOfBoundsException e) {
				if(LOG.isDebugEnabled())
					LOG.debug("법인번호 에러 : " + e.getMessage());
			}
			
			//전화번호 분할
			try {
				if(!StringUtils.isEmpty(eo.getMbtlnum2())) {
					String[] tel2 = eo.getMbtlnum2().split("-");
					eo.setTel21(tel2[0]);
					eo.setTel22(tel2[1]);
					eo.setTel23(tel2[2]);
				}
			} catch (ArrayIndexOutOfBoundsException e) {
				if(LOG.isDebugEnabled())
					LOG.debug("확인자 전화번호 에러 : " + e.getMessage());
			}
			
			req.setAttribute("eo", eo);
		}
		

		careerDeclareVO.setCntcType("view");
		careerDeclareVO.setCareerNo(eo.getCareerNo());
		
		if(StringUtils.isEmpty(careerDeclareVO.getSe()))
			careerDeclareVO.setSe(eo.getSe());
		
		if("CASE0002".equals(careerDeclareVO.getSe())){
			req.setAttribute("workList", careerDeclareService.selectIhidnumWork(careerDeclareVO));
			careerDeclareVO.setKcomwelSe("상용");
			req.setAttribute("workCmclList", careerDeclareService.selectIhidnumWorkKcomwel(careerDeclareVO));
			careerDeclareVO.setKcomwelSe("일용");
			req.setAttribute("workDlyList", careerDeclareService.selectIhidnumWorkKcomwel(careerDeclareVO));
			req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
		}else{
			req.setAttribute("licenseList", careerDeclareService.selectIhidnumLicense(careerDeclareVO));
			req.setAttribute("eduList", careerDeclareService.selectIhidnumEdu(careerDeclareVO));
			req.setAttribute("rewardList", careerDeclareService.selectIhidnumReward(careerDeclareVO));
		}
		
		return returnPage;
	}
	
	/**
	 * 신고내역관리 수정
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException, IOException 
	 */
	@RequestMapping(value="careerDeclareUpd.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareUpd(HttpServletRequest req, @Valid CareerDeclareVO vo, BindingResult result) throws SQLException, IOException{
		HttpStatus sttus =  HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		vo.setRgstId(uvo.getUserId());
		
		careerDeclareService.updateCareerDeclare(vo, null);

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 신고내역관리 삭제
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException, IOException 
	 */
	@RequestMapping(value="careerDeclareDel.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareDel(HttpServletRequest req, MultipartHttpServletRequest multi, @Valid CareerDeclareVO vo, BindingResult result) throws SQLException, IOException{
		HttpStatus sttus =  HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		vo.setRgstId(uvo.getUserId());
		
		careerDeclareService.deleteCareerDeclare(vo);

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 신고내역출력
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareReportPop.do", method=RequestMethod.POST)
	public String careerDeclareReportPop(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareVO vo) {
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(vo);
		
		req.setAttribute("no", eo.getCareerNo());
		
		String serverType = System.getProperty("server");
		if("admin".equals(serverType)) {
			req.setAttribute("ozServer", "https://mplus.cw.or.kr");	//운영서버는 contextPath oz60
		}else {
			req.setAttribute("ozServer", "http://testrpt.cw.or.kr");
		}
		
		String reportName = "";
		
		if("CASE0001".equals(eo.getSe())) {
			reportName = "기능경력인정신청서sign";
			
		}
		else {
			if("Y".equals(vo.getPreViewYn()))
				reportName = "근로직종확인서_미리보기";
			else
				reportName = "근로직종확인서sign";
		}
			
		req.setAttribute("reportName", reportName);
		
		/* 파일 다운로드시 파일명에 추가 */
		req.setAttribute("brffcNm", uvo.getBrffcNm());
		
		return "admin/careerDeclare/careerDeclareReportPop";
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
	public void excelDown(HttpServletRequest req, HttpServletResponse res, CareerDeclareSearchVO vo) throws SQLException, IOException{
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		if(!"01100".equals(uvo.getDdcAstcCd())) {
			vo.setChrgBrffc(uvo.getDdcAstcCd());
		}
		
		ExcelUtil.createXls(careerDeclareService.selectCareerDeclareProgsListXls(vo), "신고내역관리", res);
	}
}
