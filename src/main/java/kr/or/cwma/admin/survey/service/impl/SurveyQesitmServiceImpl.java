package kr.or.cwma.admin.survey.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.survey.mapper.SurveyQesitmMapper;
import kr.or.cwma.admin.survey.service.SurveyQesitmExService;
import kr.or.cwma.admin.survey.service.SurveyQesitmService;
import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmExVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

@Service
public class SurveyQesitmServiceImpl implements SurveyQesitmService{

	@Autowired
	private SurveyQesitmMapper surveyQesitmMapper;
	
	@Autowired
	private SurveyQesitmExService surveyQesitmExService;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;
	
	public void insertSurveyQesitm(SurveyQesitmVO vo) throws SQLException, IOException{
		surveyQesitmMapper.insertSurveyQesitm(vo);
		
		for(SurveyQesitmExVO exVO : vo.getExVO()){
			exVO.setQesitmSn(vo.getQesitmSn());
			surveyQesitmExService.updateSurveyQesitmEx(exVO);
		}
	}
 
	public void updateSurveyQesitm(SurveyQesitmVO vo) throws SQLException, IOException{
		if(vo.getQesitmSn() > 0)
			surveyQesitmMapper.updateSurveyQesitm(vo);
		else
			surveyQesitmMapper.insertSurveyQesitm(vo);
		
		if(vo.getExVO() != null){
			for(SurveyQesitmExVO exVO : vo.getExVO()){
				exVO.setQesitmSn(vo.getQesitmSn());
				surveyQesitmExService.updateSurveyQesitmEx(exVO);
			}
		}
		
		surveyQesitmExService.deleteSurveyQesitmEx(vo);
	}

	public void deleteSurveyQesitm(SurveyInfoVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		List<SurveyQesitmVO> list = surveyQesitmMapper.selectSurveyQesitmList(vo);
	
		for(SurveyQesitmVO itmVO : list){
			surveyQesitmExService.deleteSurveyQesitmEx(itmVO);
			
			avo.setParntsSe("ATCH0003");
			avo.setParntsSn(itmVO.getQesitmSn());
			attchFileInfoService.deleteAttchFileInfo(avo);
		}
		
		surveyQesitmMapper.deleteSurveyQesitm(vo);
		
	}

}
