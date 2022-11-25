package kr.or.cwma.admin.banner.service.impl;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.banner.mapper.BannerMapper;
import kr.or.cwma.admin.banner.service.BannerService;
import kr.or.cwma.admin.banner.vo.BannerVO;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

@Service
public class BannerServiceImpl implements BannerService{

	@Autowired
	private BannerMapper bannerMapper;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;

	public List<BannerVO> selectBannerList(BannerVO vo) throws SQLException{
		vo.setTotalCnt(bannerMapper.selectBannerListCnt(vo));
		return bannerMapper.selectBannerList(vo);
	}

	public BannerVO selectBannerView(BannerVO vo) throws SQLException{
		return bannerMapper.selectBannerView(vo);
	}

	public void insertBanner(BannerVO vo) throws SQLException, IOException{
		bannerMapper.insertBanner(vo);
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO1(), vo.getSn(), "ATCH0007");
		//attchFileInfoService.insertAttchFileInfo(vo.getFileVO2(), vo.getSn(), "ATCH0008");
	}

	public void updateBanner(BannerVO vo) throws SQLException, IOException{
		bannerMapper.updateBanner(vo);
		attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
		attchFileInfoService.insertAttchFileInfo(vo.getFileVO1(), vo.getSn(), "ATCH0007");
		//attchFileInfoService.insertAttchFileInfo(vo.getFileVO2(), vo.getSn(), "ATCH0008");
	}

	public void deleteBanner(BannerVO vo) throws SQLException{
		AttchFileInfoVO avo = new AttchFileInfoVO();
		avo.setParntsSe("ATCH0007");
		avo.setParntsSn(vo.getSn());
		
		attchFileInfoService.deleteAttchFileInfo(avo);
		
		/*
		 * avo.setParntsSe("ATCH0008"); attchFileInfoService.deleteAttchFileInfo(avo);
		 */
		
		bannerMapper.deleteBanner(vo);
	}

}
