package kr.or.cwma.admin.issuAgre.mapper;
import java.sql.SQLException;
import java.util.List;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.issuAgre.vo.IssuAgreVO;
import kr.or.cwma.admin.userInfo.vo.CntrctInfoVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;

/**
 * 회원 발급동의신청 매퍼
 */
@Repository
public interface IssuAgreMapper{

	/**  
	 * 발급동의신청 공사정보 조회(퇴직공제)
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public IssuAgreVO selectIssuAgre(IssuAgreVO vo) throws SQLException;
	
	/**  
	 * 발급동의신청 공사정보 조회(고용보험)
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public IssuAgreVO selectIssuAgreWork(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 발급동의신청 등록
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int insertIssuAgre(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 발급동의신청 수정
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int updateIssuAgre(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 발급동의신청 삭제
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int deleteIssuAgre(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 관리자 결제관리 - 발급동의신청 조회
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public IssuAgreVO selectIssuAgreView(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 발급동의신청 공사목록 개수(퇴직공제, 고용보험)
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int selectCntrctListCnt(UserInfoVO vo) throws SQLException;
	
	/**
	 * 발급동의신청 공사목록(퇴직공제, 고용보험)
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public List<CntrctInfoVO> selectCntrctList(UserInfoVO vo) throws SQLException;
	
	/**
	 * 마이페이지 발급동의신청 조회
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public IssuAgreVO selectIssuAgreInfo(IssuAgreVO vo) throws SQLException;
	
	/**
	 * 발급동의신청 접수번호 카운트
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int selectIssuAgreRceptNoCnt(String rceptNo) throws SQLException;
	
	/**
	 * 발급동의신청 접수번호 등록
	 * @param vo
	 * @return
	 * @throws SQLException
	 */
	public int updateIssuAgreRceptNo(IssuAgreVO vo) throws SQLException;
}
