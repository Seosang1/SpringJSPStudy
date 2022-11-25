package kr.or.cwma.common.service.impl;
import java.io.File;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.common.mapper.AttchFileInfoMapper;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 첨부파일정보 비지니스로직
 * @author sichoi
 */
@Service
public class AttchFileInfoServiceImpl implements AttchFileInfoService{

	@Autowired
	private AttchFileInfoMapper attchFileInfoMapper;

	public List<AttchFileInfoVO> selectAttchFileInfoList(AttchFileInfoVO vo) throws SQLException{
		return attchFileInfoMapper.selectAttchFileInfoList(vo);
	}

	public AttchFileInfoVO selectAttchFileInfo(AttchFileInfoVO vo) throws SQLException{
		AttchFileInfoVO ret = null;
		List<AttchFileInfoVO> list = attchFileInfoMapper.selectAttchFileInfoList(vo);

		if(list != null)
			ret = list.get(0);

		return ret;
	}

	public void insertAttchFileInfo(List<AttchFileInfoVO> fvo) throws SQLException{
		for(AttchFileInfoVO eo : fvo)
			attchFileInfoMapper.insertAttchFileInfo(eo);
	}

	public void insertAttchFileInfo(List<AttchFileInfoVO> vo, long parntsSn, String parntsSe) throws SQLException{
		if(vo != null){
			for(AttchFileInfoVO eo : vo){
				eo.setParntsSn(parntsSn);
				eo.setParntsSe(parntsSe);
				attchFileInfoMapper.insertAttchFileInfo(eo);
			}
		}
	}

	public void deleteAttchFileInfo(AttchFileInfoVO vo) throws SQLException{
		File file;
		List<AttchFileInfoVO> list = attchFileInfoMapper.selectAttchFileInfoList(vo);

		if(list != null){
			for(AttchFileInfoVO eo : list){
				file = new File(eo.getPath());

				if(file.exists())
					file.delete();

				attchFileInfoMapper.deleteAttchFileInfo(eo);
			}
		}
	}


	public void deleteAttchFileInfoList(List<AttchFileInfoVO> list) throws SQLException{
		if(list != null)
			for(AttchFileInfoVO eo : list)
				deleteAttchFileInfo(eo);
	}

	@Override
	public void insertAttchFileInfo(AttchFileInfoVO fvo) throws SQLException {
		attchFileInfoMapper.insertAttchFileInfo(fvo);
	}

}
