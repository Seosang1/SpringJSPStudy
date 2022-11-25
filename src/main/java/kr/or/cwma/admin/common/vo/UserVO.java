package kr.or.cwma.admin.common.vo;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 사용자 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class UserVO{
	
	private int roleSn; //역할번호
	
	private String userId; //사용자아이디
	private String userName; //사용자명
	private String deptCd; //부서코드
	private String userRank; //사용자직급
	private String brffcNm; //부서명
	private String ddcAstcCd; //지사명
	private String brffcAbrvtNm; //지사명
	private String email; //email
	private String password; //password
}
