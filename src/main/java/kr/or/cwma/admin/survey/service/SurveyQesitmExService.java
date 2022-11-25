package kr.or.cwma.admin.survey.service;
import java.io.IOException;
import java.sql.SQLException;

import kr.or.cwma.admin.survey.vo.SurveyQesitmExVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;

public interface SurveyQesitmExService{

	/**
	 * MERGE
	 * - 문항보기 정보가 기존에 있으면 수정 없으면 등록
	 * - 문항보기 정보 및 첨부파일 등록
	 * @param vo
	 * @param req
	 * @throws SQLException
	 * @throws IOException
	 */
	public void updateSurveyQesitmEx(SurveyQesitmExVO vo) throws SQLException, IOException;

	/**
	 * 삭제
	 * - 문항보기 정보 및 첨부파일 정보 삭제
	 * @param vo
	 * @throws SQLException 
	 */
	public void deleteSurveyQesitmEx(SurveyQesitmVO vo) throws SQLException;

}
