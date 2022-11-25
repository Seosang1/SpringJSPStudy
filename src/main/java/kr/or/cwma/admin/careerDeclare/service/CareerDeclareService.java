package kr.or.cwma.admin.careerDeclare.service;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareProgsVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareSearchVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;

public interface CareerDeclareService {
	
	/**
	 * 주민등록번호 조회
	 * @param vo
	 * @return
	 */
	public CareerDeclareVO selectIhidnum(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 진행 목록
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareProgsVO> selectCareerDeclareProgsList(CareerDeclareProgsVO vo);

	/**
	 * 경력인정신고 목록 
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectCareerDeclareList(CareerDeclareSearchVO vo);
	
	/**
	 * 경력인정신고 목록 카운트
	 * @param careerDeclareSearchVO
	 * @return
	 */
	public int selectCareerDeclareListCnt(CareerDeclareSearchVO vo);
	/**
	 * 경력인정신고 뷰
	 * @param vo
	 * @return
	 */
	public CareerDeclareVO selectCareerDeclareView(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 신청 입력
	 * @param vo
	 * @return
	 */
	public void insertCareerDeclare(CareerDeclareVO vo, MultipartHttpServletRequest req) throws SQLException, IOException;
	

	/**
	 * 경력인정신고 신청 수정
	 * @param vo
	 * @return
	 */
	public void updateCareerDeclare(CareerDeclareVO vo, MultipartHttpServletRequest req) throws SQLException, IOException;
	
	/**
	 * 경력인정신고 신청 삭제
	 * @param vo
	 * @return
	 */
	public void deleteCareerDeclare(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 신청 입력
	 * @param vo
	 * @return
	 */
	public void insertCareerDeclareProgs(CareerDeclareProgsVO vo);

	/**
	 * 목록조회 - 개인엑셀
	 * @param vo 
	 * @return List<Map<String, Object>> 
	 * @throws SQLException 
	 */
	public List<Map<String, Object>> selectCareerDeclareProgsListXls(CareerDeclareSearchVO vo) throws SQLException;

	/**
	 * 라이센스 조회
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumLicense(CareerDeclareVO vo);
	
	/**
	 * 교육훈련 조회
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumEdu(CareerDeclareVO vo);
	
	/**
	 * 포상 조회
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumReward(CareerDeclareVO vo);
	
	/**
	 * 근무경력 조회
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumWork(CareerDeclareVO vo);

	/**
	 * 근무경력 조회 - 고용보험
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumWorkKcomwel(CareerDeclareVO vo);
	
	/**
	 * 근무경력 조회
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumWork2(CareerDeclareVO vo);
	

	/**
	 * 경력인정신고 진행사항 체크
	 * @param vo
	 * @return
	 */
	public int chkProgrsSttus(CareerDeclareProgsVO vo);

	/**
	 * 근무경력 - 일용
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectWorkDly(CareerDeclareVO vo);

	/**
	 * 근무경력 - 상용
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectWorkCmcl(CareerDeclareVO vo);

	/**
	 * 근무경력 - 퇴직공제
	 * @param vo
	 * @return
	 */
	public List<CareerDeclareVO> selectWorkCareer(CareerDeclareVO vo);

	/**
	 * 수수료감면 신청 리스트
	 * @param careerDeclareSearchVO
	 * @return
	 */
	public List<CareerDeclareVO> selectCrtfReqstSanctnList(CareerDeclareSearchVO careerDeclareSearchVO);

	/**
	 * 수수료감면 신청 리스트 카운트
	 * @param careerDeclareSearchVO
	 * @return
	 */
	public int selectCrtfReqstSanctnListCnt(CareerDeclareSearchVO careerDeclareSearchVO);

	/**
	 * 퇴직공제 근무경력 조회(신청한 데이터 제외)
	 * @param careerDeclareVO
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumWorkExpert(CareerDeclareVO careerDeclareVO);

	

}
