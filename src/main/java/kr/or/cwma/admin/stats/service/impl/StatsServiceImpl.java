package kr.or.cwma.admin.stats.service.impl;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.stats.mapper.StatsMapper;
import kr.or.cwma.admin.stats.service.StatsService;
import kr.or.cwma.admin.stats.vo.ClmserEduStatsVO;
import kr.or.cwma.admin.stats.vo.GradStatsVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

@Service
public class StatsServiceImpl implements StatsService{

	@Autowired
	private StatsMapper statsMapper;

	@Override
	public List<Map<String, Object>> selectUserStatsList(UserInfoVO vo) throws SQLException{
		return statsMapper.selectUserStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectUserAreaStatsList(UserInfoVO vo) throws SQLException{
		return statsMapper.selectUserAreaStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectUserStatsListXls(UserInfoVO vo) throws SQLException{
		return statsMapper.selectUserStatsListXls(vo);
	}

	@Override
	public List<Map<String, Object>> selectUserAreaStatsListXls(UserInfoVO vo) throws SQLException{
		return statsMapper.selectUserAreaStatsListXls(vo);
	}
	
	@Override
	public List<GradStatsVO> selectCrtfIssuStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectCrtfIssuStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectCrtfIssuStatsListXls(GradStatsVO vo) throws SQLException {
		return statsMapper.selectCrtfIssuStatsListXls(vo);
	}
	
	@Override
	public List<GradStatsVO> selectCrtfIssuSptStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectCrtfIssuSptStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectCrtfIssuSptStatsListXls(GradStatsVO vo) throws SQLException {
		return statsMapper.selectCrtfIssuSptStatsListXls(vo);
	}
	
	@Override
	public List<GradStatsVO> selectCrtfIssuAgeStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectCrtfIssuAgeStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectCrtfIssuAgeStatsListXls(GradStatsVO vo) throws SQLException {
		return statsMapper.selectCrtfIssuAgeStatsListXls(vo);
	}

	@Override
	public List<GradStatsVO> selectGradAgeGenderStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAgeGenderStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectGradAgeGenderStatsListXls(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAgeGenderStatsListXls(vo);
	}

	@Override
	public List<GradStatsVO> selectGradAgeGradStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAgeGradStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectGradAgeGradStatsListXls(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAgeGradStatsListXls(vo);
	}

	@Override
	public List<GradStatsVO> selectGradAreaGenderStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAreaGenderStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectGradAreaGenderStatsListXls(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAreaGenderStatsListXls(vo);
	}

	@Override
	public List<GradStatsVO> selectGradAreaGradStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAreaGradStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectGradAreaGradStatsListXls(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradAreaGradStatsListXls(vo);
	}

	@Override
	public List<GradStatsVO> selectGradQuarterStatsList(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradQuarterStatsList(vo);
	}

	@Override
	public List<Map<String, Object>> selectGradQuarterStatsListXls(GradStatsVO vo) throws SQLException{
		return statsMapper.selectGradQuarterStatsListXls(vo);
	}
	
	public List<ClmserEduStatsVO> selectClmserEduStatsList(ClmserEduStatsVO vo) throws SQLException{
		vo.setTotalCnt(statsMapper.selectClmserEduStatsListCnt(vo));
		return statsMapper.selectClmserEduStatsList(vo);
	}
	
	public List<Map<String, Object>> selectClmserEduStatsListXls(ClmserEduStatsVO vo) throws SQLException{
		return statsMapper.selectClmserEduStatsListXls(vo);
	}
}
