package kr.or.cwma.admin.gradStdr.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.gradStdr.vo.GradStdrVO;

/**
 * 등급기준관리 매퍼
 * @author sichoi
 */
@Repository
public interface GradStdrMapper{

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
