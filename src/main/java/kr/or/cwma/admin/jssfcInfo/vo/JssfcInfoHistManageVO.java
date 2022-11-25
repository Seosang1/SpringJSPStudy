package kr.or.cwma.admin.jssfcInfo.vo;
import java.util.List;

import lombok.Data;

//직종이력관리 VO
@Data
public class JssfcInfoHistManageVO{

	private long sn; //일련번호
	private String applcDe; //적용일자
	private String rgstId; //등록ID
	private String rgstNm; //등록자
	private List<JssfcInfoVO> jssfcInfoVO; //직종관래VO
}
