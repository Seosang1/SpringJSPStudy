package kr.or.cwma.admin.conectIp.vo;
import kr.or.cwma.common.vo.PageVO;
import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class ConectIpVO extends PageVO{

	private static final long serialVersionUID = 1L;

	private String ip; //IP
	private String se; //구분
}
