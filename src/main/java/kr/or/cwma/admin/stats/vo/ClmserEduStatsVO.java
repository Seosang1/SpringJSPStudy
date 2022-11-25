package kr.or.cwma.admin.stats.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 맞춤형교육통계 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ClmserEduStatsVO extends PageVO{
	
	private static final long serialVersionUID = 1L;
	
	private String nm; //이름
	private String ihidnum; //주민등록번호
	
	private String answer1; //답변1
	private String answer2; //답변2
	private String answer3; //답변3
	private String answer4; //답변4
	
	private String bgnDt; //시작일
	private String endDt; //종료일
}
