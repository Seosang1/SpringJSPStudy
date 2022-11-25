package kr.or.cwma.admin.stats.controller;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.stats.service.StatsService;
import kr.or.cwma.admin.stats.vo.ClmserEduStatsVO;
import kr.or.cwma.admin.stats.vo.GradStatsVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.util.ExcelUtil;

/**
 * 통계관리 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="admin/stats")
public class StatsController{

	@Autowired
	private StatsService statsService;

	@Autowired
	CmmnCdService cmmnCdService;

	/**
	 * 회원통계 페이지 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="userList.do", method=RequestMethod.GET)
	public String userList(HttpServletRequest req) throws SQLException{
		return "admin/stats/userList";
	}
	
	/**
	 * 회원통계 조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="userList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> userListPost(HttpServletRequest req, UserInfoVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", statsService.selectUserStatsList(vo));
		map.put("area", statsService.selectUserAreaStatsList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 회원통계 엑셀다운로드 
	 * @param req 
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="userListExcelDown.do")
	public void userListExcelDown(HttpServletRequest req, HttpServletResponse res, UserInfoVO vo) throws SQLException, IOException{
		String title = "회원통계";
		List<Map<String, Object>> list = null;
		
		if("age".equals(req.getParameter("type")))
			list = statsService.selectUserStatsListXls(vo);
		else if("area".equals(req.getParameter("type"))){
			list = statsService.selectUserAreaStatsListXls(vo);
			title = "지역별회원통계";
		}
		
		ExcelUtil.createXls(list, title, res);
	}
	
	/**
	 * 등급별 증명서발급통계 페이지 
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfList.do", method=RequestMethod.GET)
	public String crtfList(HttpServletRequest req) throws SQLException{
		return "admin/stats/crtfList";
	}
	
	/**
	 * 증명서발급통계 조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> crtfListPost(HttpServletRequest req, GradStatsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if("jssfc".equals(req.getParameter("type")))
			map.put("list", statsService.selectCrtfIssuStatsList(vo));
		else if("spt".equals(req.getParameter("type")))
			map.put("list", statsService.selectCrtfIssuSptStatsList(vo));
		else if("age".equals(req.getParameter("type")))
			map.put("list", statsService.selectCrtfIssuAgeStatsList(vo));		
		
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 증명서발급통계 엑셀다운로드 
	 * @param req
	 * @param res
	 * @param vo 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="crtfListExcelDown.do")
	public void crtfListExcelDown(HttpServletRequest req, HttpServletResponse res, GradStatsVO vo) throws SQLException, IOException{
		String title = "등급별(직종)발급통계";
		List<Map<String, Object>> list = null;
		
		if("jssfc".equals(req.getParameter("type")))
			list = statsService.selectCrtfIssuStatsListXls(vo);
		else if("spt".equals(req.getParameter("type"))){
			list = statsService.selectCrtfIssuSptStatsListXls(vo);
			title = "등급별(신청방법)발급통계";
		}else if("age".equals(req.getParameter("type"))){
			list = statsService.selectCrtfIssuAgeStatsListXls(vo);
			title = "연령대별(신청방법)발급통계";
		}
		
		ExcelUtil.createXls(list, "증명서발급통계-".concat(title), res);
	}

	/**
	 * 등급통계 페이지 
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="gradList.do", method=RequestMethod.GET)
	public String gradList(HttpServletRequest req) throws SQLException{
		return "admin/stats/gradList";
	}
	
	/**
	 * 등급통계 조회 
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="gradList.do", method=RequestMethod.POST)
	public ResponseEntity<Map<String, Object>> gradListPost(HttpServletRequest req, GradStatsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		
		if("ageGender".equals(req.getParameter("type")))
			map.put("list", statsService.selectGradAgeGenderStatsList(vo));
		else if("ageGrad".equals(req.getParameter("type")))
			map.put("list", statsService.selectGradAgeGradStatsList(vo));
		else if("areaGender".equals(req.getParameter("type")))
			map.put("list", statsService.selectGradAreaGenderStatsList(vo));
		else if("areaGrad".equals(req.getParameter("type")))
			map.put("list", statsService.selectGradAreaGradStatsList(vo));
		else if("quarter".equals(req.getParameter("type")))
			map.put("list", statsService.selectGradQuarterStatsList(vo));
		
		map.put("vo", vo);
		
		return new ResponseEntity<>(map, HttpStatus.OK);
	}

	/**
	 * 등급통계 엑셀다운로드 
	 * @param req
	 * @param res
	 * @param vo
	 * @throws SQLException
	 * @throws IOException
	 */
	@RequestMapping(value="gradListExcelDown.do")
	public void gradListExcelDown(HttpServletRequest req, HttpServletResponse res, GradStatsVO vo) throws SQLException, IOException{
		String title = "연령별(성별)통계";
		List<Map<String, Object>> list = null;
		
		if("ageGender".equals(req.getParameter("type")))
			list = statsService.selectGradAgeGenderStatsListXls(vo);
		else if("ageGrad".equals(req.getParameter("type"))){
			list = statsService.selectGradAgeGradStatsListXls(vo);
			title = "연령별(등급)통계";
		}else if("areaGender".equals(req.getParameter("type"))){
			list = statsService.selectGradAreaGenderStatsListXls(vo);
			title = "지역별(성별)통계";
		}else if("areaGrad".equals(req.getParameter("type"))){
			list = statsService.selectGradAreaGradStatsListXls(vo);
			title = "지역별(등급)통계";
		}else if("quarter".equals(req.getParameter("type"))){
			list = statsService.selectGradQuarterStatsListXls(vo);
			title = "분기별통계";
			
			if(StringUtils.isEmpty(vo.getStatsDe()))
				String.valueOf(Calendar.getInstance().get(Calendar.YEAR)).concat("년 ").concat(title);
			else
				vo.getStatsDe().substring(0, 4).concat("년 ").concat(title);
		}
		
		ExcelUtil.createXls(list, "등급통계-".concat(title), res);
	}
	
	/**
	 * 등급통계 페이지 
	 * @param req 
	 * @return String 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEduList.do", method=RequestMethod.GET)
	public String clmserEduList(HttpServletRequest req) throws SQLException{
		return "admin/stats/clmserEduList";
	}
	
	/**
	 * 맞춤형교육통계 목록조회
	 * @param req 
	 * @param vo 
	 * @return ResponseEntity<Map<String, Object>> 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEduList.do")
	public ResponseEntity<Map<String, Object>> clmserEduListPost(HttpServletRequest req, ClmserEduStatsVO vo) throws SQLException{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("list", statsService.selectClmserEduStatsList(vo));
		map.put("vo", vo);
		return new ResponseEntity<>(map, HttpStatus.OK);
	}
	
	/**
	 * 맞춤형교육통계 엑셀다운로드 
	 * @param req 
	 * @param res
	 * @param vo 
	 * @throws SQLException 
	 */
	@RequestMapping(value="clmserEduListExcelDown.do")
	public void clmserEduListExcelDown(HttpServletRequest req, HttpServletResponse res, ClmserEduStatsVO vo) throws SQLException, IOException{
		ExcelUtil.createXls(statsService.selectClmserEduStatsListXls(vo), "맞춤형교육통계", res);
	}
}
