package kr.or.cwma.common.interceptor;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.MDC;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.conectIp.service.ConectIpService;
import kr.or.cwma.admin.conectIp.vo.ConectIpVO;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;


public class AdminInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	CommonService commonService;

	@Autowired
	ConectIpService conectIpService;
	
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
		String uri = req.getRequestURI();
		String ip = req.getHeader("X-FORWARDED-FOR");
		String contextPath = req.getContextPath();
		boolean isAllowIp = false;
		
		HttpSession ses = req.getSession();
		UserVO lvo = (UserVO)ses.getAttribute("adminLoginInfo");
		
		List<MenuInfoVO> list = (List<MenuInfoVO>)ses.getAttribute("adminGrantList");
		List<MenuInfoVO> menuList = (List<MenuInfoVO>)ses.getAttribute("adminMenuList");
		List<ConectIpVO> allowIpList = (List<ConectIpVO>)ses.getAttribute("allowIp");
		Iterator<ConectIpVO> allowIpIter = null;
		
        if (ip == null)
            ip = req.getRemoteAddr();
        
        MDC.put("ip", ip);
        
        if(allowIpList == null || allowIpList.size() ==0){
        	allowIpList = conectIpService.selectConectIpList(new ConectIpVO());
        	ses.setAttribute("allowIp", allowIpList);
        }
        
        allowIpIter = allowIpList.iterator();
        
        while(allowIpIter.hasNext()){
        	if(ip.indexOf(allowIpIter.next().getIp()) >= 0)
        		isAllowIp = true;
        }
        
        if(!isAllowIp){
    		res.sendError(403, "접근불가 IP");
    		return false;
        }
        
		if(lvo == null){
			if("XMLHttpRequest".equals(req.getHeader("x-requested-with")))
				res.sendError(440, "세션없음");
			else
				res.sendRedirect(contextPath.concat("/admin/login.do"));
			
			return false;
		}
		
		uri = uri.replaceFirst(contextPath, "");
		
		//세션에 메뉴등록
		
		if(menuList == null || menuList.size() == 0){
			menuList = new ArrayList<MenuInfoVO>();
			list = commonService.selectUserMenuList(lvo);
			
			for(MenuInfoVO tmp : list){
				if("Y".equals(tmp.getDisplayAt()))
					menuList.add(tmp);
			}
			
			ses.setAttribute("adminMenuList", menuList);
			ses.setAttribute("adminGrantList", list);
		}
		
		for(MenuInfoVO tmp : list){
			if(uri.equals(tmp.getUrl())){
				return true;
			}
		}
		
		System.out.println("uri>>>>>>>>" + uri);
		
		//res.sendError(401, "권한없음");
		
		
		return true;
		//return false;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

	}


}