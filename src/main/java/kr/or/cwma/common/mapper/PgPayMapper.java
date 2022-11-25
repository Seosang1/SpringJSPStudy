package kr.or.cwma.common.mapper;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Repository;


@Repository
public interface PgPayMapper{

	public void insertPgPay(HashMap<String, Object> params) throws SQLException;

	public void updatePgPay(HashMap<String, Object> params) throws SQLException;

	public HashMap<String, Object> selectPgPayCheck(Map<String, String> params)throws SQLException;
}
