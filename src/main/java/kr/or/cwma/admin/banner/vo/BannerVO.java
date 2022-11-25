package kr.or.cwma.admin.banner.vo;
import java.util.List;

import kr.or.cwma.common.vo.AttchFileInfoVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class BannerVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private long sn; //일련번호
	private int ordr; //순서
	
	private String bannerNm; //배너명
	private String imageDc; //이미지설명
	private String url; //URL
	private String trgt; //타겟
	private String bgnde; //시작일
	private String endde; //종료일
	private String displayAt; //노출여부
	private String se; //구분
	private String rgstDt; //등록일시
	private String rgstId; //등록ID
	private String chgDt; //수정일
	private String chgId; //수정ID
	private String useYn; //사용여부
	AttchFileInfoVO fileVO; //파일VO
	List<AttchFileInfoVO> fileVO1; //PC이미지
	List<AttchFileInfoVO> fileVO2; //모바일이미지
	private List<AttchFileInfoVO> delFileVO; //삭제파일목록
}
