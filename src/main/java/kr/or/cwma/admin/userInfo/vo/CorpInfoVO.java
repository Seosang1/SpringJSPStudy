package kr.or.cwma.admin.userInfo.vo;
import lombok.Data;

@Data
public class CorpInfoVO{

	//본사정보
	private String bizno;
	private String corpNo;
	private String corpNm;
	private String zip;
	private String adrs;
	private String dtlAdrs;
	private String telNo;
	private String ceoNm;
	private String hdoffceOfclNm;
	private String hdoffceTelno;
	private String corpInfoRcvSeCd;
	private String lcnsNo;
	private String dltAt;
	private String rgstDt;
	private String rgstId;
	private String chgDt;
	private String chgId;
	private String flflMthCd;
	private String flflMthNm;
	private String etc;
	private String cnsttyClsfcNm;
	private String sttus; //경영상태

	//담당자정보
	private String ofclClsf;
	private String ofclNm;
	private String ofclDept;
	private String ofclTelNo;
	private String ofclAdrs;
	private String ofclZip;
	private String ofclFax;
	private String ofclEmail;
	private String ofclPhone;
	private String ofclPhone1;
	private String ofclPhone2;
	private String ofclPhone3;

}