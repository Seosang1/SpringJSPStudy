package kr.or.cwma.admin.common.service;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.or.cwma.admin.common.vo.CommonVO;
import kr.or.cwma.admin.common.vo.DeptVO;
import kr.or.cwma.admin.common.vo.ExcelDwldHistVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;

/**
 * 관리자 공통서비스
 * @author sichoi
 */
public interface CommonService{

	/**
	 * 사용자정보조회
	 * @param vo
	 * @return UserVO
	 * @throws SQLException
	 */
	public UserVO selectUserView(UserVO vo) throws SQLException;
	
	/**
	 * 사용자목록 조회
	 * @param vo
	 * @return List<UserVO>
	 * @throws SQLException
	 */
	public List<UserVO> selectUserList(UserVO vo) throws SQLException;
	
	/**
	 * 부서목록 조회
	 * @param vo
	 * @return List<DeptVO>
	 * @throws SQLException
	 */
	public List<DeptVO> selectDeptList(DeptVO vo) throws SQLException;
	
	/**
	 * 로그인(임시)
	 * @param req
	 * @param vo
	 * @return String
	 * @throws SQLException
	 */
	public String login(HttpServletRequest req, UserVO vo) throws SQLException;
	
	/**
	 * 사용자 메뉴목록 조회
	 * @param vo
	 * @return List<CwmaCmmnMenuInfoVO>
	 * @throws SQLException
	 */
	public List<MenuInfoVO> selectUserMenuList(UserVO vo) throws SQLException;
	
	/**
	 * 엑셀다운이력 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertExcelDwldHist(ExcelDwldHistVO vo) throws SQLException;
	
	/**
	 * 온라인상담건수 - 메인페이지
	 * @return Map<String, Object> 
	 * @throws SQLException 
	 */
	public Map<String, Object> selectQnaCnt() throws SQLException;

	/**
	 * 오늘의 방문자
	 * @return List<Map<String, Object>>
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserLoginStatsToday() throws SQLException;

	/**
	 * 유형별 방문자
	 * @return List<Map<String, Object>>
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserLoginStatsSe() throws SQLException;

	/**
	 * 발급수수료
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public Map<String, Object> selectIssueFee() throws SQLException;
	
	/**
	 * 주소별 지사구분
	 * @param cnstwkLocplcAddr
	 * @return
	 */
	public String getDdcAsctCdByCnstwkLocplcAddr(String cnstwkLocplcAddr);

	/**
	 * 결재관리 개수 조회(메인페이지)
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public Map<String, Object> selectSanctn(UserVO vo) throws SQLException;

	/**
	 * 경력인정신고
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public Map<String, Object> selectCareerDeclare1(UserVO vo) throws SQLException;
	
	/**
	 * 근로직종확인
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public Map<String, Object> selectCareerDeclare2(UserVO vo) throws SQLException;

	/**
	 * 경력인정신고 리스트
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCareerDeclare(UserVO vo) throws SQLException;
	
	/**
	 * 기능등급증명서발급현황 리스트
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCareerCrtf(UserVO vo) throws SQLException;
	
	/**
	 * 결재관리 세부매뉴 개수 조회(메인페이지)
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public Map<String, Object> selectSanctnInfo(UserVO vo) throws SQLException;
	
	/**
	 * 보유증명서발급현황 리스트
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCareerCrtf2(UserVO vo) throws SQLException;
	
	/**
	 * 방문자 수 카운트
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public int selectCountVisit(CommonVO vo) throws SQLException;
	
	/**
	 * 누적상담건수 카운트
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public int selectCountQna() throws SQLException;
}
