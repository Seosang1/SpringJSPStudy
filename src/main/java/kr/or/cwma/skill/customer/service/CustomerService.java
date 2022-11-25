package kr.or.cwma.skill.customer.service;
import java.io.IOException;
import java.sql.SQLException;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;

/**
 * 고객센터 서비스
 * @author sichoi
 */
public interface CustomerService{

	/**
	 * 설문참여가능여부조회
	 * @param vo
	 * @return SurveyInfoVO 
	 * @throws SQLException 
	 */
	public SurveyInfoVO selectSurveyStatus(SurveyInfoVO vo) throws SQLException;

	/**
	 * 설문 답변 등록
	 * @param vo
	 * @throws SQLException 
	 */
	public void insertSurveyAnswer(SurveyAnswrrVO vo) throws SQLException;
	

	/**
	 * 온라인상담 등록
	 * - 첨부파일 정보와 함께 등록
	 * @param vo
	 * @param req
	 * @return String
	 * @throws SQLException
	 * @throws IOException
	 */
	public void insertBbs(BbsVO vo, MultipartHttpServletRequest req) throws SQLException, IOException;
}
