package kr.or.cwma.admin.careerDeclare.vo;

import org.apache.ibatis.type.Alias;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@Alias("CareerDeclareSearchVO")
@EqualsAndHashCode(callSuper=false)
public class CareerDeclareSearchVO extends PageVO{

	private static final long serialVersionUID = 1L;

	/**
	 * 서비스 구분
	 */
	private String se;
	
	/**
	 * 주민등록번호 앞자리
	 */
	private String jumin1;
	
	/**
	 * 주민등록번호 뒷자리
	 */
	private String jumin2;
	
	/**
	 * 접수방법
	 */
	private String sptSe;
	
	/**
	 * 처리상태
	 */
	private String progrsSttus;
	
	/**
	 * 신청자 
	 */
	private String nm;
	
	/**
	 * 결재상태
	 */
	private String sanctnSttus;
	
	/**
	 * 신청일 시작
	 */
	private String bgnRqstdt;
	
	/**
	 * 신청일 종료
	 */
	private String endRqstdt;
	
	/**
	 * 신청일 시작
	 */
	private String bgnClosedt;
	
	/**
	 * 신청일 종료
	 */
	private String endClosedt;
	
	/**
	 * 지사코드
	 */
	private String chrgBrffc;

}
