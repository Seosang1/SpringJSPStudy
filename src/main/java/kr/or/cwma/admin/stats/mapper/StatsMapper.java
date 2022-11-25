package kr.or.cwma.admin.stats.mapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.stats.vo.ClmserEduStatsVO;
import kr.or.cwma.admin.stats.vo.GradStatsVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

/**
 * 통계 매퍼
 * @author sichoi
 */
@Repository
public interface StatsMapper{

	/**
	 * 회원통계
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserStatsList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 회원통계 - 지역별
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserAreaStatsList(UserInfoVO vo) throws SQLException;

	/**
	 * 회원통계 - 엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserStatsListXls(UserInfoVO vo) throws SQLException;
	
	/**
	 * 회원통계 - 지역별 엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectUserAreaStatsListXls(UserInfoVO vo) throws SQLException;
	
	/**
	 * 등급별(직종) 증명서발급통계 
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectCrtfIssuStatsList(GradStatsVO vo) throws SQLException;
	
	/**
	 * 등급별(직종) 증명서발급통계 엑셀 
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCrtfIssuStatsListXls(GradStatsVO vo) throws SQLException;
	
	/**
	 * 등급별(신청방법) 증명서발급통계 
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectCrtfIssuSptStatsList(GradStatsVO vo) throws SQLException;
	
	/**
	 * 등급별(신청방법) 증명서발급통계 엑셀 
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCrtfIssuSptStatsListXls(GradStatsVO vo) throws SQLException;
	
	/**
	 * 연령별(신청방법) 증명서발급통계 
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectCrtfIssuAgeStatsList(GradStatsVO vo) throws SQLException;
	
	/**
	 * 연령별(신청방법) 증명서발급통계 엑셀 
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCrtfIssuAgeStatsListXls(GradStatsVO vo) throws SQLException;

	/**
	 * 연령별(성별) 등급통계 목록
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectGradAgeGenderStatsList(GradStatsVO vo) throws SQLException;

	/**
	 * 연령별(성별) 등급통계 엑셀목록
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectGradAgeGenderStatsListXls(GradStatsVO vo) throws SQLException;

	/**
	 * 연령별(등급) 등급통계 목록
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectGradAgeGradStatsList(GradStatsVO vo) throws SQLException;

	/**
	 * 연령별(등급) 등급통계 엑셀목록
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectGradAgeGradStatsListXls(GradStatsVO vo) throws SQLException;

	/**
	 * 지역별(성별) 등급통계 목록
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectGradAreaGenderStatsList(GradStatsVO vo) throws SQLException;

	/**
	 * 지역별(성별) 등급통계 엑셀목록
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectGradAreaGenderStatsListXls(GradStatsVO vo) throws SQLException;

	/**
	 * 지역별(등급) 등급통계 목록
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectGradAreaGradStatsList(GradStatsVO vo) throws SQLException;

	/**
	 * 지역별(등급) 등급통계 엑셀목록
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectGradAreaGradStatsListXls(GradStatsVO vo) throws SQLException;
	
	/**
	 * 분기별(등급) 등급통계 목록
	 * @param vo 
	 * @return List<GradStatsVO> 
	 * @throws SQLException 
	 */
	public List<GradStatsVO> selectGradQuarterStatsList(GradStatsVO vo) throws SQLException;

	/**
	 * 분기별(등급) 등급통계 엑셀목록
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectGradQuarterStatsListXls(GradStatsVO vo) throws SQLException;
	
	/**
	 * 맞춤형교육통계 목록갯수
	 * @param vo 
	 * @return int
	 * @throws SQLException 
	 */
	public int selectClmserEduStatsListCnt(ClmserEduStatsVO vo) throws SQLException;

	/**
	 * 맞춤형교육통계 목록
	 * @param vo 
	 * @return List<ClmserEduStatsVO> 
	 * @throws SQLException 
	 */
	public List<ClmserEduStatsVO> selectClmserEduStatsList(ClmserEduStatsVO vo) throws SQLException;
	
	/**
	 * 맞춤형교육통계 목록
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectClmserEduStatsListXls(ClmserEduStatsVO vo) throws SQLException;	
}
