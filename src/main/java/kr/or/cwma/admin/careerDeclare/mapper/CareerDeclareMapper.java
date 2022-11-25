package kr.or.cwma.admin.careerDeclare.mapper;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareProgsVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareSearchVO;
import kr.or.cwma.admin.careerDeclare.vo.CareerDeclareVO;

/**
 * 경력인정신고 관리자 Mapper
 * @author PCNDEV
 *
 */
/**
 * @author usrdev
 *
 */
@Repository
public interface CareerDeclareMapper {
	
	/**
	 * 주민등록번호 조회
	 * @param vo
	 * @return
	 */
	public CareerDeclareVO selectIhidnum(CareerDeclareVO vo);
	
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
	 * 연계데이터 연결
	 * @param vo
	 * @return
	 */
	public void insertCrtfCntcData(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 접수 카운트
	 * @param vo
	 * @return
	 */
	public Integer selectCareerDeclareCnt(String rceptNo);
	
	/**
	 * 경력인정신고 목록 카운트
	 * @param vo
	 * @return
	 */
	public Integer selectCareerDeclareListCnt(CareerDeclareSearchVO vo);
	
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
	public void insertCareerDeclare(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 신청 수정
	 * @param vo
	 * @return
	 */
	public void updateCareerDeclare(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 신청  접수번호 등록
	 * @param vo
	 * @return
	 */
	public void updateCareerDeclareRceptNo(CareerDeclareVO vo);
	
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
	 * 경력인정신고연계데이터 삭제 입력
	 * @param vo
	 * @return
	 */
	public void deleteCareerCntcData(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고연계데이터 삭제 입력
	 * @param vo
	 * @return
	 */
	public void updateCareerCntcData(CareerDeclareVO vo);
	
	/**
	 * 경력인정신고 진행사항 체크
	 * @param vo
	 * @return
	 */
	public int chkProgrsSttus(CareerDeclareProgsVO vo);

	/**
	 * 경력사항정정의 직종리스트
	 * @param string
	 * @return
	 */
	public List<HashMap<String, String>> selectJssfcList(String string);

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
	 * 수수료감면 신청 리스트 카운트
	 * @param careerDeclareSearchVO
	 * @return
	 */
	public int selectCrtfReqstSanctnListCnt(CareerDeclareSearchVO careerDeclareSearchVO);

	/**
	 * 수수료감면 리스트
	 * @param careerDeclareSearchVO
	 * @return
	 */
	public List<CareerDeclareVO> selectCrtfReqstSanctnList(CareerDeclareSearchVO careerDeclareSearchVO);

	/**
	 * 퇴직공제 근무경력 조회(신청한 데이터 제외)
	 * @param careerDeclareVO
	 * @return
	 */
	public List<CareerDeclareVO> selectIhidnumWorkExpert(CareerDeclareVO careerDeclareVO);

}
