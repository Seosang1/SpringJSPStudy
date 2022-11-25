package kr.or.cwma.admin.crtfIssu.vo;

import java.io.Serializable;
import java.util.List;

import org.apache.ibatis.type.Alias;

import kr.or.cwma.common.vo.AttchFileInfoVO;
import lombok.Data;

@Data
@Alias("CrtfIssuVO")
public class CrtfIssuVO implements Serializable{
	private static final long serialVersionUID = 1L;

	//rownum
	private Integer rownum;
	//신청 고유번호
	private Integer reqstNo;
	//발급 고유번호
	private String issuNo;
	
	//입력 모드
	private String mode;
	
	//신청자 성명
	private String applcntNm;
	
	//주민번호
	private String ihidnum2;
	
	//신청자 주민번호
	private String applcntIhidnum;
	private String jumin1;
	private String jumin2;
	
	//신청자 연락처
	private String applcntMoblphon;
	private String applcntMoblphon1;
	private String applcntMoblphon2;
	private String applcntMoblphon3;
	
	//발급자와의 관계
	private String relate;
	private String relateNm;
	private String relateDetail;
	
	//신청일
	private String rqstdt;
	
	//발급일
	private String issuOn;
	
	//발급자 성명
	private String issuTrgterNm;
	
	//발급자 주민번호
	private String issuTrgterIhidnum;
	private String jumin3;
	private String jumin4;
	
	//발급자 연락처
	private String issuTrgterMoblphon;
	private String issuTrgterMoblphon1;
	private String issuTrgterMoblphon2;
	private String issuTrgterMoblphon3;
	
	//발급자 주소
	private String issuTrgterZip;
	private String issuTrgterAdres;
	
	//직종번호
	private Integer jssfcNo;
	private String jssfcNm;
	
	//직종번호
	private Integer jssfcNoSub;
	
	//근무일수
	private double workDaycnt;
	
	//기타근무일수
	private double etcWorkDaycnt;
	
	//환산일수
	private double cnvrsnDaycnt;
	
	//발급매수
	private Integer issuCo;
	
	//발급금액
	private Integer issuAmount;
	
	//수수료 시퀀스
	private Integer feeSn;
	
	//발급일
	private String issuDe;
	
	//수령방법
	private String recptMth;
	private String recptMthNm;
	
	//결재방법
	private String setleMth;
	private String setleMthNm;
	
	//결재방법
	private String sptSe;
	private String sptSeNm;
	
	//등급
	private String grad;
	private String gradNm;
	private String gradCnt;
	
	//담당자
	private String sanctnId;
	private String sanctnNm;

	//등록자 id 일수
	private String rgstId;
	private String rgstDt;
	private String chrgBrffc;

	// 수정자 id 일수
	private String chgId;
	private String chgDt;
	
	//팩스번호
	private String fxnum;
	private String fxnum1;
	private String fxnum2;
	private String fxnum3;
	
	//조회기관
	private String searchAgent;
	
	//담당자
	private String rceptUser;
	
	//신청매수
	private Integer reqCnt;
	
	//환산일수
	private double emplyminsrncDaycnt;
	private double crqfcDaycnt;
	private double edcTraingDaycnt;
	private double etcDaycnt;
	
	//년수 계산 수
	private double stdrdaycnt;
	
	//세부이력 포함여부
	private String detailHistInclsAt;
	//주민등록번호 공개여부
	private String ihidnumOthbcAt;
	//수수료감면 신청
	private String feeRdcxptReqst;
	//수수료감면 유형
	private String feeRdcxptTy;
	//수수료감면 유형명
	private String feeRdcxptTyNm;
	//수수료감면 첨부파일
	private String feeRdcxptAtchmnfl;
	//수수료감면 신청 결재상태
	private String sanctnSttus;
	private String progrsSttus;
	//결재사유
	private String sanctnResn;
	
	//접수정보 담당자
	private String chrgNm;
	//접수정보 담당부서
	private String chrgDept;
	
	private String stateMatterAditAt; //기재사항추가여부
	private String stateMatter; //기재사항
	private String rceptNo; //접수번호
	
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
	private List<AttchFileInfoVO> fileVO; //첨부파일목록
}
