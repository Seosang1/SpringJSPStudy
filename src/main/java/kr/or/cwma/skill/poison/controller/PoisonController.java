package kr.or.cwma.skill.poison.controller;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 발급안내 컨트롤러
 * @author sichoi
 */
@Controller
@RequestMapping(value="skill/poison")
public class PoisonController{

	/**
	 * 전체
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="search.do", method=RequestMethod.GET)
	public String search(HttpServletRequest req){
		return "skill/poison/search";
	}
	

	/**
	 * 화학물질
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="material.do", method=RequestMethod.GET)
	public String material(HttpServletRequest req){
		return "skill/poison/material";
	}
	

	/**
	 * 화학제품
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="product.do", method=RequestMethod.GET)
	public String product(HttpServletRequest req){
		return "skill/poison/product";
	}

	/**
	 * 의약품
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="medical.do", method=RequestMethod.GET)
	public String medical(HttpServletRequest req){
		return "skill/poison/medical";
	}
	
	/**
	 * 농약
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="farm.do", method=RequestMethod.GET)
	public String farm(HttpServletRequest req){
		return "skill/poison/farm";
	}
	
	/**
	 * 동식물
	 * @param req 
	 * @param vo 
	 * @return String 
	 */
	@RequestMapping(value="live.do", method=RequestMethod.GET)
	public String live(HttpServletRequest req){
		return "skill/poison/live";
	}
}
