package kr.or.cwma.admin.survey.vo;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import kr.or.cwma.common.vo.AttchFileInfoVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 설문문항보기 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class SurveyQesitmExVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long sn; //일련번호
	private long qesitmSn; //문항 일련번호
	private long answerCnt; //답변갯수
	
	private String cn; //내용
	
	private List<MultipartFile> exFile; //첨부파일
	private AttchFileInfoVO fileVO; //파일VO
}
