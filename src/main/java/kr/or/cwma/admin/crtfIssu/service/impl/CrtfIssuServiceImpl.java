package kr.or.cwma.admin.crtfIssu.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.crtfIssu.mapper.CrtfIssuMapper;
import kr.or.cwma.admin.crtfIssu.service.CrtfIssuService;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuSearchVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.crtfIssu.vo.FeeCrtfProgrsVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.FileService;

@Service
public class CrtfIssuServiceImpl implements CrtfIssuService{
	
	@Autowired
	CrtfIssuMapper crtfIssuMapper;
	
	@Autowired
	AttchFileInfoService attchFileInfoService;

	@Autowired
	private FileService fileService;
	
	@Override
	public CrtfIssuVO searchCrtfHistory(CrtfIssuVO vo) {
		return crtfIssuMapper.searchCrtfHistory(vo);
	}

	@Override
	public void insertCrtfReqst(CrtfIssuVO vo,MultipartHttpServletRequest req) throws SQLException, IOException, InterruptedException {
		//직종변경 없이 바로 입력 시  직종값 입력.
		if(null == vo.getJssfcNo() && null != vo.getJssfcNoSub()) {
			vo.setJssfcNo(vo.getJssfcNoSub());
		}
		crtfIssuMapper.insertCrtfReqst(vo);
		
		if(vo.getFileVO() != null && vo.getFileVO().size() > 0)	//관리자 파일업로드
			attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getReqstNo(), "ATCH0011");
		
		if(null != req)	// 사용자 파일업로드
			attchFileInfoService.insertAttchFileInfo(fileService.upload(req), vo.getReqstNo(), "ATCH0011");
		
