package kr.or.cwma.admin.careerStdr.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.careerStdr.vo.CareerStdrVO;

/**
 * 경력기준관리 매퍼
 * @author sichoi
 */
@Repository
public interface CareerStdrMapper{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<CareerStdrVO> 
	 * @throws SQLException 
	 */
	public List<CareerStdrVO> selectCareerStdrList(CareerStdrVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return CareerStdrVO 
	 * @throws SQLException 
	 */
	public CareerStdrVO selectCareerStdrView(CareerStdrVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertCareerStdr(CareerStdrVO vo) throws SQLException;

}
