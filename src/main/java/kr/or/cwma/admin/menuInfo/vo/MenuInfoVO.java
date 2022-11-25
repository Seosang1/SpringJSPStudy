package kr.or.cwma.admin.menuInfo.vo;
import java.util.List;

import kr.or.cwma.admin.authorInfo.vo.MenuAuthorRelateVO;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 메뉴정보VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class MenuInfoVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private int menuSn; //메뉴일련번호
	private int upperMenuSn; //상위메뉴일련번호
	private int menuOrdr; //순서
	private int depth; //뎁스
	
	private String menuNm; //메뉴명
	private String url; //URL
	private String displayAt; //노출여부
	private String useAt; //사용여부
	private String menuDc; //메뉴설명
	private String css; //css
	private String rgstDt; //등록일
	private String chgDt; //수정일
	private String rgstId; //등록ID
	private String chgId; //수정ID
	private String bassAuthorAt; //기본권한여부
	
	private List<MenuInfoVO> list; //메뉴정보VO 배열
	private List<MenuAuthorRelateVO> relateVO; //메뉴권한관계 
}
