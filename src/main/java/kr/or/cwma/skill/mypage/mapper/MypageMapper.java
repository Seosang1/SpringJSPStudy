package kr.or.cwma.skill.mypage.mapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswerVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;
import kr.or.cwma.skill.mypage.vo.CorpCrtfIssuVO;

/**
 * 마이페이지 매퍼
 * @author sichoi
 */
@Repository
public interface MypageMapper{

	/**
	 * 온라인상담내역 상세조회
	 * @param vo
	 * @return BbsVO
	 * @throws SQLException
	 */
	public BbsVO selectQnaView(BbsVO vo) throws SQLException;
	
	/**
	 * 비밀번호 변경
	 * @param vo
	 * @throws SQLException
	 */
	public void updateUserPassword(UserInfoVO vo) throws SQLException;
	
	/**
	 * 주민번호 변경
	 * @param vo
	 * @throws SQLException
	 */
	public void updateUserIhidnum(UserInfoVO vo) throws SQLException;
	
	/**
	 * 회원근무일수 조회
	 * @param vo
	 * @return List<UserMainJssfcVO>
	 * @throws SQLException
	 */
	public List<UserMainJssfcVO> selectUserWorkDay(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 기능인기본정보 조회
	 * @param vo
	 * @return Map<String, String>
	 * @throws SQLException
	 */
	public Map<String, String> selectUserBasicInfo(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 사업주/대리인 기본정보 - 직종별, 등급별 인원조회
	 * @param vo
	 * @return List<Map<String, String>>
	 * @throws SQLException
	 */
	public List<Map<String, String>> selectGradList(UserInfoVO vo) throws SQLException;

	/**
	 * 마이페이지 사업주/대리인 기본정보 - 공사목록 조회 카운트
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int selectCntrctListCnt(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 사업주/대리인 기본정보 - 공사목록 조회
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectCntrctList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 수요기관 기본정보 - 직종별, 등급별 인원조회
	 * @param vo
	 * @return List<Map<String, String>>
	 * @throws SQLException
	 */
	public List<Map<String, String>> selectGradListForDminstt(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 수요기관 기본정보 - 공사목록 조회 카운트
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int selectCntrctListForDminsttCnt(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 수요기관 기본정보 - 공사목록 조회
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectCntrctListForDminstt(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 소속 공사 리스트 카운트
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public int selectCrtfIssuConsListCnt(CorpCrtfIssuVO vo) throws SQLException;
	
	/**
	 * 마이페이지 소속 공사 리스트
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CorpCrtfIssuVO> selectCrtfIssuConsList(CorpCrtfIssuVO vo) throws SQLException;
	
	/**
	 * 마이페이지 소속기능인관리 공사정보
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public CorpCrtfIssuVO selectCrtfIssuConsMenInfo(CorpCrtfIssuVO vo) throws SQLException;
	
	/**
	 * 마이페이지 소속기능인관리 등급카운트
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public Map<String, Object> selectCrtfIssuConsMenStaticInfo(CorpCrtfIssuVO vo) throws SQLException;

	/**
	 * 마이페이지 소속기능인 리스트 카운트
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public int selectCrtfIssuConsMenListCnt(CorpCrtfIssuVO vo) throws SQLException;
	
	/**
	 * 마이페이지 소속기능인 리스트
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CorpCrtfIssuVO> selectCrtfIssuConsMenList(CorpCrtfIssuVO vo) throws SQLException;
	
	/**
	 * 맞춤형교육 설문 답변자 등록
	 * @param vo
	 * @throws SQLException 
	 */
	public void insertClmserEduSurveyAnswrr(SurveyAnswrrVO vo) throws SQLException;	

	/**
	 * 맞춤형교육 설문 답변 등록
	 * @param vo
	 * @throws SQLException 
	 */
	public void insertClmserEduSurveyAnswer(SurveyAnswerVO vo) throws SQLException;

	/**
	 * 마이페이지 사업주/대리인 기본정보 - 공사상세 조회(퇴직공제)
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public CntrctInfoVO selectCntrctInfo(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 사업주/대리인 기본정보 - 공사상세 조회(고용보험)
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public CntrctInfoVO selectCntrctWorkInfo(UserInfoVO vo) throws SQLException;
	
}
