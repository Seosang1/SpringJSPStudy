package kr.or.cwma.admin.common.vo;
import lombok.Data;

@Data
public class CommonVO{
	private int visitInfoId; 
	private String visitIp; 
	private String visitDt; 
	private String nowTime;
	private String prevTime;
}
