package kr.or.cwma.admin.sanctn.service.impl;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.or.cwma.admin.careerDeclare.mapper.CareerDeclareMapper;
import kr.or.cwma.admin.careerDeclare.service.CareerDeclareService;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareProgsVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.crtfIssu.mapper.CrtfIssuMapper;
import kr.or.cwma.admin.crtfIssu.vo.FeeCrtfProgrsVO;
import kr.or.cwma.admin.holdCrtf.service.HoldCrtfService;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfProgrsVO;
import kr.or.cwma.admin.sanctn.mapper.SanctnMapper;
import kr.or.cwma.admin.sanctn.service.SanctnService;
import kr.or.cwma.admin.sanctn.vo.Agncy;
import kr.or.cwma.admin.sanctn.vo.CwmaDdcAsctInfoVO;
import kr.or.cwma.admin.sanctn.vo.SanctnSearchVO;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;

/**
 * @author PCNDEV
 *
 */
@Service
public class SanctnServiceImpl implements SanctnService{
	
	@Autowired
	SanctnMapper sanctnMapper;
	
	@Autowired
	CareerDeclareService careerDeclareService;

	@Autowired
	CareerDeclareMapper careerDeclareMapper;
	
	@Autowired
	HoldCrtfService holdCrtfService;

	@Autowired
	CrtfIssuMapper crtfIssuMapper;
	
	@Override
	public List<SanctnVO> selectSanctnList(SanctnSearchVO vo) {
		// TODO Auto-generated method stub
		List<SanctnVO> list = null;
		
		if("PROGRS".equals(vo.getSanctnList())){
			vo.setTotalCnt(sanctnMapper.selectSanctnProgrsListCnt(vo));
			list = sanctnMapper.selectSanctnProgrsList(vo);
		}else {
			vo.setTotalCnt(sanctnMapper.selectSanctnListCnt(vo));
			list = sanctnMapper.selectSanctnList(vo);
		}
		
		return list;
	}

	@Override
	public List<CwmaDdcAsctInfoVO> selectCwmaDdcAsctInfoList() {
		// TODO Auto-generated method stub
		return sanctnMapper.selectCwmaDdcAsctInfoList();
	}

	@Override
	public SanctnVO selectSanctnStatus(SanctnVO vo) {
		// TODO Auto-generated method stub
		return sanctnMapper.selectSanctnStatus(vo);
	}

	@Override
	public void insertSanctnProgrsMain(SanctnVO vo) {
		// TODO Auto-generated method stub
		sanctnMapper.insertSanctnProgrsMain(vo);
	}
	
	@Override
	public void insertSanctnProgrs(SanctnVO vo) {
		//결재문서에 등록되어있는지 조회 후 없으면 main 등록
		Integer sanctnNo = sanctnMapper.chkSanctnProgrs(vo);
		if(sanctnNo == null) {
			sanctnMapper.insertSanctnProgrsMain(vo);
		}else {
			vo.setSanctnNo(sanctnNo);
			
			if(StringUtils.isNotEmpty(vo.getSanctnId()))
				sanctnMapper.updateSanctnProgrsMain(vo);
		}
		
		//결재회수 취소. 기존의 승인 반려 값을 조회 후 다시 입력.
		if("APRV0000".equals(vo.getSanctnSttus())) {
			SanctnVO sanctnSttus = sanctnMapper.selectLastProgrs(vo);
			vo.setSanctnSttus(sanctnSttus.getSanctnSttus());
		}
		
		sanctnMapper.insertSanctnProgrs(vo);
	}

	@Override
	public List<Agncy> selectSearchAgncyMember(Agncy vo) {
		// TODO Auto-generated method stub
		return sanctnMapper.selectSearchAgncyMember(vo);
	}

	@Override
	public List<Agncy> selectAgncMember(Agncy vo) {
		// TODO Auto-generated method stub
		return sanctnMapper.selectAgncMember(vo);
	}

	@Override
	public void insertAgncMember(Agncy vo) {
		// TODO Auto-generated method stub
		sanctnMapper.insertAgncMember(vo);
	}

	@Override
	public void deleteAgncMember(Agncy vo) {
		// TODO Auto-generated method stub,
		sanctnMapper.deleteAgncMember(vo);
	}

