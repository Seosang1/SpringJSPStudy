package kr.or.cwma.admin.dataCmmnCd.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.dataCmmnCd.mapper.DataCmmnCdMapper;
import kr.or.cwma.admin.dataCmmnCd.service.DataCmmnCdService;
import kr.or.cwma.admin.dataCmmnCd.vo.DataCmmnCdVO;

/**
 * 코드관리 비지니스로직
 * @author sichoi
 */
@Service
public class DataCmmnCdServiceImpl implements DataCmmnCdService{

	@Autowired
	private DataCmmnCdMapper dataCmmnCdMapper;

	public List<DataCmmnCdVO> selectCmmnCdList(DataCmmnCdVO vo) throws SQLException{
		vo.setTotalCnt(dataCmmnCdMapper.selectCmmnCdListCnt(vo));
		return dataCmmnCdMapper.selectCmmnCdList(vo);
	}
	
	public List<DataCmmnCdVO> selectCmmnCdChildList(String parntsCdId) throws SQLException{
		DataCmmnCdVO vo = new DataCmmnCdVO();
		vo.seteNum(Integer.MAX_VALUE);
		vo.setParntsCdId(parntsCdId);
		return dataCmmnCdMapper.selectCmmnCdList(vo);
	}

	public DataCmmnCdVO selectCmmnCdView(DataCmmnCdVO vo) throws SQLException{
		return dataCmmnCdMapper.selectCmmnCdView(vo);
	}

	public void insertCmmnCd(DataCmmnCdVO vo) throws SQLException{
		dataCmmnCdMapper.insertCmmnCd(vo);
	}

	public void updateCmmnCd(DataCmmnCdVO vo) throws SQLException{
		dataCmmnCdMapper.updateCmmnCd(vo);
	}

	public void deleteCmmnCd(DataCmmnCdVO vo) throws SQLException{
		dataCmmnCdMapper.deleteCmmnCd(vo);
	}

}
