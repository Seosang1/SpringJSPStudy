package kr.or.cwma.skill.observer.controller;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 발급안내 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/observer")
public class ObserverController{

	/**
	 * 감시지표
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="table.do", method=RequestMethod.GET)
	public String table(HttpServletRequest req){
		return "skill/observer/table";
	}

}
