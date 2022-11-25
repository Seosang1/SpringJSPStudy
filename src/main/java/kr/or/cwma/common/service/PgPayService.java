package kr.or.cwma.common.service;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface PgPayService{

	/**
	 * PG결제 내역 등록
	 * @param params
	 * @throws SQLException
	 */
	public void insertPgPay(HashMap<String, Object>params) throws SQLException;
	/**
	 * PG결제 내역 수정
	 * @param params
	 * @throws SQLException
	 */
	public void updatePgPay(HashMap<String, Object>params) throws SQLException;
	
	/**
	 * PG결제 내역 확인
	 * @param params
	 * @return
	 */
	public HashMap<String, Object> selectPgPayCheck(Map<String, String> params) throws SQLException;
}
