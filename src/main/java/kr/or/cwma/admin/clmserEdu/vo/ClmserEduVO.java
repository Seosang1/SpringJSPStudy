package kr.or.cwma.admin.clmserEdu.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 맞춤형교육 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class ClmserEduVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int sn; //일련번호
	private String sj; //제목
	private String se; //구분
	private String seNm; //구분명
	private String vidoUrl; //영상URL
	private String rgstDt; //등록일자
	private String ihidnum; //주민번호
	
	UserClmserEduRelVO relVO; //사용자관계테이블
}
