package kr.or.cwma.skill.userSnsAuthor.vo;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class GoogleOauth {
	@Value("#{oauth['google.client_id']}")
	private String client_id;
	
	@Value("#{oauth['google.client_secret']}")
	private String client_secret;
	
	@Value("#{oauth['google.codeBaseUrl']}")
	private String codeBaseUrl;
	
	@Value("#{oauth['google.accessTokenBaseUrl']}")
	private String accessTokenBaseUrl;
	
	@Value("#{oauth['google.scope']}")
	private String scope;
	
	@Value("#{oauth['google.access_type']}")
	private String access_type;
	
	@Value("#{oauth['google.include_granted_scopes']}")
	private String include_granted_scopes;
	
	@Value("#{oauth['google.response_type']}")
	private String response_type;
	
	@Value("#{oauth['google.grant_type']}")
	private String grant_type;
	
	@Value("#{oauth['google.callBackUri']}")
	private String callBackUri;

	private String redirect_uri;
	private String id_token;
	private String code;
	private String token_type;
	private String access_token;
	private String id; // snsId
	
	public Map<String, String> getOauthCodeParmas() {
		Map<String, String> params = new HashMap<String, String>();
		params.put("scope", getScope());
		params.put("access_type", getAccess_type());
		params.put("include_granted_scopes", getInclude_granted_scopes());
		params.put("response_type", getResponse_type());
		params.put("redirect_uri", getRedirect_uri());
		params.put("client_id", getClient_id());
		return params;
	}
	
	public Map<String, String> getOauthTokenParmas() {
		Map<String, String> params = new HashMap<String, String>();
		params.put("code", getCode());
		params.put("client_id", getClient_id());
		params.put("client_secret", getClient_secret());
		params.put("redirect_uri", getRedirect_uri());
		params.put("grant_type", getGrant_type());
		return params;
	}
}
