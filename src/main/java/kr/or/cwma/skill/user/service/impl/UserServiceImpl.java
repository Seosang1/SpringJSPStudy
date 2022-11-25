package kr.or.cwma.skill.user.service.impl;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.userInfo.service.UserInfoService;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.CorpInfoVO;
import kr.or.cwma.admin.userInfo.vo.DminsttInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserCntrctRelateVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.CryptUtil;
import kr.or.cwma.skill.user.mapper.UserMapper;
import kr.or.cwma.skill.user.service.UserService;
import kr.or.cwma.skill.userSnsAuthor.mapper.UserSnsAuthorMapper;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;

/**
 * 회원 비지니스 로직
 * @author sichoi
 */
@Service
public class UserServiceImpl implements UserService{
	@Autowired
	private UserInfoService userInfoService;

	@Autowired
	private UserMapper userMapper;
	
	@Autowired
	private UserSnsAuthorMapper userSnsAuthorMapper;

	public String login(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		String ret = "";
		String ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
		
		UserInfoVO eo = userInfoService.selectUserInfoView(vo);
		UserInfoVO lvo = (UserInfoVO)req.getSession().getAttribute("loginInfo");

		req.getSession().removeAttribute("loginInfo");
		
		if(eo != null && eo.getUserId().equals(vo.getUserId())){
			//회원타입 확인
			if(!vo.getSe().equals(eo.getSe())){
				ret = "일치하는 계정정보가 없습니다. 다시 확인해주세요";
			
			//개인
			}else if(vo.getSe().equals("USSE0001")){
				if(!ps.equals(eo.getPassword()))
					ret = "아이디 또는 비밀번호가 일치하지 않습니다";
			
			//대리인
			}else if(vo.getSe().equals("USSE0003")){
				if(!lvo.getAuthVO().getCiValue().equals(eo.getCiValue()))
					ret = "일치하는 계정정보가 없습니다. 다시 확인해주세요";
				
			//사업자, 수요기관
			}else{
				if(!vo.getDnValue().equals(eo.getDnValue()))
					ret = "일치하는 계정정보가 없습니다. 다시 확인해주세요";
				
			}
			
			if(StringUtils.isEmpty(ret)){
				userMapper.updateUserLoginDt(vo);
				
				eo.setPassword(null);
				eo.setDnValue(null);
				eo.setCiValue(null);
				eo.setLogin(true);
				req.getSession().setAttribute("loginInfo", eo);
			}
			
		}else{
			ret = "회원정보가 일치하지 않습니다";
			
		}

		return ret;
	}
	
	/**
	 * 회원 SNS 로그인
	 */
	public String snsLogin(HttpServletRequest req, UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		String ret = "";
		UserSnsAuthorVO snsVO = vo.getUserSnsAuthorVO();
		// 회원 SNS 인증 여부
		if(snsVO != null && !StringUtils.isEmpty(snsVO.getSnsId()) && !StringUtils.isEmpty(snsVO.getSe())) {
			UserSnsAuthorVO snsVOInfo = userSnsAuthorMapper.selectUserSnsAuthorView(snsVO);
			// 회원 SNS 연동 여부
			if(snsVOInfo != null && !StringUtils.isEmpty(snsVOInfo.getUserId())) {
				vo.setUserId(snsVOInfo.getUserId());
				UserInfoVO eo = userInfoService.selectUserInfoView(vo);
				
				// 개인
				if("USSE0001".equals(vo.getSe()) && eo != null){
					
					userMapper.updateUserLoginDt(vo);
					
					eo.setPassword(null);
					eo.setDnValue(null);
					eo.setCiValue(null);
					eo.setLogin(true);
					req.getSession().setAttribute("loginInfo", eo);
					
				}else {
					ret = "일치하는 계정정보가 없습니다.";
				}
			}else {
				ret = "연동되지 않은 계정입니다.\r\n로그인 후 회원정보변경 화면에서 연동해주세요.";
			}
		}else {
			ret = "SNS 인증정보가 존재하지 않습니다. 다시 인증해주세요.";
		}
		return ret;	
	}

	@Override
	public UserInfoVO selectJoinUser(UserInfoVO vo) throws SQLException{
		return userMapper.selectJoinUser(vo);
	}

	@Override
	public CorpInfoVO selectCorpInfo(UserInfoVO vo) throws SQLException{
		return userMapper.selectCorpInfo(vo);
	}

	@Override
	public DminsttInfoVO selectDminsttInfo(UserInfoVO vo) throws SQLException{
		return userMapper.selectDminsttInfo(vo);
	}

	@Override
	public List<CntrctInfoVO> selectDdcJoinList(UserInfoVO vo) throws SQLException{
		return userMapper.selectDdcJoinList(vo);
	}
	
	public UserInfoVO selectUserInfoForAddCert(UserInfoVO vo) throws SQLException{
		UserInfoVO eo = userInfoService.selectUserInfoView(vo);
		
		if(!vo.getBizno().equals(eo.getBizno()))
			eo = null;
		
		return eo;
	}
	
	public void updateAddCert(UserInfoVO vo) throws SQLException{
		UserInfoVO eo = userInfoService.selectUserInfoView(vo);
		
		if(!vo.getBizno().equals(eo.getBizno()))
			throw new SQLException("사업자번호 다름");
		
		userInfoService.updateUserInfo(vo);
	}

	@Override
	public void insertUserInfo(UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		UserCntrctRelateVO ucrVO;
		
		vo.setEmailRecptnAgreAt(StringUtils.isEmpty(vo.getEmailRecptnAgreAt())?"N":vo.getEmailRecptnAgreAt());
		vo.setSmsRecptnAgreAt(StringUtils.isEmpty(vo.getSmsRecptnAgreAt())?"N":vo.getSmsRecptnAgreAt());
		
		userInfoService.insertUserInfo(vo);
		
		if(vo.getSe().equals("USSE0001"))
			userMapper.updateUserMainJssfcJoinAt(vo);
		
		if(vo.getSe().equals("USSE0003") && vo.getDdcJoinNoList() != null){
			for(String ddcJoinNo : vo.getDdcJoinNoList()){
				ucrVO = new UserCntrctRelateVO();
				ucrVO.setUserId(vo.getUserId());
				ucrVO.setDdcJoinNo(ddcJoinNo);
				userMapper.insertUserCntrctRelate(ucrVO);
			}
		}
	}

	@Override
	public void updateUserPassword(UserInfoVO vo) throws SQLException, NoSuchAlgorithmException{
		vo.setPassword(CryptUtil.encriptSHA512(vo.getPassword()));
		userMapper.updateUserPassword(vo);
	}
}
