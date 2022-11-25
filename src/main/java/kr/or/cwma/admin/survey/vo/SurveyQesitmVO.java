package kr.or.cwma.admin.survey.vo;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.cwma.common.vo.PageVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswerVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 설문문항 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class SurveyQesitmVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long qesitmSn; //문항 일련번호
	private long surveySn; //설문 일련번호
	
	private String sj; //제목
	private String cn; //내용
	private String ty; //유형
	
	private List<MultipartFile> itmFile; //첨부파일
	private List<SurveyQesitmExVO> exVO; //보기목록
	private List<SurveyAnswerVO> answerVO; //답변목록
}
