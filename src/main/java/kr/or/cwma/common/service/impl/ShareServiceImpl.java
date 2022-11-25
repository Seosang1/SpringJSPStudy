package kr.or.cwma.common.service.impl;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.or.cwma.common.mapper.ShareMapper;
import kr.or.cwma.common.service.ShareService;
import kr.or.cwma.common.vo.EduResponseVO;
import kr.or.cwma.common.vo.EduVO;
import kr.or.cwma.common.vo.LcnsResponseVO;
import kr.or.cwma.common.vo.LcnsVO;

/**
 * 행공센 실시간연계 비지니스로직
 * @author sichoi
 */
@Service
public class ShareServiceImpl implements ShareService{
	
	@Value("#{prop['share.hrdUrl']}")
	String hrdUrl;
	
	@Value("#{prop['share.keisUrl']}")
	String keisUrl;
	
	@Autowired
	ShareMapper shareMapper;
	
	public void insertJdtyInfoList(String ihidnum) throws SQLException{
		String xml = "";
		
		JAXBContext jc = null;
		Unmarshaller um = null;
		LcnsResponseVO vo = null;
		
		try{
			xml = getShareXml(hrdUrl.concat("?ihidnum=").concat(ihidnum.replaceAll("-", "")));
			xml = xml.split("<soap:Body>")[1].split("<soap:Body>")[0].replace("</soap:Body></soap:Envelope>", "").replace(" xmlns=\"http://ccais.mopas.go.kr/dh/smx/services/mstdb/CwmaJdtyInfoList/types\"", "").trim();
			
			jc = JAXBContext.newInstance(LcnsResponseVO.class);
			um = jc.createUnmarshaller();
			vo = (LcnsResponseVO)um.unmarshal(new ByteArrayInputStream(xml.getBytes("utf-8")));
		}catch(Exception e){
			e.printStackTrace();
		}

		if(vo != null && vo.getList() != null && vo.getList().size() > 0) {
			shareMapper.deleteCntcHrdLicense(vo.getList().get(0));
			
			for(LcnsVO eo : vo.getList())
				shareMapper.insertCntcHrdLicense(eo);
		}
		
	}
	
	public void insertJobAbilityTngInfo(String ihidnum) throws SQLException{
		String xml = "";
		
		JAXBContext jc = null;
		Unmarshaller um = null;
		EduResponseVO vo = null;
		
		try{
			xml = getShareXml(keisUrl.concat("?ihidnum=").concat(ihidnum.replaceAll("-", "")));
			xml = xml.split("<soap:Body>")[1].split("<soap:Body>")[0].replace("</soap:Body></soap:Envelope>", "").replace(" xmlns=\"http://ccais.mopas.go.kr/dh/ids/services/keis/JobAbilityTngInfo/types\"", "");
			
			jc = JAXBContext.newInstance(EduResponseVO.class);
			um = jc.createUnmarshaller();
			vo = (EduResponseVO)um.unmarshal(new ByteArrayInputStream(xml.getBytes("utf-8")));
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
		if(vo != null && vo.getDataList() != null && vo.getDataList().size() > 0) {
			shareMapper.deleteCntcKeisEdu(vo.getDataList().get(0));
			
			for(EduVO eo : vo.getDataList())
				shareMapper.insertCntcKeisEdu(eo);
		}
	}
	
	public String getShareXml(String strUrl) throws IOException, InterruptedException {
		int cnt = 0;
		String ret = "";
		URL url = new URL(strUrl);
		HttpURLConnection conn = null;
		StringBuffer sb = new StringBuffer();
		BufferedReader br = null;
		
		do {
			if(cnt > 0)
				Thread.sleep(100);
			
			conn = (HttpURLConnection)url.openConnection();
			conn.setConnectTimeout(3*1000);
			conn.setReadTimeout(3*1000);
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/xml");
			conn.setRequestProperty("Content-Type", "application/xml");
			conn.setDoInput(true);
			conn.connect();
			
			br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
			
			while((ret = br.readLine()) != null)
				sb.append(ret);
			
			ret = sb.toString();
			
			if(conn != null)
				conn.disconnect();
			
			cnt++;
		}while(ret.indexOf("soap:Fault") >= 0 && cnt < 3);
		
		return ret;
	}

	
}
