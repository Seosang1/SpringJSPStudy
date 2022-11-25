package kr.or.cwma.admin.bbs.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.microsoft.sqlserver.jdbc.StringUtils;

import kr.or.cwma.admin.bbs.mapper.BbsMapper;
import kr.or.cwma.admin.bbs.service.BbsService;
import kr.or.cwma.admin.bbs.vo.BbsVO;
import kr.or.cwma.admin.smsSendHist.service.SmsSendHistService;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 게시판 비지니스로직
 * @author sichoi
 */
@Service
public class BbsServiceImpl implements BbsService{

	@Autowired
	private BbsMapper bbsMapper;
	
	@Autowired
	private SmsSendHistService smsSendHistService;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;
	
	public List<BbsVO> selectBbsList(BbsVO vo) throws SQLException{
		vo.setTotalCnt(bbsMapper.selectBbsListCnt(vo));
		return bbsMapper.selectBbsList(vo);
	}
	
	public int selectBbsListCnt(BbsVO vo) throws SQLException{
		return bbsMapper.selectBbsListCnt(vo);
	}

	public BbsVO selectBbsView(BbsVO vo) throws SQLException{
		return bbsMapper.selectBbsView(vo);
	}

	public void insertBbs(BbsVO vo, HttpServletRequest req) throws SQLException, IOException{
		vo.setSmsRecptnAgreAt(StringUtils.isEmpty(vo.getSmsRecptnAgreAt())?"N":vo.getSmsRecptnAgreAt());
		vo.setDisplayAt(StringUtils.isEmpty(vo.getDisplayAt())?"N":vo.getDisplayAt());
		vo.setNoticeAt(StringUtils.isEmpty(vo.getNoticeAt())?"N":vo.getNoticeAt());
		
		bbsMapper.insertBbs(vo);
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSn(), "ATCH0001");
	}

	public void updateBbs(BbsVO vo, HttpServletRequest req) throws SQLException, IOException{
		bbsMapper.updateBbs(vo);
		attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSn(), "ATCH0001");
	}

	public void updateBbsAnswer(BbsVO vo) throws SQLException{
		bbsMapper.updateBbsAnswer(vo);
	}

	public void deleteBbs(BbsVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		avo.setParntsSe("ATCH0001");
		avo.setParntsSn(vo.getSn());
		
		bbsMapper.deleteBbs(vo);
		attchFileInfoService.deleteAttchFileInfo(avo);
	}

	@Override
	public List<BbsVO> selectBbsPrevNextList(BbsVO vo) throws SQLException{
		return bbsMapper.selectBbsPrevNextList(vo);
	}

	@Override
	public void updateBbsRdcnt(BbsVO vo) throws SQLException{
		bbsMapper.updateBbsRdcnt(vo);
	}

	@Override
	public void updateBbsDwldCo(BbsVO vo) throws SQLException{
		bbsMapper.updateBbsDwldCo(vo);
	}

	@Override
	public void executeSms(BbsVO vo) throws SQLException{
		vo.setSndngAt("Y");
		smsSendHistService.sendSmsAuto("SSSE0002", vo.getMbtlnum(), vo.getNm(), null);
		bbsMapper.updateBbsSndngAt(vo);
	}

}
