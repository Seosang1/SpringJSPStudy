package kr.or.cwma.admin.survey.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.survey.vo.SurveyQesitmExVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;

/**
 * 설문문항보기 매퍼
 * @author sichoi
 */
@Repository
public interface SurveyQesitmExMapper{

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertSurveyQesitmEx(SurveyQesitmExVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateSurveyQesitmEx(SurveyQesitmExVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteSurveyQesitmEx(SurveyQesitmVO vo) throws SQLException;
	
	/**
	 * 목록조회
	 * @param vo 
	 * @return List<SurveyQesitmExVO>
	 * @throws SQLException 
	 */
	public List<SurveyQesitmExVO> selectSurveyQesitmExList(SurveyQesitmVO vo) throws SQLException;

}
