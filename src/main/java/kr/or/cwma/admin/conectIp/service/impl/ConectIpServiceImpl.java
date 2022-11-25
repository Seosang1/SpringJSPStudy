package kr.or.cwma.admin.conectIp.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.conectIp.mapper.ConectIpMapper;
import kr.or.cwma.admin.conectIp.service.ConectIpService;
import kr.or.cwma.admin.conectIp.vo.ConectIpVO;

/**
 * 접속IP관리 비지니스 로직
 * @author sichoi
 */
@Service
public class ConectIpServiceImpl implements ConectIpService{

	@Autowired
	private ConectIpMapper conectIpMapper;

	public int selectConectIpListCnt(ConectIpVO vo) throws SQLException{
		return conectIpMapper.selectConectIpListCnt(vo);
	}

	public List<ConectIpVO> selectConectIpList(ConectIpVO vo) throws SQLException{
		vo.setTotalCnt(conectIpMapper.selectConectIpListCnt(vo));
		return conectIpMapper.selectConectIpList(vo);
	}

	public void insertConectIp(ConectIpVO vo) throws SQLException{
		conectIpMapper.insertConectIp(vo);
	}

	public void deleteConectIp(ConectIpVO vo) throws SQLException{
		conectIpMapper.deleteConectIp(vo);
	}

}
