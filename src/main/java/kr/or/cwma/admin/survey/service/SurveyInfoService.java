package kr.or.cwma.admin.survey.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import kr.or.cwma.admin.survey.vo.SurveyInfoVO;

public interface SurveyInfoService{
	
	/**
	 * 목록조회
	 * @param vo
	 * @return List<SurveyInfoVO>
	 * @throws SQLException
	 */
	public List<SurveyInfoVO> selectSurveyInfoList(SurveyInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * - 설문정보 vo에 문항list정보 추가
	 * - 문항정보 listvo에 보기list정보 추가
	 * @param vo 
	 * @return SurveyInfoVO 
	 * @throws SQLException 
	 */
	public SurveyInfoVO selectSurveyInfoView(SurveyInfoVO vo) throws SQLException;
	
	/**
	 * 엑셀목록조회
	 * - 사용자가 답변한 목록을 가로로 출력
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectSurveyInfoListXls(SurveyInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * - 설문정보, 설문문항, 문항보기 정보 및 해당 첨부파일 등록
	 * @param vo
	 * @param req
	 * @throws SQLException
	 * @throws IOException
	 */
	public void insertSurveyInfo(SurveyInfoVO vo) throws SQLException, IOException;

	/**
	 * 수정
	 * - 설문정보, 설문문항, 문항보기 정보 및 해당 첨부파일 수정
	 * - 삭제된 문항 및 보기정보는 삭제
	 * - 신규 문항 및 보기정보는 등록
	 * @param vo
	 * @param req
	 * @throws SQLException
	 * @throws IOException
	 */
	public void updateSurveyInfo(SurveyInfoVO vo) throws SQLException, IOException;

	/**
	 * 삭제
	 * - 설문정보, 설문문항, 문항보기 정보 및 해당 첨부파일 정보 전부 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteSurveyInfo(SurveyInfoVO vo) throws SQLException;

}
