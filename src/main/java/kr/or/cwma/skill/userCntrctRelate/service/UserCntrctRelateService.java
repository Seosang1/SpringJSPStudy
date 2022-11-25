package kr.or.cwma.skill.userCntrctRelate.service;

import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.userInfo.vo.UserCntrctRelateVO;

/**
 * 회원 대리인 권한 서비스
 */
public interface UserCntrctRelateService{

	/**
	 * 대리인 리스트
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<UserCntrctRelateVO> selectUserCntrctRelateList(UserCntrctRelateVO vo) throws SQLException;
	
	/**
	 * 대리인 권한 존재여부
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public Integer isUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException;
	
	/**
	 * 대리인 권한 조회
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public UserCntrctRelateVO selectUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException;
	
	/**
	 * 대리인 권한 등록
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public Integer insertUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException;
	
	/**
	 * 대리인 권한 수정
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public Integer updateUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException;
}
