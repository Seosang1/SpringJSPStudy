package kr.or.cwma.admin.banner.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.banner.vo.BannerVO;

public interface BannerService{

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
	 * @throws IOException
	 */
	public void insertBanner(BannerVO vo) throws SQLException, IOException;

	/**
	 * 수정
	 * @param vo
	 * @throws SQLException
	 * @throws IOException
	 */
	public void updateBanner(BannerVO vo) throws SQLException, IOException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteBanner(BannerVO vo) throws SQLException;

}
