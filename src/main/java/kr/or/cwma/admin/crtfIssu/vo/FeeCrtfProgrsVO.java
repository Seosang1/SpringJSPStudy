package kr.or.cwma.admin.crtfIssu.vo;
import org.hibernate.validator.constraints.NotEmpty;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class FeeCrtfProgrsVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long sn; //진행번호
	private long reqstNo; //경력번호
	
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
	
	private String userName; //사용자명
	private String brffcNm; //부서명
}
