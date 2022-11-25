package kr.or.cwma.admin.cmmnCd.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.cmmnCd.mapper.CmmnCdMapper;
import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;

/**
 * 코드관리 비지니스로직
 * @author sichoi
 */
@Service
public class CmmnCdServiceImpl implements CmmnCdService{

	@Autowired
	private CmmnCdMapper cmmnCdMapper;

	public List<CmmnCdVO> selectCmmnCdList(CmmnCdVO vo) throws SQLException{
		vo.setTotalCnt(cmmnCdMapper.selectCmmnCdListCnt(vo));
		return cmmnCdMapper.selectCmmnCdList(vo);
	}
	
	public List<CmmnCdVO> selectCmmnCdChildList(String parntsCdId) throws SQLException{
		CmmnCdVO vo = new CmmnCdVO();
		vo.seteNum(Integer.MAX_VALUE);
		vo.setParntsCdId(parntsCdId);
		return cmmnCdMapper.selectCmmnCdList(vo);
	}

	public CmmnCdVO selectCmmnCdView(CmmnCdVO vo) throws SQLException{
		return cmmnCdMapper.selectCmmnCdView(vo);
	}

	public void insertCmmnCd(CmmnCdVO vo) throws SQLException{
		cmmnCdMapper.insertCmmnCd(vo);
	}

	public void updateCmmnCd(CmmnCdVO vo) throws SQLException{
		cmmnCdMapper.updateCmmnCd(vo);
	}

	public void deleteCmmnCd(CmmnCdVO vo) throws SQLException{
		cmmnCdMapper.deleteCmmnCd(vo);
	}

}
