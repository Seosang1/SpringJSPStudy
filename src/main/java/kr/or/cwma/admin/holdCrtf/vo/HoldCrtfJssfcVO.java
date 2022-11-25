package kr.or.cwma.admin.holdCrtf.vo;
import lombok.Data;

/**
 * 보유증명서 직종VO
 * @author sichoi
 */
@Data
public class HoldCrtfJssfcVO{
	private long sn; //일련번호
	private String jssfcNo; //직종번호
	private String jssfcNm; //직종명
}
