package kr.or.cwma.admin.menuInfo.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;

/**
 * 메뉴정보 매퍼
 * @author sichoi
 */
@Repository
public interface MenuInfoMapper{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<MenuInfoVO> 
	 * @throws Exception 
	 */
	public List<MenuInfoVO> selectMenuInfoList(MenuInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return MenuInfoVO 
	 * @throws Exception 
	 */
	public MenuInfoVO selectMenuInfoView(MenuInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws Exception 
	 */
	public void insertMenuInfo(MenuInfoVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws Exception 
	 */
	public void updateMenuInfo(MenuInfoVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws Exception 
	 */
	public void deleteMenuInfo(MenuInfoVO vo) throws SQLException;
	
	/**
	 * 메뉴관리 순서변경
	 * @param vo
	 * @throws SQLException
	 */
	public void updateMenuInfoOrdr(MenuInfoVO vo) throws SQLException;

}
