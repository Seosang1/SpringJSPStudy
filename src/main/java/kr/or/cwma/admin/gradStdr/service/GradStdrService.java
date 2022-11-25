package kr.or.cwma.admin.gradStdr.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.gradStdr.vo.GradStdrVO;

/**
 * 등급기준관리 서비스
 * @author sichoi
 */
public interface GradStdrService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<GradStdrVO> 
	 * @throws SQLException 
	 */
	public List<GradStdrVO> selectGradStdrList(GradStdrVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return GradStdrVO 
	 * @throws SQLException 
	 */
	public GradStdrVO selectGradStdrView(GradStdrVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertGradStdr(GradStdrVO vo) throws SQLException;

}
