package kr.or.cwma.admin.sanctn.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.sanctn.vo.Agncy;
import kr.or.cwma.admin.sanctn.vo.CwmaDdcAsctInfoVO;
import kr.or.cwma.admin.sanctn.vo.SanctnSearchVO;
import kr.or.cwma.admin.sanctn.vo.SanctnVO;

public interface SanctnService {

	/**
	 * 결재 리스트
	 * @param vo
	 * @return
	 */
	public List<SanctnVO> selectSanctnList(SanctnSearchVO vo);
	
	/**
	 * 지사 리스트
	 * @param vo
	 * @return
	 */
	public List<CwmaDdcAsctInfoVO> selectCwmaDdcAsctInfoList();
	
	/**
	 * 결재상태 확인
	 * @param vo
	 * @return
	 */
	public SanctnVO selectSanctnStatus(SanctnVO vo);

	/**
	 * 결재문서메인 입력
	 * @param vo
	 * @return
	 */
	public void insertSanctnProgrsMain(SanctnVO vo);

	/**
	 * 결재문서진행 입력
	 * @param vo
	 * @return
	 */
	public void insertSanctnProgrs(SanctnVO vo);

	/**
	 * 대리결제 조회
	 * @param vo
	 * @return
	 */
	public List<Agncy> selectSearchAgncyMember(Agncy vo);

	/**
	 * 대리결재 리스트
	 * @param vo
	 * @return
	 */
	public List<Agncy> selectAgncMember(Agncy vo);

	/**
	 * 대리결재 입력
	 * @param vo
	 * @return
	 */
	public void insertAgncMember(Agncy vo);
	
	/**
	 * 대리결재 삭제
	 * @param vo
	 * @return
	 */
	public void deleteAgncMember(Agncy vo);
	
	/**
	 * 대리결재 삭제
	 * @param vo
	 * @return Map<String, Object>
	 * @throws SQLException 
	 */
	public Map<String, Object> progrsSanctn(UserVO uvo, SanctnVO vo) throws SQLException;
	

	/**
	 * 목록조회 - 개인엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectSanctnListXls(SanctnSearchVO vo) throws SQLException;
}
