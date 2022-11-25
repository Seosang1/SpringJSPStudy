package kr.or.cwma.admin.stats.vo;
import lombok.Data;

@Data
public class GradStatsVO{
	private int jssfcNo; //직종번호
	
	private int grad1Cnt; //초급건수
	private int grad2Cnt; //중급건수
	private int grad3Cnt; //고급건수
	private int grad4Cnt; //특급건수
	private int totalCnt; //전체건수
	
	private int age20Cnt; //20대건수
	private int age30Cnt; //30대건수
	private int age40Cnt; //40대건수
	private int age50Cnt; //50대건수
	private int age60Cnt; //60대건수
	private int age70Cnt; //70대건수
	
	private int seoulCnt; //서울건수
	private int incheonCnt; //인천건수
	private int busanCnt; //부산건수
	private int kyeongkiCnt; //경기건수
	private int kangwonCnt; //강원건수 
	private int daejeonCnt; //대전건수  
	private int sejongCnt; //세종건수 
	private int kwangjuCnt; //광주건수 
	private int daeguCnt; //대구건수 
	private int ulsanCnt; //울산건수 
	private int jejuCnt; //제주건수 
	private int chungbukCnt; //충북건수 
	private int chungnamCnt; //충남건수 
	private int jeonbukCnt; //전북건수 
	private int jeonnamCnt; //전남건수 
	private int kyeongbukCnt; //경북건수 
	private int kyeongnamCnt; //경남건수 
	private int etcCnt; //기타건수 
	
	private String statsDe; //통계일
	private String jssfcNm; //직종명
	private String seNm; //구분
	private String adrea; //주소지
	private String sexdstn; //성별
	private String grad; //등급코드
	private String agrde; //연령대
}
