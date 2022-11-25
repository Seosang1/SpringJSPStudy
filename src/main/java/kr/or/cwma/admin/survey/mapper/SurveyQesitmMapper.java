package kr.or.cwma.admin.survey.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;

/**
 * 설문문항 매퍼
 * @author sichoi
 */
@Repository
public interface SurveyQesitmMapper{

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertSurveyQesitm(SurveyQesitmVO vo) throws SQLException;
	
	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateSurveyQesitm(SurveyQesitmVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteSurveyQesitm(SurveyInfoVO vo) throws SQLException;
	
	/**
	 * 목록조회
	 * @param vo 
	 * @return List<SurveyQesitmVO>
	 * @throws SQLException 
	 */
	public List<SurveyQesitmVO> selectSurveyQesitmList(SurveyInfoVO vo) throws SQLException;

}
