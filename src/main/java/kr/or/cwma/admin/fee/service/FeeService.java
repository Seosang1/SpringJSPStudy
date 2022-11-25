package kr.or.cwma.admin.fee.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.fee.vo.FeeVO;

/**
 * 수수료 관리 서비스
 * @author sichoi
 */
public interface FeeService{
	
	/**
	 * 목록조회
	 * @param vo 
	 * @return List<FeeVO> 
	 * @throws SQLException 
	 */
	public List<FeeVO> selectFeeList(FeeVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return FeeVO 
	 * @throws SQLException 
	 */
	public FeeVO selectFeeView(FeeVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertFee(FeeVO vo) throws SQLException;

}
