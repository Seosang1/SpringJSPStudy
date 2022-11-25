package kr.or.cwma.admin.careerDeclare.vo;


import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@Alias("CareerDeclareProgsVO")
@EqualsAndHashCode(callSuper=false)
public class CareerDeclareProgsVO implements Serializable{

	private static final long serialVersionUID = 1L;

	/**
	 * 경력인정신고 고유번호
	 */
	private Integer careerNo;
	
	/**
	 * 경력인정신고 진행 고유번호
	 */
	private Integer progrsNo;
	
	/**
	 * 경력인정신고 진행 상태
	 */
	private String progrsSttus;
	
	/**
	 * 경력인정신고 진행 상태
	 */
	private String progrsSttusNm;
	
	/**
	 * 경력인정신고 진행 사유
	 */
	private String progrsResn;
	
	/**
	 * 경력인정신고 진행일자
	 */
	private String progrsDe;
	
	/**
	 * 경력인정신고 회신기한
	 */
	private String rplyTmlmt;
	
	/**
	 * 경력인정신고 등록자 id
	 */
	private String rgstId;
	
	/**
	 * 경력인정신고 등록자 id
	 */
	private String rgstNm;
	
	/**
	 * 경력인정신고 등록자 id
	 */
	private String rgstDept;
	
	/**
	 * 경력인정신고 등록일
	 */
	private String rgstDt;

}
