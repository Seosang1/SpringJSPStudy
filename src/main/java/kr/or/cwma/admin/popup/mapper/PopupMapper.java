package kr.or.cwma.admin.popup.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.popup.vo.PopupVO;

@Repository
public interface PopupMapper{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<PopupVO> 
	 * @throws SQLException 
	 */
	public int selectPopupListCnt(PopupVO vo) throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<PopupVO> 
	 * @throws SQLException 
	 */
	public List<PopupVO> selectPopupList(PopupVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return PopupVO 
	 * @throws SQLException 
	 */
	public PopupVO selectPopupView(PopupVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertPopup(PopupVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updatePopup(PopupVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deletePopup(PopupVO vo) throws SQLException;

}
