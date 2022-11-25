package kr.or.cwma.admin.crtfIssu.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuSearchVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.crtfIssu.vo.FeeCrtfProgrsVO;

public interface CrtfIssuService {

	/**
	 * @param vo
	 * @return
	 * 발급대상자 주민등록번호 등급 조회
	 */
	public CrtfIssuVO searchCrtfHistory(CrtfIssuVO vo);

	/**
	 * @param vo
	 * @return
	 * 증명서신청 입력
	 */
	public void insertCrtfReqst(CrtfIssuVO vo,MultipartHttpServletRequest req) throws SQLException, IOException, InterruptedException;

	/**
	 * 신청내역관리 목록
	 * @param vo
	 * @return
	 */
	public List<CrtfIssuVO> selectCrtfReqList(CrtfIssuSearchVO vo);
	
	/**
	 * @param vo
	 * @return
	 */
	public CrtfIssuVO selectCrtfReqView(CrtfIssuVO vo);

	/**
	 * 증명서신청 수정
	 * @param vo
	 * @param multi 
	 * @return
	 */
	public void updateCrtfReqst(CrtfIssuVO vo, MultipartHttpServletRequest multi) throws SQLException, IOException, InterruptedException;
	
	/**
	 * 증명서신청 삭제
	 * @param vo
	 * @return
	 */
	public void deleteCrtfReqst(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 발급 업데이트
	 * @param vo
	 * @return
	 */
	public void updateCrtfIssu(CrtfIssuVO vo);
	
	/**
	 * 처음 출력 확인 count
	 * @param vo
	 * @return
	 */
	public Integer selectCrtfReqFristCnt(CrtfIssuVO vo);

	/**
	 * 발급대장관리 목록
	 * @param vo
	 * @return
	 */
	public List<CrtfIssuVO> selectCrtfIssuList(CrtfIssuSearchVO vo);

	/**
	 * 신청내역관리 엑셀
	 * @param vo
	 * @return
	 */
	public List<Map<String, Object>> selectCrtfReqListXls(CrtfIssuSearchVO vo);
	

	/**
	 * 발급대장관리 엑셀
	 * @param vo
	 * @return
	 */
	public List<Map<String, Object>> selectCrtfIssuListXls(CrtfIssuSearchVO vo);

	/**
	 * 수수료감면 신청 리스트
	 * @param vo
	 * @return
	 */
	public List<CrtfIssuVO> selectCrtfReqFeeRdcxptList(CrtfIssuSearchVO vo);

	/**
	 * 수수료감면 신청 리스트 카운트
	 * @param vo
	 * @return
	 */
	public int selectCrtfReqFeeRdcxptListCnt(CrtfIssuSearchVO vo);

	/**
	 * 주 직종 코드(비기능직은 제외한 제일많이 일한 직종)
	 * @param vo
	 * @return
	 */
	public HashMap<String, Object> selectMainJssfcCd(CrtfIssuVO vo);

	/**
	 * 증명서 발급 신청 미리보기 정보 저장
	 * @param vo
	 */
	public void insertCrtfIssuPreView(CrtfIssuVO vo);

	/**
	 * 수수료감면 신청 처리상태 리스트
	 * @param vo
	 * @return List<FeeCrtfProgrsVO>
	 */
	public List<FeeCrtfProgrsVO> selectSanctnList(CrtfIssuVO vo);

	/**
	 * 수수료감면 신청 결재상태 저장
	 * @param feeVO
	 */
	public void insertFeeProgrs(FeeCrtfProgrsVO feeVO);
}
