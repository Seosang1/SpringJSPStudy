package kr.or.cwma.admin.survey.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.survey.mapper.SurveyInfoMapper;
import kr.or.cwma.admin.survey.mapper.SurveyQesitmMapper;
import kr.or.cwma.admin.survey.service.SurveyInfoService;
import kr.or.cwma.admin.survey.service.SurveyQesitmService;
import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.admin.survey.vo.SurveyQesitmVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

@Service
public class SurveyInfoServiceImpl implements SurveyInfoService{

	@Autowired
	private SurveyInfoMapper surveyInfoMapper;
	
	@Autowired
	private SurveyQesitmMapper surveyQesitmMapper;
	
	@Autowired
	private SurveyQesitmService surveyQesitmService;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;
	
	public List<SurveyInfoVO> selectSurveyInfoList(SurveyInfoVO vo) throws SQLException{
		vo.setTotalCnt(surveyInfoMapper.selectSurveyInfoListCnt(vo));
		return surveyInfoMapper.selectSurveyInfoList(vo);
	}

	public SurveyInfoVO selectSurveyInfoView(SurveyInfoVO vo) throws SQLException{
		return surveyInfoMapper.selectSurveyInfoView(vo);
	}
	
	@Override
	public List<Map<String, Object>> selectSurveyInfoListXls(SurveyInfoVO vo) throws SQLException{
		int rownum = 1;
		long answrrSn = 0;
		
		Map<String, Object> map = new LinkedHashMap<String, Object>();
		List<SurveyQesitmVO> list = surveyQesitmMapper.selectSurveyQesitmList(vo);
		List<Map<String, Object>> answerList = surveyInfoMapper.selectSurveyInfoListXls(vo);
		List<Map<String, Object>> retList = new ArrayList<Map<String, Object>>();
		
		for(Map<String, Object> answer : answerList){
			if(answrrSn != (long)answer.get("ANSWRR_SN")){
				if(answrrSn != 0)
					retList.add(map);
				
				map = new LinkedHashMap<String, Object>();
				answrrSn = (long)answer.get("ANSWRR_SN");
			}
			
			for(SurveyQesitmVO sjVO : list){
				if(sjVO.getQesitmSn() == (long)answer.get("QESITM_SN")){
					if(map.isEmpty()){
						map.put("NO", rownum++);
						map.put("????????????", answer.get("ANSWRR_DT"));
					}
					
					if(StringUtils.isEmpty((String)map.get(sjVO.getSj())))
						map.put(sjVO.getSj(), answer.get("ANSWER"));
					else
						map.put(sjVO.getSj(), ((String)map.get(sjVO.getSj())).concat(",").concat((String)answer.get("ANSWER")));
					
					break;
				}
			}
			
		}
			
		retList.add(map);
		
		return retList;
	}

	public void insertSurveyInfo(SurveyInfoVO vo) throws SQLException, IOException{
		//???????????? ??????
		surveyInfoMapper.insertSurveyInfo(vo);
		
		//???????????? ???????????? ??????
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSurveySn(), "ATCH0002");
		
		//???????????? ??????
		for(SurveyQesitmVO itmVO : vo.getItmVO()){
			itmVO.setSurveySn(vo.getSurveySn());
			surveyQesitmService.insertSurveyQesitm(itmVO);
		}
	}
 
	public void updateSurveyInfo(SurveyInfoVO vo) throws SQLException, IOException{
		//???????????? update
		surveyInfoMapper.updateSurveyInfo(vo);
		
		//???????????? ?????? ??? ???????????? ??????????????????
		attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSurveySn(), "ATCH0002");
		
		for(SurveyQesitmVO itmVO : vo.getItmVO()){
			itmVO.setSurveySn(vo.getSurveySn());
			surveyQesitmService.updateSurveyQesitm(itmVO);
		}
		
		//??????????????????
		surveyQesitmService.deleteSurveyQesitm(vo);
	}

	public void deleteSurveyInfo(SurveyInfoVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		SurveyInfoVO eo = surveyInfoMapper.selectSurveyInfoView(vo);
		
		//???????????? ??????????????????
		avo.setParntsSe("ATCH0002");
		avo.setParntsSn(eo.getSurveySn());
		attchFileInfoService.deleteAttchFileInfo(avo);
		
		//?????????????????? ??????
		surveyQesitmService.deleteSurveyQesitm(vo);
		
		//???????????? ??????
		surveyInfoMapper.deleteSurveyInfo(eo);
	}

}
