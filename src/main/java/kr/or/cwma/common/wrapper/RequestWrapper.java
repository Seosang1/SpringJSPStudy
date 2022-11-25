package kr.or.cwma.common.wrapper;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public final class RequestWrapper extends HttpServletRequestWrapper{

    public RequestWrapper(HttpServletRequest servletRequest){
        super(servletRequest);
    }

    public String[] getParameterValues(String parameter){
    	int count = 0;
    	String encodedValues[] = null;
        String values[] = super.getParameterValues(parameter);
        
        count = values.length;
        
        if(values != null){
	        encodedValues = new String[count];
	        
	        for(int i = 0; i < count; i++)
	            encodedValues[i] = cleanXSS(values[i]);
        }

        return encodedValues;
    }

    public String getParameter(String parameter){
        String value = super.getParameter(parameter);
        if(value == null)
            return null;
        else
            return cleanXSS(value);
    }

    public String getHeader(String name){
        String value = super.getHeader(name);
        if(value == null)
            return null;
        else
            return cleanXSS(value);
    }

    private String cleanXSS(String value){
        value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
        //value = value.replaceAll("\\(", "&#40;").replaceAll("\\)", "&#41;");
        value = value.replaceAll("'", "&#39;");
        value = value.replaceAll("eval\\((.*)\\)", "");
        value = value.replaceAll("[\\\"\\'][\\s]*javascript:(.*)[\\\"\\']", "\"\"");
        value = value.replaceAll("script", "");
        return value;
    }
}