package kr.or.cwma.common.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import lombok.Data;

@XmlRootElement(name="DataList")
@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class EduVO{
	@XmlElement(name="ssn")
	String ihidnum;
	
	@XmlElement(name="pnm")
	String nm;
	
	@XmlElement(name="trngNmor")
	String insttNm;
	
	@XmlElement(name="trngTycd")
	String tyCd;
	
	@XmlElement(name="trngTynm")
	String tyNm;
	
	@XmlElement(name="tgcrId")
	String crseCd;
	
	@XmlElement(name="trngTme")
	String crseTme;
	
	@XmlElement(name="trngCrsn")
	String crseNm;
	
	@XmlElement(name="comlYn")
	String complAt;
	
	@XmlElement(name="trneeSttusNd")
	String trneeSttusNd;
	
	@XmlElement(name="ttc")
	String traingTime;
	
	@XmlElement(name="rltrTct")
	String rlTraingTime;
	
	@XmlElement(name="trngBgde")
	String bgnde;
	
	@XmlElement(name="trngEnde")
	String endde;
	
	@XmlElement(name="ncsCd")
	String ncsCd;
	
	@XmlElement(name="kecoCd")
	String kecoCd;
	
	@XmlElement(name="trngJscd")
	String jssfcCd;
	
	@XmlElement(name="ntnPrdJscd")
	String nationPdJssfcCd;
}
