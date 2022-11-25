package kr.or.cwma.admin.holdCrtf.vo;
import lombok.Data;

/**
 * 보유증명서 근로자VO
 * @author sichoi
 */
@Data
public class HoldCrtfLabrrVO{
	private long sn; //일련번호
	private String ihidnum; //주민등록번호
	private String cntrctNm; //공사명
	private String nm; //근로자명
	private String se; //구분
	private String seNm; //구분명
	private String jssfcNm; //직종명
	private String jssfcNo; //직종번호
	private String ddcJoinNo; //공제계약번호
	private String cl; //분류
	private String clNm; //분류명
}
