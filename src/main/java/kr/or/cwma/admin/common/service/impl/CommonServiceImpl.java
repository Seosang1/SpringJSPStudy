package kr.or.cwma.admin.common.service.impl;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.common.mapper.CommonMapper;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.admin.common.vo.CommonVO;
import kr.or.cwma.admin.common.vo.DeptVO;
import kr.or.cwma.admin.common.vo.ExcelDwldHistVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;
import kr.or.cwma.common.util.CryptUtil;

/**
 * 관리자 공통 서비스 비지니스 로직
 * @author sichoi
 */
@Service
public class CommonServiceImpl implements CommonService{
	@Autowired
	private CommonMapper commonMapper;

	@Override
	public UserVO selectUserView(UserVO vo) throws SQLException{
		return commonMapper.selectUserView(vo);
	}

	@Override
	public List<UserVO> selectUserList(UserVO vo) throws SQLException{
		return commonMapper.selectUserList(vo);
	}

	@Override
	public List<DeptVO> selectDeptList(DeptVO vo) throws SQLException{
		return commonMapper.selectDeptList(vo);
	}

	@Override
	public String login(HttpServletRequest req, UserVO vo) throws SQLException{
		String ret = "";
		UserVO eo = commonMapper.selectUserView(vo);
		String ps = "";
		try {
			ps = CryptUtil.encriptSHA512(vo.getPassword().trim());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		if(eo != null && !StringUtils.isEmpty(eo.getUserId()) && ps.equals(eo.getPassword())) {
			req.getSession().setAttribute("adminLoginInfo", eo);
		}else {
			ret = "일치하는 회원정보가 없습니다.";
		}
		
		return ret;
	}

	@Override
	public List<MenuInfoVO> selectUserMenuList(UserVO vo) throws SQLException{
		return commonMapper.selectUserMenuList(vo);
	}
	
	public void insertExcelDwldHist(ExcelDwldHistVO vo) throws SQLException{
		commonMapper.insertExcelDwldHist(vo);
	}

	@Override
	public Map<String, Object> selectQnaCnt() throws SQLException{
		return commonMapper.selectQnaCnt();
	}

	@Override
	public List<Map<String, Object>> selectUserLoginStatsToday() throws SQLException{
		return commonMapper.selectUserLoginStatsToday();
	}

	@Override
	public List<Map<String, Object>> selectUserLoginStatsSe() throws SQLException{
		return commonMapper.selectUserLoginStatsSe();
	}

	@Override
	public Map<String, Object> selectIssueFee() throws SQLException{
		return commonMapper.selectIssueFee();
	}

	@Override
	public Map<String, Object> selectSanctn(UserVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return commonMapper.selectSanctn(vo);
	}

	@Override
	public Map<String, Object> selectCareerDeclare1(UserVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return commonMapper.selectCareerDeclare1(vo);
	}

	@Override
	public Map<String, Object> selectCareerDeclare2(UserVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return commonMapper.selectCareerDeclare2(vo);
	}
	
	@Override
	public List<Map<String, Object>> selectCareerDeclare(UserVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return commonMapper.selectCareerDeclare(vo);
	}
	
	@Override
	public List<Map<String, Object>> selectCareerCrtf(UserVO vo) throws SQLException {
		// TODO Auto-generated method stub
		return commonMapper.selectCareerCrtf(vo);
	}
	
	@Override
	public String getDdcAsctCdByCnstwkLocplcAddr(String cnstwkLocplcAddr) {
		String trimAddr = cnstwkLocplcAddr.trim();
		
		if(StringUtils.isEmpty(trimAddr)) {
			return "01100";
		}
		
		if(trimAddr.startsWith("서울")) {
			if(trimAddr.contains("강남") || trimAddr.contains("강서") || trimAddr.contains("관악")
			|| trimAddr.contains("구로") || trimAddr.contains("금천") || trimAddr.contains("동작")
			|| trimAddr.contains("양천") || trimAddr.contains("영등포") ) {
				return "01102";
			}else {
				return "01101";
			}
		}else if(trimAddr.startsWith("경기")) {
			if( trimAddr.contains("김포") || trimAddr.contains("부천")) {
				return "02102";
			}else if(trimAddr.contains("가평") || trimAddr.contains("구리") || trimAddr.contains("남양주") || trimAddr.contains("동두천")
				  || trimAddr.contains("양주") || trimAddr.contains("연천") || trimAddr.contains("의정부") || trimAddr.contains("파주")
				  || trimAddr.contains("포천")) {
				return "01103";
			}else if(trimAddr.contains("시흥") || trimAddr.contains("안산") 
					|| trimAddr.contains("고양") || trimAddr.contains("광명")) {
				return "02102";
			}else {
				return "02101";
			}
		}else if(trimAddr.startsWith("대전") || trimAddr.startsWith("충청남도") || trimAddr.startsWith("충남") || trimAddr.startsWith("세종")) {
			return "04101";
		}else if(trimAddr.startsWith("부산") || trimAddr.startsWith("울산")) {
			return "08101";
		}else if(trimAddr.contains("대구") || trimAddr.startsWith("경상북도") || trimAddr.startsWith("경북")) {
			/*
			 * 안동센터 폐지 이슈로 안동센터로 들어갈 데이터는 상위지사인 대구지사로 들어가도록 수정 2020-10-16
			if( trimAddr.contains("문경") || trimAddr.contains("봉화") || trimAddr.contains("상주") || trimAddr.contains("안동")
			 || trimAddr.contains("영덕") || trimAddr.contains("영양") || trimAddr.contains("영주") || trimAddr.contains("예천")
			 || trimAddr.contains("울진") || trimAddr.contains("의성") || trimAddr.contains("청송")) {
				return "07102";
			}else {
				return "07101";
			}
			*/
			return "07101";
		}else if(trimAddr.startsWith("광주") || trimAddr.startsWith("전라남도") || trimAddr.startsWith("전남")) {
			return "06101";
		}else if(trimAddr.startsWith("강원")) {
			return "03101";
		}else if(trimAddr.startsWith("인천")) {
			return "02102";
		}else if(trimAddr.startsWith("충청북도") || trimAddr.startsWith("충북")) {
			return "04102";
		}else if(trimAddr.startsWith("경상남도") || trimAddr.startsWith("경남")) {
			if( trimAddr.contains("김해") || trimAddr.contains("밀양") || trimAddr.contains("양산")) {
				return "08101";
			}else{
				return "08102";
			}
		}else if(trimAddr.startsWith("전라북도") || trimAddr.startsWith("전북")) {
			return "05101";
		}else if(trimAddr.startsWith("제주")) {
			return "06102";
		}
		return "01100";
	}

	@Override
	public Map<String, Object> selectSanctnInfo(UserVO vo) throws SQLException {
		return commonMapper.selectSanctnInfo(vo);
	}

	@Override
	public List<Map<String, Object>> selectCareerCrtf2(UserVO vo) throws SQLException {
		return commonMapper.selectCareerCrtf2(vo);
	}
	
	@Override
	public int selectCountVisit(CommonVO vo) throws SQLException{
		return commonMapper.selectCountVisit(vo);
	}
	
	@Override
	public int selectCountQna() throws SQLException{
		return commonMapper.selectCountQna();
	}
}
