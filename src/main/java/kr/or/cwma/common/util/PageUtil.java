package kr.or.cwma.common.util;

import java.io.UnsupportedEncodingException;
import java.util.Enumeration;

import javax.servlet.http.HttpServletRequest;

import kr.or.cwma.common.vo.PageVO;

import org.springframework.util.StringUtils;

public class PageUtil {
	
	public static void setPaging(PageVO vo, HttpServletRequest req) throws UnsupportedEncodingException{
		vo.setQueryStr(getQueryString(req, new String[]{"pageNo"}));
	}
	
	public static String getQueryString(HttpServletRequest request) throws UnsupportedEncodingException{
		return getQueryString(request, new String[]{});
	}
	
	public static String getQueryString(HttpServletRequest request, String[] arr) throws UnsupportedEncodingException{
		String val = "";
		String ret = "?";
		
		Enumeration<String> e = request.getParameterNames();
		
		while(e.hasMoreElements()){
			boolean chk = true;
			String tmp = e.nextElement();
			
			for(String tmpVal : request.getParameterValues(tmp)){
				if(!"?".equals(ret))
					ret = ret.concat("&");
				if ( tmpVal == null) tmpVal = "";
				
				val = tmpVal;
				
				for(String param : arr){
					if(param.equals(tmp))
						chk = false;
				}
				
				if(chk && !StringUtils.isEmpty(tmpVal))
					ret = ret.concat(tmp).concat("=").concat(val);
			}
		}
		
		if("?".equals(ret))
			ret = "";
		
		return ret;
	}
	
	public static String getSelectQueryString(HttpServletRequest request, String[] arr) throws UnsupportedEncodingException{
		String val = "";
		String ret = "";
		
		for(String tmp : arr){
			if(request.getParameterValues(tmp) != null){
				for(String tmpVal : request.getParameterValues(tmp)){
					if(!"".equals(ret))
						ret = ret.concat("&");
					
					if ( tmpVal == null) tmpVal = "";
					
					val = tmpVal;
					
					if(!StringUtils.isEmpty(tmpVal))
						ret = ret.concat(tmp).concat("=").concat(val);
				}
			}
		}
		
		return ret;
	}
	
}
