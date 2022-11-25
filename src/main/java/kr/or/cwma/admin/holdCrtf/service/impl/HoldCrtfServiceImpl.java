package kr.or.cwma.admin.holdCrtf.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.service.impl.CrtfIssuServiceImpl;
import kr.or.cwma.admin.holdCrtf.mapper.HoldCrtfMapper;
import kr.or.cwma.admin.holdCrtf.service.HoldCrtfService;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfCntrwkVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfGradVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfJssfcVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfLabrrVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfProgrsVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.FileService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 보유증명서 비지니스로직
 * @author sichoi
 */
@Service
public class HoldCrtfServiceImpl implements HoldCrtfService{

	@Autowired
	private HoldCrtfMapper holdCrtfMapper;
	
	@Autowired
	private SanctnService sanctnService;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private HoldCrtfService holdCrtfService;

	public List<HoldCrtfVO> selectHoldCrtfList(HoldCrtfVO vo) throws SQLException{
		vo.setTotalCnt(holdCrtfMapper.selectHoldCrtfListCnt(vo));
		return holdCrtfMapper.selectHoldCrtfList(vo);
	}

	public List<Map<String, Object>> selectHoldCrtfListXls(HoldCrtfVO vo) throws SQLException{
		return holdCrtfMapper.selectHoldCrtfListXls(vo);
	}

	public HoldCrtfVO selectHoldCrtfView(HoldCrtfVO vo) throws SQLException{
		return holdCrtfMapper.selectHoldCrtfView(vo);
	}

	public int insertHoldCrtf(HoldCrtfVO vo, MultipartHttpServletRequest req) throws SQLException, IOException{
		int cnt = 0;
		
		if(vo.getLabrrVO() != null && vo.getLabrrVO().size() > 0)
			cnt = vo.getLabrrVO().size();
		else
			cnt = holdCrtfMapper.selectHoldCrtfIssuLabrrCnt(vo);
		
		if(cnt > 0){
			holdCrtfMapper.insertHoldCrtf(vo);
			
			if(req != null)
				attchFileInfoService.insertAttchFileInfo(fileService.upload(req), vo.getSn(), "ATCH0014");
			
			else{
				attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSn(), "ATCH0014");
			
				if("N".equals(vo.getTmprAt())){
					//전결 처리
					SanctnVO sanctnVO = new SanctnVO();
					sanctnVO.setDocNo((int)vo.getSn());
					sanctnVO.setSanctnKnd("ARCS0005");
					sanctnVO.setRgstId(vo.getRgstId());
					sanctnService.insertSanctnProgrs(sanctnVO);
					
					sanctnVO.setSanctnSttus("APRV0002");
					sanctnVO.setSanctnResn("보유증명서 발급신청 전결처리");
					sanctnService.insertSanctnProgrs(sanctnVO);
					sanctnVO.setSanctnSttus("APRV0005");
					sanctnService.insertSanctnProgrs(sanctnVO);
				}
			}
		}
		
