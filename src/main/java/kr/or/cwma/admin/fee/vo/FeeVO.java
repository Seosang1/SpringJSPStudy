package kr.or.cwma.admin.fee.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 수수료 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class FeeVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int sn; //일련번호
	private int frst; //최초
	private int grad; //등급증명서
	private int gradOnline; //등급증명서 온라인
	private int hold; //보유증명서
	private int holdOnline; //보유증명서 온라인
	
	private String applcDe; //적용일자
	private String rgstDt; //등록일시
	private String rgstId; //등록ID
	private String rgstNm; //등록자명
}
