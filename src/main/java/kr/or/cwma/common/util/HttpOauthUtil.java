package kr.or.cwma.common.util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;

public class HttpOauthUtil<T> {
	String urlStr;
	Map<String, String> params;
	T entity;
	
	public HttpOauthUtil() {}

	public HttpOauthUtil(String urlStr) {
		this.urlStr = urlStr;
	}

	public HttpOauthUtil(String urlStr, T entity) {
		this(urlStr);
		this.entity = entity;
	}
	
	public URI getURI() throws URISyntaxException {
		URI uri = new URI(urlStr);
		return uri;
	}
	
	public String getUri() {
		return urlStr;
	}
	
	/**
	 * 전체 params
	 */
	public String getAllParam() throws Exception {
		StringBuilder result = new StringBuilder();
		int cnt = 0;
		for (Map.Entry<String, String> entry : params.entrySet()) {
			++cnt;
			result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
			result.append("=");
			result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
			
			if(cnt < params.entrySet().size()) {
				result.append("&");
			}
		}
		return result.toString();
	}
	
	public void setParams(Map<String, String> params) {
		this.params = params;
	}
	
	/**
	 * Header 새팅
	 */
	public HttpEntity<T> getHttpEntity(){
		HttpHeaders headers = new HttpHeaders();
		headers.set("Content-Type", "application/json");
		HttpEntity<T> httpEntity = new HttpEntity<>(entity, headers);
		return httpEntity;
	}
	
	public String getHttpRequestExec() throws Exception{
		URL url = new URL(urlStr);
		HttpURLConnection con = (HttpURLConnection) url.openConnection();
		con.setRequestMethod("GET");
		
		con.setDoOutput(true);
		DataOutputStream out = new DataOutputStream(con.getOutputStream());
		
		out.writeBytes(getAllParam());
		out.flush();
		out.close();
		
		BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer content = new StringBuffer();
		while ((inputLine = in.readLine()) != null) {
		    content.append(inputLine);
		}
		in.close();
		con.disconnect();
		
		return content.toString();
	}
}
