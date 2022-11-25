package kr.or.cwma.admin.authorInfo.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.authorInfo.vo.AuthorInfoVO;
import kr.or.cwma.admin.authorInfo.vo.MenuAuthorRelateVO;

/**
 * 권한정보 매퍼
 * @author sichoi
 */
@Repository
public interface AuthorInfoMapper{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<AuthorInfoVO> 
	 * @throws SQLException 
	 */
	public List<AuthorInfoVO> selectAuthorInfoList(AuthorInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return AuthorInfoVO 
	 * @throws SQLException 
	 */
	public AuthorInfoVO selectAuthorInfoView(AuthorInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertAuthorInfo(AuthorInfoVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateAuthorInfo(AuthorInfoVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteAuthorInfo(AuthorInfoVO vo) throws SQLException;
	
	/**
	 * 메뉴권한관계 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertMenuAuthorRelate(MenuAuthorRelateVO vo) throws SQLException;
	
	/**
	 * 메뉴권한관계 삭제
	 * @param vo
	 * @throws SQLException
	 */
	public void deleteMenuAuthorRelate(AuthorInfoVO vo) throws SQLException;
	
	/**
	 * 메뉴권한관계 목록 조회
	 * @param vo
	 * @return List<MenuAuthorRelateVO>
	 * @throws SQLException
	 */
	public List<MenuAuthorRelateVO> selectMenuAuthorRelateList(MenuAuthorRelateVO vo) throws SQLException;

}
