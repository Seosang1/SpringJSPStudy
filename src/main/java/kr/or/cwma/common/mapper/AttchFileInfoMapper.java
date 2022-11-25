package kr.or.cwma.common.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 첨부파일정보 매퍼
 * @author sichoi
 */
@Repository
public interface AttchFileInfoMapper{

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
	public AttchFileInfoVO selectAttchFileInfoView(AttchFileInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo  
	 * @throws SQLException 
	 */
	public void insertAttchFileInfo(AttchFileInfoVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo  
	 * @throws SQLException 
	 */
	public void deleteAttchFileInfo(AttchFileInfoVO vo) throws SQLException;

}
