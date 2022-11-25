package kr.or.cwma.admin.jssfcInfo.vo;
import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class JssfcInfoVO extends JssfcInfoHistManageVO{

	private int jssfcNo; //직종번호
	private double stdrDaycnt; //null
	
	private String se; //구분
	private String seNm; //구분명
	private String actvtyAt; //활성여부
	private String jssfcNm; //직종명
	private String searchIhidnum; //주민등록번호
	private String searchIhidnumByWorkYm; //근무이력 3개월 이내 주민등록번호
	private List<JssfcInfoVO> searchList; //복수조건조회
}
