package kr.or.cwma.common.vo;


import org.apache.ibatis.type.Alias;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode
@Alias("PGPayVO")
public class PGPayVO {
	/* 〓〓〓〓〓〓〓〓〓〓〓필수 파라미터〓〓〓〓〓〓〓〓〓〓〓〓〓〓 */
	private String mchtId;			//상점아이디
	private String plainTrdAmt;		//거래금액
	
	private String method;			//결제수단
	private String trdDt;				//요청일자(yyyyMMdd)
	private String trdTm;				//요청시간(HHmmss)
	private String mchtTrdNo;		//상점주문번호
	private String mchtName;		//상점한글명
	private String mchtEName;		//상점영문명
	private String pmtPrdtNm;		//상품명
	private String notiUrl;				//결과처리 URL
	private String nextUrl;			//결과화면 URL
	private String cancUrl;			//결제취소 URL
	/* 〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓〓 */
	
	private String plainMchtCustNm;			//고객명(평문)
	private String custAcntSumry;				//통장인자내용
	private String expireDt;						//입금만료일시(yyyyMMddHHmmss)
	private String mchtParam;					//상점예약필드
	private String plainCphoneNo;				//핸드폰번호(평문)
	private String plainEmail;					//이메일주소(평문)
	private String telecomCd; 					//통신사코드
	private String prdtTerm;						//상품제공기간
	private String plainMchtCustId;			//상점고객아이디(평문)
	private String taxTypeCd; 					//면세여부(Y:면세, N:과세, G:복합과세)
	private String plainTaxAmt;					//과세금액(평문)(복합과세인 경우 필수)
	private String plainVatAmt;					//부가세금액(평문)(복합과세인 경우 필수)
	private String plainTaxFreeAmt;			//비과세금액(평문)(복합과세인 경우 필수)
	private String plainSvcAmt;					//봉사료(평문)
	private String cardType;						//카드결제타입
	private String chainUserId;					//현대카드Payshot ID
	private String cardGb; 						//특정카드사코드
	private String plainClipCustNm;			//클립포인트고객명(평문)
	private String plainClipCustCi;				//클립포인트CI(평문)
	private String plainClipCustPhoneNo;	//클립포인트고객핸드폰번호(평문)
	private String certNotiUrl;					//인증결과URL
	private String skipCd; 						//스킵여부
	private String multiPay;						//포인트복합결제
	private String autoPayType;					//자동결제 타입(공백:일반결제, M:월자동 1회차)
	private String linkMethod;					//연동방식
	private String appScheme; 					//앱스키마
	private String custIp;							//고객IP주소
	
}
