package kr.or.cwma.admin.userInfo.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserCnsltHistVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long sn; //일련번호
	
	private String ihidnum; //주민번호
	private String ddcerSn; //신피공제자번호
	private String cn; //내용
	private String cnsltDe; //상담일자
	private String se; //구분
	private String trgt; //대상
	private String descriptionAt = "0"; //제도설명여부
	private String etcAt = "0"; //기타여부
	private String skillAt = "0"; //기능인등급여부
	private String seNm; //구분명
	private String rgstDt; //등록일시
	private String rgstDept; //등록부서
	private String rgstId; //등록ID
	private String rgstNm; //등록자명
}
