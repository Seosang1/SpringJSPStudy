package kr.or.cwma.admin.survey.vo;
import java.util.List;

import kr.or.cwma.common.vo.AttchFileInfoVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 설문문항 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class SurveyInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long surveySn; //설문 일련번호
	private long answrrCnt; //답변자 수
	
	private String sj; //제목
	private String cn; //내용
	private String bgnde; //시작일
	private String endde; //종료일
	private String displayAt; //상태
	private String useAt; //사용여부
	private String rgstId; //등록ID
	private String rgstDt; //등록일
	private String chgId; //수정ID
	private String chgDt; //수정일
	private String chkId; //설문참여검사ID
	
	private List<SurveyQesitmVO> itmVO; //문항목록
	private List<AttchFileInfoVO> fileVO; //첨부파일목록
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
}
