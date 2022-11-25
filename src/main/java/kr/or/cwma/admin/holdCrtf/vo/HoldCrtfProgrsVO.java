package kr.or.cwma.admin.holdCrtf.vo;
import org.hibernate.validator.constraints.NotEmpty;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 보유증명서 진행상황VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class HoldCrtfProgrsVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long sn; //진행번호
	private long holdCrtfSn; //경력번호
	
	@NotEmpty(message="진행상태를 입력해주세요")
	private String progrsSttus; //진행상태
	
	@NotEmpty(message="처리일자를 입력해주세요")
	private String progrsDe; //진행일자
	
	private String progrsSttusNm; //진행상태명
	private String progrsResn; //진행사유
	private String rplyTmlmt; //회신기한
	private String rgstId; //등록ID
	private String rgstNm; //등록자명
	private String rgstBrffc; //등록자부서
	private String rgstDt; //등록일
}
