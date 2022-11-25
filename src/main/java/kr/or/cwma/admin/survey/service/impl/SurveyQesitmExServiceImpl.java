package kr.or.cwma.admin.survey.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.survey.mapper.SurveyQesitmExMapper;
import kr.or.cwma.admin.survey.service.SurveyQesitmExService;
import kr.or.cwma.admin.survey.vo.SurveyQesitmExVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

@Service
public class SurveyQesitmExServiceImpl implements SurveyQesitmExService{

	@Autowired
	private SurveyQesitmExMapper surveyQesitmExMapper;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;
	
	public void updateSurveyQesitmEx(SurveyQesitmExVO vo) throws SQLException, IOException{
		if(vo.getSn() > 0)
			surveyQesitmExMapper.updateSurveyQesitmEx(vo);
		else
			surveyQesitmExMapper.insertSurveyQesitmEx(vo);
	}

	public void deleteSurveyQesitmEx(SurveyQesitmVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		List<SurveyQesitmExVO> list = surveyQesitmExMapper.selectSurveyQesitmExList(vo);
		
		if(list != null){
			for(SurveyQesitmExVO exVO : list){
				avo = new AttchFileInfoVO();
				avo.setParntsSe("ATCH0004");
				avo.setParntsSn(exVO.getSn());
				
				attchFileInfoService.deleteAttchFileInfo(avo);
			}
		}
		
		surveyQesitmExMapper.deleteSurveyQesitmEx(vo);
	}
	
}
