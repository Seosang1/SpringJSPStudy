package kr.or.cwma.admin.menuInfo.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.menuInfo.mapper.MenuInfoMapper;
import kr.or.cwma.admin.menuInfo.service.MenuInfoService;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;

/**
 * 메뉴관리 비지니스 로직
 * @author sichoi
 */
@Service
public class MenuInfoServiceImpl implements MenuInfoService{

	@Autowired
	private MenuInfoMapper menuInfoMapper;

	public List<MenuInfoVO> selectMenuInfoList(MenuInfoVO vo) throws SQLException{
		return menuInfoMapper.selectMenuInfoList(vo);
	}

	public MenuInfoVO selectMenuInfoView(MenuInfoVO vo) throws SQLException{
		return menuInfoMapper.selectMenuInfoView(vo);
	}

	public void insertMenuInfo(MenuInfoVO vo) throws SQLException{
		menuInfoMapper.insertMenuInfo(vo);
	}

	public void updateMenuInfo(MenuInfoVO vo) throws SQLException{
		menuInfoMapper.updateMenuInfo(vo);
	}

	public void deleteMenuInfo(MenuInfoVO vo) throws SQLException{
		menuInfoMapper.deleteMenuInfo(vo);
	}

	@Override
	public void updateMenuInfoOrdr(MenuInfoVO vo) throws SQLException{
		for(MenuInfoVO list : vo.getList())
			menuInfoMapper.updateMenuInfoOrdr(list);
	}

}
