package kr.or.cwma.admin.careerDeclare.vo;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.type.Alias;

import kr.or.cwma.admin.jssfcInfo.vo.JssfcInfoVO;
import kr.or.cwma.common.vo.AttchFileInfoVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 경력인정신고 관리자 VO
 * @author PCNDEV
 *
 */

@Data
@Alias("CareerDeclareVO")
@EqualsAndHashCode(callSuper=false)
public class CareerDeclareVO implements Serializable {
	
	private static final long serialVersionUID = 1L;
	
	/**
	 * 서비스 구분
	 */
	private String se;
	
	/**
	 * 서비스 구분
	 */
	private String seNm;
	
	/**
	 * 주민등록번호 앞자리
	 */
	private String jumin1;
	
	/**
	 * 주민등록번호 뒷자리
	 */
	private String jumin2;

	/**
	 * 주민등록번호 
	 */
	private String ihidnum;
	
	/**
	 * 신청자 
	 */
	private String nm;
	
	/**
	 * 신청자와 관계 
	 */
	private String relate;
	
	/**
	 * 신청자와 관계 
	 */
	private String relateNm;
	
	/**
	 * 신청자와 관계 상세
	 */
	private String relateDetail;
	
	/**
	 * 휴대폰번호1
	 */
	private String tel1;
	
	/**
	 * 휴대폰번호2
	 */
	private String tel2;
	
	/**
	 * 휴대폰번호3
	 */
	private String tel3;
	
	/**
	 * 휴대폰번호
	 */
	private String mbtlnum;
	
	/**
	 * 휴대폰번호
	 */
	private String email1;
	
	/**
	 * 휴대폰번호
	 */
	private String email2;
	
	/**
	 * 휴대폰번호
	 */
	private String email;
	
	/**
	 * 우편번호
	 */
	private String zip;
	
	/**
	 * 주소
	 */
	private String adres;
	
	/**
	 * 신청일
	 */
	private String rqstdt;
	
	/**
	 * 확인자 상호명
	 */
	private String cmpnmNm;
	
	/**
	 * 확인자 대표자명
	 */
	private String rprsntvNm;
	
	/**
	 * 확인자 사업자등록번호
	 */
	private String bizno1;
	
	/**
	 * 확인자 사업자등록번호
	 */
	private String bizno2;
	
	/**
	 * 확인자 사업자등록번호
	 */
	private String bizno3;
	
	/**
	 * 확인자 사업자등록번호
	 */
	private String bizno;
	
	/**
	 * 확인자 법인번호
	 */
	private String jurirno1;
	
	/**
	 * 확인자 법인번호
	 */
	private String jurirno2;
	
	/**
	 * 확인자 법인번호
	 */
	private String jurirno;
	
	/**
	 * 휴대폰번호1
	 */
	private String tel21;
	
	/**
	 * 휴대폰번호2
	 */
	private String tel22;
	
	/**
	 * 휴대폰번호3
	 */
	private String tel23;
	
	/**
	 * 확인자 휴대폰번호
	 */
	private String mbtlnum2;
	
	/**
	 * 확인자 우편번호
	 */
	private String zip2;
	
	/**
	 * 확인자 주소
	 */
	private String adres2;	

	/**
	 * 경력인정신고 진행상황 고유번호
	 */
	private Integer progrsNo;

	/**
	 * 경력인정신고 고유번호
	 */
	private Integer careerNo;

	/**
	 * 진행상태
	 */
	private String progrsSttus;
	
	/**
	 * 진행상태 명칭
	 */
	private String progrsSttusNm;
	
	/**
	 * 진행상태 일
	 */
	private String progrsSttusDe;
	
	/**
	 * 진행상태 일
	 */
	private String rplyTmlmt;

	/**
	 * 진행상태 사유
	 */
	private String progrsResn;

	/**
	 * 등록ID
	 */
	private String rgstId;

	/**
	 * 등록일
	 */
	private String rgstDt;

	/**
	 * 수정ID
	 */
	private String chgId;

	/**
	 * 수정일
	 */
	private String chgDt;
	
	/**
	 * 신청구분
	 */
	private String sptSe;
	
	/**
	 * 신청구분
	 */
	private String sptSeNm;
	
	/**
	 * 접수번호
	 */
	private String rceptNo;
	
	/**
	 * 열번호
	 */
	private Integer rownum;
	
	/**
	 * 신청일
	 */
	private String rceptDe;
	
	/**
	 * 접수자
	 */
	private String rceptUser;
	
	/**
	 * 접수자
	 */
	private String rceptDept;
	
	/**
	 * 결재상태
	 */
	private String processSttus;
	
	/**
	 * 처리일
	 */
	private String trede;
	
	/**
	 * 담당지사
	 */
	private String chrgBrffc;
	
	
	/**
	 * 미리보기 여부
	 */
	private String preViewYn;
	
	//연계데이터 결과값 공통
	private Integer sn;
	private Integer cntcSn;
	private String cntcCd;
	private String cntcCode;
	private String cntcNm;
	private Integer jssfcNo;
	
	//자격증
	private String lcnsJssfc;
	private String lcnsAcqdt;
	private String lcnsNo;
	
	private String lcnsNm;
	private String lcnsInst;
	
	//교육훈련
	private String crseNm;
	private String traingDe;
	
	//포상
	private String item;
	private String cnfrncNm;
	private String grad;
	private String gradNm;
	private String rwardDe;
	
	//근무내역
	private String bplcNm;
	private String bplcCno;
	private String bplcAdres;		//사업자 주소
	private String bplcNo;			//법인번호
	private String laborYm;
	private Integer laborDaycnt;
	private String jssfcCd;
	private String jssfcNm;
	private String stdrJssfcNo;
	private String stdrJssfcNm;
	private String laborAcqdt;
	private String laborFrfdt;
	private String kcomwelSe;
	
	private String corpNm;	//업체명
	
	//근무일수.
	
	//사용여부
	private String deleteAt = "N";
	//승인여부 (결재 통과)
	private String confmAt;
	
	//연계데이터 결과 조회
	private String cntcType;
	
	//연계데이터 결과값 공통
	private Integer[] snList;
	private String[] cntcCodeList;
	private Integer[] jssfcNoList;
	
	private List<HashMap<String, String>> jssfcList;
	
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
	private List<AttchFileInfoVO> fileVO; //첨부파일목록
	private List<JssfcInfoVO> multiJssfcVO; //미분류직종VO
}
