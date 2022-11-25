package kr.or.cwma.admin.jssfcInfo.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

/**
 * 직종정보 서비스
 * @author sichoi
 */
public interface JssfcInfoService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<JssfcInfoVO> 
	 * @throws SQLException 
	 */
	public List<JssfcInfoVO> selectJssfcInfoList(JssfcInfoVO vo) throws SQLException;

}
