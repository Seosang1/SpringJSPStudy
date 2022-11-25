package kr.or.cwma.admin.holdCrtf.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfIssuVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfLabrrVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfProgrsVO;
import kr.or.cwma.admin.holdCrtf.vo.HoldCrtfVO;
import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;

/**
 * 보유증명서 서비스
 * @author sichoi
 */
public interface HoldCrtfService{

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
	 * 등록
	 * @param vo 
	 * @param req
	 * @return int
	 * @throws SQLException 
	 * @throws IOException
	 */
	public int insertHoldCrtf(HoldCrtfVO vo, MultipartHttpServletRequest req) throws SQLException, IOException;

	/**
	 * 수정
	 * @param vo
	 * @param req
	 * @return int 
	 * @throws SQLException 
	 */
	public int updateHoldCrtf(HoldCrtfVO vo, MultipartHttpServletRequest req) throws SQLException, IOException;

	/**
	 * 삭제
	 * @param vo 
	 * @throws SQLException 
	 */
	public void deleteHoldCrtf(HoldCrtfVO vo) throws SQLException;

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
	 * @return String
	 * @throws SQLException 
	 */
	public String insertHoldCrtfProgrs(HoldCrtfProgrsVO vo) throws SQLException;
	
	/**
	 * 공사목록 조회
	 * @param vo
	 * @return List<CntrctInfoVO>
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectCntrctList(CntrctInfoVO vo) throws SQLException;

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
	 * 증명서출력 목록조회
	 * @param vo 
	 * @return List<HoldCrtfVO> 
	 * @throws SQLException 
	 */
	public List<HoldCrtfVO> selectUserIssuList(HoldCrtfVO vo) throws SQLException;
}
