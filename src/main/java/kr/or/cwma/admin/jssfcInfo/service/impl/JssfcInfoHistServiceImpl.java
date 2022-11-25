package kr.or.cwma.admin.jssfcInfo.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.jssfcInfo.mapper.JssfcInfoHistMapper;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoHistService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

@Service
public class JssfcInfoHistServiceImpl implements JssfcInfoHistService{

	@Autowired
	private JssfcInfoHistMapper jssfcInfoHistMapper;

	public List<JssfcInfoVO> selectJssfcInfoHistList(JssfcInfoVO vo) throws SQLException{
		return jssfcInfoHistMapper.selectJssfcInfoHistList(vo);
	}
	
	public JssfcInfoVO selectJssfcInfoHistView(JssfcInfoVO vo) throws SQLException{
		return jssfcInfoHistMapper.selectJssfcInfoHistView(vo);
	}

	public void insertJssfcInfoHist(JssfcInfoVO vo) throws SQLException{
		jssfcInfoHistMapper.insertJssfcInfoHist(vo);
	}
}
