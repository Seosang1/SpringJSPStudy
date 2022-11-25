package kr.or.cwma.common.service.impl;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.or.cwma.common.mapper.PgPayMapper;
import kr.or.cwma.common.mapper.ShareMapper;
import kr.or.cwma.common.service.PgPayService;
import kr.or.cwma.common.service.ShareService;
import kr.or.cwma.common.vo.EduResponseVO;
import kr.or.cwma.common.vo.EduVO;
import kr.or.cwma.common.vo.LcnsResponseVO;
import kr.or.cwma.common.vo.LcnsVO;

@Service
public class PgPayServiceImpl implements PgPayService{
	
	@Value("#{prop['share.hrdUrl']}")
	String hrdUrl;
	
	@Value("#{prop['share.keisUrl']}")
	String keisUrl;
	
	@Autowired
	PgPayMapper pgPayMapper;

	@Override
	public void insertPgPay(HashMap<String, Object> params) throws SQLException {
		pgPayMapper.insertPgPay(params);
	}

	@Override
	public void updatePgPay(HashMap<String, Object> params) throws SQLException {
		pgPayMapper.updatePgPay(params);
	}
	
	@Override
	public HashMap<String, Object> selectPgPayCheck(Map<String, String> params)  throws SQLException {
		return pgPayMapper.selectPgPayCheck(params);
	}

	
}
