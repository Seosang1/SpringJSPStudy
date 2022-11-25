package kr.or.cwma.skill.common.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.banner.vo.BannerVO;
import kr.or.cwma.admin.popup.vo.PopupVO;
import kr.or.cwma.skill.common.vo.CommonVO;

/**
 * 사용자공통 서비스
 * @author sichoi
 */
public interface CommonService{

	/**
	 * 배너목록조회
	 * @param vo
	 * @throws SQLException
	 * @return List<BannerVO>
	 */
	public List<BannerVO> selectBannerList(BannerVO vo) throws SQLException;
	

	/**
	 * 팝업목록조회
	 * @throws SQLException
	 * @return List<BannerVO>
	 */
	public List<PopupVO> selectPopupList() throws SQLException;
	
	/**
	 * 방문회원 추가
	 * @throws SQLException
	 * @return List<BannerVO>
	 */
	public int insertVisitInfo(CommonVO vo) throws SQLException;
	
	/**
	 * 방문회원 조회
	 * @throws SQLException
	 * @return List<CommonVO>
	 */
	public int selectCountVisitInfo(CommonVO vo) throws SQLException;
	
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
