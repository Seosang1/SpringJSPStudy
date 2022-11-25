package kr.or.cwma.admin.dataCmmnCd.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.dataCmmnCd.vo.DataCmmnCdVO;

/**
 * 코드관리 서비스
 * @author sichoi
 */
public interface DataCmmnCdService{

	/**
	 * 코드관리 목록조회
	 * @param vo
	 * @return List<DataCmmnCdVO>
	 * @throws SQLException
	 */
	public List<DataCmmnCdVO> selectCmmnCdList(DataCmmnCdVO vo) throws SQLException;

	/**
	 * 코드관리 자식목록조회
	 * @param parntsCdId
	 * @return List<DataCmmnCdVO>
	 * @throws SQLException
	 */
	public List<DataCmmnCdVO> selectCmmnCdChildList(String parntsCdId) throws SQLException;

	/**
	 * 코드관리 상세보기
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
