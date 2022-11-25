package kr.or.cwma.admin.batchLog.vo;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class BatchLogVO extends PageVO{

	private static final long serialVersionUID = 1L;
	
	private long sn; //일련번호
	private int cnt; //건수
	
	private String batchCd; //배치코드
	private String batchNm; //배치명
	private String batchResult; //배치결과
	private String mssage; //메세지
	private String executDe; //실행일
	private String bgnDt; //시작일
	private String endDt; //종료일
}
