package kr.or.cwma.admin.careerStdr.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.careerStdr.vo.CareerStdrVO;

/**
 * 경력기준관리 서비스
 * @author sichoi
 */
public interface CareerStdrService{

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
