package kr.or.cwma.admin.issuAgre.vo;
import java.util.List;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.vo.AttchFileInfoVO;
import lombok.Data;

@Data
public class IssuAgreVO{
	
	private Integer sn; 		//일련번호
	private String ihidnum; 	//주민등록번호
	private int jssfcNo; 		//직종번호
	private String ddcJoinNo;	//공제가입번호
	private String rgstDt; 		//등록 일시
	private String validDt; 	//유효 일시
	private String sptSe;		//현장 구분
	private String cntrwkSe;	//공사 구분
	private String deleteAt;	//삭제 여부(태블릿 구분용)
	private String rceptNo;		//접수번호
	
	
	private Integer reAgreCnt;	//유효 일시까지 남은 일수
	private String sptSeNm;		//현장명
	private String jssfcNm;		//직종명
	private int selectJssfcNo; 	//직종번호
	private String cntrwkSeNm;	//공사 구분명
	
	// 공사정보
	private String corpNm;		//기업명
	private String cnstwkNm;	//공사명
	private String ceoNm;		//대표자
	private String telNo;		//전화번호
	private String bizno;		//사업자등록번호
	private String trmnatAt;	//해지여부
	
	// 회원정보
	private String nm;			//이름
	private String moblphonNo;	//핸드폰번호
	private String email; 		//이메일
	
	// 결재정보
	private String issuOn;		//발급 일시
	private Integer docNo;		//결재번호
	private String rceptUser;	//담당자
	private String rceptDept;	//담당부서
	
	// 첨부파일
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
	private List<AttchFileInfoVO> fileVO; //첨부파일목록
	private List<Long> seqList; //일련번호목록
	
	// 연계VO
	private UserVO userVO; //관리자정보
	private UserInfoVO userInfoVO; //사용자정보
}