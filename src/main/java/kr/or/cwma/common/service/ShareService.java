package kr.or.cwma.common.service;
import java.sql.SQLException;

/**
 * 행공센 실시간 연계 서비스
 * @author sichoi
 */
public interface ShareService{

	/**
	 * 산인공 자격정보 등록
	 * @param ihidnum
	 * @throws SQLException
	 */
	public void insertJdtyInfoList(String ihidnum) throws SQLException;
	
	/**
	 * 한고원 교육정보 등록
	 * @param ihidnum
	 * @throws SQLException
	 */
	public void insertJobAbilityTngInfo(String ihidnum) throws SQLException;
}
