package kr.or.cwma.admin.admin.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 코드관리 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class AdminVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int sort; //순번
	private String userId; //아이디
	private String password; //패스워드
	private String userName; //이름
	private String deptCd; //부서
	private String deptName; //부서명
	private String email; //이메일
	private String rgstDt; //등록일
	private String updDt; //수정일
	private String phoneNum; //핸드폰번호
	private String compPhoneNum; //사무실번호
}
