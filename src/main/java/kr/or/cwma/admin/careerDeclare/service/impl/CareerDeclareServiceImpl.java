package kr.or.cwma.admin.careerDeclare.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.careerDeclare.mapper.CareerDeclareMapper;
import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareProgsVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareSearchVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.common.service.CommonService;
import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.FileService;


/**
 * 경력인정신고 관리자 서비스
 * @author PCNDEV
 *
 */
@Service
public class CareerDeclareServiceImpl implements CareerDeclareService {
	
	@Autowired
	CareerDeclareMapper careerDeclareMapper;
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private AttchFileInfoService attchFileInfoService;

	@Override
	public CareerDeclareVO selectIhidnum(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnum(vo);
	}

	@Override
	public List<CareerDeclareVO> selectCareerDeclareList(CareerDeclareSearchVO vo) {
		return careerDeclareMapper.selectCareerDeclareList(vo);
	}
	@Override
	public int selectCareerDeclareListCnt(CareerDeclareSearchVO vo) {
		return careerDeclareMapper.selectCareerDeclareListCnt(vo);
	}

	@Override
	public void insertCareerDeclare(CareerDeclareVO vo, MultipartHttpServletRequest req) throws SQLException, IOException {
		
		//주민번호
		if(StringUtils.isNotEmpty(vo.getJumin1()) && StringUtils.isNotEmpty(vo.getJumin2()))
			vo.setIhidnum(vo.getJumin1() + "-" + vo.getJumin2());
		
		//휴대폰번호 
		if(StringUtils.isNotEmpty(vo.getTel1()) && StringUtils.isNotEmpty(vo.getTel2()) && StringUtils.isNotEmpty(vo.getTel3()))
			vo.setMbtlnum(vo.getTel1() + "-" + vo.getTel2() + "-" + vo.getTel3());
		
		//이메일
		if(StringUtils.isNotEmpty(vo.getEmail1()) && StringUtils.isNotEmpty(vo.getEmail2()))
			vo.setEmail(vo.getEmail1() + "@" + vo.getEmail2());
		
		//근로직종확인 필요정보
		if("CASE0002".equals(vo.getSe())) {
			//확인자 사업자등록번호
			if(StringUtils.isNotEmpty(vo.getBizno1()) && StringUtils.isNotEmpty(vo.getBizno2()) && StringUtils.isNotEmpty(vo.getBizno3()))
				vo.setBizno(vo.getBizno1() + "-" + vo.getBizno2() + "-" + vo.getBizno3());
			
			//확인자 법인번호
			if(StringUtils.isNotEmpty(vo.getJurirno1()) && StringUtils.isNotEmpty(vo.getJurirno2()))
				vo.setJurirno(vo.getJurirno1() + "-" + vo.getJurirno2());
			
			//확인자 휴대폰번호 
			if(StringUtils.isNotEmpty(vo.getTel21()) && StringUtils.isNotEmpty(vo.getTel22()) && StringUtils.isNotEmpty(vo.getTel23()))
				vo.setMbtlnum2(vo.getTel21() + "-" + vo.getTel22() + "-" + vo.getTel23());
			
		}
		
		if(StringUtils.isEmpty(vo.getChrgBrffc()))
			vo.setChrgBrffc(commonService.getDdcAsctCdByCnstwkLocplcAddr(vo.getAdres()));
		
		careerDeclareMapper.insertCareerDeclare(vo);
		
		
			//연결데이터 입력
			for(int i = 0; i < vo.getSnList().length; i++) {
				CareerDeclareVO vo2 = vo;
				vo2.setCntcSn(vo.getSnList()[i]);
				vo2.setCntcCd(vo.getCntcCodeList()[i]);
				if(vo.getJssfcNoList() != null) {
					vo2.setJssfcNo(vo.getJssfcNoList()[i]);
				}
				vo2.setDeleteAt("Y".equals(vo.getPreViewYn())? "Y":"N");
				careerDeclareMapper.insertCrtfCntcData(vo2);
			}

			if(!"Y".equals(vo.getDeleteAt())) {
				attchFileInfoService.insertAttchFileInfo(req != null?fileService.upload(req):vo.getFileVO(), vo.getCareerNo(), "ATCH0009");
		
				//진행상태값 입력
				CareerDeclareProgsVO vo2 = new CareerDeclareProgsVO();
				vo2.setCareerNo(vo.getCareerNo());
				vo2.setProgrsSttus("CAPG0001");
				vo2.setRgstId(vo.getRgstId());
				this.insertCareerDeclareProgs(vo2);
			}
	}

