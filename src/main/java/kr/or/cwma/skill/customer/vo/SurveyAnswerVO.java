package kr.or.cwma.skill.customer.vo;
import lombok.Data;

@Data
public class SurveyAnswerVO{
	private long answrrSn; //답변자 일련번호
	private long qesitmSn; //문항 일련번호
	
	private String answer; //답변
	private String etcAnswer; //기타답변
	private String ty; //유형
	
	private String[] answerList; //답변목록
	private String[] etcList; //기타답변목록
}
