package kr.or.cwma.admin.holdCrtf.vo;
import lombok.Data;

/**
 * 보유증명서 등급VO
 * @author sichoi
 */
@Data
public class HoldCrtfCntrwkVO{

	private long sn; //일련번호
	private String ddcJoinNo; //공제가입번호
	private String se; //구분
	private String seNm; //구분명
	private String cntrctNm; //공사명
	private String dminsttNm; //수요기관명
	private String adrs; //주소
}
