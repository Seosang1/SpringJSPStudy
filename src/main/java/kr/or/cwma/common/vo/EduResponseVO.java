package kr.or.cwma.common.vo;

import java.util.List;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

import lombok.Data;

@XmlRootElement(name="getJobAbilityTngInfoResponse")
@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class EduResponseVO{
	List<EduVO> dataList;
}
