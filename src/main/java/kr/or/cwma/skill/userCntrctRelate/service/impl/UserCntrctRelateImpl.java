package kr.or.cwma.skill.userCntrctRelate.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.userInfo.vo.UserCntrctRelateVO;
import kr.or.cwma.skill.userCntrctRelate.mapper.UserCntrctRelateMapper;
import kr.or.cwma.skill.userCntrctRelate.service.UserCntrctRelateService;

/**
 * 회원 대리인 권한 비지니스 로직
 */
@Service
public class UserCntrctRelateImpl implements UserCntrctRelateService{
	
	@Autowired
	private UserCntrctRelateMapper userCntrctRelateMapper;

	@Override
	public List<UserCntrctRelateVO> selectUserCntrctRelateList(UserCntrctRelateVO vo) throws SQLException {
		return userCntrctRelateMapper.selectUserCntrctRelateList(vo);
	}

	@Override
	public Integer isUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException {
		return userCntrctRelateMapper.isUserCntrctRelate(vo);
	}
	
	@Override
	public UserCntrctRelateVO selectUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException {
		return userCntrctRelateMapper.selectUserCntrctRelate(vo);
	}

	@Override
	public Integer insertUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException {
		return userCntrctRelateMapper.insertUserCntrctRelate(vo);
	}

	@Override
	public Integer updateUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException {
		return userCntrctRelateMapper.updateUserCntrctRelate(vo);
	}
	
}
