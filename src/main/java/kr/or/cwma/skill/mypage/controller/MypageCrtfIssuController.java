package kr.or.cwma.skill.mypage.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.MapUtils;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.message.BasicNameValuePair;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.common.enums.CrtfIssuSanctnId;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuSearchVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.fee.service.FeeService;
import kr.or.cwma.admin.fee.vo.FeeVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.service.ShareService;
import kr.or.cwma.skill.common.kisa.Seed128;
import kr.or.cwma.skill.mypage.service.MypageService;
import kr.or.cwma.skill.mypage.vo.CorpCrtfIssuVO;

/**
 * ???????????? ????????????
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/mypage")
public class MypageCrtfIssuController{
	
	static final Logger LOG = LoggerFactory.getLogger(MypageCrtfIssuController.class);
	
	@Autowired
	private CrtfIssuService crtfIssuService;
	
	@Autowired
	private CareerDeclareService careerDeclareService;
	
	@Autowired
	private JssfcInfoService jssfcInfoService;

	@Autowired
	private FeeService feeService;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	SanctnService sanctnService;
	
	@Autowired
	MypageService mypageService;

	@Autowired
	private UserInfoService userInfoService;
	
	@Autowired
	ShareService shareService;
	
	/**
	 * ??????????????????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuConfirmList.do")
	public String crtfIssuConfirmList(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuSearchVO vo) {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
		}
		
		return "skill/mypage/crtfIssu/chkList";
	}
	
	/**
	 * ??????????????????????? ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuConfirmList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuConfirmListPost(HttpServletRequest req, CrtfIssuSearchVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
		}
		
		if(StringUtils.isEmpty(vo.getIssuTrgterNm())) {
			map.put("msg", "????????? ???????????? ???????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		if(StringUtils.isEmpty(vo.getIssuNo1()) || StringUtils.isEmpty(vo.getIssuNo2()) || StringUtils.isEmpty(vo.getIssuNo3()) || StringUtils.isEmpty(vo.getIssuNo4())) {
			map.put("msg", "??????????????? ???????????? ???????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}else {
			vo.setIssuNo(vo.getIssuNo1().toUpperCase() + "-" + vo.getIssuNo2().toUpperCase() + "-" + vo.getIssuNo3().toUpperCase() + "-" + vo.getIssuNo4().toUpperCase());
		}
		
		crtfIssuService.selectCrtfIssuList(vo);
		map.put("totalCnt", vo.getTotalCnt());
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * ????????????????????? ???????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return String
	 * @throws SQLException
	 */
	@RequestMapping(value="crtfIssuReq.do")
	public String crtfIssuReq(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws SQLException{
		String serverType = System.getProperty("server");
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		UserInfoVO pUvo = new UserInfoVO();
		CareerDeclareVO vo2 = new CareerDeclareVO();
		List<CareerDeclareVO> workList2;
		
		// ????????? ??????
		if("USSE0001".equals(uvo.getSe()) && StringUtils.isEmpty(uvo.getUserId()) && StringUtils.isEmpty(uvo.getIhidnum())) {
			return "/skill/mypage/index";
		}
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			if(!"Y".equals(uvo.getClmserEduComplAt())){
				if(!uvo.isMyPageLogin() && !StringUtils.isEmpty(uvo.getUserId()))
					return "/skill/mypage/redirectIndex";
				else
					return "redirect:/skill/mypage/clmserEdu.do";
			}
			
			vo2.setNm(uvo.getNm());
			vo2.setJumin1(uvo.getIhidnum().split("-")[0]);
			vo2.setJumin2(uvo.getIhidnum().split("-")[1]);
			vo2.setIhidnum(uvo.getIhidnum());
			
			vo.setApplcntNm(uvo.getNm());
			vo.setJumin3(uvo.getIhidnum().split("-")[0]);
			vo.setJumin4(uvo.getIhidnum().split("-")[1]);
			
			pUvo.setNm(uvo.getNm());
			pUvo.setIhidnum(uvo.getIhidnum());
			pUvo.setMoblphonNo(uvo.getMoblphonNo());
			pUvo.setZip(uvo.getZip());
			pUvo.setAdres(uvo.getAdres());
			
			/*?????? - ??????????????? ?????????*/
			if(null != vo.getReqstNo()) {
				CrtfIssuVO issuVO = crtfIssuService.selectCrtfReqView(vo);
				req.setAttribute("befIssuVO", issuVO);
			}
			
		}else {
			return "redirect:/skill/mypage/index.do";
/*			???????????? ????????? ????????????????????? ???????????? ???????????? 21/06
			//???????????? ????????? ????????????????????? ????????????
			if(StringUtils.isEmpty(vo.getIssuTrgterIhidnum())) {
				return "redirect:/skill/mypage/index.do";
			}
			
			//?????????????????? ????????? KISA ????????? ?????????
			Seed128 seed = new Seed128("CwmaGradeIhidnum");
			vo2.setIhidnum(seed.decrypt(vo.getIssuTrgterIhidnum()));
			CareerDeclareVO eo = careerDeclareService.selectIhidnum(vo2);
			
			vo2.setNm(eo.getNm());
			vo2.setJumin1(eo.getIhidnum().split("-")[0]);
			vo2.setJumin2(eo.getIhidnum().split("-")[1]);
			vo2.setIhidnum(eo.getIhidnum());
			
			vo.setApplcntNm(eo.getNm());
			vo.setJumin3(eo.getIhidnum().split("-")[0]);
			vo.setJumin4(eo.getIhidnum().split("-")[1]);
			
			pUvo.setNm(eo.getNm());
			pUvo.setIhidnum(eo.getIhidnum());
			pUvo.setMoblphonNo(eo.getMbtlnum());
			pUvo.setZip(eo.getZip());
			pUvo.setAdres(eo.getAdres());*/
			
		}
		
		
		vo.setIssuTrgterIhidnum(vo.getJumin3()+"-"+vo.getJumin4());

		/* ??? ?????? ??????(USER_STAT ??????) */
		HashMap<String, Object> map =  crtfIssuService.selectMainJssfcCd(vo);
		if(MapUtils.isNotEmpty(map)) {
			vo.setJssfcNo((Integer) map.get("JSSFC_NO"));
		}else {
			return "redirect:/skill/mypage/index.do?mainJssfc=0";
		}
		//???????????? ??????
		CrtfIssuVO data = crtfIssuService.searchCrtfHistory(vo);
		req.setAttribute("userGrade", data);
		req.setAttribute("pUvo", pUvo);
		
		req.setAttribute("userSe", uvo.getSe());
		
		//????????? ????????? ??????
		JssfcInfoVO jssfcVO = new JssfcInfoVO();
		if(!StringUtils.isEmpty(data.getIssuTrgterNm()))
			jssfcVO.setSearchIhidnum(vo2.getIhidnum());
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(jssfcVO)); //????????????
		
		//??????????????? ???????????? ?????????
		vo2.setCntcType("mypage");
		
		workList2 = careerDeclareService.selectIhidnumWork2(vo2);
		
		if(workList2 == null || workList2.size() == 0)
			return "redirect:".concat(req.getHeader("referer")).concat("#noCareerPop");
		
		if("live".equals(serverType)){
			shareService.insertJdtyInfoList(pUvo.getIhidnum());
			shareService.insertJobAbilityTngInfo(pUvo.getIhidnum());
		}
			
		req.setAttribute("workList", workList2);
		req.setAttribute("licenseList", careerDeclareService.selectIhidnumLicense(vo2));
		req.setAttribute("eduList", careerDeclareService.selectIhidnumEdu(vo2));
		req.setAttribute("rewardList", careerDeclareService.selectIhidnumReward(vo2));
		
		//????????? ???????????? ??????
		vo2.setCntcType("req");
		List<CareerDeclareVO> licenseList = careerDeclareService.selectIhidnumLicense(vo2);
		List<CareerDeclareVO> eduList = careerDeclareService.selectIhidnumEdu(vo2);
		List<CareerDeclareVO> rewardList = careerDeclareService.selectIhidnumReward(vo2);
		req.setAttribute("careerNoReqCnt", (licenseList.size() + eduList.size() + rewardList.size()));

		//???????????? ??? ?????? 0 ??? ??????
		req.setAttribute("crtfFirstCnt", crtfIssuService.selectCrtfReqFristCnt(vo));
		
		return "skill/mypage/crtfIssu/crtfIssuReq";
	}
	

	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws InterruptedException 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuAmmount.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuAmmountPost(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws InterruptedException, SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("fee", feeService.selectFeeView(null));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ??????????????? ?????????????????? ?????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuSearch.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuSearch(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		CareerDeclareVO vo2 = new CareerDeclareVO();
		if("USSE0001".equals(uvo.getSe())) {
			vo.setApplcntNm(uvo.getNm());
			vo.setJumin3(uvo.getIhidnum().split("-")[0]);
			vo.setJumin4(uvo.getIhidnum().split("-")[1]);
		}else {
			if(StringUtils.isEmpty(vo.getIssuTrgterIhidnum())) {
				return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
			}
			Seed128 seed = new Seed128("CwmaGradeIhidnum");
			vo2.setIhidnum(seed.decrypt(vo.getIssuTrgterIhidnum()));
			CareerDeclareVO eo = careerDeclareService.selectIhidnum(vo2);
			
			vo.setApplcntNm(eo.getNm());
			vo.setJumin3(eo.getIhidnum().split("-")[0]);
			vo.setJumin4(eo.getIhidnum().split("-")[1]);
		}
		
		vo.setIssuTrgterIhidnum(vo.getJumin3()+"-"+vo.getJumin4());
		map.put("grad", crtfIssuService.searchCrtfHistory(vo).getGrad());
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws InterruptedException 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuReqIns.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuReqPost(HttpServletRequest req,MultipartHttpServletRequest multi, @ModelAttribute("vo") CrtfIssuVO vo) throws InterruptedException, SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
		CareerDeclareVO vo2 = new CareerDeclareVO();
		
		vo.setRgstId(uvo.getUserId());
		
		//???????????? - PC/?????????(?????????)????????(?????????)
		String sptSe = StringUtils.isEmpty(vo.getSptSe()) ? "SPTS0001" : vo.getSptSe();
		String sptSeNm = "SPTS0001".equals(vo.getSptSe()) ? "PC" : "?????????";
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			vo.setApplcntNm(uvo.getNm());
			vo.setIssuTrgterNm(uvo.getNm());
			vo.setRelate("RELA0001");
			vo.setRqstdt(sdf.format(new Date()));
			vo.setIssuOn(sdf.format(new Date()));
			if(uvo.getMoblphonNo().length() > 0 && uvo.getMoblphonNo().split("-").length == 3) {
				vo.setApplcntMoblphon1(uvo.getMoblphonNo().split("-")[0]);
				vo.setApplcntMoblphon2(uvo.getMoblphonNo().split("-")[1]);
				vo.setApplcntMoblphon3(uvo.getMoblphonNo().split("-")[2]);
				vo.setIssuTrgterMoblphon1(uvo.getMoblphonNo().split("-")[0]);
				vo.setIssuTrgterMoblphon2(uvo.getMoblphonNo().split("-")[1]);
				vo.setIssuTrgterMoblphon3(uvo.getMoblphonNo().split("-")[2]);
			}
			vo.setJumin1(uvo.getIhidnum().split("-")[0]);
			vo.setJumin2(uvo.getIhidnum().split("-")[1]);
			vo.setJumin3(uvo.getIhidnum().split("-")[0]);
			vo.setJumin4(uvo.getIhidnum().split("-")[1]);
			vo.setIssuTrgterZip(uvo.getZip());
			vo.setIssuTrgterAdres(uvo.getAdres());
			vo.setChrgBrffc(commonService.getDdcAsctCdByCnstwkLocplcAddr(vo.getIssuTrgterAdres()));
			vo.setSanctnId(CrtfIssuSanctnId.getValue(vo.getChrgBrffc()));
		}else {
/*			???????????? ????????? ????????????????????? ???????????? ???????????? 21/06
			Seed128 seed = new Seed128("CwmaGradeIhidnum");
			vo2.setIhidnum(seed.decrypt(vo.getIssuTrgterIhidnum()));
			CareerDeclareVO eo = careerDeclareService.selectIhidnum(vo2);
			
			//??????????????? ?????????.
			vo.setApplcntNm(eo.getNm());
			vo.setIssuTrgterNm(eo.getNm());
			if("USSE0002".equals(uvo.getSe())) {
				vo.setRelate("RELA0003");
				vo.setRelateDetail(sptSeNm + " ?????? (?????????) : " + uvo.getCorpInfoVO().getCorpNm());
			} else if("USSE0003".equals(uvo.getSe())) {
				vo.setRelate("RELA0002");
				vo.setRelateDetail(sptSeNm + " ?????? (???????????????) : " + uvo.getCorpInfoVO().getCorpNm());
			} else {
				vo.setRelate("RELA0004");
				vo.setRelateDetail(sptSeNm + " ?????? (????????????) : " + uvo.getCorpInfoVO().getCorpNm());
			}
			vo.setRqstdt(sdf.format(new Date()));
			vo.setIssuOn(sdf.format(new Date()));
			if(eo.getMbtlnum().length() > 0 && eo.getMbtlnum().split("-").length == 3) {
				vo.setApplcntMoblphon1(eo.getMbtlnum().split("-")[0]);
				vo.setApplcntMoblphon2(eo.getMbtlnum().split("-")[1]);
				vo.setApplcntMoblphon3(eo.getMbtlnum().split("-")[2]);
				vo.setIssuTrgterMoblphon1(eo.getMbtlnum().split("-")[0]);
				vo.setIssuTrgterMoblphon2(eo.getMbtlnum().split("-")[1]);
				vo.setIssuTrgterMoblphon3(eo.getMbtlnum().split("-")[2]);
			}
			vo.setJumin1(eo.getIhidnum().split("-")[0]);
			vo.setJumin2(eo.getIhidnum().split("-")[1]);
			vo.setJumin3(eo.getIhidnum().split("-")[0]);
			vo.setJumin4(eo.getIhidnum().split("-")[1]);
			vo.setIssuTrgterZip(eo.getZip());
			vo.setIssuTrgterAdres(eo.getAdres());
			vo.setSanctnId(CrtfIssuSanctnId.getValue(commonService.getDdcAsctCdByCnstwkLocplcAddr(vo.getIssuTrgterAdres()))); */
		}
		
		//????????? ????????? ?????? ?????? ????????? ?????? ??????
		vo.setIssuTrgterIhidnum(vo.getJumin3()+"-"+vo.getJumin4());
		CrtfIssuVO data = crtfIssuService.searchCrtfHistory(vo);
		vo.setJssfcNo(data.getJssfcNo());
		vo.setGrad(data.getGrad());
		vo.setWorkDaycnt(data.getWorkDaycnt());
		vo.setEtcWorkDaycnt(data.getEtcWorkDaycnt());
		vo.setCnvrsnDaycnt(data.getCnvrsnDaycnt());
		vo.setEmplyminsrncDaycnt(data.getEmplyminsrncDaycnt());
		vo.setEdcTraingDaycnt(data.getEdcTraingDaycnt());
		vo.setEtcDaycnt(data.getEtcDaycnt());
		vo.setCrqfcDaycnt(data.getCrqfcDaycnt());
		
		//???????????? ??????
		if(StringUtils.isEmpty(vo.getRecptMth())) {
			map.put("msg", "??????????????? ???????????? ????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		//???????????? ??????
		/*if(StringUtils.isEmpty(vo.getSetleMth())) {
			map.put("msg", "??????????????? ???????????? ????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}*/
		
		if(StringUtils.isEmpty(vo.getGrad())) {
			vo.setGrad("GRAD0001");
		}
		
		//????????????
		FeeVO fee = feeService.selectFeeView(null);
		int firstCnt = crtfIssuService.selectCrtfReqFristCnt(vo);
		int issuCo = vo.getIssuCo();
		int ammount = 0;
		
		if(firstCnt == 0 && "USSE0001".equals(uvo.getSe()))
			issuCo = issuCo - 1;
		
		ammount = fee.getGrad() * issuCo;
		
		if(ammount != vo.getIssuAmount()) {
			map.put("msg", "??????????????? ????????????\n???????????? ????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		vo.setSptSe(sptSe);
		try {
			if(null == vo.getReqstNo()) {
				UserCnsltHistVO cnsltHist = new UserCnsltHistVO();
				cnsltHist.setIhidnum(vo.getJumin1() + "-" + vo.getJumin2());
				double day = data.getWorkDaycnt() + (data.getEtcWorkDaycnt() / 2);
				cnsltHist.setCn("????????????????????? ?????? - "+ sptSeNm +" ("+data.getJssfcNm()+", "+data.getGradNm()+")");// 21/06/11 ???????????? ??????
				cnsltHist.setRgstId(vo.getSanctnId());
				cnsltHist.setSe("3");
				cnsltHist.setSkillAt("1");
				
				if("USSE0001".equals(vo.getRelate()))
					cnsltHist.setTrgt("1");
				else if("USSE0002".equals(vo.getRelate()))
					cnsltHist.setTrgt("2");
				else
					cnsltHist.setTrgt("3");
				
				List<CmmnCdVO> ddcerList = userInfoService.selectUserCnsltDdcerSnList(uvo);
				
				if(ddcerList != null && ddcerList.size() > 0){
					cnsltHist.setDdcerSn(ddcerList.get(0).getCdId());
					userInfoService.executeUserCnsltHist(cnsltHist);
				}
				
				crtfIssuService.insertCrtfReqst(vo,multi);
				
				//?????? ??? ?????? ??????
				SanctnVO sanctnVO = new SanctnVO();
				
				sanctnVO.setDocNo(vo.getReqstNo());
				sanctnVO.setSanctnKnd("ARCS0002");
				sanctnVO.setRgstId(CrtfIssuSanctnId.getValue(commonService.getDdcAsctCdByCnstwkLocplcAddr(vo.getIssuTrgterAdres())));
				
				if(!"Y".equals(vo.getFeeRdcxptReqst()) && !"Y".equals(vo.getStateMatterAditAt())) {	// ??????????????? ??????
					sanctnVO.setSanctnSttus("APRV0002");
					sanctnVO.setSanctnKnd("ARCS0002");	//????????????(?????????????????????)
					sanctnVO.setSanctnResn("????????????????????? ???????????? ????????????");
					sanctnService.insertSanctnProgrs(sanctnVO);
					sanctnVO.setSanctnSttus("APRV0005");
					sanctnService.insertSanctnProgrs(sanctnVO);
				}
				map.put("status", "insert");
			}else {
				crtfIssuService.updateCrtfReqst(vo,multi);
				map.put("status", "update");
			}
		} catch (SQLException | IOException e) {
			if(LOG.isDebugEnabled())
				LOG.debug(e.getMessage());
			
			map.put("msg", "????????? ????????? ?????????????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ??????????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuPrintList.do")
	public String crtfIssuPrintList(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuSearchVO vo) {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
		}
		
		return "skill/mypage/crtfIssu/crtfIssuPrintList";
	}
	
	/**
	 * ??????????????? ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuPrintList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuPrintListPost(HttpServletRequest req, CrtfIssuSearchVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		List<CrtfIssuVO> list = null;
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			vo.setViewType(uvo.getSe());
			vo.setJumin1(uvo.getIhidnum().split("-")[0]);
			vo.setJumin2(uvo.getIhidnum().split("-")[1]);
			vo.setIssuTrgterNm(uvo.getNm());

			list = crtfIssuService.selectCrtfIssuList(vo);
		}else {
			vo.setViewType(uvo.getSe());
			vo.setRgstId(uvo.getUserId());
			list = crtfIssuService.selectCrtfIssuList(vo);
		}
		
		map.put("vo", vo);
		map.put("list", list);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ??????????????? ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuReqReceiptPop.do", method=RequestMethod.POST)
	public String crtfIssuReqReceiptPopPost(HttpServletRequest req, CrtfIssuVO vo) {
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");

		String serverType = System.getProperty("server");
		if("live".equals(serverType)) {
			req.setAttribute("subDomain", "rpt");
		}else {
			req.setAttribute("subDomain", "testrpt");
		}
		
		req.setAttribute("se", uvo.getSe());
		
		req.setAttribute("no", vo.getReqstNo());
		
		return "skill/mypage/crtfIssu/crtfIssuReqReceiptPop";
	}
	
	/**
	 * ????????????????????? ?????? ????????? ??? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws InterruptedException 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuReportPop.do", method=RequestMethod.POST)
	public String crtfIssuReqReport(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws InterruptedException, SQLException {
		String returnPage = "skill/mypage/crtfIssu/crtfIssuReportPop";
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		CrtfIssuSearchVO vo2 = new CrtfIssuSearchVO();
		vo2.setReqstNo(vo.getReqstNo());
		vo2.setSe("req");
		
		//?????? ?????? ???????????? ??????		
		if(crtfIssuService.selectCrtfReqList(vo2).size() > 0 && !"PRNT0003".equals(vo.getRecptMth())){
			String serverType = System.getProperty("server");
			if("live".equals(serverType)) {
				req.setAttribute("ozServer", "https://rpt.cwma.or.kr");
			}else if("admin".equals(serverType)) {
				req.setAttribute("ozServer", "https://mplus.cw.or.kr");
			}else {
				req.setAttribute("ozServer", "http://testrpt.cwma.or.kr");
			}
			
			CrtfIssuVO getVO = crtfIssuService.selectCrtfReqView(vo);
			
			//??????????????? ?????? ??????
			if(!"PRNT0003".equals(getVO.getRecptMth())) {
				
				req.setAttribute("no", vo.getReqstNo());
				
				//???????????? ????????????
				req.setAttribute("detailHistInclsAt", getVO.getDetailHistInclsAt());
				
				//?????? ??? ?????? ??????
				/*	????????????????????? ?????? ????????? ?????? ??????.21-05-12
				 * SanctnVO sanctnVO = new SanctnVO();
				
				sanctnVO.setDocNo(vo.getReqstNo());
				sanctnVO.setSanctnKnd("ARCS0002");
				sanctnVO.setRgstId(CrtfIssuSanctnId.getValue(commonService.getDdcAsctCdByCnstwkLocplcAddr(getVO.getIssuTrgterAdres())));
				sanctnService.insertSanctnProgrsMain(sanctnVO);
				
				sanctnVO.setSanctnSttus("APRV0002");
				sanctnVO.setSanctnResn("????????????????????? ???????????? ????????????");
				sanctnService.insertSanctnProgrs(sanctnVO);
				sanctnVO.setSanctnSttus("APRV0005");
				sanctnService.insertSanctnProgrs(sanctnVO);*/
				
				//????????? ???????????? ????????? ????????????
				vo.setRgstId(uvo.getUserId());
				crtfIssuService.updateCrtfIssu(vo);
			}
		}
		
		return returnPage;
	}

	/**
	 * ??????????????? ????????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="crtfIssuPrintFax.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuPrintFaxPost(HttpServletRequest req, CrtfIssuVO vo) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		CrtfIssuSearchVO vo2 = new CrtfIssuSearchVO();
		vo2.setReqstNo(vo.getReqstNo());
		vo2.setSe("req");
		
		String serverCode = "";
		//?????? ?????? ???????????? ??????		
		if(crtfIssuService.selectCrtfReqList(vo2).size() > 0 && "PRNT0003".equals(vo.getRecptMth())){
			
			CrtfIssuVO getVO = crtfIssuService.selectCrtfReqView(vo);
			
			//??????????????? ?????? ??????
			if("PRNT0003".equals(getVO.getRecptMth())) {
				String ddcAstcCd = commonService.getDdcAsctCdByCnstwkLocplcAddr(getVO.getIssuTrgterAdres());
				
				String faxSend = CrtfIssuSanctnId.getAgentNm(ddcAstcCd) + "::" + CrtfIssuSanctnId.getFaxNum(ddcAstcCd)+ "::" + CrtfIssuSanctnId.getUserNm(ddcAstcCd)+ "::" + CrtfIssuSanctnId.getValue(ddcAstcCd);
				String faxReceive1 = vo.getFxnum1() + "-" + vo.getFxnum2() + "-" + vo.getFxnum3();
				vo.setFxnum(faxReceive1);
				try {
					serverCode = crtfFaxSend(vo.getReqstNo(), faxSend, faxReceive1, "", "Crtf0", getVO.getDetailHistInclsAt());
				} catch (IOException e) {
					if(LOG.isInfoEnabled())
						LOG.info(e.getMessage());
					map.put("msg", "?????? ?????? ??? ????????? ?????????????????????.");
					return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
				}
				/*	?????????????????? ??????????????? ?????????.
				//?????? ??? ?????? ??????
				SanctnVO sanctnVO = new SanctnVO();
				
				sanctnVO.setDocNo(vo.getReqstNo());
				sanctnVO.setSanctnKnd("ARCS0002");
				sanctnVO.setRgstId(CrtfIssuSanctnId.getValue(commonService.getDdcAsctCdByCnstwkLocplcAddr(getVO.getIssuTrgterAdres())));
				sanctnService.insertSanctnProgrsMain(sanctnVO);
				
				sanctnVO.setSanctnSttus("APRV0002");
				sanctnVO.setSanctnResn("????????????????????? ???????????? ????????????");
				sanctnService.insertSanctnProgrs(sanctnVO);
				sanctnVO.setSanctnSttus("APRV0005");
				sanctnService.insertSanctnProgrs(sanctnVO);
				*/
				//????????? ???????????? ????????? ????????????
				if("200".equals(serverCode)) {
					vo.setRgstId(uvo.getUserId());
					crtfIssuService.updateCrtfIssu(vo);					
				}else {
					map.put("msg", "?????? ?????? ??? ?????? ????????? ?????????????????????.");
				}
			}
		}else {
			map.put("msg", "?????? ?????? ????????? ????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	public String crtfFaxSend(Integer getValue, String faxSend, String faxReceive1, String faxReceive2, String data, String detailYn) throws IOException {
		
		String serverType = System.getProperty("server");
		String urlStr = "https://rpt.cwma.or.kr/oz60/fax/fax_bind.jsp";
		
		if("live".equals(serverType)) {
			urlStr = "https://mplus.cw.or.kr/oz60/fax/fax_bind.jsp";
		}else if("admin".equals(serverType)) {
			urlStr = "https://mplus.cw.or.kr/oz60/fax/fax_bind.jsp";			
		}else {
			urlStr = "http://testrpt.cwma.or.kr/oz60/fax/fax_bind.jsp";
		}
		
		String strSep = ";;";
        String strParam = "";	
    	
        if("Y".equals(detailYn)) {
        	strParam += "connection.reportname=/grade/??????????????????????????????_????????????.ozr"+strSep;
        }else {
        	strParam += "connection.reportname=/grade/??????????????????????????????_???????????????.ozr"+strSep;
        }
//        strParam = "connection.reportname=/grade/??????????????????????????????.ozr"+strSep;
    	strParam += "connection.dataFromServer=false"+strSep;
    	strParam += "connection.formfromserver=true"+strSep;
    	strParam += "odi.odinames=??????????????????????????????_??????"+strSep;
    	strParam += "odi.??????????????????????????????_??????.pcount=1"+strSep;
    	strParam += "odi.??????????????????????????????_??????.args1=no=" + getValue + strSep;
    	
    	/* 2021.07.01 before source
    	URL url = new URL(urlStr);
		Map<String,Object> params = new LinkedHashMap<>(); // ???????????? ??????
		
    	params.put("strParam", strParam);
    	params.put("faxSend", faxSend);
    	params.put("getValue", getValue);
    	params.put("faxReceive1", faxReceive1);
    	params.put("faxReceive2", faxReceive2);
    	params.put("data", data);
    	log.info("params ::::::"+params);
        StringBuilder postData = new StringBuilder();
        for(Map.Entry<String,Object> param : params.entrySet()) {
            if(postData.length() != 0) postData.append('&');
            postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
            postData.append('=');
            postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
        }
        byte[] postDataBytes = postData.toString().getBytes("UTF-8");
        HttpsURLConnection conn = (HttpsURLConnection)url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        conn.setRequestProperty("Content-Length", String.valueOf(postDataBytes.length));
        conn.setDoOutput(true);
        log.info("connnection::::::"+conn);
        conn.getOutputStream().write(postDataBytes); // POST ??????
        log.debug("postDataBytes.length::::::::::::"+String.valueOf(postDataBytes.length));
        return String.valueOf(conn.getResponseCode());
        */
        
		HttpClient client = HttpClients.createDefault() ;
        HttpPost post = new HttpPost(urlStr);
        List<NameValuePair> urlParams = new ArrayList<NameValuePair>();
        urlParams.add(new BasicNameValuePair("strParam", strParam));
        urlParams.add(new BasicNameValuePair("faxSend", faxSend));     
        urlParams.add(new BasicNameValuePair("getValue", String.valueOf(getValue)));
        urlParams.add(new BasicNameValuePair("faxReceive1", faxReceive1));
        urlParams.add(new BasicNameValuePair("faxReceive2", faxReceive2));
        urlParams.add(new BasicNameValuePair("data", data));
        
        post.setEntity(new UrlEncodedFormEntity(urlParams, "UTF-8"));

        HttpResponse res = client.execute(post);
        HttpEntity entity = res.getEntity();
        return String.valueOf(res.getStatusLine().getStatusCode());
        
//        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
//        log.debug(params+"");
// 
//        String inputLine;
//        while((inputLine = in.readLine()) != null) { // response ??????
//            System.out.println(inputLine);
//        }
//        
//        conn = null;
//        in.close();
	}
	
	/**
	 * ????????? ???????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuConsList.do")
	public String crtfIssuConsList(HttpServletRequest req, @ModelAttribute("vo") CorpCrtfIssuVO vo) throws SQLException {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			return "redirect:/skill/mypage/index.do";
		}else {
			
		}
		
		
		return "skill/mypage/crtfIssu/crtfIssuConsList";
	}
	
	/**
	 * ????????? ???????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuConsList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuConsListPost(HttpServletRequest req, @ModelAttribute("vo") CorpCrtfIssuVO vo) throws SQLException {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}else {
			vo.setBizno(uvo.getBizno());
			vo.setUserId(uvo.getUserId());
			vo.setUserSe(uvo.getSe());
			map.put("consList", mypageService.selectCrtfIssuConsList(vo));
			map.put("vo", vo);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * ????????? ???????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuConsMenList.do")
	public String crtfIssuConsMenList(HttpServletRequest req, @ModelAttribute("vo") CorpCrtfIssuVO vo) throws SQLException {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			return "redirect:/skill/mypage/index.do";
		}else {
			if(!StringUtils.isEmpty(vo.getDdcJoinNo())) {
				uvo.setDdcJoinNo(vo.getDdcJoinNo());
			}else {
				return "redirect:/skill/mypage/index.do";
			}
			req.setAttribute("gradList", mypageService.selectGradList(uvo));
			req.setAttribute("consInfo", mypageService.selectCrtfIssuConsMenInfo(vo));
			req.setAttribute("staticInfo", mypageService.selectCrtfIssuConsMenStaticInfo(vo));
		}
		
		
		return "skill/mypage/crtfIssu/crtfIssuConsMenList";
	}
	
	/**
	 * ????????????????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuConsMenSearchList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuConsMenSearchList(HttpServletRequest req, @ModelAttribute("vo") CorpCrtfIssuVO vo) throws SQLException {
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		Map<String, Object> map = new HashMap<String, Object>();
		if("USSE0001".equals(uvo.getSe())) {
			//??????????????? ?????????.
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}else {
			vo.setRgstId(uvo.getUserId());
			map.put("consList", mypageService.selectCrtfIssuConsMenList(vo));
			map.put("vo", vo);
		}
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 *	?????????????????? ????????? ??????
	 * @param req
	 * @param vo
	 * @return
	 */
	@RequestMapping(value="docConfirm.do")
	public String docConfirm(HttpServletRequest req) throws SQLException {
		
		return "skill/mypage/crtfIssu/docConfirm";
	}

}
