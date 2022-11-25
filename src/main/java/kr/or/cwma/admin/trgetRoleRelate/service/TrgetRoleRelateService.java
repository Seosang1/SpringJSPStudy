package kr.or.cwma.admin.trgetRoleRelate.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.trgetRoleRelate.vo.TrgetRoleRelateVO;

public interface TrgetRoleRelateService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<TrgetRoleRelateVO> 
	 * @throws SQLException 
	 */
	public List<TrgetRoleRelateVO> selectTrgetRoleRelateList(TrgetRoleRelateVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateTrgetRoleRelate(TrgetRoleRelateVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteTrgetRoleRelate(TrgetRoleRelateVO vo) throws SQLException;

}
