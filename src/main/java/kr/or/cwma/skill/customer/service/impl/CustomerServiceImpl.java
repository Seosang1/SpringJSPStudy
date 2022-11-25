package kr.or.cwma.skill.customer.service.impl;
import java.io.IOException;
import java.sql.SQLException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.bbs.mapper.BbsMapper;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.survey.vo.SurveyInfoVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.FileService;
import kr.or.cwma.skill.customer.mapper.CustomerMapper;
import kr.or.cwma.skill.customer.service.CustomerService;
import kr.or.cwma.skill.customer.vo.SurveyAnswerVO;
import kr.or.cwma.skill.customer.vo.SurveyAnswrrVO;

/**
 * 고객센터 비지니스로직
 * @author sichoi
 */
@Service
public class CustomerServiceImpl implements CustomerService{

	@Autowired
	private BbsMapper bbsMapper;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;
	
	@Autowired
	CustomerMapper customerMapper;

	@Override
	public SurveyInfoVO selectSurveyStatus(SurveyInfoVO vo) throws SQLException{
		return customerMapper.selectSurveyStatus(vo);
	}

	@Override
	public void insertSurveyAnswer(SurveyAnswrrVO vo) throws SQLException{
		customerMapper.insertSurveyAnswrr(vo);
		
		for(SurveyAnswerVO avo : vo.getAnswerVO()){
			avo.setAnswrrSn(vo.getAnswrrSn());
			
			if(!"SQTY0002".equals(avo.getTy()) && !"SQTY0005".equals(avo.getTy())){
				customerMapper.insertSurveyAnswer(avo);
				
			}else{
				for(int i = 0;i<avo.getAnswerList().length;i++){
					avo.setAnswer(avo.getAnswerList()[i]);
					
					if(avo.getEtcList() != null)
						avo.setEtcAnswer(avo.getEtcList()[i]);
					
					customerMapper.insertSurveyAnswer(avo);
				}					
			}
		}
	}
	
	public void insertBbs(BbsVO vo, MultipartHttpServletRequest req) throws SQLException, IOException{
		vo.setSmsRecptnAgreAt(StringUtils.isEmpty(vo.getSmsRecptnAgreAt())?"N":vo.getSmsRecptnAgreAt());
		vo.setDisplayAt(StringUtils.isEmpty(vo.getDisplayAt())?"N":vo.getDisplayAt());
		vo.setNoticeAt(StringUtils.isEmpty(vo.getNoticeAt())?"N":vo.getNoticeAt());
		
		bbsMapper.insertBbs(vo);
		attchFileInfoService.insertAttchFileInfo(fileService.upload(req), vo.getSn(), "ATCH0001");
	}

}