	@Override
	public void updateCareerDeclare(CareerDeclareVO vo, MultipartHttpServletRequest req) throws SQLException, IOException {
		//주민번호
		if(StringUtils.isNotEmpty(vo.getJumin1()) && StringUtils.isNotEmpty(vo.getJumin2()))
			vo.setIhidnum(vo.getJumin1() + "-" + vo.getJumin2());
		
		//휴대폰번호 
		if(StringUtils.isNotEmpty(vo.getTel1()) && StringUtils.isNotEmpty(vo.getTel2()) && StringUtils.isNotEmpty(vo.getTel3()))
			vo.setMbtlnum(vo.getTel1() + "-" + vo.getTel2() + "-" + vo.getTel3());
		
		//이메일
		if(StringUtils.isNotEmpty(vo.getEmail1()) && StringUtils.isNotEmpty(vo.getEmail2()))
			vo.setEmail(vo.getEmail1() + "@" + vo.getEmail2());
		
		//근로직종확인 필요정보
		if("CASE0002".equals(vo.getSe())) {
			//확인자 사업자등록번호
			if(StringUtils.isNotEmpty(vo.getBizno1()) && StringUtils.isNotEmpty(vo.getBizno2()) && StringUtils.isNotEmpty(vo.getBizno3()))
				vo.setBizno(vo.getBizno1() + "-" + vo.getBizno2() + "-" + vo.getBizno3());
			
			//확인자 법인번호
			if(StringUtils.isNotEmpty(vo.getJurirno1()) && StringUtils.isNotEmpty(vo.getJurirno2()))
				vo.setJurirno(vo.getJurirno1() + "-" + vo.getJurirno2());
			
			//확인자 휴대폰번호 
			if(StringUtils.isNotEmpty(vo.getTel21()) && StringUtils.isNotEmpty(vo.getTel22()) && StringUtils.isNotEmpty(vo.getTel23()))
				vo.setMbtlnum2(vo.getTel21() + "-" + vo.getTel22() + "-" + vo.getTel23());
		}
		
		vo.setChrgBrffc(commonService.getDdcAsctCdByCnstwkLocplcAddr(vo.getAdres()));
				
		careerDeclareMapper.updateCareerDeclare(vo);
		
		attchFileInfoService.deleteAttchFileInfoList(vo.getDelFileVO());
		
		if(req != null || vo.getFileVO() != null)
			attchFileInfoService.insertAttchFileInfo(req != null?fileService.upload(req):vo.getFileVO(), vo.getCareerNo(), "ATCH0009");
		
		//연결데이터 삭제
		careerDeclareMapper.deleteCareerCntcData(vo);
		
		//연결데이터 입력
		for(int i = 0; i < vo.getSnList().length; i++) {
			CareerDeclareVO vo2 = vo;
			vo2.setCntcSn(vo.getSnList()[i]);
			vo2.setCntcCd(vo.getCntcCodeList()[i]);
			if(vo.getJssfcNoList() != null) {
				vo2.setJssfcNo(vo.getJssfcNoList()[i]);
			}
			careerDeclareMapper.insertCrtfCntcData(vo2);
		}
	}

	@Override
	public void deleteCareerDeclare(CareerDeclareVO vo) {
		careerDeclareMapper.deleteCareerDeclare(vo);
		
		vo.setCntcType("refuse");
		careerDeclareMapper.updateCareerCntcData(vo);
	}

