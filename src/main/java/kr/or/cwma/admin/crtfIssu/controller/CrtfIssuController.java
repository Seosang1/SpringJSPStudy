package kr.or.cwma.admin.crtfIssu.controller;

import java.awt.Dimension;
import java.awt.DisplayMode;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
import java.awt.Toolkit;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuSearchVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.crtfIssu.vo.FeeCrtfProgrsVO;
import kr.or.cwma.admin.fee.service.FeeService;
import kr.or.cwma.admin.indvdlinfoAccesLog.service.IndvdlinfoAccesLogService;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;
import kr.or.cwma.common.service.ShareService;
import kr.or.cwma.common.util.ExcelUtil;

/**
 * @author PCNDEV
 * ????????????????????? 
 */
@Controller
@RequestMapping(value="admin/crtfIssu")
public class CrtfIssuController {
	static final Logger LOG = LoggerFactory.getLogger(CrtfIssuController.class);
	
	@Autowired
	CmmnCdService cmmnCdService;
	
	@Autowired
	CrtfIssuService crtfIssuService;
	
	@Autowired
	private FeeService feeService;

	@Autowired
	private JssfcInfoService jssfcInfoService;

	@Autowired
	private UserInfoService userInfoService;
	
	@Autowired
	SanctnService sanctnService;
	
	@Autowired
	private CareerDeclareService careerDeclareService;
	
	@Autowired
	ShareService shareService;
	
