package kr.or.cwma.admin.smsSendHist.vo;
import org.hibernate.validator.constraints.NotEmpty;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class SmsSendHistVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int sn; //일련번호
	
	@NotEmpty(message="필수값입니다")
	private String cn; //내용
	
	@NotEmpty(message="필수값입니다")
	private String moblphonNo; //전화번호
	
	private String se; //구분
	private String seNm; //구분
	private String sttus; //상태
	private String sttusNm; //상태
	private String rgstDt; //등록일시
	private String bgnDt; //등록일시
	private String endDt; //등록일시
}
