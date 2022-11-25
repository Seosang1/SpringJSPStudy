package kr.or.cwma.admin.indvdlinfoAccesLog.service;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.cwma.admin.indvdlinfoAccesLog.vo.IndvdlinfoAccesLogVO;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;

/**
 * 접속기록관리 서비스
 * @author sichoi
 */
public interface IndvdlinfoAccesLogService{
	
	/**
	 * 사용메뉴목록조회
	 * @return List<MenuInfoVO>
	 * @throws SQLException
	 */
	public List<MenuInfoVO> selectMenuList() throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<IndvdlinfoAccesLogVO> 
	 * @throws SQLException 
	 */
	public List<IndvdlinfoAccesLogVO> selectIndvdlinfoAccesLogList(IndvdlinfoAccesLogVO vo) throws SQLException;

	/**
	 * 목록조회 - 엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectIndvdlinfoAccesLogListXls(IndvdlinfoAccesLogVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return IndvdlinfoAccesLogVO 
	 * @throws SQLException 
	 */
	public IndvdlinfoAccesLogVO selectIndvdlinfoAccesLogView(IndvdlinfoAccesLogVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertIndvdlinfoAccesLog(IndvdlinfoAccesLogVO vo, HttpServletRequest req) throws SQLException;
	
	/**
	 * 등록
	 * @param list
	 * @param req
	 * @throws SQLException
	 */
	public void insertIndvdlinfoAccesLog(List<?> list, HttpServletRequest req) throws SQLException;

}
