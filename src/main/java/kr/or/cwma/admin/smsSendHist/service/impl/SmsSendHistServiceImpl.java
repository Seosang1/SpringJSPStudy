package kr.or.cwma.admin.smsSendHist.service.impl;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.cmmnCd.service.CmmnCdService;
import kr.or.cwma.admin.cmmnCd.vo.CmmnCdVO;
import kr.or.cwma.admin.smsSendHist.mapper.SmsSendHistMapper;
import kr.or.cwma.admin.smsSendHist.service.SmsSendHistService;
import kr.or.cwma.admin.smsSendHist.vo.SmsSendHistVO;

@Service
public class SmsSendHistServiceImpl implements SmsSendHistService{

	@Autowired
	private SmsSendHistMapper smsSendHistMapper;
	
	@Autowired
	private CmmnCdService cmmnCdService;

	public List<SmsSendHistVO> selectSmsSendHistList(SmsSendHistVO vo) throws SQLException{
		vo.setTotalCnt(smsSendHistMapper.selectSmsSendHistListCnt(vo));
		return smsSendHistMapper.selectSmsSendHistList(vo);
	}

	public SmsSendHistVO selectSmsSendHistView(SmsSendHistVO vo) throws SQLException{
		return smsSendHistMapper.selectSmsSendHistView(vo);
	}

	public void sendSms(SmsSendHistVO vo) throws SQLException{
		CmmnCdVO cvo = new CmmnCdVO(); 
		cvo.setCdId(vo.getSe());
		cmmnCdService.selectCmmnCdView(cvo);
		
		
		smsSendHistMapper.executeSms(vo);
		smsSendHistMapper.insertSmsSendHist(vo);
	}
	
	public void sendSmsAuto(String se, String phoneNumber, String userNm, String corpNm) throws SQLException{
		CmmnCdVO cvo = new CmmnCdVO();
		SmsSendHistVO vo = new SmsSendHistVO();
		
		cvo.setCdId(se);
		vo.setSe(se);
		vo.setMoblphonNo(phoneNumber);
		vo.setCn(cmmnCdService.selectCmmnCdView(cvo).getCdDc());
		vo.setCn(vo.getCn().replaceAll("#회원명#", userNm).replaceAll("#업체명#", corpNm));
		vo.setSttus("SSST0001");
		
		sendSms(vo);
	}

}
