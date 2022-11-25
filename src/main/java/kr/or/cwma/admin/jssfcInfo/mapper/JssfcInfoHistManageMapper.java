package kr.or.cwma.admin.jssfcInfo.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoHistManageVO;

@Repository
public interface JssfcInfoHistManageMapper{

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