		return cnt;
	}

	public int updateHoldCrtf(HoldCrtfVO vo, MultipartHttpServletRequest req) throws SQLException, IOException{
		int cnt = 0;
		
		HoldCrtfProgrsVO pvo = new HoldCrtfProgrsVO();
		
		if(vo.getLabrrVO() != null && vo.getLabrrVO().size() > 0)
			cnt = vo.getLabrrVO().size();
		else
			cnt = holdCrtfMapper.selectHoldCrtfIssuLabrrCnt(vo);
		
		if(cnt > 0){
			holdCrtfMapper.updateHoldCrtf(vo);
			holdCrtfMapper.deleteHoldCrtfCntrwk(vo);
			holdCrtfMapper.deleteHoldCrtfLabrr(vo);
			holdCrtfMapper.deleteHoldCrtfJssfc(vo);
			holdCrtfMapper.deleteHoldCrtfGrad(vo);
			
			if(vo.getCntrwkVO() != null) {
				for(HoldCrtfCntrwkVO cvo : vo.getCntrwkVO()){
					cvo.setSn(vo.getSn());
					holdCrtfMapper.insertHoldCrtfCntrwk(cvo);
				}
			}
			
			if(vo.getLabrrVO() != null) {
				for(HoldCrtfLabrrVO cvo : vo.getLabrrVO()){
					cvo.setSn(vo.getSn());
					holdCrtfMapper.insertHoldCrtfLabrr(cvo);
				}
			}
			
			if(vo.getJssfcVO() != null){
				for(HoldCrtfJssfcVO cvo : vo.getJssfcVO()){
					cvo.setSn(vo.getSn());
					holdCrtfMapper.insertHoldCrtfJssfc(cvo);
				}
			}
			
			if(vo.getGradVO() != null){
				for(HoldCrtfGradVO cvo : vo.getGradVO()){
					cvo.setSn(vo.getSn());
					holdCrtfMapper.insertHoldCrtfGrad(cvo);
				}
			}
			
			attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
			
			if(req != null) {
				attchFileInfoService.insertAttchFileInfo(fileService.upload(req), vo.getSn(), "ATCH0014");
				pvo.setProgrsDe(LocalDate.now().toString());
				pvo.setProgrsSttus("CAPG0002");
				pvo.setRgstId(vo.getRgstId());
				pvo.setHoldCrtfSn(vo.getSn());
				this.insertHoldCrtfProgrs(pvo);
			}else
				attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getSn(), "ATCH0014");
		}
		
		return cnt;
	}

	public void deleteHoldCrtf(HoldCrtfVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		avo.setParntsSe("ATCH0014");
		avo.setParntsSn(vo.getSn());
		
		holdCrtfMapper.deleteHoldCrtfCntrwk(vo);
		holdCrtfMapper.deleteHoldCrtfCntrwk(vo);
		holdCrtfMapper.deleteHoldCrtfJssfc(vo);
		holdCrtfMapper.deleteHoldCrtfGrad(vo);
		holdCrtfMapper.deleteHoldCrtf(vo);
		attchFileInfoService.deleteAttchFileInfo(avo);
	}

	@Override
	public List<HoldCrtfProgrsVO> selectHoldCrtfProgrsList(HoldCrtfVO vo) throws SQLException{
		return holdCrtfMapper.selectHoldCrtfProgrsList(vo);
	}

	@Override
	public String insertHoldCrtfProgrs(HoldCrtfProgrsVO vo) throws SQLException{
		String sttus = "", msg = "";
		HoldCrtfVO hvo = new HoldCrtfVO();
		hvo.setSn(vo.getHoldCrtfSn());
		hvo = holdCrtfService.selectHoldCrtfView(hvo);
		
		if(!"CAPG0002".equals(vo.getProgrsSttus()) && StringUtils.isEmpty(hvo.getRceptNo())){
			sttus = vo.getProgrsSttus();
			vo.setProgrsSttus("CAPG0002");
			holdCrtfMapper.insertHoldCrtfProgrs(vo);
		}
		
		//접수번호 생성
		if("CAPG0002".equals(vo.getProgrsSttus()) && StringUtils.isEmpty(hvo.getRceptNo())){
			hvo.setChrgId(vo.getRgstId());
			hvo.setChrgBrffc(vo.getRgstBrffc());
			holdCrtfMapper.updateHoldCrtfRceptNo(hvo);
		}

		if(!StringUtils.isEmpty(sttus))
			vo.setProgrsSttus(sttus);
		
		holdCrtfMapper.insertHoldCrtfProgrs(vo);
		
		return msg;
	}

	@Override
	public List<CntrctInfoVO> selectCntrctList(CntrctInfoVO vo) throws SQLException{
		vo.setTotalCnt(holdCrtfMapper.selectCntrctListCnt(vo));
		return holdCrtfMapper.selectCntrctList(vo);
	}

	@Override
	public List<HoldCrtfLabrrVO> selectLabrrList(HoldCrtfVO vo) throws SQLException{
		vo.setTotalCnt(holdCrtfMapper.selectLabrrListCnt(vo));
		return holdCrtfMapper.selectLabrrList(vo);
	}

	@Override
	public IssuAgreVO selectIssuAgreView(IssuAgreVO vo) throws SQLException{
		return holdCrtfMapper.selectIssuAgreView(vo);
	}

	@Override
	public List<CntrctInfoVO> selectDdcAsctList(UserVO vo) throws SQLException{
		return holdCrtfMapper.selectDdcAsctList(vo);
	}

	@Override
	public List<HoldCrtfVO> selectIssuList(HoldCrtfVO vo) throws SQLException{
		vo.setTotalCnt(holdCrtfMapper.selectIssuListCnt(vo));
		return holdCrtfMapper.selectIssuList(vo);
	}

	public void insertHoldCrtfIssu(HoldCrtfIssuVO vo) throws SQLException{
		HoldCrtfVO hvo = new HoldCrtfVO();
		vo.setIssuNo(CrtfIssuServiceImpl.generateKey(System.nanoTime()));
		hvo.setIssuVO(vo);
		hvo.setSn(vo.getSn());
		
		while(holdCrtfMapper.selectIssuListCnt(hvo) > 0)
			vo.setIssuNo(CrtfIssuServiceImpl.generateKey(System.nanoTime()));

		hvo = holdCrtfMapper.selectHoldCrtfView(hvo);
		vo.setIssuLabrrCo(holdCrtfMapper.selectHoldCrtfIssuLabrrCnt(hvo));
		holdCrtfMapper.insertHoldCrtfIssu(vo);
	}

	@Override
	public List<HoldCrtfVO> selectUserIssuList(HoldCrtfVO vo) throws SQLException{
		vo.setTotalCnt(holdCrtfMapper.selectUserIssuListCnt(vo));
		return holdCrtfMapper.selectUserIssuList(vo);
	}
}
