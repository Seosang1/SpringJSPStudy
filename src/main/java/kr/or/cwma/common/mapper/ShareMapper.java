package kr.or.cwma.common.mapper;
import java.sql.SQLException;

import org.springframework.stereotype.Repository;

import kr.or.cwma.common.vo.EduVO;
import kr.or.cwma.common.vo.LcnsVO;

/**
 * 행공센 실시간연계 매퍼
 * @author sichoi
 */
@Repository
public interface ShareMapper{

	/**
	 * 산인공 자격증정보 등록
	 * @param vo  
	 * @throws SQLException 
	 */
	public void insertCntcHrdLicense(LcnsVO vo) throws SQLException;

	/**
	 * 산인공 자격증정보 삭제
	 * @param vo  
	 * @throws SQLException 
	 */
	public void deleteCntcHrdLicense(LcnsVO vo) throws SQLException;

	/**
	 * 한고원 교육정보 머지
	 * @param vo  
	 * @throws SQLException 
	 */
	public void insertCntcKeisEdu(EduVO vo) throws SQLException;
	
	/**
	 * 한고원 교육정보 삭제
	 * @param vo  
	 * @throws SQLException 
	 */
	public void deleteCntcKeisEdu(EduVO vo) throws SQLException;

}
