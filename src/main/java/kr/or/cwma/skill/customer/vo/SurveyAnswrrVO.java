package kr.or.cwma.skill.customer.vo;
import java.util.List;

import lombok.Data;

@Data
public class SurveyAnswrrVO{
	private long answrrSn; //답변자일련번호
	private long surveySn; //설문 일련번호
	
	private String answrrId; //답변자ID
	private String answrrDt; //답변일
	
	private List<SurveyAnswerVO> answerVO; //답변VO
}
