package kr.or.cwma.admin.sanctn.vo;

import org.apache.ibatis.type.Alias;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 지사관리 VO
 * @author sichoi
 */
@Data
@Alias("CwmaDdcAsctInfoVO")
@EqualsAndHashCode(callSuper=false)
public class CwmaDdcAsctInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;

	/**  인덱스 */
	private String ddcAsctCd;

	/**  상위부서인덱스 */
	private String upperDdcAsctCd;

	/**  부서장ID */
	private String brffcHedId;

	/**  정렬순서 */
	private int sort;

	/* private String dstrctNm; */
	/* private String divCd; */

	/**  명칭 */
	private String brffcNm;

	/**  약칭 */
	private String brffcAbrvtNm;

	/**  우편번호 */
	private String zip;

	/**  주소 */
	private String addr;

	/**  전화번호 */
	private String telNo;

	/**  팩스번호 */
	private String faxNo;

	/*
	 * private String useYn; private String rgstId; private String rgstDt; private
	 * String chgDt; private String chgId;
	 */
}