	@Override
	public Map<String, Object> progrsSanctn(UserVO uvo, SanctnVO vo) throws SQLException {
		Map<String, Object> map = new HashMap<String, Object>();
		
		vo.setRgstId(uvo.getUserId());
		
		vo.setCareerNo(vo.getDocNo());
		
		//결재문서에 등록되어있는지 조회 후 없으면 main 등록
		Integer sanctnNo = sanctnMapper.chkSanctnProgrs(vo);
		if(sanctnNo == null) {
			map.put("msg", "잘못 된 결재 입니다.");
			return map;
		}else {
			vo.setSanctnNo(sanctnNo);
		}
		
		SanctnVO compareVo = this.selectSanctnStatus(vo);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		//승인 반려 코드만 입력 받음.
		if("APRV0005".equals(vo.getSanctnSttus()) || "APRV0006".equals(vo.getSanctnSttus())) {
			if("ARCS0005".equals(vo.getSanctnKnd())){
				// 승인 시 접수처리 변경 및 직종 및 경력인정신고 부분 처리 승인
				HoldCrtfProgrsVO vo2 = new HoldCrtfProgrsVO();
				vo2.setRgstId(uvo.getUserId());
				vo2.setHoldCrtfSn(vo.getCareerNo());
				vo2.setProgrsDe(sdf.format(new Date()));
				
				if("APRV0005".equals(vo.getSanctnSttus())) {
					if("APRV0003".equals(compareVo.getSanctnSttus())) {
						//반려기안을 승인 처리 시 최종결재는 반려로 입력.
						vo.setSanctnSttus("APRV0006");
						vo2.setProgrsResn("반려");
					}else {
						vo2.setProgrsResn("승인");
					}
					
					vo2.setProgrsSttus("CAPG0009");
				} else {
					if("APRV0003".equals(compareVo.getSanctnSttus())) {
						//반려기안을 반려 처리 시 기안대기로 입력.
						vo.setSanctnSttus("APRV0001");
					}else {
						vo2.setProgrsResn("반려");
					}
					
					vo2.setProgrsSttus("CAPG0007");
				}
				
				holdCrtfService.insertHoldCrtfProgrs(vo2);
				
			}else if("ARCS0002".equals(vo.getSanctnKnd())) {	//등급증명서 신청
				// 승인 시 접수처리 변경 및 직종 및 처리 승인
				FeeCrtfProgrsVO fvo = new FeeCrtfProgrsVO();
				fvo.setRgstId(uvo.getUserId());
				fvo.setReqstNo(vo.getCareerNo());
				fvo.setProgrsDe(sdf.format(new Date()));
				
				if("APRV0005".equals(vo.getSanctnSttus())) {
					if("APRV0003".equals(compareVo.getSanctnSttus())) {
						//반려기안을 승인 처리 시 최종결재는 반려로 입력.
						vo.setSanctnSttus("APRV0006");
						fvo.setProgrsResn("반려");
					}else {
						fvo.setProgrsResn("승인");
					}
					fvo.setProgrsSttus("FEEA0007");	//처리완료
				} else {
					if("APRV0003".equals(compareVo.getSanctnSttus())) {
						//반려기안을 반려 처리 시 기안대기로 입력.
						vo.setSanctnSttus("APRV0001");
					}else {
						fvo.setProgrsResn("반려");
					}
					fvo.setProgrsSttus("FEEA0006");	//제출완료
				}
				
				crtfIssuMapper.insertFeeProgrs(fvo);
				
			}else{
				// 승인 시 접수처리 변경 및 직종 및 경력인정신고 부분 처리 승인
				CareerDeclareProgsVO vo2 = new CareerDeclareProgsVO();
				vo2.setRgstId(uvo.getUserId());
				vo2.setCareerNo(vo.getCareerNo());
				vo2.setProgrsDe(sdf.format(new Date()));
				
				CareerDeclareVO vo3 = new CareerDeclareVO();
				vo3.setCareerNo(vo.getDocNo());
				
				if("APRV0005".equals(vo.getSanctnSttus())) {
					if("APRV0003".equals(compareVo.getSanctnSttus())) {
						//반려기안을 승인 처리 시 최종결재는 반려로 입력.
						vo.setSanctnSttus("APRV0006");
						vo2.setProgrsResn("반려");
					}else {
						vo2.setProgrsResn("승인");
					}
					
					//승인 시 처리 로직 추가 예정
					vo3.setCntcType("confirm");
					vo2.setProgrsSttus("CAPG0009");
				} else {
					if("APRV0003".equals(compareVo.getSanctnSttus())) {
						//반려기안을 반려 처리 시 기안대기로 입력.
						vo.setSanctnSttus("APRV0001");
					}else {
						vo2.setProgrsResn("반려");
					}
					
					//승인 시 처리 로직 추가 예정
					vo3.setCntcType("refuse");
					vo2.setProgrsSttus("CAPG0007");
				}
				
				// 승인/거절 시 사용 및 사용 불가 데이터 입력.
				careerDeclareMapper.updateCareerCntcData(vo3);
				careerDeclareService.insertCareerDeclareProgs(vo2);
			}
		}
		
		//결재과정 입력
		this.insertSanctnProgrs(vo);
		
		return map;
	}

	@Override
	public List<Map<String, Object>> selectSanctnListXls(SanctnSearchVO vo) throws SQLException {
		// TODO Auto-generated method stub
		List<Map<String, Object>> list = null;
		if("PROGRS".equals(vo.getSanctnList())){
			vo.setTotalCnt(sanctnMapper.selectSanctnProgrsListCnt(vo));
			list = sanctnMapper.selectSanctnProgrsListXls(vo);
		}else {
			list = sanctnMapper.selectSanctnListXls(vo);
		}
		return list;
	}
}
