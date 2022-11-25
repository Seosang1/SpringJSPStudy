package kr.or.cwma.skill.userSnsAuthor.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.common.util.HttpOauthUtil;
import kr.or.cwma.skill.userSnsAuthor.vo.KakaoOauth;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;

/**
 * 카카오 SNS 인증 컨트롤러
 */
@Controller
@RequestMapping(value="skill/userSnsAuthor")
public class UserSnsKakaoController {
	static final Logger LOG = LoggerFactory.getLogger(UserSnsKakaoController.class);

	@Autowired
	private CmmnCdService cmmnCdService;
	
	@Autowired
	private KakaoOauth kakao;
	
	private UserSnsAuthorVO vo;
	
	/**
	 * 인증 요청
	 * @param request
	 * @param response
	 * @return String
	 */
	@RequestMapping("/getKakao.do")
	public String getKakao(HttpServletRequest request, HttpServletResponse response) {
		
		String serverName = request.getServerName();
		String contextPath = request.getContextPath();
		String redirectUrl = "redirect:";
		String redirectUri = "", port = "";
		String protocol = request.isSecure() ? "https://" : "http://";
		
		try {
			// callBack URL
			if("localhost".equals(serverName)){
				port = ":"+String.valueOf(request.getServerPort());
				redirectUri = protocol + serverName + port + contextPath + kakao.getCallBackUri();
			}else {
				redirectUri = protocol + serverName + contextPath + kakao.getCallBackUri();
			}
			kakao.setRedirect_uri(redirectUri);
			
			// redirect URL
			HttpOauthUtil<KakaoOauth> kakaoUtil = new HttpOauthUtil<>();
			kakaoUtil.setParams(kakao.getOauthCodeParmas());
			
			redirectUrl += kakao.getCodeBaseUrl() + "?" + kakaoUtil.getAllParam();
			
		} catch (Exception e) {
			e.printStackTrace();
			
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
	@RequestMapping("/kakaoCallBack.do")
	public ModelAndView getKakaoCallBack(HttpServletRequest request) {
		
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
					if("kakao".equals(cmmnCdVO.getCdNm())) {
						se = cmmnCdVO.getCdId();
					}
				}
				
				String accToken = getAccToken(code);
				if(accToken != null && !"".equals(accToken)) {
					
					// 사용자 정보
					ResponseEntity<KakaoOauth> entity = getKakaoEntity(accToken);
					snsId = entity.getBody().getId();
					
					vo.setAuthYn("Y");
					vo.setSe(se);
					vo.setSnsId(snsId);
					
				}else {
					vo.setAuthYn("N");
				}
				
			}catch (Exception e) {
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
	public String getAccToken(String code) throws Exception {
		
		vo = new UserSnsAuthorVO();
		String accToken = "";
		
		try {
			HttpOauthUtil<KakaoOauth> kakaoUtil = new HttpOauthUtil<>();
			RestTemplate restTemplate = new RestTemplate();
			
			kakao.setCode(code);
			kakaoUtil.setParams(kakao.getOauthTokenParmas());
			
			String url = kakao.getAccessTokenBaseUrl() + "?" + kakaoUtil.getAllParam();
			ResponseEntity<KakaoOauth> entity = restTemplate.getForEntity(url, KakaoOauth.class);
			
			accToken = entity.getBody().getAccess_token();
			kakao.setAccess_token(accToken);
			
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
	 * @return ResponseEntity<KakaoOauth>
	 */
	public ResponseEntity<KakaoOauth> getKakaoEntity(String accToken) {
		HttpHeaders headers = new HttpHeaders();
		RestTemplate restTemplate = new RestTemplate();
		
		headers.set("Authorization", "Bearer " + accToken); 
		headers.set("Content-Type", "application/json;charset=utf-8");
		HttpEntity<KakaoOauth> httpEntity = new HttpEntity<KakaoOauth>(kakao, headers);
		
		return restTemplate.postForEntity(kakao.getUserInfoBaseUrl(), httpEntity, KakaoOauth.class);
	}
	
}
