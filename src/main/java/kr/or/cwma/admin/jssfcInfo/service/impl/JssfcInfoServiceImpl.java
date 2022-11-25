package kr.or.cwma.admin.jssfcInfo.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.jssfcInfo.mapper.JssfcInfoMapper;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

/**
 * 직종정보 비지니스 로직
 * @author sichoi
 */
@Service
public class JssfcInfoServiceImpl implements JssfcInfoService{

	@Autowired
	private JssfcInfoMapper jssfcInfoMapper;

	public List<JssfcInfoVO> selectJssfcInfoList(JssfcInfoVO vo) throws SQLException{
		return jssfcInfoMapper.selectJssfcInfoList(vo);
	}

}
