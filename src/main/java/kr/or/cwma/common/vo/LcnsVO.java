package kr.or.cwma.common.vo;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import lombok.Data;

@XmlRootElement(name="list")
@XmlAccessorType(XmlAccessType.FIELD)
@Data
public class LcnsVO{
	
	long sn;

	@XmlElement(name="RESD_NO_ENCR")
	public String ihidnum;
	
	@XmlElement(name="HGUL_NM")
	public String nm;
	
	@XmlElement(name="LCS_NO")
	public String crqfcNo;
	
	@XmlElement(name="CURR_JM_CD")
	public String crqfcCd;
	
	@XmlElement(name="JM_NM")
	public String crqfcNm;
	
	@XmlElement(name="OBLIG_FLD_NM")
	public String obligFldNm;
	
	@XmlElement(name="OBLIG_FLD_CD")
	public String obligFldCd;
	
	@XmlElement(name="GRD_NM")
	public String grdNm;
	
	@XmlElement(name="GRD_CD")
	public String grdCd;
	
	@XmlElement(name="LAST_PASS_DT")
	public String crqfcAcqdt;
	
	@XmlElement(name="QUAL_ACQU_STAT_CCD")
	public String qualAcquStatCcd;
	
	@XmlElement(name="CHG_DT")
	public String chgDt;

	@XmlElement(name="MODIFY_DTTM")
	public String modifyDttm;
	
	@XmlElement(name="FST_GIVE_DT")
	public String fstGiveDt;
	
}
