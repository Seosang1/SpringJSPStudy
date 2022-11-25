package kr.or.cwma.admin.jssfcInfo.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

public interface JssfcInfoHistService{


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

}
