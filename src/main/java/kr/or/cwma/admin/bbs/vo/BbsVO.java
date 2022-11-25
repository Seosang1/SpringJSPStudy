package kr.or.cwma.admin.bbs.vo;
import java.util.List;

import org.hibernate.validator.constraints.NotEmpty;

import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.admin.userInfo.vo.UserInfoVO;
import kr.or.cwma.common.vo.AttchFileInfoVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class BbsVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private boolean admin = false;
	private long sn; //일련번호
	private long rdcnt; //조회수
	private long dwldCo; //다운로드수
	
	private String se; //구분
	private String cl; //분류
	private String clNm; //분류명
	@NotEmpty(message="제목을 입력해주세요")
	private String sj; //제목
	@NotEmpty(message="내용을 입력해주세요")
	private String cn; //내용
	private String noticeAt; //공지여부
	private String answer; //답변
	private String displayAt; //노출여부
	private String displaySttus; //게시상태
	private String rgstDt; //등록일시
	private String rgstId; //등록ID
	private String chgDt; //수정일시
	private String chgId; //수정일시
	private String answerId; //답변ID
	private String answerNm; //답변자
	private String answerDt; //답변일시
	private String ntceBgnde; //게시시작일
	private String ntceEndde; //게시종료일
	private String sndngAt; //발송여부
	private String smsRecptnAgreAt; //SMS수신여부
	private String nm; //등록자명(비회원용)
	private String mbtlnum; //휴대폰번호(비회원용)
	private String smsSj; //문자내용
	private String callNumber; //전화번호
	private String email; // 이메일
	private String rgstNm; //작성자 이름
	
	private String bgnDt; //검색시작일
	private String endDt; //검색종료일
	private String answerAt; //답변상태 - 온라인상담
	
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
	private List<AttchFileInfoVO> fileVO; //첨부파일목록
	private List<Long> seqList; //일련번호목록
	private UserVO userVO; //관리자정보
	private UserInfoVO userInfoVO; //사용자정보
}
