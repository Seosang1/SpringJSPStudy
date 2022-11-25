package kr.or.cwma.admin.jssfcInfo.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.jssfcInfo.mapper.JssfcInfoHistManageMapper;
import kr.or.cwma.admin.jssfcInfo.mapper.JssfcInfoHistMapper;
import kr.or.cwma.admin.jssfcInfo.service.JssfcInfoHistManageService;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoHistManageVO;
import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;

@Service
public class JssfcInfoHistManageServiceImpl implements JssfcInfoHistManageService{

	@Autowired
	private JssfcInfoHistManageMapper jssfcInfoHistManageMapper;
	
	@Autowired
	private JssfcInfoHistMapper jssfcInfoHistMapper;

	public List<JssfcInfoHistManageVO> selectJssfcInfoHistManageList(JssfcInfoHistManageVO vo) throws SQLException{
		return jssfcInfoHistManageMapper.selectJssfcInfoHistManageList(vo);
	}

	public void insertJssfcInfoHistManage(JssfcInfoHistManageVO vo) throws SQLException{
		jssfcInfoHistManageMapper.insertJssfcInfoHistManage(vo);
		
		for(JssfcInfoVO jvo : vo.getJssfcInfoVO()){
			jvo.setSn(vo.getSn());
			jssfcInfoHistMapper.insertJssfcInfoHist(jvo);
		}
	}
}
