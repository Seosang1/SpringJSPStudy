package kr.or.cwma.skill.userSnsAuthor.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;

/**
 * 회원 SNS 인증 서비스
 */
public interface UserSnsAuthorService{

	/**
	 * 회원 SNS 인증 목록조회
	 * @param vo
	 * @return List<UserSnsAuthorVO>
	 * @throws SQLException
	 */
	public List<UserSnsAuthorVO> selectUserSnsAuthorList(UserSnsAuthorVO vo) throws SQLException;
	
	/**
	 * 회원 SNS 인증 상세조회
	 * @param vo
	 * @return UserSnsAuthorVO
	 * @throws SQLException
	 */
	public UserSnsAuthorVO selectUserSnsAuthorView(UserSnsAuthorVO vo) throws SQLException;
	
	/**
	 * SNS 인증 등록
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int insertUserSnsAuthor(UserSnsAuthorVO vo) throws SQLException;
	
	/**
	 * SNS 인증 삭제
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int deleteUserSnsAuthor(UserSnsAuthorVO vo) throws SQLException;

}
