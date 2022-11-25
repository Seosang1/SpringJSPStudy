package kr.or.cwma.skill.mypage.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareSearchVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.common.enums.CrtfIssuSanctnId;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

/**
 * 발급안내 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/mypage")
public class MypageCarrerController{
	
	@Autowired
	CareerDeclareService careerDeclareService;
	
	@Autowired
	private JssfcInfoService jssfcInfoService;

	@Autowired
	private CommonService commonService;

	@Autowired
	private UserInfoService userInfoService;

	/**
	 * 마이페이지 인덱스 페이지
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="careerDeclare.do")
	public String careerDeclare(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareVO vo) throws SQLException {
		String returnPage = "skill/mypage/careerDeclare/careerDeclare";
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		// 비회원 접근
		if("USSE0001".equals(uvo.getSe()) && StringUtils.isEmpty(uvo.getUserId()) && StringUtils.isEmpty(uvo.getIhidnum())) {
			return "/skill/mypage/index";
		}
		
		//일반사용자 접근임.
		if(!"Y".equals(uvo.getClmserEduComplAt())){
			if(!uvo.isMyPageLogin() && !StringUtils.isEmpty(uvo.getUserId()))
				return "/skill/mypage/redirectIndex";
			else
				return "redirect:/skill/mypage/clmserEdu.do";
		}
		
		vo.setCntcType("req");
		
		if(uvo.getSe().equals("USSE0001")){
			//개인  자격증/포상/훈련교육 확인
			vo.setNm(uvo.getNm());
			vo.setJumin1(uvo.getIhidnum().split("-")[0]);
			vo.setJumin2(uvo.getIhidnum().split("-")[1]);
		}else{
			//대리인/사업주/수요기관
			return "redirect:/skill/mypage/index.do";
		}
		
		// caType의 종류에 따라 신청서 페이지 변경
		if(!StringUtils.isEmpty(vo.getSe())){
			if("CASE0002".equals(vo.getSe())){
				returnPage = "skill/mypage/careerDeclare/careerDeclare2";
			}else if("CASE0003".equals(vo.getSe())) {
				returnPage = "skill/mypage/careerDeclare/careerDeclare3";
			}
		}
		
		vo.setCntcType("req");
		if("CASE0002".equals(vo.getSe())){
//			req.setAttribute("workList", careerDeclareService.selectIhidnumWork(vo));
			
			req.setAttribute("workDlyList", careerDeclareService.selectWorkDly(vo));	//일용
			req.setAttribute("workCmclList", careerDeclareService.selectWorkCmcl(vo));	//상용
			req.setAttribute("workCareerList", careerDeclareService.selectWorkCareer(vo));	//퇴직공제
			
			req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //직종코드
		}else{
			req.setAttribute("licenseList", careerDeclareService.selectIhidnumLicense(vo));
			req.setAttribute("eduList", careerDeclareService.selectIhidnumEdu(vo));
			req.setAttribute("rewardList", careerDeclareService.selectIhidnumReward(vo));
		}
		
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
	public ResponseEntity<Map<String, Object>> careerDeclareIns(HttpServletRequest req, MultipartHttpServletRequest multi, @Valid CareerDeclareVO vo, BindingResult result) throws SQLException, IOException{
		HttpStatus sttus =  HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		//현장구분 - PC/모바일(사용자)·방문(관리자)
		String sptSe = StringUtils.isEmpty(vo.getSptSe()) ? "SPTS0001" : vo.getSptSe();
		String sptSeNm = "SPTS0001".equals(vo.getSptSe()) ? "PC" : "모바일";
				
		if(!uvo.getSe().equals("USSE0001")){
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		vo.setJumin1(uvo.getIhidnum().split("-")[0]);
		vo.setJumin2(uvo.getIhidnum().split("-")[1]);
		vo.setNm(uvo.getNm());
		vo.setRelate("RELA0001");
		vo.setTel1(uvo.getMoblphonNo().split("-")[0]);
		vo.setTel2(uvo.getMoblphonNo().split("-")[1]);
		vo.setTel3(uvo.getMoblphonNo().split("-")[2]);
		vo.setEmail(uvo.getEmail());
		vo.setZip(uvo.getZip());
		vo.setAdres(uvo.getAdres());
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		vo.setRqstdt(sdf.format(new Date()));
		
		vo.setRgstId(uvo.getUserId());
		
		vo.setSptSe(sptSe);
		
		UserCnsltHistVO cnsltHist = new UserCnsltHistVO();
		cnsltHist.setIhidnum(vo.getJumin1() + "-" + vo.getJumin2());
		if("CASE0001".equals(vo.getSe())) {
			cnsltHist.setCn("경력인정신청 (" + sptSeNm + ")");
		}else {
			cnsltHist.setCn("근로직종확인 신청 (" + sptSeNm + ")");
		}
		cnsltHist.setRgstId(CrtfIssuSanctnId.getValue(commonService.getDdcAsctCdByCnstwkLocplcAddr(uvo.getAdres())));
		cnsltHist.setSe("3");
		cnsltHist.setSkillAt("1");
		cnsltHist.setTrgt("USSE0001".equals(uvo.getSe())?"1":"2");
		
		if("USSE0001".equals(vo.getRelate()))
			cnsltHist.setTrgt("1");
		else if("USSE0002".equals(vo.getRelate()))
			cnsltHist.setTrgt("2");
		else
			cnsltHist.setTrgt("3");
		
		List<CmmnCdVO> ddcerList = userInfoService.selectUserCnsltDdcerSnList(uvo);
		
		if(ddcerList != null && ddcerList.size() > 0 && !"Y".equals(vo.getPreViewYn())){
			cnsltHist.setDdcerSn(ddcerList.get(0).getCdId());
			userInfoService.executeUserCnsltHist(cnsltHist);
		}
		
		careerDeclareService.insertCareerDeclare(vo, multi);
		
		if("Y".equals(vo.getDeleteAt())) {
			map.put("careerNo", vo.getCareerNo());
		}

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
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if(!uvo.getSe().equals("USSE0001")){
			return "redirect:/skill/mypage/index.do";
		}
		
		CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(vo);
		
		if(uvo.getUserId().equals(eo.getRgstId())) {
		
			req.setAttribute("no", eo.getCareerNo());
			
			String serverType = System.getProperty("server");
			if("live".equals(serverType)) {
				req.setAttribute("subDomain", "rpt");
			}else {
				req.setAttribute("subDomain", "testrpt");
			}
			
			String reportName = "";
			
			if("CASE0001".equals(eo.getSe()))
				reportName = "기능경력인정신청서";
			else
				reportName = "근로직종확인서";
				
			req.setAttribute("reportName", reportName);
		}
		
		return "skill/mypage/careerDeclare/careerDeclareReportPop";
	}
	
	/**
	 * 신고내역관리 수정
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException, IOException 
	 */
	@RequestMapping(value="careerDeclareUpd.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareUpd(HttpServletRequest req, MultipartHttpServletRequest multi, @Valid CareerDeclareVO vo, BindingResult result) throws SQLException, IOException{
		HttpStatus sttus =  HttpStatus.OK;
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		if(!uvo.getSe().equals("USSE0001")){
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		CareerDeclareVO eo = careerDeclareService.selectCareerDeclareView(vo);
		vo.setRgstId(uvo.getUserId());
		if(!uvo.getUserId().equals(eo.getRgstId())) {
			map.put("msg", "잘못 된 입력입니다.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}else {
			vo.setJumin1(uvo.getIhidnum().split("-")[0]);
			vo.setJumin2(uvo.getIhidnum().split("-")[1]);
			vo.setNm(uvo.getNm());
			vo.setRelate("RELA0001");
			vo.setTel1(uvo.getMoblphonNo().split("-")[0]);
			vo.setTel2(uvo.getMoblphonNo().split("-")[1]);
			vo.setTel3(uvo.getMoblphonNo().split("-")[2]);
			vo.setEmail(uvo.getEmail());
			vo.setZip(uvo.getZip());
			vo.setAdres(uvo.getAdres());
		}
		careerDeclareService.updateCareerDeclare(vo, multi);

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * 신청내역 리스트
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareList.do")
	public String careerDeclareList(HttpServletRequest req, @ModelAttribute("vo") CareerDeclareSearchVO careerDeclareSearchVO) {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		if(!uvo.getSe().equals("USSE0001")){
			return "redirect:/skill/mypage/index.do";
		}
		
		return "skill/mypage/careerDeclare/list";
	}
	

	/**
	 * 신청내역 리스트 조회
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="careerDeclareList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> careerDeclareListPost(HttpServletRequest req, CareerDeclareSearchVO careerDeclareSearchVO) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		if(!uvo.getSe().equals("USSE0001")){
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}

		careerDeclareSearchVO.setJumin1(uvo.getIhidnum().split("-")[0]);
		careerDeclareSearchVO.setJumin2(uvo.getIhidnum().split("-")[1]);
		careerDeclareSearchVO.setNm(uvo.getNm());
		
		careerDeclareSearchVO.setTotalCnt(careerDeclareService.selectCareerDeclareListCnt(careerDeclareSearchVO));
		map.put("list", careerDeclareService.selectCareerDeclareList(careerDeclareSearchVO));

		map.put("vo", careerDeclareSearchVO);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
