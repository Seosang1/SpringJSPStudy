package kr.or.cwma.admin.indvdlinfoAccesLog.service.impl;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.indvdlinfoAccesLog.mapper.IndvdlinfoAccesLogMapper;
import kr.or.cwma.admin.indvdlinfoAccesLog.service.IndvdlinfoAccesLogService;
import kr.or.cwma.admin.indvdlinfoAccesLog.vo.IndvdlinfoAccesLogVO;
import kr.or.cwma.admin.menuInfo.vo.MenuInfoVO;

/**
 * 접속기록관리 비지니스로직
 * @author sichoi
 */
@Service
public class IndvdlinfoAccesLogServiceImpl implements IndvdlinfoAccesLogService{

	@Autowired
	private IndvdlinfoAccesLogMapper indvdlinfoAccesLogMapper;

	public List<IndvdlinfoAccesLogVO> selectIndvdlinfoAccesLogList(IndvdlinfoAccesLogVO vo) throws SQLException{
		vo.setTotalCnt(indvdlinfoAccesLogMapper.selectIndvdlinfoAccesLogListCnt(vo));
		return indvdlinfoAccesLogMapper.selectIndvdlinfoAccesLogList(vo);
	}

	public List<Map<String, Object>> selectIndvdlinfoAccesLogListXls(IndvdlinfoAccesLogVO vo) throws SQLException{
		return indvdlinfoAccesLogMapper.selectIndvdlinfoAccesLogListXls(vo);
	}

	public IndvdlinfoAccesLogVO selectIndvdlinfoAccesLogView(IndvdlinfoAccesLogVO vo) throws SQLException{
		return indvdlinfoAccesLogMapper.selectIndvdlinfoAccesLogView(vo);
	}

	public void insertIndvdlinfoAccesLog(IndvdlinfoAccesLogVO vo, HttpServletRequest req) throws SQLException{
		String uri = req.getRequestURI();
		String ip = req.getHeader("X-FORWARDED-FOR");
		String contextPath = req.getContextPath();
		UserVO uvo = (UserVO)req.getSession().getAttribute("adminLoginInfo");
		
        if (ip == null)
            ip = req.getRemoteAddr();
        
        uri = uri.replaceFirst(contextPath, "");
		
		vo.setAccesId(uvo.getUserId());
		vo.setIp(ip);
		vo.setUrl(uri);
		
		indvdlinfoAccesLogMapper.insertIndvdlinfoAccesLog(vo);
	}
	
	public void insertIndvdlinfoAccesLog(List<?> list, HttpServletRequest req) throws SQLException{
		IndvdlinfoAccesLogVO vo = new IndvdlinfoAccesLogVO();
		
		vo.setSe("IALS0004");
		
		for(Object obj : list){
			if(obj.getClass().getName().indexOf("CrtfIssuVO") >= 0)
				vo.setIhidnum(((CrtfIssuVO)obj).getIssuTrgterIhidnum());
			
			else if(obj.getClass().getName().indexOf("CareerDeclareVO") >= 0)
				vo.setIhidnum(((CareerDeclareVO)obj).getIhidnum());
			
			insertIndvdlinfoAccesLog(vo, req);
		}
	}

	@Override
	public List<MenuInfoVO> selectMenuList() throws SQLException{
		return indvdlinfoAccesLogMapper.selectMenuList();
	}
}