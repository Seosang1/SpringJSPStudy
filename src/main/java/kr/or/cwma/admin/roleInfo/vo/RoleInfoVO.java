package kr.or.cwma.admin.roleInfo.vo;
import java.util.List;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 역할정보VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class RoleInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int roleSn; //역할일련번호
	private String roleNm; //역할명
	private String roleDc; //역할설명
	private String rgstDt; //등록일
	private String chgDt; //수정일
	private String rgstId; //등록ID
	private String chgId; //수정ID
	
	private List<AuthorRoleRelateVO> relateVO; //권한역할관계
}