	@Autowired
	IndvdlinfoAccesLogService indvdlinfoAccesLogService;
	
	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuForm.do")
	public String crtfIssuForm(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuForm";

		//??????????????? ?????? ????????????
		CmmnCdVO cmmVo = new CmmnCdVO();
		cmmVo.setParntsCdId("RELA0000");
		cmmVo.setNumOfPage(999);
		req.setAttribute("relateList", cmmnCdService.selectCmmnCdList(cmmVo));
		// ????????????????????? ?????????????????? ??????
		cmmVo.setParntsCdId("RDCX0000");
		req.setAttribute("codeRDCXList", cmmnCdService.selectCmmnCdList(cmmVo));
		return returnPage;
	}
	
	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws InterruptedException 
	 */
	@RequestMapping(value="crtfIssuFormIns.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuFormPost(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws InterruptedException {
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		UserInfoVO uivo = new UserInfoVO();
		
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
		
		vo.setRgstId(uvo.getUserId());
		vo.setChrgBrffc(uvo.getDdcAstcCd());
		vo.setRecptMth("PRNT0002");
		vo.setSetleMth("PAYM0004");
		
		
		try {
			if(null == vo.getReqstNo()) {
				UserCnsltHistVO cnsltHist = new UserCnsltHistVO();
				cnsltHist.setIhidnum(vo.getJumin1() + "-" + vo.getJumin2());
				cnsltHist.setCn("????????????????????? ?????? - ?????? ("+data.getJssfcNm()+", "+data.getGradNm()+")");// 21/06/11 ???????????? ??????
				cnsltHist.setSe("2");
				cnsltHist.setSkillAt("1");
				uivo.setIhidnum(cnsltHist.getIhidnum());
				
				if("RELA0001".equals(vo.getRelate()))
					cnsltHist.setTrgt("1");
				else if("RELA0003".equals(vo.getRelate()))
					cnsltHist.setTrgt("2");
				else
					cnsltHist.setTrgt("3");
				
				cnsltHist.setRgstId(uvo.getUserId());
				
				List<CmmnCdVO> ddcerList = userInfoService.selectUserCnsltDdcerSnList(uivo);
				
				if(ddcerList != null && ddcerList.size() > 0){
					cnsltHist.setDdcerSn(ddcerList.get(0).getCdId());
					userInfoService.executeUserCnsltHist(cnsltHist);
				}
				
				crtfIssuService.insertCrtfReqst(vo,null);
				
				//?????? ??????
				SanctnVO sanctnVO = new SanctnVO();
				sanctnVO.setDocNo(vo.getReqstNo());
				
				// ??????????????? ????????? ????????? ????????????(?????? ???????????????.)
				if(!"Y".equals(vo.getFeeRdcxptReqst()) && !"Y".equals(vo.getStateMatterAditAt())){
					sanctnVO.setSanctnKnd("ARCS0002");	//???????????????
					sanctnVO.setSanctnSttus("APRV0002");
					sanctnVO.setSanctnResn("????????????????????? ???????????? ????????????");
					sanctnService.insertSanctnProgrs(sanctnVO);
					sanctnVO.setSanctnSttus("APRV0005");
					sanctnService.insertSanctnProgrs(sanctnVO);
				}

			}else
				crtfIssuService.updateCrtfReqst(vo,null);
			
			map.put("reqstNo", vo.getReqstNo());
			
		} catch (SQLException | IOException e) {
			if(LOG.isDebugEnabled())
				LOG.debug(e.getMessage());
			
			map.put("msg", "????????? ????????? ?????????????????????.");
			return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
		}
		
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
	public ResponseEntity<Map<String, Object>> crtfIssuSearch(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = new UserInfoVO();
		UserMainJssfcVO umvo = new UserMainJssfcVO(); 
		CareerDeclareVO vo2 = new CareerDeclareVO();
		JssfcInfoVO jssfcVO = new JssfcInfoVO();
		
		map.put("vo", vo);
		vo.setIssuTrgterIhidnum(vo.getJumin3()+"-"+vo.getJumin4());
		uvo.setIhidnum(vo.getIssuTrgterIhidnum());
		umvo = userInfoService.selectPersonalUserInfoView(uvo);
		
		if(umvo != null){
			shareService.insertJdtyInfoList(uvo.getIhidnum());
			shareService.insertJobAbilityTngInfo(uvo.getIhidnum());
			
			if(vo.getJssfcNo() == null || vo.getJssfcNo() == 0)
				vo.setJssfcNo(umvo.getJssfcNo());
			
			vo2.setNm(umvo.getNm());
			vo2.setJumin1(umvo.getIhidnum().split("-")[0]);
			vo2.setJumin2(umvo.getIhidnum().split("-")[1]);
			vo2.setIhidnum(umvo.getIhidnum());
			vo2.setCntcType("req");
			List<CareerDeclareVO> licenseList = careerDeclareService.selectIhidnumLicense(vo2);
			List<CareerDeclareVO> eduList = careerDeclareService.selectIhidnumEdu(vo2);
			List<CareerDeclareVO> rewardList = careerDeclareService.selectIhidnumReward(vo2);
			map.put("careerNoReqCnt", (licenseList.size() + eduList.size() + rewardList.size()));
		}
		
		CrtfIssuVO data = crtfIssuService.searchCrtfHistory(vo);
		map.put("data", data);
		map.put("fee", feeService.selectFeeView(null));
		map.put("crtfFirstCnt", crtfIssuService.selectCrtfReqFristCnt(vo));
		map.put("user", umvo);
		
		if((data.getWorkDaycnt()+data.getEtcWorkDaycnt()) != 0)
			jssfcVO.setSearchIhidnum(vo.getIssuTrgterIhidnum());
		
		map.put("jssfcList", jssfcInfoService.selectJssfcInfoList(jssfcVO)); //????????????
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * ?????????????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuReqList.do")
	public String crtfIssuReqList(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuSearchVO vo) throws SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuReqList";

		//??????????????? ?????? ????????????
		CmmnCdVO cmmVo = new CmmnCdVO();
		cmmVo.setParntsCdId("PAYM0000");
		cmmVo.setNumOfPage(999);
		req.setAttribute("payList", cmmnCdService.selectCmmnCdList(cmmVo)); //????????????
		req.setAttribute("ddcAsctList", sanctnService.selectCwmaDdcAsctInfoList()); //??????????????????
		
		return returnPage;
	}
	
	/**
	 * ?????????????????? ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuReqList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuReqListPost(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuSearchVO vo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		List<CrtfIssuVO> list = null;
		
		if(!"01100".equals(uvo.getDdcAstcCd()))
			vo.setChrgBrffc(uvo.getDdcAstcCd());
		
		//??????????????????
		vo.setSe("req");
		map.put("vo", vo);
		list = crtfIssuService.selectCrtfReqList(vo); 
		indvdlinfoAccesLogService.insertIndvdlinfoAccesLog(list, req);
		
		/*??????????????? ?????? ??????*/
		/*if(null != vo.getFeeRdcxptStat() && !"".equals(vo.getFeeRdcxptStat())) {
			List<CrtfIssuVO> feeList = crtfIssuService.selectCrtfReqFeeRdcxptList(vo);
			vo.setTotalCnt(vo.getTotalCnt()+crtfIssuService.selectCrtfReqFeeRdcxptListCnt(vo));
			list.addAll(feeList);
		}*/
		map.put("list", list);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuReqView.do")
	public String crtfIssuReqView(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuReqView";
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		req.setAttribute("uvo", uvo); //????????? ????????? ??????
		
		req.setAttribute("relateList", cmmnCdService.selectCmmnCdChildList("RELA0000"));
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //????????????
		req.setAttribute("eo", crtfIssuService.selectCrtfReqView(vo)); //????????????
		
		req.setAttribute("feeList", crtfIssuService.selectSanctnList(vo));	//??????????????? ?????? ???????????? ?????????
		return returnPage;
	}
	
	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws InterruptedException 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuReqForm.do", method=RequestMethod.POST)
	public String crtfIssuReqFormPost(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws InterruptedException, SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuForm";
		String[] ihidNum = null, tel = null;
		
		JssfcInfoVO jssfcVO = new JssfcInfoVO();
		CrtfIssuVO eo = crtfIssuService.selectCrtfReqView(vo);
		
		if(!StringUtils.isEmpty(eo.getApplcntIhidnum())) {
			ihidNum = eo.getApplcntIhidnum().split("-");
			eo.setJumin1(ihidNum[0]);
			eo.setJumin2(ihidNum[1]);
		}
		
		if(!StringUtils.isEmpty(eo.getIssuTrgterIhidnum())) {
			ihidNum = eo.getIssuTrgterIhidnum().split("-");
			eo.setJumin3(ihidNum[0]);
			eo.setJumin4(ihidNum[1]);
		}
		
		if(!StringUtils.isEmpty(eo.getApplcntMoblphon())) {
			tel = eo.getApplcntMoblphon().split("-");
			
			if(tel.length > 0) {
				if(!StringUtils.isEmpty(tel[0]))
					eo.setApplcntMoblphon1(tel[0]);
				if(!StringUtils.isEmpty(tel[1]))
					eo.setApplcntMoblphon2(tel[1]);
				if(!StringUtils.isEmpty(tel[2]))
					eo.setApplcntMoblphon3(tel[2]);
			}
		}
		
		if(!StringUtils.isEmpty(eo.getIssuTrgterMoblphon())) {
			tel = eo.getIssuTrgterMoblphon().split("-");
			
			if(tel.length > 0) {
				if(!StringUtils.isEmpty(tel[0]))
					eo.setIssuTrgterMoblphon1(tel[0]);
				if(!StringUtils.isEmpty(tel[1]))
					eo.setIssuTrgterMoblphon2(tel[1]);
				if(!StringUtils.isEmpty(tel[2]))
					eo.setIssuTrgterMoblphon3(tel[2]);
			}
		}
		
		jssfcVO.setSearchIhidnum(eo.getIssuTrgterIhidnum());
		
		req.setAttribute("eo", eo); //????????????
		req.setAttribute("relateList", cmmnCdService.selectCmmnCdChildList("RELA0000"));
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(jssfcVO)); //????????????
		
		return returnPage;
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
		String returnPage = "admin/crtfIssu/crtfIssuReportPop";
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		String serverType = System.getProperty("server");
		if("admin".equals(serverType)) {
			req.setAttribute("ozServer", "https://mplus.cw.or.kr");	//??????????????? contextPath oz60
		}else {
			req.setAttribute("ozServer", "http://192.168.209.161");
		}
		
		req.setAttribute("no", vo.getReqstNo());
		/* ???????????? ???????????? */
		req.setAttribute("detailHistInclsAt", vo.getDetailHistInclsAt());
		/* ?????? ??????????????? ???????????? ?????? */
		req.setAttribute("brffcNm", uvo.getBrffcNm());
		
		//????????? ???????????? ????????? ????????????
		vo.setRgstId(uvo.getUserId());
		vo.setRecptMth("PRNT0002");
		vo.setSetleMth("PAYM0004");
		crtfIssuService.updateCrtfIssu(vo);
		
		return returnPage;
	}
	
