package kr.or.cwma.admin.holdCrtf.vo;
import lombok.Data;

/**
 * 보유증명서 발급VO
 * @author sichoi
 */
@Data
public class HoldCrtfIssuVO{
	private int issuLabrrCo; //발급근로자수
	private long sn; //일련번호
	private String issuNo; //발급번호
	private String issuDt; //발급일시
}
