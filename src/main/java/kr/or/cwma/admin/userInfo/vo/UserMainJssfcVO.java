package kr.or.cwma.admin.userInfo.vo;
import java.util.List;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserMainJssfcVO extends PageVO{
	private static final long serialVersionUID = 1L;
	
	private int jssfcNo; //직종번호
	private int workDaycnt; //근무일수
	private int etcWorkDaycnt; //기타근무일수
	
	private String workYear; //근무년수
	private String ihidnum; //주민등록번호
	private String nm; //성명
	private String adres; //주소
	private String zip; //우편번호
	private String telno; //전화번호
	private String grad; //등급
	private String gradNm; //등급명
	private String jssfcNm; //직종명
	private String joinAt; //가입여부
	private String joinDt; //가입일시
	
	private UserInfoVO userInfoVO; //사용자VO
	private List<UserCareerVO> userCareerVO; //경력목록
	
	// 기타
	private String customerAt;//온라인상담 여부
}
