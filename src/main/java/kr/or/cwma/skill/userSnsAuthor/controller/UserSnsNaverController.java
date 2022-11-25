package kr.or.cwma.skill.userSnsAuthor.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.common.util.HttpOauthUtil;
import kr.or.cwma.skill.userSnsAuthor.vo.NaverOauth;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;

/**
 * 네이버 SNS 인증 컨틀롤러 
 */
@Controller
@RequestMapping(value="skill/userSnsAuthor")
public class UserSnsNaverController {
	static final Logger LOG = LoggerFactory.getLogger(UserSnsNaverController.class);
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private NaverOauth naver;
	
	private UserSnsAuthorVO vo;
	
	/**
	 * 인증 요청
	 * @param request
	 * @param response
	 * @return String
	 */
	@RequestMapping("/getNaver.do")
	public String getNaverOauthCode(HttpServletRequest request, HttpServletResponse response) {
		
		String serverName = request.getServerName();
		String contextPath = request.getContextPath();
		String redirectUrl = "redirect:";
		String redirectUri = "", port = "";
		String protocol = request.isSecure() ? "https://" : "http://";
		
		try {
			// callBack URL
			if("localhost".equals(serverName)){
				port = ":" + String.valueOf(request.getServerPort());
				redirectUri = protocol + serverName + port + contextPath + naver.getCallBackUri();
			}else {
				redirectUri = protocol + serverName + contextPath + naver.getCallBackUri();
			}
			naver.setRedirect_uri(redirectUri);
			
			// redirect URL
			HttpOauthUtil<NaverOauth> naverUtil = new HttpOauthUtil<>();
			naverUtil.setParams(naver.getOauthCodeParmas());
			
			redirectUrl += naver.getCodeBaseUrl() + "?" + naverUtil.getAllParam();
			
		} catch (Exception e) {
			if(LOG.isErrorEnabled())
				LOG.error("[" + e.getClass() + "] " + e.getMessage());
		}
		
		return redirectUrl;
	}
	
	/**
	 * 인증 응답
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping("/naverCallBack.do")
	public ModelAndView getNaverCallBack(HttpServletRequest request) {
		
		ModelAndView mav = new ModelAndView();
		vo = new UserSnsAuthorVO();
		
		String snsId = "";
		String se = "";
		String code = StringUtils.trimToEmpty((String)request.getParameter("code"));
		
		if(!StringUtils.isEmpty(code)) {
			try {
				// SNS구분 코드 조회
				List<CmmnCdVO> cmmnList = cmmnCdService.selectCmmnCdChildList("SNSE0000");
				for (CmmnCdVO cmmnCdVO : cmmnList) {
					if("naver".equals(cmmnCdVO.getCdNm())) {
						se = cmmnCdVO.getCdId();
					}
				}
				
				String accToken = naverAccToken(code);
				if(accToken != null && !"".equals(accToken)) {
					// 사용자 정보
					Map<String, Object> naverInfo = getNaverUserInfo(accToken);
					snsId = (String)naverInfo.get("id");

					vo.setAuthYn("Y");
					vo.setSe(se);
					vo.setSnsId(snsId);
					
				}else {
					vo.setAuthYn("N");
				}
				
			} catch (Exception e) {
				e.printStackTrace();
				
				if(LOG.isErrorEnabled())
					LOG.error("[" + e.getClass() + "] " + e.getMessage());
				
				vo.setAuthYn("N");
			}
			
		}else {
			vo.setAuthYn("N");
		}
		
		mav.addObject("vo", vo);
		mav.setViewName("skill/user/oauthResult");
		return mav;
	}

	
	/**
	 * token 정보
	 * @param code
	 * @return String
	 * @throws Exception
	 */
	public String naverAccToken(String code) throws Exception {
		
		vo = new UserSnsAuthorVO();
		String accToken = "";
		
		try {
			HttpOauthUtil<NaverOauth> naverUtil = new HttpOauthUtil<>();
			RestTemplate restTemplate = new RestTemplate();
			
			naver.setCode(code);
			naver.setGrant_type("authorization_code");
			
			naverUtil.setParams(naver.getOauthTokenParmas());
			
			String url = naver.getAccessTokenBaseUrl() +"?"+ naverUtil.getAllParam();
			ResponseEntity<NaverOauth> entity = restTemplate.getForEntity(url, NaverOauth.class);
			
			accToken = entity.getBody().getAccess_token();
			naver.setAccess_token(accToken);
			
		} catch (Exception e) {
			e.printStackTrace();
			
			if(LOG.isErrorEnabled())
				LOG.error("[" + e.getClass() + "] " + e.getMessage());
		}
		
		return accToken;
	}
	
	/**
	 * 사용자 정보
	 * @param accToken
	 * @return Map<String, Object>
	 * @throws Exception
	 */
	public Map<String, Object> getNaverUserInfo(String accToken) throws Exception {
		
		HttpOauthUtil<NaverOauth> util = new HttpOauthUtil<>();
		RestTemplate restTemplate = new RestTemplate();
		
		naver.setAccess_token(accToken);
		util.setParams(naver.getOauthUserInfoParmas());
		
		String url = naver.getUserInfoBaseUrl() +"?"+ util.getAllParam();
		ResponseEntity<NaverOauth> entity = restTemplate.getForEntity(url, NaverOauth.class);
		
		return entity.getBody().getResponse();
	}
	
}
