package kr.or.cwma.admin.trgetRoleRelateHist.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.trgetRoleRelateHist.vo.TrgetRoleRelateHistVO;

public interface TrgetRoleRelateHistService{

	/**
	 * 목록개수조회
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int selectTrgetRoleRelateHistListCnt(TrgetRoleRelateHistVO vo) throws SQLException;
	
	/**
	 * 목록조회
	 * @param vo 
	 * @return List<TrgetRoleRelateHistVO> 
	 * @throws SQLException 
	 */
	public List<TrgetRoleRelateHistVO> selectTrgetRoleRelateHistList(TrgetRoleRelateHistVO vo) throws SQLException;

}
