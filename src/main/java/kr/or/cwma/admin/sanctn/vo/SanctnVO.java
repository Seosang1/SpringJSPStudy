package kr.or.cwma.admin.sanctn.vo;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("SanctnVO")
public class SanctnVO implements Serializable{

	private static final long serialVersionUID = 1L;
	
	private Integer rownum; //순번
	private Integer careerNo; //경력인정신고 고유번호
	private Integer sanctnNo; //결재 고유번호
	private Integer docNo; //결재 고유번호
	private Integer sanctnProgrsNo; //결재 고유번호
	private String sptSe; //등록 구분
	private String se; //서비스구분
	private String seNm; //서비스구분
	private String rceptDe; //접수일
	private String rceptNo; //접수번호
	private String nm; //신청자
	private String draftDe; //기안일
	private String drafter; //기안자
	private String sanctner; //결재자
	private String chrgBrffcNm; //지사/센터
	private String sanctnSttus; //결재코드
	private String sanctnSttusNm; //결재상태
	private String sanctnResn; //결재상태
	private String sanctnKnd; //결재타입 (경력인정신고/증명서발급신청)
	private String rgstId; //등록자
	private String progrsSttus; //처리상태
	private String sanctnId; //결재자ID
	
	List<SanctnVO> sanctnVO; //결재VO 리스트
}
