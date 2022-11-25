package kr.or.cwma.skill.userSnsAuthor.vo;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class NaverOauth {
	@Value("#{oauth['naver.client_id']}")
	private String client_id;
	
	@Value("#{oauth['naver.client_secret']}")
	private String client_secret;
	
	@Value("#{oauth['naver.codeBaseUrl']}")
	private String codeBaseUrl;
	
	@Value("#{oauth['naver.accessTokenBaseUrl']}")
	private String accessTokenBaseUrl;
	
	@Value("#{oauth['naver.userInfoBaseUrl']}")
	private String userInfoBaseUrl;
	
	@Value("#{oauth['naver.response_type']}")
	private String response_type;
	
	@Value("#{oauth['naver.grant_type']}")
	private String grant_type;
	
	@Value("#{oauth['naver.callBackUri']}")
	private String callBackUri;
	
	private String redirect_uri;
	private String code;
	private String state;
	private String access_token;
	private String service_provider;
	
	private String resultcode;
	private String message;
	private Map<String, Object> response;
	private String id; // snsId
	
	public Map<String, String> getOauthCodeParmas() {
		Map<String, String> params = new HashMap<String, String>();
		params.put("response_type", getResponse_type());
		params.put("redirect_uri", getRedirect_uri());
		params.put("client_id", getClient_id());
		return params;
	}
	
	public Map<String, String> getOauthTokenParmas() {
		Map<String, String> params = new HashMap<String, String>();
		params.put("grant_type", getGrant_type());
		params.put("code", getCode());
		params.put("client_id", getClient_id());
		params.put("client_secret", getClient_secret());
		return params;
	}
	
	public Map<String, String> getOauthUserInfoParmas() {
		Map<String, String> params = new HashMap<String, String>();
		params.put("access_token", getAccess_token());
		return params;
	}
}
