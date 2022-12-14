package kr.or.cwma.skill.mypage.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.common.enums.CrtfIssuSanctnId;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuSearchVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.fee.service.FeeService;
import kr.or.cwma.admin.holdCrtf.service.HoldCrtfService;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.issuAgre.service.IssuAgreService;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.skill.mypage.service.MypageService;
import kr.or.cwma.skill.user.service.UserService;

/**
 * ??????????????? ????????? ????????????
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/mypage")
public class MypageHoldCrtfController{

	static final Logger LOG = LoggerFactory.getLogger(MypageHoldCrtfController.class);
	
	@Autowired
	private JssfcInfoService jssfcInfoService;

	@Autowired
	private FeeService feeService;
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	SanctnService sanctnService;
	
	@Autowired
	MypageService mypageService;

	@Autowired
	private HoldCrtfService holdCrtfService;
	
	@Autowired
	IssuAgreService issuAgreService;
	
	@Autowired
	AttchFileInfoService attchFileInfoService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	UserService userService;
	
	/**
	 * ??????????????? ?????????
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="holdCrtfForm.do")
	public String holdCrtfForm(HttpServletRequest req, HoldCrtfVO vo) throws SQLException {
		if(vo.getSn() > 0)
			req.setAttribute("eo", holdCrtfService.selectHoldCrtfView(vo));
		
		req.setAttribute("seList", cmmnCdService.selectCmmnCdChildList("HCSE0000")); //????????????
		req.setAttribute("clList", cmmnCdService.selectCmmnCdChildList("HCCL0000")); //????????????
		req.setAttribute("gradList", cmmnCdService.selectCmmnCdChildList("GRAD0000")); //????????????
		req.setAttribute("officList", cmmnCdService.selectCmmnCdChildList("HCPO0000")); //????????????
		req.setAttribute("payList", cmmnCdService.selectCmmnCdChildList("PAYM0000")); //????????????
		req.setAttribute("printList", cmmnCdService.selectCmmnCdChildList("PRNT0000")); //??????????????????
		req.setAttribute("jssfcList", jssfcInfoService.selectJssfcInfoList(new JssfcInfoVO())); //????????????
		req.setAttribute("fee", feeService.selectFeeView(null)); //?????????
		
		return "skill/mypage/holdCrtfForm";
	}
	
	/**
	 * ??????????????????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="cntrctInfoList.do")
	public ResponseEntity<Map<String, Object>> corpInfoList(HttpServletRequest req, CntrctInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		if("USSE0003".equals(lvo.getSe()))
			vo.setRgstId(lvo.getUserId());
		
		map.put("list", holdCrtfService.selectCntrctList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ????????????????????? - ???????????????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="labrrInfoList.do")
	public ResponseEntity<Map<String, Object>> labrrInfoList(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		vo.setBizno(lvo.getBizno());
		
		if("USSE0003".equals(lvo.getSe()))
			vo.setRgstId(lvo.getUserId());
		
		map.put("list", holdCrtfService.selectLabrrList(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ????????????????????? - ????????????, ??????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="issuAgreInfo.do")
	public ResponseEntity<Map<String, Object>> issuAgreInfo(HttpServletRequest req, IssuAgreVO vo, JssfcInfoVO jvo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		jvo.setSearchIhidnumByWorkYm(vo.getIhidnum());
		map.put("eo", holdCrtfService.selectIssuAgreView(vo));
		map.put("jssfcList", jssfcInfoService.selectJssfcInfoList(jvo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ?????? 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */
	@RequestMapping(value="insertHoldCrtf.do")
	public ResponseEntity<Map<String, Object>> insert(HttpServletRequest req, MultipartHttpServletRequest multi, @Valid HoldCrtfVO vo, BindingResult result) throws SQLException, IOException{
		int cnt = 0;
		
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		UserInfoVO uvo = new UserInfoVO();
		CorpInfoVO cvo = new CorpInfoVO();
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();

		if(!result.hasErrors()){
			uvo.setBizno(vo.getBizno());
			vo.setRgstId(lvo.getUserId());
			cvo = userService.selectCorpInfo(uvo);
			vo.setChrgBrffc(commonService.getDdcAsctCdByCnstwkLocplcAddr(cvo.getAdrs()));
			cnt = holdCrtfService.insertHoldCrtf(vo, multi);
			map.put("vo", vo);
			
			if(cnt > 0)
				sttus = HttpStatus.OK;
			else{
				tmp.put("field", "");
				tmp.put("defaultMessage", "??????????????? ???????????? ????????????.");
				errors.add(tmp);
				map.put("errors", errors);
			}

		}else{
			map.put("errors", result.getFieldErrors());
		}

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * ??????????????? ???????????? ?????????
	 * @param req
	 * @return String
	 * @throws SQLException 
	 */
	@RequestMapping(value="holdCrtfList.do")
	public String holdCrtfList(HttpServletRequest req) throws SQLException {
		return "skill/mypage/holdCrtfList";
	}
	
	/**
	 * ??????????????? ????????????
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="holdCrtfList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> holdCrtfListPost(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		vo.setRgstId(uvo.getUserId());
		map.put("list", holdCrtfService.selectHoldCrtfList(vo));
		map.put("vo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ?????? 
	 * @param req 
	 * @param vo 
	 * @param result 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 * @throws IOException 
	 */ 
	@RequestMapping(value="updateHoldCrtf.do")
	public ResponseEntity<Map<String, Object>> update(HttpServletRequest req, MultipartHttpServletRequest multi, HoldCrtfVO vo, BindingResult result) throws SQLException, IOException{
		int cnt = 0;
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		
		HttpStatus sttus = HttpStatus.BAD_REQUEST;
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> tmp = new HashMap<String, String>();
		List<Map<String, String>> errors = new ArrayList<Map<String, String>>();

		if(!result.hasErrors()){
			vo.setRgstId(uvo.getUserId());
			cnt = holdCrtfService.updateHoldCrtf(vo, multi);
			map.put("vo", vo);
			
			if(cnt > 0)
				sttus = HttpStatus.OK;
			else{
				tmp.put("field", "");
				tmp.put("defaultMessage", "??????????????? ???????????? ????????????.");
				errors.add(tmp);
				map.put("errors", errors);
			}

		}else{
			map.put("errors", result.getFieldErrors());
		}

		return new ResponseEntity<>(map, sttus);
	}
	
	/**
	 * ?????????????????????
	 * @param req
	 * @param vo
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws SQLException
	 */
	@RequestMapping(value="corpInfo.do")
	public ResponseEntity<Map<String, Object>> corpInfo(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("corpEo", userService.selectCorpInfo(vo));
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ??????????????? ??????????????? 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="holdCrtfIssuList.do", method=RequestMethod.GET)
	public String holdCrtfIssuList(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		return "skill/mypage/holdCrtfIssuList";
	}

	/**
	 * ??????????????? ???????????? 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="holdCrtfIssuList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> holdCrtfIssuListPost(HttpServletRequest req, HoldCrtfVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		UserInfoVO uvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");
		vo.setRgstId(uvo.getUserId());
		map.put("list", holdCrtfService.selectUserIssuList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * ????????? ??????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 */
	@RequestMapping(value="holdCrtfRptPop.do")
	public String rptPop(HttpServletRequest req, @ModelAttribute("vo") HoldCrtfIssuVO vo) throws SQLException {
		String serverType = System.getProperty("server");
		if("live".equals(serverType)) {
			req.setAttribute("ozServer", "https://rpt.cwma.or.kr");
		}else if("admin".equals(serverType)) {
			req.setAttribute("ozServer", "https://mplus.cw.or.kr");
		}else {
			req.setAttribute("ozServer", "http://testrpt.cwma.or.kr");
		}
		
		if("??????????????????????????????".equals(req.getParameter("title"))){
			holdCrtfService.insertHoldCrtfIssu(vo);
		}
		
		return "admin/holdCrtf/rptPop";
	}
	
	/**
	 * ????????????????????? ????????????
	 * @param req
	 * @param careerDeclareVO
	 * @return
	 * @throws SQLException 
	 * @throws Exception 
	 */
	@RequestMapping(value="holdCrtfIssuPrintFax.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> holdCrtfIssuPrintFax(HttpServletRequest req, HoldCrtfVO vo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String serverCode = "";
		//?????? ?????? ???????????? ??????		
		if(holdCrtfService.selectHoldCrtfList(vo).size() > 0){
			
			HoldCrtfVO getVO = holdCrtfService.selectHoldCrtfView(vo);
			
			//??????????????? ?????? ??????
			if("PRNT0003".equals(getVO.getRecptSe())) {
				String ddcAstcCd = vo.getChrgBrffc();
				
				String faxSend = CrtfIssuSanctnId.getAgentNm(ddcAstcCd) + "::" + CrtfIssuSanctnId.getFaxNum(ddcAstcCd)+ "::" + CrtfIssuSanctnId.getUserNm(ddcAstcCd)+ "::" + CrtfIssuSanctnId.getValue(ddcAstcCd);
				String faxReceive1 = vo.getFxnum1() + "-" + vo.getFxnum2() + "-" + vo.getFxnum3();
				vo.setFxnum(faxReceive1);
				try {
					serverCode = holdCrtfFaxSend(vo.getSn(), faxSend, faxReceive1, "", "Crtf0");
				} catch (IOException e) {
					if(LOG.isInfoEnabled())
						LOG.info(e.getMessage());
					map.put("msg", "?????? ?????? ??? ????????? ?????????????????????.");
					return new ResponseEntity<>(map, HttpStatus.BAD_REQUEST);
				}

				//????????? ???????????? ????????? ????????????
				if("200".equals(serverCode)) {
					HoldCrtfIssuVO issuVO = new HoldCrtfIssuVO();
					issuVO.setSn(vo.getSn());
					holdCrtfService.insertHoldCrtfIssu(issuVO);					
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
	
	public String holdCrtfFaxSend(long getValue, String faxSend, String faxReceive1, String faxReceive2, String data) throws IOException {
		
		String serverType = System.getProperty("server");
		String urlStr = "https://mplus.cw.or.kr/oz60/fax/fax_bind.jsp";
		
		if("live".equals(serverType)) {
			urlStr = "https://mplus.cw.or.kr/oz60/fax/fax_bind.jsp";
		}else if("admin".equals(serverType)) {
			urlStr = "https://mplus.cw.or.kr/oz60/fax/fax_bind.jsp";			
		}else {
			urlStr = "http://testrpt.cwma.or.kr/oz60/fax/fax_bind.jsp";
		}
		
		String strSep = ";;";
        String strParam = "";	
    	
    	strParam += "connection.reportname=/grade/??????????????????????????????.ozr"+strSep;
    	strParam += "connection.dataFromServer=false"+strSep;
    	strParam += "connection.formfromserver=true"+strSep;
    	strParam += "odi.odinames=??????????????????????????????"+strSep;
    	strParam += "odi.??????????????????????????????.pcount=1"+strSep;
    	strParam += "odi.??????????????????????????????.args1=no=" + getValue + strSep;
    	
        
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
        
	}
}
