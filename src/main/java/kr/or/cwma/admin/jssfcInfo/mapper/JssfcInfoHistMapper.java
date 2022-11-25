package kr.or.cwma.admin.jssfcInfo.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

@Repository
public interface JssfcInfoHistMapper{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<JssfcInfoVO>
	 * @throws SQLException 
	 */
	public List<JssfcInfoVO> selectJssfcInfoHistList(JssfcInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return JssfcInfoVO
	 * @throws SQLException 
	 */
	public JssfcInfoVO selectJssfcInfoHistView(JssfcInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertJssfcInfoHist(JssfcInfoVO vo) throws SQLException;
	
	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateJssfcInfoHist(JssfcInfoVO vo) throws SQLException;

}
