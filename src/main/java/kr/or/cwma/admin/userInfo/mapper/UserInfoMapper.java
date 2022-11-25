package kr.or.cwma.admin.userInfo.mapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.userInfo.vo.UserCareerVO;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;

@Repository
public interface UserInfoMapper{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<UserInfoVO> 
	 * @throws SQLException 
	 */
	public int selectUserInfoListCnt(UserInfoVO vo) throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<UserInfoVO> 
	 * @throws SQLException 
	 */
	public List<UserInfoVO> selectUserInfoList(UserInfoVO vo) throws SQLException;

	/**
	 * 목록조회 - 엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserInfoListXls(UserInfoVO vo) throws SQLException;

	/**
	 * 목록갯수조회 - 개인
	 * @param vo 
	 * @return List<UserInfoVO> 
	 * @throws SQLException 
	 */
	public int selectPersonalUserInfoListCnt(UserInfoVO vo) throws SQLException;

	/**
	 * 목록조회 - 개인
	 * @param vo 
	 * @return List<UserMainJssfcVO> 
	 * @throws SQLException 
	 */
	public List<UserMainJssfcVO> selectPersonalUserInfoList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 목록조회 - 개인엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectPersonalUserInfoListXls(UserInfoVO vo) throws SQLException;
	
	/**
	 * 개인회원 고용정보 상용이력 조회
	 * @param vo 
	 * @return List<UserCareerVO> 
	 * @throws SQLException 
	 */
	public List<UserCareerVO> selectPersonalUserCmclList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 개인회원 고용정보 일용이력 조회
	 * @param vo 
	 * @return List<UserCareerVO> 
	 * @throws SQLException 
	 */
	public List<UserCareerVO> selectPersonalUserDlyList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 개인회원 자격정보 조회
	 * @param vo 
	 * @return List<UserCareerVO> 
	 * @throws SQLException 
	 */
	public List<UserCareerVO> selectPersonalUserLicenseList(UserInfoVO vo) throws SQLException;

	/**
	 * 개인회원 교육정보 조회
	 * @param vo 
	 * @return List<UserCareerVO> 
	 * @throws SQLException 
	 */
	public List<UserCareerVO> selectPersonalUserEduList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 개인회원 포상이력 조회
	 * @param vo 
	 * @return List<UserCareerVO> 
	 * @throws SQLException 
	 */
	public List<UserCareerVO> selectPersonalUserRewardList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 상세조회 - 개인
	 * @param vo 
	 * @return UserMainJssfcVO 
	 * @throws SQLException 
	 */
	public UserMainJssfcVO selectPersonalUserInfoView(UserInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return UserInfoVO 
	 * @throws SQLException 
	 */
	public UserInfoVO selectUserInfoView(UserInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertUserInfo(UserInfoVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateUserInfo(UserInfoVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteUserInfo(UserInfoVO vo) throws SQLException;
	
	/**
	 * 상담내역 목록조회
	 * @param vo 
	 * @return List<UserCnsltHistVO> 
	 * @throws SQLException 
	 */
	public List<UserCnsltHistVO> selectUserCnsltHistList(UserCnsltHistVO vo) throws SQLException;
	
	/**
	 * 상담내역 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertUserCnsltHist(UserCnsltHistVO vo) throws SQLException;
	
	/**
	 * 민원상담 신피공제자번호 조회
	 * @param vo 
	 * @return List<CmmnCdVO> 
	 * @throws SQLException 
	 */
	public List<CmmnCdVO> selectUserCnsltDdcerSnList(UserInfoVO vo) throws SQLException;

	/**
	 * 민원상담 대상코드 조회
	 * @return List<CmmnCdVO> 
	 * @throws SQLException 
	 */
	public List<CmmnCdVO> selectUserCnsltHistTrgtList() throws SQLException;

	/**
	 * 민원상담 구분코드 조회
	 * @param vo 
	 * @return List<CmmnCdVO> 
	 * @throws SQLException 
	 */
	public List<CmmnCdVO> selectUserCnsltHistSeList() throws SQLException;

}
