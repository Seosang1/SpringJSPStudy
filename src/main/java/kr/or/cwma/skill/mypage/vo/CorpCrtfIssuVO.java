package kr.or.cwma.skill.mypage.vo;


import org.apache.ibatis.type.Alias;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
@Alias("CorpCrtfIssuVO")
public class CorpCrtfIssuVO extends PageVO{
	private static final long serialVersionUID = 1L;
	
	//사업자등록번호
	private String bizno;
	
	//시공여부
	private String cnstwkSttusCd;
	private String cnstwkSttusNm;
	
	//공제계약번호
	private String ddcJoinNo;
	
	//공사주소
	private String cnstwkAdres;
	
	//공사기간
	private String cnstwkPeriod;
	
	//소재지 전화번호
	private String cnstwkTel;
	
	//공사명
	private String cnstwkNm;
	
	//주민등록번호
	private String ihidnum;
	
	//기능인성명
	private String nm;
	
	//우편번호 
	private String zip;
	//주소 
	private String adres;
	//전화번호 
	private String telno;
	
	//등록 아이디
	private String rgstId;
	
	//등급
	private String grad;
	private String gradNm;
	
	//직종
	private Integer jssfcNo;
	private String jssfcNm;
	
	//근무일수
	private Integer workDaycnt;
	private Integer etcWorkDaycnt;
	
	private String se; //공사구분

	// 검색조건
	private String userId; //사용자아이디
	private String userSe; //사용자구분
	
}
