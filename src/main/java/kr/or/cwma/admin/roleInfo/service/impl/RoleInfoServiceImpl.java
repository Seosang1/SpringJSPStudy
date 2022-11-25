package kr.or.cwma.admin.roleInfo.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.roleInfo.mapper.RoleInfoMapper;
import kr.or.cwma.admin.roleInfo.service.RoleInfoService;
import kr.or.cwma.admin.roleInfo.vo.AuthorRoleRelateVO;
import kr.or.cwma.admin.roleInfo.vo.RoleInfoVO;

/**
 * 역할정보 비지니스로직
 * @author sichoi
 */
@Service
public class RoleInfoServiceImpl implements RoleInfoService{

	@Autowired
	private RoleInfoMapper roleInfoMapper;

	public List<RoleInfoVO> selectRoleInfoList(RoleInfoVO vo) throws SQLException{
		return roleInfoMapper.selectRoleInfoList(vo);
	}

	public RoleInfoVO selectRoleInfoView(RoleInfoVO vo) throws SQLException{
		return roleInfoMapper.selectRoleInfoView(vo);
	}

	public void insertRoleInfo(RoleInfoVO vo) throws SQLException{
		roleInfoMapper.insertRoleInfo(vo);
	}

	public void updateRoleInfo(RoleInfoVO vo) throws SQLException{
		roleInfoMapper.updateRoleInfo(vo);
	}

	public void deleteRoleInfo(RoleInfoVO vo) throws SQLException{
		roleInfoMapper.deleteRoleInfo(vo);
	}

	@Override
	public List<AuthorRoleRelateVO> selectAuthorRoleRelateList(RoleInfoVO vo) throws SQLException{
		return roleInfoMapper.selectAuthorRoleRelateList(vo);
	}

	@Override
	public void updateAuthorRoleRelate(RoleInfoVO vo) throws SQLException{
		roleInfoMapper.deleteAuthorRoleRelate(vo);
		
		if(vo.getRelateVO() != null){
			for(AuthorRoleRelateVO rvo:vo.getRelateVO()){
				rvo.setRoleSn(vo.getRoleSn());
				roleInfoMapper.insertAuthorRoleRelate(rvo);
			}
		}
	}

}
