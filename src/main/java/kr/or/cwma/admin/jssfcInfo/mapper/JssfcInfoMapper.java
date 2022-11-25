package kr.or.cwma.admin.jssfcInfo.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

/**
 * 직종정보 매퍼
 * @author sichoi
 */
@Repository
public interface JssfcInfoMapper{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<JssfcInfoVO> 
	 * @throws SQLException 
	 */
	public List<JssfcInfoVO> selectJssfcInfoList(JssfcInfoVO vo) throws SQLException;

}
