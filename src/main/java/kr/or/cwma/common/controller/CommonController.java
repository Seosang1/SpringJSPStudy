package kr.or.cwma.common.controller;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.BadRequestException;

import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.namo.crossuploader.CrossUploaderException;

import kr.or.cwma.common.service.FileService;
import kr.or.cwma.common.service.ShareService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 공통 컨트롤러
 * @author sichoi
 */
@Controller
public class CommonController{
	
	@Value("#{prop['file.uploadDir']}")
	String uploadDir;
	
	@Value("#{prop['file.baseDir']}")
	String baseDir;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	ShareService shareService;
	
	/**
	 * 401에러
	 * @param req
	 * @return String
	 */
	@RequestMapping(value="/error/401.do")
	public String error401(Model model, HttpServletRequest req){
		return "common/error/error401";
	}
	
	/**
	 * 404에러
	 * @param req
	 * @return String
	 */
	@RequestMapping(value="/error/404.do")
	public String error404(Model model, HttpServletRequest req){
		return "common/error/error404";
	}

	/**
	 * 500에러
	 * @param req
	 * @return String
	 */
	@RequestMapping(value="/error/500.do")
	public String error500(Model model, HttpServletRequest req){
		return "common/error/error500";
	}
	
	/**
	 * 크로스업로더 - 파일다운로드
	 * @param req
	 * @param res
	 * @param vo
	 * @param result
	 * @throws IOException
	 * @throws SQLException
	 * @throws ParseException
	 */
	@RequestMapping(value="/common/download.do")
	public void download(HttpServletRequest req, HttpServletResponse res, AttchFileInfoVO vo) throws IOException, SQLException, ParseException{
		String downloadFormData = req.getParameter("CD_DOWNLOAD_FILE_INFO"); 
		JSONParser jsonParser = new JSONParser();
		JSONObject jsonObject = null;
		
		if(StringUtils.isNotEmpty(downloadFormData)){
			jsonObject = (JSONObject)jsonParser.parse(downloadFormData);
			
			if(!StringUtils.isEmpty(downloadFormData)){
				vo.setFileSn((Long)jsonObject.get("fileSn"));
				vo.setParntsSe((String)jsonObject.get("parntsSe"));
				vo.setParntsSn((Long)jsonObject.get("parntsSn"));
			}
		}
		
		if(vo.getFileSn() > 0 && !StringUtils.isEmpty(vo.getParntsSe()) && vo.getParntsSn() > 0)
			fileService.download(res, vo);
		else
			throw new BadRequestException("필수항목누락");
	}
	
	/**
	 * 크로스업로더 - 업로드
	 * @param req
	 * @param res
	 * @return ResponseEntity<Map<String, Object>>
	 * @throws CrossUploaderException
	 * @throws IOException 
	 */
	@RequestMapping(value="/common/upload.do")
	public ResponseEntity<AttchFileInfoVO> upload(HttpServletRequest req, HttpServletResponse res) throws CrossUploaderException, IOException{
		return new ResponseEntity<>(fileService.crossUpload(req, res), HttpStatus.OK);
	}
	
	/**
	 * 주소검색 팝업
	 * @param model
	 * @param req
	 * @return
	 */
	@RequestMapping(value="/common/adrsPop.do")
	public String adrsPop() {
		return "common/popup/adrs";
	}
	
	/**
	 * 세션타임아웃 팝업
	 * @param model
	 * @param req
	 * @return
	 */
	@RequestMapping(value="/common/timeoutPop.do")
	public String timeoutPop() {
		return "common/popup/timeOut";
	}
}
