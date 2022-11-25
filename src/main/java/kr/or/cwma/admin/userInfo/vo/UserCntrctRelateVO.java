package kr.or.cwma.admin.userInfo.vo;
import java.util.List;

import lombok.Data;

@Data
public class UserCntrctRelateVO{
	private String userId; //사용자아이디
	private String ddcJoinNo; //공제가입번호
	private String authorCd;//권한 코드
	
	private String se; //구분
	private String seNm; //구분명
	private String nm; //이름
	private String ihidnum; //주민등록번호
	private String moblphonNo; //핸드폰번호
	private String email; //이메일
	private String bizno; //사업자등록번호
	
	private String checkYn;
	private List<UserCntrctRelateVO> list;
	
	
}

