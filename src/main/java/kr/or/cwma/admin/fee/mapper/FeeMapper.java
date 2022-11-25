package kr.or.cwma.admin.fee.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.fee.vo.FeeVO;

/**
 * 수수료 관리 매퍼
 * @author sichoi
 */
@Repository
public interface FeeMapper{

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
