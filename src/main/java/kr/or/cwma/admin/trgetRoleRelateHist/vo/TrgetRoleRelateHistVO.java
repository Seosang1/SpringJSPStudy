package kr.or.cwma.admin.trgetRoleRelateHist.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class TrgetRoleRelateHistVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int sn; //일련번호
	private int roleSn; //역할번호(권한)
	private String se; //구분
	private String trget; //대상(개인관리자/부서)
	private String chgSe; //변경구분(유형)
	private String rgstDt; //등록일시
	private String rgstId; //등록ID
	
	// 검색조건
	private String userId;//사용자아이디
	private String nm;//사용자명
	private String seNm; //구분명
	private String roleNm;//권한명
	private String chgSeNm;//변경구분명
	private String rgstNM; //작업자
	private String bgnDt; //시작일
	private String endDt; //종료일
	
	
}
