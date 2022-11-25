package kr.or.cwma.admin.common.vo;
import lombok.Data;

@Data
public class ExcelDwldHistVO{

	private long sn; //일련번호
	
	private String cn; //내용
	private String ihidnumIndictAt; //주민번호표시여부
	private String url; //URL
	private String rgstId; //등록ID
	private String rgstDt; //등록일시
}
