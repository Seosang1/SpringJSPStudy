package kr.or.cwma.skill.common.controller;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import kr.or.cwma.admin.banner.vo.BannerVO;
import kr.or.cwma.admin.bbs.service.BbsService;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.CommonUtils;
import kr.or.cwma.skill.common.service.CommonService;
import kr.or.cwma.skill.common.vo.CommonVO;

/**
 * 사용자 공통 컨트롤러
 * @author sichoi
 */
@Controller("skill.commonController")
public class CommonController{
	@Autowired
	private BbsService bbsService;
	
	@Autowired
	private CommonService commonService;
	
	/**
	 * 메인 페이지
	 * @param req
	 * @param vo
	 * @return String
	 * @throws Exception 
	 */
	@RequestMapping(value="/index.do", method=RequestMethod.GET)
	public String index(HttpServletRequest req) throws Exception{
		
        String ip = req.getHeader("X-Forwarded-For");
 
        if (ip == null) {
            ip = req.getHeader("Proxy-Client-IP");
        }
        if (ip == null) {
            ip = req.getHeader("WL-Proxy-Client-IP"); // 웹로직
        }
        if (ip == null) {
            ip = req.getHeader("HTTP_CLIENT_IP");
        }
        if (ip == null) {
            ip = req.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ip == null) {
            ip = req.getRemoteAddr();
        }
        
        CommonVO commonVO = new CommonVO();
        commonVO.setVisitIp(ip);
        commonVO.setNowTime(CommonUtils.getTimeNow());
        commonVO.setPrevTime(CommonUtils.getTime1HoursPrev());
        
        int result = commonService.selectCountVisitInfo(commonVO);
        
        if(0 == result) {
        	commonService.insertVisitInfo(commonVO);	
        }
        
        
        CommonVO commonVO2 = new CommonVO();
        req.setAttribute("vsitCntTotal", commonService.selectCountVisit(commonVO2));
        commonVO2.setNowTime(CommonUtils.getTimeNow());
        commonVO2.setPrevTime(CommonUtils.getDateNow()+" 00:00:00");
		req.setAttribute("vsitCntToday", commonService.selectCountVisit(commonVO2));
		
		req.setAttribute("qnaCnt", commonService.selectCountQna());
        
		BbsVO vo = new BbsVO();
		BannerVO bvo = new BannerVO();
		
		//게시판 변수
		vo.setNumOfPage(3);
		vo.setSe("BSSE0001");
		vo.setDisplayAt("Y");
		//배너변수
		bvo.setSe("BASE0001");
		
		req.setAttribute("noticeList", bbsService.selectBbsList(vo));
		
		vo.setSe("BSSE0002");
		req.setAttribute("dataList", bbsService.selectBbsList(vo));
		
		//알림배너
		req.setAttribute("bannerList1", commonService.selectBannerList(bvo));
		
		//팝업
		req.setAttribute("popupList", commonService.selectPopupList());
		return "skill/index";
	}
}
