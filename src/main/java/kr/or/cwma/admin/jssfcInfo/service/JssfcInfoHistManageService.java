package kr.or.cwma.admin.jssfcInfo.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoHistManageVO;

public interface JssfcInfoHistManageService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<JssfcInfoHistManageVO> 
	 * @throws SQLException 
	 */
	public List<JssfcInfoHistManageVO> selectJssfcInfoHistManageList(JssfcInfoHistManageVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertJssfcInfoHistManage(JssfcInfoHistManageVO vo) throws SQLException;

}
