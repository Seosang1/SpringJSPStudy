package kr.or.cwma.skill.userSnsAuthor.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.skill.userSnsAuthor.mapper.UserSnsAuthorMapper;
import kr.or.cwma.skill.userSnsAuthor.service.UserSnsAuthorService;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;

/**
 * 회원 SNS 인증 비지니스 로직
 */
@Service
public class UserSnsAuthorServiceImpl implements UserSnsAuthorService{
	@Autowired
	UserSnsAuthorMapper userSnsAuthorMapper;

	@Override
	public List<UserSnsAuthorVO> selectUserSnsAuthorList(UserSnsAuthorVO vo) throws SQLException {
		return userSnsAuthorMapper.selectUserSnsAuthorList(vo);
	}

	@Override
	public UserSnsAuthorVO selectUserSnsAuthorView(UserSnsAuthorVO vo) throws SQLException {
		return userSnsAuthorMapper.selectUserSnsAuthorView(vo);
	}

	@Override
	public int insertUserSnsAuthor(UserSnsAuthorVO vo) throws SQLException {
		return userSnsAuthorMapper.insertUserSnsAuthor(vo);
	}

	@Override
	public int deleteUserSnsAuthor(UserSnsAuthorVO vo) throws SQLException {
		return userSnsAuthorMapper.deleteUserSnsAuthor(vo);
	}
}
