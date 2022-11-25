package kr.or.cwma.admin.common.enums;

public enum CrtfIssuSanctnId {
	A01100("01100","jooh", "석주현",  "건설근로자공제회 본회", "0505-182-8331"),
	A01101("01101","parkminimo", "석주현",  "건설근로자공제회 서울지사", "0505-182-8371"),
	A01102("01102","jhj8626", "석주현",  "건설근로자공제회 서울남부센터", "0505-182-8380"),
	A01103("01103","zpakfn88", "석주현",  "건설근로자공제회 의정부센터", "0505-182-8382"),
	A02101("02101","woowjyj", "석주현",  "건설근로자공제회 경기지사", "0505-182-8373"),
	A02102("02102","jkl22345", "석주현",  "건설근로자공제회 인천지사", "0505-182-8372"),
	A03101("03101","suk418", "석주현",  "건설근로자공제회 원주센터", "0505-182-8379"),
	A04101("04101","153yeon", "석주현",  "건설근로자공제회 대전지사", "0505-182-8377"),
	A04102("04102","sgju", "석주현",  "건설근로자공제회 청주센터", "0505-182-8370"),
	A05101("05101","hogjeong", "석주현",  "건설근로자공제회 전주센터", "0505-182-8378"),
	A06101("06101","h58032", "석주현",  "건설근로자공제회 광주지사", "0505-182-8376"),
	A07101("07101","aristta", "석주현",  "건설근로자공제회 대구지사", "0505-182-8375"),
	A08101("08101","parkje", "석주현",  "건설근로자공제회 부산지사", "0505-182-8374"),
	A08102("08102","shmy2001", "석주현",  "건설근로자공제회 창원센터", "0505-182-8383"),
	A06102("06102","yuyung", "석주현",  "건설근로자공제회 제주센터", "0505-182-8384");
	

	private final String code;
	private final String name;
	private final String userName;
	private final String agent;
	private final String fax;

	private CrtfIssuSanctnId(String code, String name, String userName, String agent, String fax) {
		this.code = code;
		this.name = name;
		this.userName = userName;
		this.agent = agent;
		this.fax = fax;
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
	
	public String getUserName() {
		return userName;
	}
	
	public String getAgent() {
		return agent;
	}
	
	public String getFax() {
		return fax;
	}

	public static CrtfIssuSanctnId getType(String code) {
		for (CrtfIssuSanctnId ty : CrtfIssuSanctnId.values()) {
			if(ty.getCode().equals(code)) {
				return ty;
			}
		}
		return null;
	}
	
	public static String getValue(String code) {
		for (CrtfIssuSanctnId ty : CrtfIssuSanctnId.values()) {
			if(ty.getCode().equals(code)) {
				return ty.getName();
			}
		}
		return null;
	}
	
	public static String getFaxNum(String code) {
		for (CrtfIssuSanctnId ty : CrtfIssuSanctnId.values()) {
			if(ty.getCode().equals(code)) {
				return ty.getFax();
			}
		}
		return null;
	}
	
	public static String getUserNm(String code) {
		for (CrtfIssuSanctnId ty : CrtfIssuSanctnId.values()) {
			if(ty.getCode().equals(code)) {
				return ty.getUserName();
			}
		}
		return null;
	}
	
	public static String getAgentNm(String code) {
		for (CrtfIssuSanctnId ty : CrtfIssuSanctnId.values()) {
			if(ty.getCode().equals(code)) {
				return ty.getAgent();
			}
		}
		return null;
	}
}
