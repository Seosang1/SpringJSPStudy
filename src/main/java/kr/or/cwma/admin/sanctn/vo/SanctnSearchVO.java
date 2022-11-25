package kr.or.cwma.admin.sanctn.vo;

import org.apache.ibatis.type.Alias;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@Alias("SanctnSearchVO")
@EqualsAndHashCode(callSuper=false)
public class SanctnSearchVO extends PageVO{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 서비스구분
	 */
	private String se;
	
	/**
	 * 기안시작일
	 */
	private String bgnDrftDe;
	
	/**
	 * 기안종료일
	 */
	private String endDrftDe;
	
	/**
	 * 기안자
	 */
	private String drfter;
	
	/**
	 * 기안자 id
	 */
	private String drftId;

	/**
	 * 결재자 id
	 */
	private String sanctnId;
	
	/**
	 * 결재자 성명
	 */
	private String sancter;
	
	/**
	 * 지사센터
	 */
	private String chrgBrffc;
	
	/**
	 * 신청자
	 */
	private String nm;
	
	/**
	 * 주민등록 앞자리
	 */
	private String jumin1;
	
	/**
	 * 주민등록 뒷자리
	 */
	private String jumin2;
	
	/**
	 * 결재상태
	 */
	private String sanctnSttus;
	
	/**
	 * 결재 진행/대기/완료 구분
	 */
	private String sanctnList;
	
	/**
	 * 결재타입 (경력인정신고/증명서발급신청)
	 */
	private String sanctnKnd;
	
	/**
	 * 경력인정신청 번호
	 */
	private Integer careerNo;
	
	/**
	 * 증명서발급신청 번호
	 */
	private Integer reqstNo;
}
