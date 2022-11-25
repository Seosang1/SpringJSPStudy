package kr.or.cwma.admin.clmserEdu.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.clmserEdu.vo.ClmserEduVO;
import kr.or.cwma.admin.clmserEdu.vo.UserClmserEduRelVO;

/**
 * 맞춤형교육 서비스
 * @author sichoi
 */
public interface ClmserEduService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<ClmserEduVO> 
	 * @throws SQLException 
	 */
	public List<ClmserEduVO> selectClmserEduList(ClmserEduVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return ClmserEduVO 
	 * @throws SQLException 
	 */
	public ClmserEduVO selectClmserEduView(ClmserEduVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertClmserEdu(ClmserEduVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateClmserEdu(ClmserEduVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteClmserEdu(ClmserEduVO vo) throws SQLException;
	
	/**
	 * 사용자관계 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertUserClmserEduRel(UserClmserEduRelVO vo) throws SQLException;
	
	/**
	 * 사용자관계 조회
	 * @param vo 
	 * @throws SQLException 
	 */
	public UserClmserEduRelVO selectUserClmserEduRelView(UserClmserEduRelVO vo) throws SQLException;

}
