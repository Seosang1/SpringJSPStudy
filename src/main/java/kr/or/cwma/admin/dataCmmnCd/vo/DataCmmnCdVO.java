package kr.or.cwma.admin.dataCmmnCd.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 코드관리 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class DataCmmnCdVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int sort; //순번
	private String cdId; //코드ID
	private String parntsCdId; //부모코드ID
	private String gParntsCdId; //최상위 부모코드ID
	private String cdNm; //코드명
	private String cdDc; //코드설명
}