	@Override
	public CareerDeclareVO selectCareerDeclareView(CareerDeclareVO vo) {
		return careerDeclareMapper.selectCareerDeclareView(vo);
	}

	@Override
	public List<CareerDeclareProgsVO> selectCareerDeclareProgsList(CareerDeclareProgsVO vo) {
		return careerDeclareMapper.selectCareerDeclareProgsList(vo);
	}

	@Override
	public void insertCareerDeclareProgs(CareerDeclareProgsVO vo) {
		if("CAPG0002".equals(vo.getProgrsSttus()) && this.chkProgrsSttus(vo) == 0){
			//접수번호 생성
			CareerDeclareVO vo2 = new CareerDeclareVO();
			vo2.setCareerNo(vo.getCareerNo());
			vo2 = careerDeclareMapper.selectCareerDeclareView(vo2);
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String rceptNoFront = sdf.format(new Date());
			String rceptNo = rceptNoFront.substring(2, 4) + "-" + vo2.getSe().replaceAll("CASE000", "") + rceptNoFront.substring(4, 8) + "-";
			int rceptCnt = careerDeclareMapper.selectCareerDeclareCnt(rceptNo);
			vo2.setRceptNo(rceptNo + String.format("%04d", rceptCnt));
			careerDeclareMapper.updateCareerDeclareRceptNo(vo2);
		}
		careerDeclareMapper.insertCareerDeclareProgs(vo);
	}

	@Override
	public List<Map<String, Object>> selectCareerDeclareProgsListXls(CareerDeclareSearchVO vo) throws SQLException {
		return careerDeclareMapper.selectCareerDeclareProgsListXls(vo);
	}

	@Override
	public List<CareerDeclareVO> selectIhidnumLicense(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnumLicense(vo);
	}

	@Override
	public List<CareerDeclareVO> selectIhidnumEdu(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnumEdu(vo);
	}

	@Override
	public List<CareerDeclareVO> selectIhidnumReward(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnumReward(vo);
	}

	@Override
	public List<CareerDeclareVO> selectIhidnumWork(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnumWork(vo);
	}

	@Override
	public List<CareerDeclareVO> selectIhidnumWorkKcomwel(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnumWorkKcomwel(vo);
	}

	@Override
	public List<CareerDeclareVO> selectIhidnumWork2(CareerDeclareVO vo) {
		return careerDeclareMapper.selectIhidnumWork2(vo);
	}

	@Override
	public int chkProgrsSttus(CareerDeclareProgsVO vo) {
		return careerDeclareMapper.chkProgrsSttus(vo);
	}

	@Override
	public List<CareerDeclareVO> selectWorkDly(CareerDeclareVO vo) {
		return careerDeclareMapper.selectWorkDly(vo);
	}

	@Override
	public List<CareerDeclareVO> selectWorkCmcl(CareerDeclareVO vo) {
		return careerDeclareMapper.selectWorkCmcl(vo);
	}

	@Override
	public List<CareerDeclareVO> selectWorkCareer(CareerDeclareVO vo) {
		return careerDeclareMapper.selectWorkCareer(vo);
	}

	@Override
	public List<CareerDeclareVO> selectCrtfReqstSanctnList(CareerDeclareSearchVO careerDeclareSearchVO) {
		return careerDeclareMapper.selectCrtfReqstSanctnList(careerDeclareSearchVO);
	}

	@Override
	public int selectCrtfReqstSanctnListCnt(CareerDeclareSearchVO careerDeclareSearchVO) {
		return careerDeclareMapper.selectCrtfReqstSanctnListCnt(careerDeclareSearchVO);
	}
	@Override
	public List<CareerDeclareVO> selectIhidnumWorkExpert(CareerDeclareVO careerDeclareVO) {
		return careerDeclareMapper.selectIhidnumWorkExpert(careerDeclareVO);
	}
}
