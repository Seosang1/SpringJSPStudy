package kr.or.cwma.admin.trgetRoleRelate.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class TrgetRoleRelateVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int roleSn; //역할번호
	private String se; //구분
	private String trget; //대상
	private String rgstId; //등록ID
	private String[] trgetList; //대상
}
