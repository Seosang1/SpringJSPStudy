package kr.or.cwma.admin.cmmnCd.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;

/**
 * 코드관리 서비스
 * @author sichoi
 */
public interface CmmnCdService{

	/**
	 * 코드관리 목록조회
	 * @param vo
	 * @return List<CmmnCdVO>
	 * @throws SQLException
	 */
	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 자식목록조회
	 * @param parntsCdId
	 * @return List<CmmnCdVO>
	 * @throws SQLException
	 */
	public List<CmmnCdVO> selectCmmnCdChildList(String parntsCdId) throws SQLException;

	/**
	 * 코드관리 상세보기
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
