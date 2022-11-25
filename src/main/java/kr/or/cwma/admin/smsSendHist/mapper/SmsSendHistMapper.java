package kr.or.cwma.admin.smsSendHist.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.smsSendHist.vo.SmsSendHistVO;

@Repository
public interface SmsSendHistMapper{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<SmsSendHistVO> 
	 * @throws SQLException 
	 */
	public int selectSmsSendHistListCnt(SmsSendHistVO vo) throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<SmsSendHistVO> 
	 * @throws SQLException 
	 */
	public List<SmsSendHistVO> selectSmsSendHistList(SmsSendHistVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return SmsSendHistVO 
	 * @throws SQLException 
	 */
	public SmsSendHistVO selectSmsSendHistView(SmsSendHistVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertSmsSendHist(SmsSendHistVO vo) throws SQLException;

	/**
	 * 발송
	 * @param vo 
	 * @throws SQLException 
	 */
	public void executeSms(SmsSendHistVO vo) throws SQLException;

}
