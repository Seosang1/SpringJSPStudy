package kr.or.cwma.admin.gradStdr.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 등급기준관리 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class GradStdrVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private Long sn; //일련번호
	private Integer grad1; //등급1
	private Integer grad2; //등급2
	private Integer grad3; //등급3
	private Integer grad4; //등급4
	private Integer useJssfc; //활용직종
	private Integer etcJssfc; //기타직종
	private String applcDe; //적용일자
	private String rgstDt; //등록일시
	private String rgstId; //등록ID
	private String rgstNm; //등록자
}
