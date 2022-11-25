package kr.or.cwma.admin.trgetRoleRelateHist.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.trgetRoleRelateHist.mapper.TrgetRoleRelateHistMapper;
import kr.or.cwma.admin.trgetRoleRelateHist.service.TrgetRoleRelateHistService;
import kr.or.cwma.admin.trgetRoleRelateHist.vo.TrgetRoleRelateHistVO;

@Service
public class TrgetRoleRelateHistServiceImpl implements TrgetRoleRelateHistService{

	@Autowired
	private TrgetRoleRelateHistMapper trgetRoleRelateHistMapper; 
	
	@Override
	public int selectTrgetRoleRelateHistListCnt(TrgetRoleRelateHistVO vo) throws SQLException {
		return trgetRoleRelateHistMapper.selectTrgetRoleRelateHistListCnt(vo);
	}

	@Override
	public List<TrgetRoleRelateHistVO> selectTrgetRoleRelateHistList(TrgetRoleRelateHistVO vo) throws SQLException {
		vo.setTotalCnt(trgetRoleRelateHistMapper.selectTrgetRoleRelateHistListCnt(vo));
		return trgetRoleRelateHistMapper.selectTrgetRoleRelateHistList(vo);
	}

}
