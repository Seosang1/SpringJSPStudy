package kr.or.cwma.admin.careerStdr.vo;
import java.util.List;

import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 경력기준관리 VO
 * @author sichoi
 */
@Data
@EqualsAndHashCode(callSuper=false)
public class CareerStdrVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private Long sn; //일련번호
	private String se; //구분
	private Float grad1; //등급1
	private Float grad2; //등급2
	private Float grad3; //등급3
	private Float grad4; //등급4
	private String applcDe; //적용일자
	private String rgstDt; //등록일시
	private String rgstId; //등록ID
	private String rgstNm; //등록자
	List<CareerStdrVO> voList;
}
