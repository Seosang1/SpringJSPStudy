package kr.or.cwma.admin.batchLog.service;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import kr.or.cwma.admin.batchLog.vo.BatchLogVO;

public interface BatchLogService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<BatchLogVO> 
	 * @throws SQLException 
	 */
	public List<BatchLogVO> selectBatchLogList(BatchLogVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return BatchLogVO 
	 * @throws SQLException 
	 */
	public BatchLogVO selectBatchLogView(BatchLogVO vo) throws SQLException;
	
	/**
	 * 엑셀목록조회
	 * @param vo
	 * @return List<Map<String, Object>>
	 * @throws SQLException
	 */
	public List<Map<String, Object>> selectBatchLogListXls(BatchLogVO vo) throws SQLException;

	/**
	 * 배치코드 목록 조회
	 * @return List<BatchLogVO> 
	 * @throws SQLException 
	 */
	public List<BatchLogVO> selectBatchCdList() throws SQLException;

}
