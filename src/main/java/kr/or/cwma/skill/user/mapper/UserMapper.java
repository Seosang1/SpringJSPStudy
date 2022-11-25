package kr.or.cwma.skill.user.mapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.DminsttInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserCntrctRelateVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

/**
 * 회원 매퍼
 * @author sichoi
 */
@Repository
public interface UserMapper{

	/**
	 * 공동인증서 OID 조회
	 * @param oid
	 * @return Map<String, String> 
	 * @throws SQLException 
	 */
	public Map<String, String> selectOid(String oid) throws SQLException;

	/**
	 * 중복가입 조회
	 * @param vo
	 * @return UserInfoVO
	 * @throws SQLException
	 */
	public UserInfoVO selectJoinUser(UserInfoVO vo) throws SQLException;

	/**
	 * 업체정보 조회
	 * @param vo
	 * @return CorpInfoVO
	 * @throws SQLException
	 */
	public CorpInfoVO selectCorpInfo(UserInfoVO vo) throws SQLException;

	/**
	 * 수요기관정보 조회
	 * @param vo
	 * @return DminsttInfoVO
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
	 * 사용자공사관계(대리인 관리공사) 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertUserCntrctRelate(UserCntrctRelateVO vo) throws SQLException;
	
	/**
	 * 마지막 로그인일시 변경
	 * @param vo
	 * @throws SQLException
	 */
	public void updateUserLoginDt(UserInfoVO vo) throws SQLException;
	
	/**
	 * 비밀번호 변경
	 * @param vo
	 * @throws SQLException
	 */
	public void updateUserPassword(UserInfoVO vo) throws SQLException;

	/**
	 * 회원 가입이력 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void updateUserMainJssfcJoinAt(UserInfoVO vo) throws SQLException;
	
}
