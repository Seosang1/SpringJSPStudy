package kr.or.cwma.admin.dataCmmnCd.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.dataCmmnCd.vo.DataCmmnCdVO;

/**
 * 코드관리 매퍼
 * @author sichoi
 */
@Repository
public interface DataCmmnCdMapper{

	/**
	 * 코드관리 목록갯수 조회
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int selectCmmnCdListCnt(DataCmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 목록조회
	 * @param vo
	 * @return List<DataCmmnCdVO>
	 * @throws SQLException
	 */
	public List<DataCmmnCdVO> selectCmmnCdList(DataCmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 상세조회
	 * @param vo
	 * @return DataCmmnCdVO
	 * @throws SQLException
	 */
	public DataCmmnCdVO selectCmmnCdView(DataCmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertCmmnCd(DataCmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 수정
	 * @param vo
	 * @throws SQLException
	 */
	public void updateCmmnCd(DataCmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 삭제
	 * @param vo
	 * @throws SQLException
	 */
	public void deleteCmmnCd(DataCmmnCdVO vo) throws SQLException;

}
