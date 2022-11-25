package kr.or.cwma.admin.popup.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.popup.vo.PopupVO;

public interface PopupService{

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
	 * @throws IOException
	 */
	public void insertPopup(PopupVO vo) throws SQLException, IOException;

	/**
	 * 수정
	 * @param vo
	 * @throws SQLException
	 * @throws IOException 
	 */
	public void updatePopup(PopupVO vo) throws SQLException, IOException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deletePopup(PopupVO vo) throws SQLException;

}
