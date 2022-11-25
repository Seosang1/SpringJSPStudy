package kr.or.cwma.admin.survey.service;
import java.io.IOException;
import java.sql.SQLException;

import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;

public interface SurveyQesitmService{

	/**
	 * 등록
	 * - 설문문항 정보 및 첨부파일 등록
	 * @param vo
	 * @param req
	 * @throws SQLException
	 * @throws IOException
	 */
	public void insertSurveyQesitm(SurveyQesitmVO vo) throws SQLException, IOException;

	/**
	 * 수정
	 * - 설문문항 정보 및 첨부파일 수정
	 * - 문항보기 정보 및 첨부파일 수정
	 * @param vo
	 * @param req
	 * @throws SQLException
	 * @throws IOException
	 */
	public void updateSurveyQesitm(SurveyQesitmVO vo) throws SQLException, IOException;

	/**
	 * 삭제
	 * - 문항보기 정보 및 첨부파일 정보 삭제
	 * - 설문문항 정보 및 첨부파일 정보 삭제
	 * @param vo
	 * @throws SQLException 
	 */
	public void deleteSurveyQesitm(SurveyInfoVO vo) throws SQLException;

}
