package kr.or.cwma.admin.userInfo.vo;
import java.util.List;

import javax.validation.constraints.Pattern;

import org.hibernate.validator.constraints.NotEmpty;

import kr.or.cwma.common.vo.NiceIdVO;
import kr.or.cwma.common.vo.PageVO;
import kr.or.cwma.skill.userSnsAuthor.vo.UserSnsAuthorVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;
	
	private boolean login = false;
	private boolean myPageLogin = false;
	private long retSysTime; //인증시간

	@NotEmpty(message="사용자ID를 입력해주세요")
	@Pattern(regexp="(?=.{5,15})(?=.*[a-zA-Z])(?=.*[0-9])[a-zA-Z0-9]+", message="사용자ID는 영문대소문자와 숫자를 조합하여 5~15자이내로 입력해주세요")
	private String userId; //사용자아이디
	
	@NotEmpty(message="비밀번호를 입력해주세요")
	@Pattern(regexp="(?=.{9,15})(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[~!@#$^*()])[a-zA-Z0-9~!@#$^*()]+", message="비밀번호는 영문대소문자, 숫자, 특수문자를 조합하여 9~15자이내로 입력해주세요")
	private String password; //비밀번호
	private String se; //구분
	private String seNm; //구분명
	private String nm; //이름
	private String ihidnum; //주민등록번호
	private String gender; //성별(0:여,1:남)
	private String bizno; //사업자등록번호
	private String diValue; //DI값(개인)
	private String ciValue; //CI값(개인)
	private String dnValue; //DN값(기업)
	private String email; //이메일
	private String telno; //전화번호
	
	@NotEmpty(message="휴대폰번호를 입력해주세요")
	private String moblphonNo; //핸드폰번호
	private String adres; //주소
	private String zip; //우편번호
	private String passwordChgDt; //암호변경일
	private String sttus; //상태
	private String rgstDt; //등록 일시
	private String chgDt; //수정 일시
	private String rgstId; //등록ID
	private String chgId; //수정ID
	private String lastLoginDt; //최종로그인 일시
	private String bgnDt; //시작 일시
	private String endDt; //종료 일시
	private String emailRecptnAgreAt; //이메일수신동의여부
	private String smsRecptnAgreAt; //SMS수신동의여부
	private String ddcJoinNo; //공제가입번호
	private String joinAt; //가입여부
	private String joinDt; //가입여부
	private List<String> ddcJoinNoList; //공제가입번호목록
	private String authorCd;//권한 코드
	private String clmserEduComplAt; //최초교육이수여부
	
	private String advrtsInfoPrcuseAgreAt;//광고정보활용동의여부
	private String stplatAgreAt;//약관동의여부
	private String stplatSnsAgreAt;//약관 SNS 동의여부
	private String stplatOnlineCnsltAgreAt;//약관 온라인상담 동의여부

	//검색조건
	private String ihidnum1; //주민등록번호 앞자리
	private String ihidnum2; //주민등록번호 뒷자리
	private String bizno1; //사업자등록번호 앞자리
	private String bizno2; //사업자등록번호 중간자리
	private String bizno3; //사업자등록번호 뒷자리
	private String jssfcNo; //직종번호
	private String grad; //등급번호
	private String telno1; //휴대폰번호 앞자리
	private String telno2; //휴대폰번호 중간자리
	private String telno3; //휴대폰번호 끝자리
	private String cnstwkNm;//공사명
	private String searchSeNm;//공사구분
	private String trmnatAt;//해지여부
	
	//기업공인인증
	private String signCert; //rsa암호키
	private String encServerKey; //인증키
	private String encPassword; //인증비번
	private String signChk; //인증키 체크값
	private String encRndNum; //신원확인값(사업자번호)
	private String signValue; //인증정보
	
	//연계VO
	private CorpInfoVO corpInfoVO; //업체정보
	private DminsttInfoVO dminsttInfoVO; //업체정보
	private UserInfoVO authVO; //인증정보
	private NiceIdVO niceVO; //나이스 인증결과
	private UserSnsAuthorVO userSnsAuthorVO; //SNS 인증결과
}

