package kr.or.cwma.skill.customer.mapper;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswerVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;

/**
 * 고객센터 매퍼
 * @author sichoi
 */
@Repository
public interface CustomerMapper{

	/**
	 * 설문참여가능여부조회
	 * @param vo
	 * @return SurveyInfoVO 
	 * @throws SQLException 
	 */
	public SurveyInfoVO selectSurveyStatus(SurveyInfoVO vo) throws SQLException;

	/**
	 * 설문 답변자 등록
	 * @param vo
	 * @throws SQLException 
	 */
	public void insertSurveyAnswrr(SurveyAnswrrVO vo) throws SQLException;	

	/**
	 * 설문 답변 등록
	 * @param vo
	 * @throws SQLException 
	 */
	public void insertSurveyAnswer(SurveyAnswerVO vo) throws SQLException;
	
}
