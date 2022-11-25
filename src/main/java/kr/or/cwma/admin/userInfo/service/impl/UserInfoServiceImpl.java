package kr.or.cwma.admin.userInfo.service.impl;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.userInfo.mapper.UserInfoMapper;
import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.UserCareerVO;
import kr.or.cwma.admin.userInfo.vo.UserCnsltHistVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserMainJssfcVO;
import kr.or.cwma.common.util.CryptUtil;

@Service
public class UserInfoServiceImpl implements UserInfoService{

	@Autowired
	private UserInfoMapper userInfoMapper;

	public List<?> selectUserInfoList(UserInfoVO vo) throws SQLException{
		List<?> ret = null;
		
		if("USSE0001".equals(vo.getSe())){
			vo.setTotalCnt(userInfoMapper.selectPersonalUserInfoListCnt(vo));
			ret = userInfoMapper.selectPersonalUserInfoList(vo);
			
		}else{
			vo.setTotalCnt(userInfoMapper.selectUserInfoListCnt(vo));
			ret = userInfoMapper.selectUserInfoList(vo);
		}
		
		return ret;
	}

	public List<Map<String, Object>> selectUserInfoListXls(UserInfoVO vo) throws SQLException{
		if("USSE0001".equals(vo.getSe()))
			return userInfoMapper.selectPersonalUserInfoListXls(vo);
		else
			return userInfoMapper.selectUserInfoListXls(vo);
	}

	public UserMainJssfcVO selectPersonalUserInfoView(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectPersonalUserInfoView(vo);
	}

	public UserInfoVO selectUserInfoView(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectUserInfoView(vo);
	}

	public void insertUserInfo(UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		if(!StringUtils.isEmpty(vo.getPassword()))
			vo.setPassword(CryptUtil.encriptSHA512(vo.getPassword()));
		
		userInfoMapper.insertUserInfo(vo);
	}

	public void updateUserInfo(UserInfoVO vo) throws SQLException{
		userInfoMapper.updateUserInfo(vo);
	}

	public void deleteUserInfo(UserInfoVO vo) throws SQLException{
		userInfoMapper.deleteUserInfo(vo);
	}
	
	public List<UserCnsltHistVO> selectUserCnsltHistList(UserCnsltHistVO vo) throws SQLException{
		return userInfoMapper.selectUserCnsltHistList(vo);
	}

	public void executeUserCnsltHist(UserCnsltHistVO vo) throws SQLException{
		userInfoMapper.insertUserCnsltHist(vo);
	}

	@Override
	public List<UserCareerVO> selectPersonalUserCmclList(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectPersonalUserCmclList(vo);
	}

	@Override
	public List<UserCareerVO> selectPersonalUserDlyList(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectPersonalUserDlyList(vo);
	}

	@Override
	public List<UserCareerVO> selectPersonalUserLicenseList(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectPersonalUserLicenseList(vo);
	}

	@Override
	public List<UserCareerVO> selectPersonalUserEduList(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectPersonalUserEduList(vo);
	}

	@Override
	public List<UserCareerVO> selectPersonalUserRewardList(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectPersonalUserRewardList(vo);
	}

	@Override
	public List<CmmnCdVO> selectUserCnsltHistTrgtList() throws SQLException{
		return userInfoMapper.selectUserCnsltHistTrgtList();
	}

	@Override
	public List<CmmnCdVO> selectUserCnsltHistSeList() throws SQLException{
		return userInfoMapper.selectUserCnsltHistSeList();
	}

	@Override
	public List<CmmnCdVO> selectUserCnsltDdcerSnList(UserInfoVO vo) throws SQLException{
		return userInfoMapper.selectUserCnsltDdcerSnList(vo);
	}

}
