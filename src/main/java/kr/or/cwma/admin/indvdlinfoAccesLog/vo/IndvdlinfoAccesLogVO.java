package kr.or.cwma.admin.indvdlinfoAccesLog.vo;
import kr.or.cwma.admin.common.vo.UserVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class IndvdlinfoAccesLogVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long sn; //일련번호
	private int menuSn; //메뉴일련번호
	
	private String accesId; //접근ID
	private String accesDt; //접근일시
	private String ip; //아이피
	private String trgetId; //대상ID
	private String nwDdcerNo; //신피공제자번호
	private String se; //구분
	private String seNm; //구분명
	private String ihidnum; //주민번호
	private String url; //접속URL
	private String menuNm; //메뉴명
	
	private String bgnDt; //시작일
	private String endDt; //종료일
	
	private UserVO userVO; //사용자VO
}
