package kr.or.cwma.admin.crtfIssu.mapper;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuSearchVO;
import kr.or.cwma.admin.crtfIssu.vo.CrtfIssuVO;
import kr.or.cwma.admin.crtfIssu.vo.FeeCrtfProgrsVO;

@Repository
public interface CrtfIssuMapper {

	/**
	 * 발급대상자 주민등록번호 등급 조회
	 * @param vo
	 * @return
	 */
	public CrtfIssuVO searchCrtfHistory(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 입력
	 * @param vo
	 * @return
	 */
	public void insertCrtfReqst(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 수정
	 * @param vo
	 * @return
	 */
	public void updateCrtfReqst(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 삭제
	 * @param vo
	 * @return
	 */
	public void deleteCrtfReqst(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 입력
	 * @param vo
	 * @return
	 */
	public Integer countCrtfIssu(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 입력
	 * @param vo
	 * @return
	 */
	public void insertCrtfIssu(CrtfIssuVO vo);

	/**
	 * 증명서신청 발급 업데이트
	 * @param vo
	 * @return
	 */
	public void updateCrtfIssu(CrtfIssuVO vo);
	
	/**
	 * 증명서신청 삭제
	 * @param vo
	 * @return
	 */
	public void deleteCrtfIssu(CrtfIssuVO vo);
	
	/**
	 * 처음 출력 확인 count
	 * @param vo
	 * @return
	 */
	public Integer selectCrtfReqFristCnt(CrtfIssuVO vo);
	
	/**
	 * 신청내역관리 count
	 * @param vo
	 * @return
	 */
	public Integer selectCrtfReqListCnt(CrtfIssuSearchVO vo);
	
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
	 * 발급대장관리 count
	 * @param vo
	 * @return
	 */
	public Integer selectCrtfIssuListCnt(CrtfIssuSearchVO vo);
	
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
	 * 수수료감면 신청 처리상태 저장
	 * @param vo
	 */
	public void insertFeeProgrs(FeeCrtfProgrsVO vo);

	/**
	 * 수수료감면 신청 처리상태 리스트 카운트
	 * @param vo
	 * @return
	 */
	public int selectProgrsCnt(FeeCrtfProgrsVO vo);

	/**
	 * 기안자/결재자 수정
	 * @param cvo
	 */
	public void updateCrtfReqstChrg(CrtfIssuVO cvo);
}
