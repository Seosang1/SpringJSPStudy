package kr.or.cwma.admin.userInfo.vo;
import java.util.List;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=true)
public class CntrctInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;
	
	private int cntrctSeq = 0; //공사번호
	private int laborGrfcSeq = 0;
	private int ddcDayAmtSeq = 0;
	private long thtmCntrctAmt = 0; //총공사금액
	private long ddcDayAmt = 0;
	private long ddcTotAmt = 0;
	private long ddcPayAmt = 0;

	private String dcsnCntrctNo; //확정계약번호
	private String bidNtceNo; //입찰공고번호
	private String bidNtceOrd;
	private String kisconCnstwkId;
	private String cntrctNm; //공사명
	private String cntrctRcvMediaCd; //계약수신매체코드
	private String cntrctRcvMediaNm;
	private String cntrctCnclsDe; //계약일
	private String cntrctBgnDe; //계약시작일자
	private String cntrctEndDe; //계약종료일자
	private String cnstwkBgnDe;
	private String cnstwkEndDe;
	private String cntrctCnclsMthdCd; //계약체결방법코드
	private String cntrctCnclsMthdNm;
	private String cntrctInfoUrl;
	private String cntrctDtlInfoUrl;
	private String cntrctDisposDivCd; //계약성질구분코드
	private String cntrctDisposDivNm; //계약성질구분명
	private String cntrctTpCd; //도급방법코드
	private String cntrctTpNm;
	private String lawordNm;//공사업법
	private String cnstwkJoinTyCd; //공사가입유형코드

	private String cnstwkJoinTyNm; //공사가입유형명
	private String cnstwkLawordCd;	// 법령코드
	private String cnstwkLawordNm;	//	법령명
	private String cnstwkSttusCd; //공사상태코드
	private String cnstwkSttusNm;
	private String cnstwkRlStrwrkDe; //실제공사착공일
	private String cnstwkStrwrkPrearngDe; //공사착공예정일
	private String cnstwkManageMthdCd;
	private String cnstwkManageMthdNm;
	private String ddcDeclarePrearngDe; //가입예정일
	private String ddcUnSttemntResnCd; //미가입사유코드
	private String ddcUnSttemntResnNm;
	private String ddcUnSttemntResn;	//미가입사유
	private String ddcAsctCd;
	private String ddcAsctNm;
	private String rgstDt;
	private String rgstId;
	private String rgstNm;
	private String chgDt;
	private String chgId;
	private String chgNm;
	private String competAt; //준공확인

	private String cntrctRgstDt; //계약등록일
	private String exmntResnCd;
	private String exmntResnNm;
	private String laborGrfcNm; //노동관서명
	private String ddcUnSttemntResnDe;
	private Long cnstwkPrearngAmt; //공사예정금액
	private String cntrctRcvMediaDe; //보도일자
	private String prmpcReflctYn; //원가반영여부
	private String bidNtceRcvMediaNm; //공고매체명
	
	private String cntrwkSe; //공사구분코드

	//업체정보
	private String corpNm;
	private String bizno;
	private String corpNo;
	private String ceoNm;
	private String telNo;

	//수요기관
	private String dminsttNm;
	private String dminsttCd;
	private String seNm; //수요기관 구분명
	private String dminsttOfclDept; //수요기관담당 부서
	private String dminsttOfclClsf; //수요기관담당 직급
	private String dminsttOfclNm; //수요기관 담당자 명
	private String dminsttTel; //수요기관 전화번호
	private String dminsttZip; //수요기관 우편번호
	private String dminsttAddr; //수요기관 주소
	private String dminsttOfclPhone; //수요기관담당Phone
	private String dminsttFaxNo; //수요기관팩스번호

	//공제가입
	private String cnstwkLocplcAddr; //현장 주소
	private String ddcJoinNo;
	private String ddcJoinDt;
	private String trmnDt;
	private String procsRt;
	private String ddcFlflMthdNm;
	private String ddcJoinEtc; //현장관리비고
	private String giroSendingMthdCd; //우편물수령지
	private String upperDdcJoinNo; //원도급공제가입번호
	private List<String> ddcJoinNoList;
}
