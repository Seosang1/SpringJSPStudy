package kr.or.cwma.admin.conectIp.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.conectIp.vo.ConectIpVO;

/**
 * 접속IP관리 서비스
 * @author sichoi
 */
public interface ConectIpService{
	
	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<ConectIpVO> 
	 * @throws SQLException 
	 */
	public int selectConectIpListCnt(ConectIpVO vo) throws SQLException;
	
	/**
	 * 목록조회
	 * @param vo 
	 * @return List<ConectIpVO> 
	 * @throws SQLException 
	 */
	public List<ConectIpVO> selectConectIpList(ConectIpVO vo) throws SQLException;
	
	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertConectIp(ConectIpVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteConectIp(ConectIpVO vo) throws SQLException;

}
