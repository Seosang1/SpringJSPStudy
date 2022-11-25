package kr.or.cwma.admin.banner.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.banner.vo.BannerVO;

@Repository
public interface BannerMapper{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<BannerVO> 
	 * @throws SQLException 
	 */
	public int selectBannerListCnt(BannerVO vo) throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<BannerVO> 
	 * @throws SQLException 
	 */
	public List<BannerVO> selectBannerList(BannerVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return BannerVO 
	 * @throws SQLException 
	 */
	public BannerVO selectBannerView(BannerVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertBanner(BannerVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateBanner(BannerVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteBanner(BannerVO vo) throws SQLException;

}
