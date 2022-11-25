package kr.or.cwma.common.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 첨부파일정보 서비스
 * @author sichoi
 */
public interface AttchFileInfoService{

	/**
	 * 목록조회
	 * @param vo
	 * @return List<AttchFileInfoVO>
	 * @throws SQLException
	 */
	public List<AttchFileInfoVO> selectAttchFileInfoList(AttchFileInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo
	 * @return AttchFileInfoVO
	 * @throws SQLException
	 */
	public AttchFileInfoVO selectAttchFileInfo(AttchFileInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertAttchFileInfo(List<AttchFileInfoVO> vo) throws SQLException;

	/**
	 * 등록
	 * @param vo
	 * @param parntsSn
	 * @param parntsSe
	 * @throws SQLException
	 */
	public void insertAttchFileInfo(List<AttchFileInfoVO> vo, long parntsSn, String parntsSe) throws SQLException;

	/**
	 * 등록 - 단건
	 * @param vo
	 * @param refSeq
	 * @throws SQLException
	 */
	public void insertAttchFileInfo(AttchFileInfoVO fvo) throws SQLException;

	/**
	 * 삭제 - 단건
	 * @param AttchFileInfoVO
	 * @throws SQLException
	 */
	public void deleteAttchFileInfo(AttchFileInfoVO vo) throws SQLException;

	/**
	 * 삭제 - 여러건
	 * @param AttchFileInfoVO
	 * @throws SQLException
	 */
	public void deleteAttchFileInfoList(List<AttchFileInfoVO> vo) throws SQLException;

}
