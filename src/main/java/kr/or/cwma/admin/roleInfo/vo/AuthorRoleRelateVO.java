package kr.or.cwma.admin.roleInfo.vo;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 역할권한관계 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class AuthorRoleRelateVO{

	private int roleSn; //역할일련번호
	private String authorCd; //권한코드
}
