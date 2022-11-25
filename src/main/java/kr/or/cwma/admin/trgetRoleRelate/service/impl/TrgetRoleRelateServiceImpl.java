package kr.or.cwma.admin.trgetRoleRelate.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.trgetRoleRelate.mapper.TrgetRoleRelateMapper;
import kr.or.cwma.admin.trgetRoleRelate.service.TrgetRoleRelateService;
import kr.or.cwma.admin.trgetRoleRelate.vo.TrgetRoleRelateVO;

@Service
public class TrgetRoleRelateServiceImpl implements TrgetRoleRelateService{

	@Autowired
	private TrgetRoleRelateMapper trgetRoleRelateMapper;

	public List<TrgetRoleRelateVO> selectTrgetRoleRelateList(TrgetRoleRelateVO vo) throws SQLException{
		return trgetRoleRelateMapper.selectTrgetRoleRelateList(vo);
	}

	public void updateTrgetRoleRelate(TrgetRoleRelateVO vo) throws SQLException{
		for(String trget : vo.getTrgetList()){
			vo.setTrget(trget);
			trgetRoleRelateMapper.updateTrgetRoleRelate(vo);
		}
	}
	
	public void deleteTrgetRoleRelate(TrgetRoleRelateVO vo) throws SQLException{
		for(String trget : vo.getTrgetList()){
			vo.setTrget(trget);
			trgetRoleRelateMapper.deleteTrgetRoleRelate(vo);
		}
	}

}
