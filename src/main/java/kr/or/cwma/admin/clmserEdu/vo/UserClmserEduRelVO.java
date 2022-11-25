package kr.or.cwma.admin.clmserEdu.vo;
import java.util.List;

import kr.or.cwma.common.vo.AttchFileInfoVO;
import lombok.Data;

/**
 * 맞춤형교육 사용자관계VO
 * @author sichoi
 */
@Data
public class UserClmserEduRelVO{
	private long sn; //일련번호
	private int eduSn; //맞춤형교육 일련번호
	private String ihidnum; //주민번호
	private String complAt; //이수여부
	private String complDt; //이수일자
	
	List<AttchFileInfoVO> fileVO; //첨부파일
}
