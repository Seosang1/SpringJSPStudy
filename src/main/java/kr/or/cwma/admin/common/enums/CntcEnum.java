package kr.or.cwma.admin.common.enums;

public enum CntcEnum {
	KMCCA_LICENSE("CNTC0001", "대한기계설비건설협회-인정기능사"), //kmcca_license
	KOSCA_LICENSE("CNTC0002", "대한전문건설협회-인정기능사"), //kosca_license
	BOILER_LICENSE("CNTC0003", "한국열관리시공협회-인정기능사"), //boiler_license
	HRD_LICENSE("CNTC0004", "한국산업인력공단-자격DB"), // hrd_license
	KEIS_WORK("CNTC0005", "한국고용정보원-고용보험"), // keis_work
	KEIS_EDU("CNTC0006", "한국고용정보원-교육훈련"), // keis_edu
	KCOMWEL_WORK("CNTC0007", "근로복지공단-고용정보"), // kcomwel_work
	FCAS_REWARD("CNTC0008", "대한건설단체총연합회-포상정보"), // fcas_reward
	KFCITU_REWARD("CNTC0009", "민주노총 건설산업연맹-포상정보"), // kfcitu_reward
	HRD_REWARD("CNTC0010", "한국산업인력공단-포상정보"); // hrd_reward
	
	private final String code;
	private final String name;

	private CntcEnum(String code, String name) {
		this.code = code;
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public Object getValue() {
		return this.toString();
	}

	public String getCode() {
		return code;
	}

	public static CntcEnum getType(String code) {
		for (CntcEnum ty : CntcEnum.values()) {
			if(ty.getCode().equals(code)) {
				return ty;
			}
		}
		return null;
	}
}
