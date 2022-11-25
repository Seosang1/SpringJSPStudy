package kr.or.cwma.admin.authorInfo.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.authorInfo.mapper.AuthorInfoMapper;
import kr.or.cwma.admin.authorInfo.service.AuthorInfoService;
import kr.or.cwma.admin.authorInfo.vo.AuthorInfoVO;
import kr.or.cwma.admin.authorInfo.vo.MenuAuthorRelateVO;

/**
 * 권한정보 비지니스 로직
 * @author sichoi
 */
@Service
public class AuthorInfoServiceImpl implements AuthorInfoService{

	@Autowired
	private AuthorInfoMapper authorInfoMapper;

	public List<AuthorInfoVO> selectAuthorInfoList(AuthorInfoVO vo) throws SQLException{
		return authorInfoMapper.selectAuthorInfoList(vo);
	}

	public AuthorInfoVO selectAuthorInfoView(AuthorInfoVO vo) throws SQLException{
		return authorInfoMapper.selectAuthorInfoView(vo);
	}

	public void insertAuthorInfo(AuthorInfoVO vo) throws SQLException{
		authorInfoMapper.insertAuthorInfo(vo);
	}

	public void updateAuthorInfo(AuthorInfoVO vo) throws SQLException{
		authorInfoMapper.updateAuthorInfo(vo);
	}

	public void deleteAuthorInfo(AuthorInfoVO vo) throws SQLException{
		authorInfoMapper.deleteAuthorInfo(vo);
	}

	@Override
	public void updateMenuAuthorRelate(AuthorInfoVO vo) throws SQLException{
		authorInfoMapper.deleteMenuAuthorRelate(vo);
		
		for(MenuAuthorRelateVO rvo : vo.getRelateVO()){
			rvo.setAuthorCd(vo.getAuthorCd());
			authorInfoMapper.insertMenuAuthorRelate(rvo);
		}
	}

	@Override
	public List<MenuAuthorRelateVO> selectMenuAuthorRelateList(MenuAuthorRelateVO vo) throws SQLException{
		return authorInfoMapper.selectMenuAuthorRelateList(vo);
	}

}
