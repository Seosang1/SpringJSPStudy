package kr.or.cwma.admin.admin.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.admin.vo.AdminVO;

/**
 * 관리자 매퍼
 * @author sichoi
 */
@Repository
public interface AdminMapper{

	/**
	 * 관리자 목록갯수 조회
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int selectAdminListCnt(AdminVO vo) throws SQLException;

	/**
	 * 관리자 목록조회
	 * @param vo
	 * @return List<AdminVO>
	 * @throws SQLException
	 */
	public List<AdminVO> selectAdminList(AdminVO vo) throws SQLException;

	/**
	 * 관리자 상세조회
	 * @param vo
	 * @return AdminVO
	 * @throws SQLException
	 */
	public AdminVO selectAdminView(AdminVO vo) throws SQLException;

	/**
	 * 관리자 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertAdmin(AdminVO vo) throws SQLException;

	/**
	 * 관리자 수정
	 * @param vo
	 * @throws SQLException
	 */
	public void updateAdmin(AdminVO vo) throws SQLException;

	/**
	 * 관리자 삭제
	 * @param vo
	 * @throws SQLException
	 */
	public void deleteAdmin(AdminVO vo) throws SQLException;

}
