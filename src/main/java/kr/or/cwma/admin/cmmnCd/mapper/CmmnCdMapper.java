package kr.or.cwma.admin.cmmnCd.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;

/**
 * 코드관리 매퍼
 * @author sichoi
 */
@Repository
public interface CmmnCdMapper{

	/**
	 * 코드관리 목록갯수 조회
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int selectCmmnCdListCnt(CmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 목록조회
	 * @param vo
	 * @return List<CmmnCdVO>
	 * @throws SQLException
	 */
	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 상세조회
	 * @param vo
	 * @return CmmnCdVO
	 * @throws SQLException
	 */
	public CmmnCdVO selectCmmnCdView(CmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertCmmnCd(CmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 수정
	 * @param vo
	 * @throws SQLException
	 */
	public void updateCmmnCd(CmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 삭제
	 * @param vo
	 * @throws SQLException
	 */
	public void deleteCmmnCd(CmmnCdVO vo) throws SQLException;

}
