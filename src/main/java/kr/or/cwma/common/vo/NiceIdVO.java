package kr.or.cwma.common.vo;

import lombok.Data;

@Data
public class NiceIdVO{
	private int retCd = 0; //결과코드
	
	private String reqNo; //요청번호
	private String type; //인증타입(X:인증서, M:핸드폰, I:아이핀, C:신용카드)
	private String juminType; //실명인증타입(L:내국인, F:외국인)
	private String refUrl; //인증요청URL
	private String cancelAt = "N"; //취소버튼표시여부
	private String mobileAt = ""; //모바일페이지 여부(모바일:Mobile, 기본:null)
	private String gender = ""; //성별(여:0, 남:1)
	private String retUrl; //인증후 이동 URL
	private String msg; //오류메세지
	private String result; //요청문자
	private String nm; //성명
	private String se; //회원구분
	private String jumin1; //주민번호 앞자리
	private String jumin2; //주민번호 뒷자리
	private String bizno1; //사업자등록번호 앞자리
	private String bizno2; //사업자등록번호 중간자리
	private String bizno3; //사업자등록번호 뒷자리
}
