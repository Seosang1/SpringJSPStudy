package kr.or.cwma.admin.popup.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.popup.mapper.PopupMapper;
import kr.or.cwma.admin.popup.service.PopupService;
import kr.or.cwma.admin.popup.vo.PopupVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

@Service
public class PopupServiceImpl implements PopupService{

	@Autowired
	private PopupMapper popupMapper;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;

	public List<PopupVO> selectPopupList(PopupVO vo) throws SQLException{
		vo.setTotalCnt(popupMapper.selectPopupListCnt(vo));
		return popupMapper.selectPopupList(vo);
	}

	public PopupVO selectPopupView(PopupVO vo) throws SQLException{
		return popupMapper.selectPopupView(vo);
	}

	public void insertPopup(PopupVO vo) throws SQLException, IOException{
		popupMapper.insertPopup(vo);
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO1(), vo.getSn(), "ATCH0005");
		//attchFileInfoService.insertAttchFileInfo(vo.getFileVO2(), vo.getSn(), "ATCH0006");
	}

	public void updatePopup(PopupVO vo) throws SQLException, IOException{
		popupMapper.updatePopup(vo);
		attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO1(), vo.getSn(), "ATCH0005");
		//attchFileInfoService.insertAttchFileInfo(vo.getFileVO2(), vo.getSn(), "ATCH0006");
	}

	public void deletePopup(PopupVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		avo.setParntsSe("ATCH0005");
		avo.setParntsSn(vo.getSn());
		attchFileInfoService.deleteAttchFileInfo(avo);
		/*
		 * avo.setParntsSe("ATCH0006"); attchFileInfoService.deleteAttchFileInfo(avo);
		 */
		
		popupMapper.deletePopup(vo);
	}

}
