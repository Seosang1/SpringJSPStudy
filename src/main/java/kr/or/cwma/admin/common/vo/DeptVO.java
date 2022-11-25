package kr.or.cwma.admin.common.vo;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 부서 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class DeptVO{
	
	private String deptCd; //부서코드
	private String deptName; //부서명
	private String pdeptCd; //부모부서코드
	private String fullPathName; //전체부서명
	private String ddcAstcCd; //지사코드
	private String upperDdcAstcCd; //지사코드
	private String brffcNm; //부서명
	private String roleSn; //역할번호
}
