package kr.or.cwma.admin.clmserEdu.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.clmserEdu.mapper.ClmserEduMapper;
import kr.or.cwma.admin.clmserEdu.service.ClmserEduService;
import kr.or.cwma.admin.clmserEdu.vo.ClmserEduVO;
import kr.or.cwma.admin.clmserEdu.vo.UserClmserEduRelVO;
import kr.or.cwma.common.service.AttchFileInfoService;

/**
 * 맞춤형교육 비지니스로직
 * @author sichoi
 */
@Service
public class ClmserEduServiceImpl implements ClmserEduService{

	@Autowired
	private ClmserEduMapper clmserEduMapper;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;


	public List<ClmserEduVO> selectClmserEduList(ClmserEduVO vo) throws SQLException{
		vo.setTotalCnt(clmserEduMapper.selectClmserEduListCnt(vo));
		return clmserEduMapper.selectClmserEduList(vo);
	}

	public ClmserEduVO selectClmserEduView(ClmserEduVO vo) throws SQLException{
		return clmserEduMapper.selectClmserEduView(vo);
	}

	public void insertClmserEdu(ClmserEduVO vo) throws SQLException{
		clmserEduMapper.insertClmserEdu(vo);
	}

	public void updateClmserEdu(ClmserEduVO vo) throws SQLException{
		clmserEduMapper.updateClmserEdu(vo);
	}

	public void deleteClmserEdu(ClmserEduVO vo) throws SQLException{
		clmserEduMapper.deleteClmserEdu(vo);
	}

	@Override
	public void insertUserClmserEduRel(UserClmserEduRelVO vo) throws SQLException{
		clmserEduMapper.insertUserClmserEduRel(vo);
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSn(), "ATCH0012");
	}

	@Override
	public UserClmserEduRelVO selectUserClmserEduRelView(UserClmserEduRelVO vo) throws SQLException{
		return clmserEduMapper.selectUserClmserEduRelView(vo);
	}
	
	
}
