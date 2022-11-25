package kr.or.cwma.admin.admin.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.admin.vo.AdminVO;

/**
 * 관리자 서비스
 * @author sichoi
 */
public interface AdminService{

	/**
	 * 관리자 목록조회
	 * @param vo
	 * @return List<AdminVO>
	 * @throws SQLException
	 */
	public List<AdminVO> selectAdminList(AdminVO vo) throws SQLException;


	/**
	 * 관리자 상세보기
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
