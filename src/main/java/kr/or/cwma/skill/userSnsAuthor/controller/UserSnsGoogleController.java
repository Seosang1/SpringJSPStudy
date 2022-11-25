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
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.auth0.jwt.JWT;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.common.util.HttpOauthUtil;
import kr.or.cwma.skill.userSnsAuthor.vo.GoogleOauth;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;

/**
 * 구글 SNS 인증 컨트롤러 
 */
@Controller
@RequestMapping(value="skill/userSnsAuthor")
public class UserSnsGoogleController {
	static final Logger LOG = LoggerFactory.getLogger(UserSnsGoogleController.class);
	
	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private GoogleOauth google;
	
	private UserSnsAuthorVO vo;
	
	/**
	 * 인증 요청
	 * @param request
	 * @param response
	 * @return String
	 */
	@RequestMapping("/getGoogle.do")
	public String getGoogleOauthCode(HttpServletRequest request, HttpServletResponse response) {
		String serverName = request.getServerName();
		String contextPath = request.getContextPath();
		String redirectUrl = "redirect:";
		String redirectUri = "", port = "";
		String protocol = request.isSecure() ? "https://" : "http://";
		
		try {
			// callBack URL
			if("localhost".equals(serverName)){
				port = ":" + String.valueOf(request.getServerPort());
				redirectUri = protocol + serverName + port + contextPath + google.getCallBackUri();
			}else {
				redirectUri = protocol + serverName + contextPath + google.getCallBackUri();
			}
			google.setRedirect_uri(redirectUri);
			
			// redirect URL
			HttpOauthUtil<GoogleOauth> googleUtil = new HttpOauthUtil<>();
			googleUtil.setParams(google.getOauthCodeParmas());
			
			redirectUrl += google.getCodeBaseUrl() + "?" + googleUtil.getAllParam();
		} catch (Exception e) {
			if(LOG.isErrorEnabled())
				LOG.error("[" + e.getClass() + "] " + e.getMessage());
		}
		
		return redirectUrl;
	}
	
	/**
	 * 인증응답
	 * @param request
	 * @return ModelAndView
	 */
	@RequestMapping("/googleCallBack.do")
	public ModelAndView getGoogleCallBack(HttpServletRequest request) {
		ModelAndView mav = new ModelAndView();
		vo = new UserSnsAuthorVO();
		
		String snsId = "";
		String se = "";
		String code = StringUtils.trimToEmpty((String)request.getParameter("code"));
		
		if(!StringUtils.isEmpty(code)) {
			
			google.setCode(code);
			HttpOauthUtil<GoogleOauth> utile = new HttpOauthUtil<GoogleOauth>(google.getAccessTokenBaseUrl(), google);
			
			try {
				// SNS구분 코드 조회
				List<CmmnCdVO> cmmnList = cmmnCdService.selectCmmnCdChildList("SNSE0000");
				for (CmmnCdVO cmmnCdVO : cmmnList) {
					if("google".equals(cmmnCdVO.getCdNm())) {
						se = cmmnCdVO.getCdId();
					}
				}
				
				RestTemplate restTemplate = new RestTemplate();
				ResponseEntity<GoogleOauth> result = restTemplate.postForEntity(utile.getURI(), utile.getHttpEntity(), GoogleOauth.class);

				// 사용자 정보
				String token = result.getBody().getId_token();
				DecodedJWT decodeJwt = JWT.decode(token);
				Map<String, Claim> claims = decodeJwt.getClaims();
				
				snsId = claims.get("sub").asString();
				
				vo.setAuthYn("Y");
				vo.setSe(se);
				vo.setSnsId(snsId);
			
				
			} catch (HttpClientErrorException he) {
				if(LOG.isErrorEnabled()){
					LOG.error("[" + he.getClass() + "] " + he.getMessage());
					LOG.error("response :: " + he.getResponseBodyAsString());
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
}
