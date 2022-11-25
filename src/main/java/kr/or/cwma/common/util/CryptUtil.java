package kr.or.cwma.common.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class CryptUtil {
	
	/** 파라메터로 암호화된 문자열 반환.
	 * @param str
	 * @param str
	 * @return
	 * @throws NoSuchAlgorithmException 
	 * @throws Exception
	 */
	public static String encriptSHA512(String str) throws NoSuchAlgorithmException{
    	if (str == null) return str;
    	MessageDigest md = MessageDigest.getInstance("SHA-512");
    	byte[] diArr = md.digest(str.getBytes());
    	StringBuffer sb = new StringBuffer();
    	for (byte b : diArr) {
    		char c = (char)b;
    		String md5Str = String.format("%02x", 0xff&c);
    		sb.append(md5Str);
    	}
    	return sb.toString().toUpperCase();
    }
	
}
