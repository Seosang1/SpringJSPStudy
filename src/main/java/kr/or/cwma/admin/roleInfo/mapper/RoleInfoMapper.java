package kr.or.cwma.admin.roleInfo.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.roleInfo.vo.AuthorRoleRelateVO;
import kr.or.cwma.admin.roleInfo.vo.RoleInfoVO;

/**
 * 역할정보 매퍼
 * @author sichoi
 */
@Repository
public interface RoleInfoMapper{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<RoleInfoVO> 
	 * @throws SQLException 
	 */
	public List<RoleInfoVO> selectRoleInfoList(RoleInfoVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return RoleInfoVO 
	 * @throws SQLException 
	 */
	public RoleInfoVO selectRoleInfoView(RoleInfoVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertRoleInfo(RoleInfoVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateRoleInfo(RoleInfoVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteRoleInfo(RoleInfoVO vo) throws SQLException;
	
	/**
	 * 권한관계 목록
	 * @param vo
	 * @return List<AuthorRoleRelateVO>
	 * @throws SQLException
	 */
	public List<AuthorRoleRelateVO> selectAuthorRoleRelateList(RoleInfoVO vo) throws SQLException;

	/**
	 * 권한관계 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertAuthorRoleRelate(AuthorRoleRelateVO vo) throws SQLException;

	/**
	 * 권한관계 삭제
	 * @param vo
	 * @throws SQLException
	 */
	public void deleteAuthorRoleRelate(RoleInfoVO vo) throws SQLException;


}
