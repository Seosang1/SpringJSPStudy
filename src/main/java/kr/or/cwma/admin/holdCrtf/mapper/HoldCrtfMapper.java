package kr.or.cwma.admin.holdCrtf.mapper;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfCntrwkVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfGradVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfJssfcVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfLabrrVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfProgrsVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;

/**
 * 보유증명서 매퍼
 * @author sichoi
 */
@Repository
public interface HoldCrtfMapper{

	/**
	 * 목록갯수조회
	 * @param vo 
	 * @return List<HoldCrtfVO> 
	 * @throws SQLException 
	 */
	public int selectHoldCrtfListCnt(HoldCrtfVO vo) throws SQLException;

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<HoldCrtfVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfVO> selectHoldCrtfList(HoldCrtfVO vo) throws SQLException;

	/**
	 * 목록조회 - 엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectHoldCrtfListXls(HoldCrtfVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return HoldCrtfVO 
	 * @throws SQLException 
	 */
	public HoldCrtfVO selectHoldCrtfView(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 발급대상자수 조회 
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int selectHoldCrtfIssuLabrrCnt(HoldCrtfVO vo) throws SQLException;

	/**
	 * 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertHoldCrtf(HoldCrtfVO vo) throws SQLException;

	/**
	 * 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateHoldCrtf(HoldCrtfVO vo) throws SQLException;

	/**
	 * 접수번호 수정
	 * @param vo 
	 * @throws SQLException 
	 */
	public void updateHoldCrtfRceptNo(HoldCrtfVO vo) throws SQLException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteHoldCrtf(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 사업장 목록조회
	 * @param vo 
	 * @return List<HoldCrtfCntrwkVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfCntrwkVO> selectHoldCrtfCntrwkList(HoldCrtfCntrwkVO vo) throws SQLException;

	/**
	 * 사업장 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertHoldCrtfCntrwk(HoldCrtfCntrwkVO vo) throws SQLException;

	/**
	 * 사업장 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteHoldCrtfCntrwk(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 근로자 목록조회
	 * @param vo 
	 * @return List<HoldCrtfLabrrVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfLabrrVO> selectHoldCrtfLabrrList(HoldCrtfLabrrVO vo) throws SQLException;

	/**
	 * 근로자 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertHoldCrtfLabrr(HoldCrtfLabrrVO vo) throws SQLException;

	/**
	 * 근로자 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteHoldCrtfLabrr(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 직종 목록조회
	 * @param vo 
	 * @return List<HoldCrtfJssfcVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfJssfcVO> selectHoldCrtfJssfcList(HoldCrtfJssfcVO vo) throws SQLException;

	/**
	 * 직종 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertHoldCrtfJssfc(HoldCrtfJssfcVO vo) throws SQLException;

	/**
	 * 직종 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteHoldCrtfJssfc(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 등급 목록조회
	 * @param vo 
	 * @return List<HoldCrtfGradVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfGradVO> selectHoldCrtfGradList(HoldCrtfGradVO vo) throws SQLException;

	/**
	 * 등급 등록
	 * @param vo 
	 * @throws SQLException 
	 */
	public void insertHoldCrtfGrad(HoldCrtfGradVO vo) throws SQLException;

	/**
	 * 등급 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteHoldCrtfGrad(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 진행상황 목록조회
	 * @param vo
	 * @return List<HoldCrtfProgrsVO>
	 * @throws SQLException
	 */
	public List<HoldCrtfProgrsVO> selectHoldCrtfProgrsList(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 진행상황 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertHoldCrtfProgrs(HoldCrtfProgrsVO vo) throws SQLException;
	
	/**
	 * 공사목록 조회
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectCntrctList(CntrctInfoVO vo) throws SQLException;
	
	/**
	 * 공사목록 갯수 조회
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int selectCntrctListCnt(CntrctInfoVO vo) throws SQLException;
	
	/**
	 * 근로자 목록갯수조회
	 * @param vo
	 * @return int
	 * @throws SQLException
	 */
	public int selectLabrrListCnt(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 근로자 목록조회
	 * @param vo
	 * @return List<HoldCrtfLabrrVO>
	 * @throws SQLException
	 */
	public List<HoldCrtfLabrrVO> selectLabrrList(HoldCrtfVO vo) throws SQLException;
	
	/**
	 * 발급동의자 조회 
	 * @param vo
	 * @return IssuAgreVO
	 * @throws SQLException
	 */
	public IssuAgreVO selectIssuAgreView(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 지사목록 조회
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectDdcAsctList(UserVO vo) throws SQLException;

	/**
	 * 발급대장 목록 갯수 조회
	 * @param vo 
	 * @return int
	 * @throws SQLException 
	 */
	public int selectIssuListCnt(HoldCrtfVO vo) throws SQLException;

	/**
	 * 발급대장 목록조회
	 * @param vo 
	 * @return List<HoldCrtfVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfVO> selectIssuList(HoldCrtfVO vo) throws SQLException;

	/**
	 * 발급 등록
	 * @param vo
	 * @throws SQLException
	 */
	public void insertHoldCrtfIssu(HoldCrtfIssuVO vo) throws SQLException;

	/**
	 * 증명서출력 목록갯수조회
	 * @param vo 
	 * @return int
	 * @throws SQLException 
	 */
	public int selectUserIssuListCnt(HoldCrtfVO vo) throws SQLException;

	/**
	 * 증명서출력 목록조회
	 * @param vo 
	 * @return List<HoldCrtfVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfVO> selectUserIssuList(HoldCrtfVO vo) throws SQLException;
	
}
