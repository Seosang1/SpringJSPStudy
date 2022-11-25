package kr.or.cwma.admin.userInfo.vo;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserCareerVO{
	private int daycnt; //일수
	
	private String nm; //경력명
	private String prmtr; //주최
	private String bgnDt; //시작일
	private String endDt; //종료일
	private String jssfc; //신고직종
	private String jssfcNm; //통합직종
	private String jssfcSe; //통합직종 구분
	private String ddcJoinNo; //공제가입번호
	private String rank; //순위
}