	/**
	 * ????????????????????? ?????? ???
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws InterruptedException 
	 */
	@RequestMapping(value="crtfIssuReqDelete.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuReqDeletePost(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws InterruptedException {
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		vo.setChgId(uvo.getUserId());
		
		crtfIssuService.deleteCrtfReqst(vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ?????????????????? ?????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuList.do")
	public String crtfIssuList(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuSearchVO vo) throws SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuList";

		req.setAttribute("gradList", cmmnCdService.selectCmmnCdChildList("GRAD0000")); //????????????
		req.setAttribute("sptList", cmmnCdService.selectCmmnCdChildList("SPTS0000")); //??????????????????
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //????????????
		req.setAttribute("ddcAsctList", sanctnService.selectCwmaDdcAsctInfoList());
		
		return returnPage;
	}

	/**
	 * ?????????????????? ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfIssuList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuListPost(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuSearchVO vo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		List<CrtfIssuVO> list = crtfIssuService.selectCrtfIssuList(vo);
		
		if(!"01100".equals(uvo.getDdcAstcCd()))
			vo.setChrgBrffc(uvo.getDdcAstcCd());
		
		map.put("list", list);
		map.put("vo", vo);
		indvdlinfoAccesLogService.insertIndvdlinfoAccesLog(list, req);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * ?????????????????? ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="crtfIssuReqReceiptPop.do")
	public String crtfIssuReqReceiptPop(HttpServletRequest req, @ModelAttribute("vo") CrtfIssuVO vo) throws SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuReqReceiptPop";
		
		String serverType = System.getProperty("server");
		if("admin".equals(serverType)) {
			req.setAttribute("subDomain", "rpt");
		}else {
			req.setAttribute("subDomain", "testrpt");
		}
		
		req.setAttribute("no", vo.getReqstNo());
		
		return returnPage;
	}
	
	/**
	 * ???????????? 
	 * @param req 
	 * @param res 
	 * @param vo 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="excelDown.do", method=RequestMethod.POST)
	public void excelDown(HttpServletRequest req, HttpServletResponse res, CrtfIssuSearchVO vo) throws SQLException, IOException{
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		if(!"01100".equals(uvo.getDdcAstcCd())) {
			vo.setChrgBrffc(uvo.getDdcAstcCd());
		}
		
		if("CASE0001".equals(vo.getPrintSe())) {
			ExcelUtil.createXls(crtfIssuService.selectCrtfReqListXls(vo), "??????????????????", res);
		}else if("CASE0002".equals(vo.getPrintSe())) {
			ExcelUtil.createXls(crtfIssuService.selectCrtfIssuListXls(vo), "??????????????????", res);
		}
	}
	
	/**
	 * ????????? ?????? ?????? ???????????? ?????? ??????
	 * @param req
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value="crtfIssuPreViewSave.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfIssuPreViewSave(HttpServletRequest req,@ModelAttribute("vo") CrtfIssuVO vo) throws SQLException {
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		vo.setApplcntIhidnum(vo.getJumin1()+"-"+vo.getJumin2());	//????????? ????????????
		vo.setApplcntMoblphon(vo.getApplcntMoblphon1()+"-"+vo.getApplcntMoblphon2()+"-"+vo.getApplcntMoblphon3());	//????????? ????????????
		vo.setIssuTrgterIhidnum(vo.getJumin3()+"-"+vo.getJumin4());	//????????? ????????????
		vo.setIssuTrgterMoblphon(vo.getIssuTrgterMoblphon1()+"-"+vo.getIssuTrgterMoblphon2()+"-"+vo.getIssuTrgterMoblphon3());
		
		crtfIssuService.insertCrtfIssuPreView(vo);
		
		map.put("reqstNo", vo.getReqstNo());
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ????????? ?????? ?????? ????????? ??????
	 * @param req
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	@RequestMapping(value="crtfIssuPreViewReportPop.do", method=RequestMethod.POST)
	public String crtfIssuPreViewReportPop(HttpServletRequest req,@ModelAttribute("vo") CrtfIssuVO vo) throws SQLException {
		String returnPage = "admin/crtfIssu/crtfIssuPreViewReportPop";
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		String serverType = System.getProperty("server");
		if("admin".equals(serverType)) {
			req.setAttribute("ozServer", "https://mplus.cw.or.kr");	//??????????????? contextPath oz60
		}else {
			req.setAttribute("ozServer", "http://192.168.209.161");
		}

		/*
		GraphicsEnvironment ge      = GraphicsEnvironment.getLocalGraphicsEnvironment();
		GraphicsDevice[]    gs      = ge.getScreenDevices();
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
		Dimension           mySize  = new Dimension( myWidth, myHeight);
		Dimension           maxSize = new Dimension(minRequiredWidth, minRequiredHeight);
		
		for (int i = 0; i < gs.length; i++)
		{
		    DisplayMode dm = gs[i].getDisplayMode();
		    
		   System.out.println(dm.getWidth());
		    if (dm.getWidth() > maxSize.getWidth() && dm.getHeight() > maxSize.getHeight())
		    {   // Update the max size found on this monitor
		        maxSize.setSize(dm.getWidth(), dm.getHeight());
		    }

		}
		*/
		
		req.setAttribute("reqstNo", vo.getReqstNo());

		/* ?????? ??????????????? ???????????? ?????? */
		req.setAttribute("brffcNm", uvo.getBrffcNm());
		
		return returnPage;
	}
	
	@RequestMapping(value="feeUpdateStatus.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> feeUpdateStatus(HttpServletRequest req,@ModelAttribute("vo") FeeCrtfProgrsVO vo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
		vo.setRgstId(uvo.getUserId());
		vo.setRgstBrffc(uvo.getDdcAstcCd());
		//??????????????? ?????? ???????????? ??????
		crtfIssuService.insertFeeProgrs(vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
}
