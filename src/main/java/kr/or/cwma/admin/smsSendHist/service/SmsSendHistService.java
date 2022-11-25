package kr.or.cwma.admin.smsSendHist.service;
import java.sql.SQLException;
import java.util.List;

import kr.or.cwma.admin.smsSendHist.vo.SmsSendHistVO;

public interface SmsSendHistService{

	/**
	 * 목록조회
	 * @param vo 
	 * @return List<SmsSendHistVO> 
	 * @throws SQLException 
	 */
	public List<SmsSendHistVO> selectSmsSendHistList(SmsSendHistVO vo) throws SQLException;

	/**
	 * 상세조회
	 * @param vo 
	 * @return SmsSendHistVO 
	 * @throws SQLException 
	 */
	public SmsSendHistVO selectSmsSendHistView(SmsSendHistVO vo) throws SQLException;

	/**
	 * 발송
	 * @param vo 
	 * @throws SQLException 
	 */
	public void sendSms(SmsSendHistVO vo) throws SQLException;


	/**
	 * 자동발송
	 * @param 구분
	 *  - SSSE0001 : 회원가입
	 *  - SSSE0002 : 온라인상담(수신동의 시)
	 *  - SSSE0003 : 경력인정신고(보완 시)
	 *  - SSSE0004 : 근로직종확인(보완 시)
	 *  - SSSE0005 : 경력인정신고(완료 시)
	 *  - SSSE0006 : 근로직종확인(완료 시)
	 *  - SSSE0007 : 등급증명서 수수료 감면(보완 시)
	 *  - SSSE0008 : 등급증명서 수수료감면(완료 시)
	 *  - SSSE0009 : 맞춤형 교육
	 *  - SSSE0010 : 대리인 현황(접근승인 시)
	 *  - SSSE0011 : 근로자 재동의(비회원/회원-증명서 발급동의)
	 * @param 전화번호
	 * @param 회원명
	 * @param 업체명
	 * @throws SQLException 
	 */
	public void sendSmsAuto(String se, String phoneNumber, String userNm, String corpNm) throws SQLException;

}
