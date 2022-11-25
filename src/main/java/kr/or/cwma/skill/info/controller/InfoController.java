package kr.or.cwma.skill.info.controller;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 발급안내 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/info")
public class InfoController{

	/**
	 * 센터소개
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="centerInfo.do", method=RequestMethod.GET)
	public String centerInfo(HttpServletRequest req){
		return "skill/info/centerInfo";
	}
	

	/**
	 * 운영안내
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="plan.do", method=RequestMethod.GET)
	public String plan(HttpServletRequest req){
		return "skill/info/plan";
	}
	

	/**
	 * 조직도
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="group.do", method=RequestMethod.GET)
	public String group(HttpServletRequest req){
		return "skill/info/group";
	}
	
}