		for(int i = 0 ; i < vo.getIssuCo(); i++) {
			vo.setIssuNo(generateKey(System.currentTimeMillis()));
			while(crtfIssuMapper.countCrtfIssu(vo) != 0) {
				vo.setIssuNo(generateKey(System.currentTimeMillis()));
				Thread.sleep(100);
			}
			Thread.sleep(100);
			crtfIssuMapper.insertCrtfIssu(vo);
		}
	}

	@Override
	public List<CrtfIssuVO> selectCrtfReqList(CrtfIssuSearchVO vo) {
		vo.setTotalCnt(crtfIssuMapper.selectCrtfReqListCnt(vo));
		List<CrtfIssuVO> list = crtfIssuMapper.selectCrtfReqList(vo);
		
		for(CrtfIssuVO cvo : list) {
			String[] jumin = cvo.getIssuTrgterIhidnum().split("-");
			cvo.setJumin3(jumin[0]);
			cvo.setJumin4(jumin[1].substring(0, 1)+"******");
		}
		return list;
	}

	@Override
	public CrtfIssuVO selectCrtfReqView(CrtfIssuVO vo) {
		return crtfIssuMapper.selectCrtfReqView(vo);
	}
	
	public static String generateKey(long date){
		Random oRandom = new Random();
		oRandom.setSeed(date);
		StringBuffer key = new StringBuffer();
		
		while(key.length()<16){
			int iKey = Math.abs(oRandom.nextInt()%74)+48;
			//숫자 아스키 코드 : 48~57 10
			//대문자 아스키 코드 :65~90 26
			//소문자 아스키 코드 : 97~122 26
			if((iKey >= 48 && iKey <=57)||(iKey >= 65 && iKey <=90))
				key.append((char)(iKey));
		}
		
		String rtnKey = "";
		
		for(int i=0; i < key.length(); i++) {
			rtnKey += key.charAt(i);
			if(i != 0 && (i+1) % 4 ==0 && i < 15) {
				rtnKey += "-"; 
			}
		}
		
		return rtnKey;
	}

	@Override
	public void updateCrtfReqst(CrtfIssuVO vo, MultipartHttpServletRequest req) throws SQLException, IOException, InterruptedException {
		//직종변경 없이 바로 입력 시  직종값 입력.
		if(null == vo.getJssfcNo() && null != vo.getJssfcNoSub()) {
			vo.setJssfcNo(vo.getJssfcNoSub());
		}
		
		crtfIssuMapper.updateCrtfReqst(vo);
		crtfIssuMapper.deleteCrtfIssu(vo);
		
		for(int i = 0 ; i < vo.getIssuCo(); i++) {
			vo.setIssuNo(generateKey(System.currentTimeMillis()));
			while(crtfIssuMapper.countCrtfIssu(vo) != 0) {
				vo.setIssuNo(generateKey(System.currentTimeMillis()));
				Thread.sleep(100);
			}
			Thread.sleep(100);
			crtfIssuMapper.insertCrtfIssu(vo);
		}
		
		attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
		
		if(vo.getFileVO() != null && vo.getFileVO().size() > 0)
			attchFileInfoService.insertAttchFileInfo(vo.getFileVO(), vo.getReqstNo(), "ATCH0011");
		
		if(null != req)
			attchFileInfoService.insertAttchFileInfo(fileService.upload(req), vo.getReqstNo(), "ATCH0011");
	}

	@Override
	public void deleteCrtfReqst(CrtfIssuVO vo) {
		crtfIssuMapper.deleteCrtfReqst(vo);
	}

	@Override
	public void updateCrtfIssu(CrtfIssuVO vo) {
		crtfIssuMapper.updateCrtfIssu(vo);
	}

	@Override
	public List<CrtfIssuVO> selectCrtfIssuList(CrtfIssuSearchVO vo) {
		vo.setTotalCnt(crtfIssuMapper.selectCrtfIssuListCnt(vo));
		
		List<CrtfIssuVO> list = crtfIssuMapper.selectCrtfIssuList(vo);
		for(CrtfIssuVO cvo : list) {
			String[] jumin = cvo.getIssuTrgterIhidnum().split("-");
			cvo.setJumin1(jumin[0]);
			cvo.setJumin2(jumin[1].substring(0, 1)+"******");
		}
		return list;
	}

	@Override
	public List<Map<String, Object>> selectCrtfReqListXls(CrtfIssuSearchVO vo) {
		return crtfIssuMapper.selectCrtfReqListXls(vo);
	}

	@Override
	public List<Map<String, Object>> selectCrtfIssuListXls(CrtfIssuSearchVO vo) {
		return crtfIssuMapper.selectCrtfIssuListXls(vo);
	}

	@Override
	public Integer selectCrtfReqFristCnt(CrtfIssuVO vo) {
		return crtfIssuMapper.selectCrtfReqFristCnt(vo);
	}

	@Override
	public List<CrtfIssuVO> selectCrtfReqFeeRdcxptList(CrtfIssuSearchVO vo) {
		List<CrtfIssuVO> list = crtfIssuMapper.selectCrtfReqFeeRdcxptList(vo);
		for(CrtfIssuVO cvo : list) {
			String[] jumin = cvo.getIssuTrgterIhidnum().split("-");
			cvo.setJumin3(jumin[0]);
			/* 주민등록번호 뒷부분 공개여부 추가 */
			/*if("Y".equals(cvo.getIhidnumOthbcAt()))
				cvo.setJumin4(jumin[1]);
			else*/
			cvo.setJumin4(jumin[1].substring(0, 1)+"******");
			cvo.setIssuTrgterIhidnum("");
		}
		return list;
	}
	@Override
	public int selectCrtfReqFeeRdcxptListCnt(CrtfIssuSearchVO vo) {
		return crtfIssuMapper.selectCrtfReqFeeRdcxptListCnt(vo);
	}

	@Override
	public HashMap<String, Object> selectMainJssfcCd(CrtfIssuVO vo) {
		return crtfIssuMapper.selectMainJssfcCd(vo);
	}

	@Override
	public void insertCrtfIssuPreView(CrtfIssuVO vo) {
		crtfIssuMapper.insertCrtfIssuPreView(vo);
	}
	
	@Override
	public List<FeeCrtfProgrsVO> selectSanctnList(CrtfIssuVO vo) {
		return crtfIssuMapper.selectSanctnList(vo);
	}

	@Override
	public void insertFeeProgrs(FeeCrtfProgrsVO vo) {
		// 최초 처리상태 등록시 접수가 아니면 민원접수 추가
		int cnt = crtfIssuMapper.selectProgrsCnt(vo);
		String befStatus = vo.getProgrsSttus();
		CrtfIssuVO cvo = new CrtfIssuVO();
		
		if(cnt == 0 && !"FEEA0002".equals(vo.getProgrsSttus())) {
			vo.setProgrsSttus("FEEA0008");	//처리상태 : 민원접수
			crtfIssuMapper.insertFeeProgrs(vo);
		}
		
		//기안자/결재자 수정
		if(cnt == 0 && ("FEEA0002".equals(vo.getProgrsSttus()) || "FEEA0008".equals(vo.getProgrsSttus()))){
			cvo.setReqstNo((int)vo.getReqstNo());
			cvo.setChgId(vo.getRgstId());
			cvo.setChrgBrffc(vo.getRgstBrffc());
			crtfIssuMapper.updateCrtfReqstChrg(cvo);
		}
		
		vo.setProgrsSttus(befStatus);
		crtfIssuMapper.insertFeeProgrs(vo);
	}
}
