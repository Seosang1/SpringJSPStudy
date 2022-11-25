package kr.or.cwma.common.vo;

import javax.validation.constraints.Min;

import org.hibernate.validator.constraints.NotEmpty;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class AttchFileInfoVO{

	private long size;
	
	@Min(value=0, message="필수값입니다")
	private long fileSn;
	@Min(value=0, message="필수값입니다")
	private long parntsSn;
	@NotEmpty(message="필수값입니다")
	private String parntsSe;
	
	private String orginlFileNm;
	private String fileNm;
	private String path;
	private String extsn;
}
