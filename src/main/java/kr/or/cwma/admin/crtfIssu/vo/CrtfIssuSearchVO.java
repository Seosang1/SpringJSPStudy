package kr.or.cwma.admin.crtfIssu.vo;

import org.apache.ibatis.type.Alias;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
@Alias("CrtfIssuSearchVO")
public class CrtfIssuSearchVO extends PageVO{

	private static final long serialVersionUID = 1L;
	
	//신청자 게시판 구분
	private String se;

	//신청자 성명
	private String applcntNm;
	
	//등급
	private String grad;
	
	//직종번호
	private Integer reqstNo;
	
	//결재방법
	private String setleMth;
	
	//직종번호
	private Integer jssfcNo;
	
	//발급번호
	private String issuNo;
	private String issuNo1;
	private String issuNo2;
	private String issuNo3;
	private String issuNo4;
	
	//주민번호
	private String jumin1;
	private String jumin2;
	
	//발급자 성명
	private String issuTrgterNm;
	
	//담당지사
	private String chrgBrffc;
	
	//조회구분
	private String viewType;

	//신청일
	private String bgnRqstdt;
	private String endRqstdt;
	
	//발급일
	private String bgnIssuOn;
	private String endIssuOn;
	
	//주민번호표시여부
	private String printSe;
	
	//접수방법
	private String sptSe;
	
	//조회기간
	private String bgnDt;
	private String endDt;
	
	//조회기간
	private String rgstId;
	
	//수수료감면 신청 구분
	private String feeRdcxptStat;
}
