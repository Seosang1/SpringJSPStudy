package kr.or.cwma.admin.authorInfo.vo;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 메뉴권한관계 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MenuAuthorRelateVO{
	private int menuSn; //메뉴일련번호
	private String authorCd; //권한코드
}
