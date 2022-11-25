package kr.or.cwma.common.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.apache.commons.lang.StringUtils;

public class CommonUtils {
	public static String toCamelCase(String str){
		StringBuffer ret = new StringBuffer();

		for(String tmp : str.toLowerCase().split("_")){
			if(ret.length() > 0)
				ret.append(StringUtils.capitalize(tmp));
			else
				ret.append(tmp);
		}

		return ret.toString();
	}

	public static String toSnakeCase(String str){
		return str.replaceAll("([a-z])([A-Z]+)", "$1_$2").toUpperCase();
	}
	
	public static String getDateNow() {
		String today = null;
		 
		 
		Date date = new Date();
		 
		System.out.println(date);
		 
		// 포맷변경 ( 년월일 시분초)
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd"); 
		 
		// Java 시간 더하기
		 
		Calendar cal = Calendar.getInstance();
		 
		cal.setTime(date);
		 
		today = sdformat.format(cal.getTime());  
		return today;
	}
	
	public static String getTimeNow() {
		String today = null;
		 
		 
		Date date = new Date();
		 
		System.out.println(date);
		 
		// 포맷변경 ( 년월일 시분초)
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		 
		// Java 시간 더하기
		 
		Calendar cal = Calendar.getInstance();
		 
		cal.setTime(date);
		 
		today = sdformat.format(cal.getTime());  
		return today;
	}
	
	public static String getTime1HoursPrev() {
		String today = null;
		 
		 
		Date date = new Date();
		 
		System.out.println(date);
		 
		// 포맷변경 ( 년월일 시분초)
		SimpleDateFormat sdformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		 
		// Java 시간 더하기
		 
		Calendar cal = Calendar.getInstance();
		 
		cal.setTime(date);
		cal.add(Calendar.HOUR, -1);
		today = sdformat.format(cal.getTime());  
		return today;
	}
}
