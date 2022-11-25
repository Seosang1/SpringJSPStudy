package kr.or.cwma.admin.authorInfo.vo;
import java.util.List;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 권한정보 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class AuthorInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private String authorCd; //권한코드
	private String authorDc; //권한설명
	private String authorNm; //권한명
	private String rgstDt; //등록일
	private String chgDt; //수정일
	private String rgstId; //등록ID
	private String chgId; //수정ID
	
	private List<MenuAuthorRelateVO> relateVO; //역할권한관계
}
