package kr.or.cwma.admin.admin.service.impl;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.admin.mapper.AdminMapper;
import kr.or.cwma.admin.admin.service.AdminService;
import kr.or.cwma.admin.admin.vo.AdminVO;
import kr.or.cwma.common.util.CryptUtil;

/**
 * 코드관리 비지니스로직
 * @author sichoi
 */
@Service
public class AdminServiceImpl implements AdminService{

	@Autowired
	private AdminMapper adminMapper;

	public List<AdminVO> selectAdminList(AdminVO vo) throws SQLException{
		vo.setTotalCnt(adminMapper.selectAdminListCnt(vo));
		return adminMapper.selectAdminList(vo);
	}
	
	public AdminVO selectAdminView(AdminVO vo) throws SQLException{
		return adminMapper.selectAdminView(vo);
	}

	public void insertAdmin(AdminVO vo) throws SQLException{
		String ps = "";
		try {
			ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		vo.setPassword(ps);
		adminMapper.insertAdmin(vo);
	}

	public void updateAdmin(AdminVO vo) throws SQLException{
		String ps = "";
		try {
			ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		vo.setPassword(ps);
		adminMapper.updateAdmin(vo);
	}

	public void deleteAdmin(AdminVO vo) throws SQLException{
		adminMapper.deleteAdmin(vo);
	}

}
