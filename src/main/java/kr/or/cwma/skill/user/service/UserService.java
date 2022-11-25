package kr.or.cwma.skill.user.service;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.DminsttInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

/**
 * 회원 서비스
 * @author sichoi
 */
public interface UserService{

	/**
	 * 로그인
	 * @param req
	 * @param vo
	 * @return String 
	 * @throws SQLException 
	 */
	public String login(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException;
	
	
	/**
	 * 로그인 SNS
	 * @param req
	 * @param vo
	 * @return String 
	 * @throws SQLException 
	 */
	public String snsLogin(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException;

	/**
	 * 중복가입조회
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public UserInfoVO selectJoinUser(UserInfoVO vo) throws SQLException;

	/**
	 * 업체정보 조회
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public CorpInfoVO selectCorpInfo(UserInfoVO vo) throws SQLException;

	/**
	 * 수요기관정보 조회
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public DminsttInfoVO selectDminsttInfo(UserInfoVO vo) throws SQLException;
	
	/**
	 * 대리인 공제계약목록 조회
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectDdcJoinList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 공동인증서 등록 - 사용자조회
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public UserInfoVO selectUserInfoForAddCert(UserInfoVO vo) throws SQLException;
	
	/**
	 * 공동인증서 등록
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public void updateAddCert(UserInfoVO vo) throws SQLException;
	
	/**
	 * 비밀번호 변경
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public void updateUserPassword(UserInfoVO vo) throws SQLException, NoSuchAlgorithmException;
	
	/**
	 * 사용자 등록
	 * @param vo
	 */
	public void insertUserInfo(UserInfoVO vo) throws SQLException, NoSuchAlgorithmException;

}
