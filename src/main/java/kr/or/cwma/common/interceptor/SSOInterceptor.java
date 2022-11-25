
package kr.or.cwma.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.ksign.access.wrapper.api.SSORspData;
import com.ksign.access.wrapper.api.SSOService;
import com.ksign.access.wrapper.sso.sso10.SSO10Conf;

import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.common.vo.UserVO;

public class SSOInterceptor extends HandlerInterceptorAdapter {

	@Autowired
	CommonService commonService;

	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse res, Object handler) throws Exception {
		HttpSession ses = req.getSession();
		UserVO lvo = (UserVO)ses.getAttribute("adminLoginInfo");
		
		if(lvo == null){
			SSOService ssoService = SSOService.getInstance();
			SSORspData rspData = ssoService.ssoGetLoginData(req);
			
			lvo = new UserVO();
			lvo.setUserId(rspData.getAttribute(SSO10Conf.UIDKey));
			
			if(lvo != null && StringUtils.isNotEmpty(lvo.getUserId()))
				commonService.login(req, lvo);
		}
		
		return true;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

	}

	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {

	}


}