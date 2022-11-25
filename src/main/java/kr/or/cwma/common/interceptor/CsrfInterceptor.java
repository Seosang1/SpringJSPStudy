package kr.or.cwma.common.interceptor;

import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class CsrfInterceptor extends HandlerInterceptorAdapter {

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
		HttpSession ses = req.getSession();
		String token = (String)ses.getAttribute("SESSION_CSRF_TOKEN");
		String reqToken = req.getParameter("csrfToken");
		
//		if(req.getMethod().equals("POST")){
//			if(StringUtils.isEmpty(token) || !token.equals(reqToken))
//				return false;
//		}
		
		if(!"XMLHttpRequest".equals(req.getHeader("x-requested-with")))
			ses.setAttribute("SESSION_CSRF_TOKEN", UUID.randomUUID().toString());
		
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

	}


}