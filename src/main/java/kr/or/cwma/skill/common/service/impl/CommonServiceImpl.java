package kr.or.cwma.skill.common.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.banner.vo.BannerVO;
import kr.or.cwma.admin.popup.vo.PopupVO;
import kr.or.cwma.skill.common.mapper.CommonMapper;
import kr.or.cwma.skill.common.service.CommonService;
import kr.or.cwma.skill.common.vo.CommonVO;

/**
 * 사용자공통 비지니스 로직
 * @author sichoi
 */
@Service("skill.commonServiceImpl")
public class CommonServiceImpl implements CommonService{
	@Autowired
	private CommonMapper commonMapper;

	@Override
	public List<BannerVO> selectBannerList(BannerVO vo) throws SQLException{
		return commonMapper.selectBannerList(vo);
	}

	@Override
	public List<PopupVO> selectPopupList() throws SQLException{
		return commonMapper.selectPopupList();
	}

	@Override
	public int insertVisitInfo(CommonVO vo) throws SQLException {
		return commonMapper.insertVisitInfo(vo);
	}

	@Override
	public int selectCountVisitInfo(CommonVO vo) throws SQLException {
		return commonMapper.selectCountVisitInfo(vo);
	}
	
	@Override
	public int selectCountVisit(CommonVO vo) throws SQLException{
		return commonMapper.selectCountVisit(vo);
	}
	
	@Override
	public int selectCountQna() throws SQLException{
		return commonMapper.selectCountQna();
	}
	
}
