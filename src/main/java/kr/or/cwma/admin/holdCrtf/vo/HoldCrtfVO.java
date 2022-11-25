package kr.or.cwma.admin.holdCrtf.vo;
import java.util.List;

import org.hibernate.validator.constraints.NotEmpty;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.fee.vo.FeeVO;
import kr.or.cwma.common.vo.AttchFileInfoVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 보유증명서 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class HoldCrtfVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int issuCo; //발급건수
	private int feeSn; //수수료일련번호
	private long sn; //일련번호
	
	@NotEmpty(message="구분을 입력해주세요")
	private String se; //구분
	
	@NotEmpty(message="사업자등록번호를 입력해주세요")
	private String bizno; //사업자등록번호
	
	@NotEmpty(message="제출처를 입력해주세요")
	private String presentnOffic; //제출처
	
	@NotEmpty(message="결제구분을 입력해주세요")
	private String setleSe; //결제구분
	
	@NotEmpty(message="수령구분을 입력해주세요")
	private String recptSe; //수령구분
	
	@NotEmpty(message="현장구분을 입력해주세요")
	private String sptSe; //현장구분
	
	private String nm; //이름
	private String cntrctNm; //공사명
	private String ihidnum; //주민번호
	private String cl; //분류
	private String clNm; //분류명
	private String corpNm; //업체명
	private String ceoNm; //대표자
	private String telNo; //전화번호
	
	private String bplcAllAt = "N"; //사업장전체여부
	private String labrrAllAt = "N"; //근로자전체여부
	private String gradAllAt = "N"; //등급전체여부
	private String jssfcAllAt = "N"; //직종전체여부

	
	private String presentnOfficNm; //제출처명
	private String presentnOfficEtc; //제출처기타
	private String setleSeNm; //결제구분명
	private String recptSeNm; //수령구분명
	private String sptSeNm; //현장구분명
	private String reqstDt; //신청일시
	private String rgstId; //등록ID
	private String seNm; //구분명
	private String chrgBrffc; //담당지사
	private String chrgId; //담당ID
	private String applcntBizno; //신청자 사업자번호
	private String chgId; //수정ID
	private String chgDt; //수정일시
	private String rceptNo; //접수번호
	private String tmprAt; //임시여부
	
	private String bgnDt; //신청시작일
	private String endDt; //신청종료일
	private String issuBgnDt; //발급시작일
	private String issuEndDt; //발급종료일
	
	private HoldCrtfProgrsVO progrsVO; //진행상황VO
	private List<HoldCrtfJssfcVO> jssfcVO; //직종목록
	private List<HoldCrtfGradVO> gradVO; //등급목록
	private List<HoldCrtfCntrwkVO> cntrwkVO; //사업장목록
	private List<HoldCrtfLabrrVO> labrrVO; //근로자목록
	private FeeVO feeVO; //수수료VO
	private UserVO userVO; //담당자VO
	private HoldCrtfIssuVO issuVO; //발급VO
	
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
	private List<AttchFileInfoVO> fileVO; //첨부파일목록
	
	//팩스번호
	private String fxnum;
	private String fxnum1;
	private String fxnum2;
	private String fxnum3;
	
}
