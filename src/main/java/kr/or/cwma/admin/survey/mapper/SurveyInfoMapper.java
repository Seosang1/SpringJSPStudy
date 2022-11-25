package kr.or.cwma.admin.survey.mapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.survey.vo.SurveyInfoVO;

/**
 * 설문정보 매퍼
 * @author sichoi
 */
@Repository
public interface SurveyInfoMapper{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<SurveyInfoVO> 
	 * @throws SQLException 
	 */
	public int selectSurveyInfoListCnt(SurveyInfoVO vo) throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<SurveyInfoVO> 
	 * @throws SQLException 
	 */
	public List<SurveyInfoVO> selectSurveyInfoList(SurveyInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return SurveyInfoVO 
	 * @throws SQLException 
	 */
	public SurveyInfoVO selectSurveyInfoView(SurveyInfoVO vo) throws SQLException;

	/**
	 * 엑셀목록조회
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectSurveyInfoListXls(SurveyInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertSurveyInfo(SurveyInfoVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateSurveyInfo(SurveyInfoVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteSurveyInfo(SurveyInfoVO vo) throws SQLException;

}
