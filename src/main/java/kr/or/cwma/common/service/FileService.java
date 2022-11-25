package kr.or.cwma.common.service;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.namo.crossuploader.CrossUploaderException;

import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 파일관리 서비스
 * @author sichoi
 */
public interface FileService{

	/**
	 * 파일 업로드
	 * 파일파라미터명 "file"이여야 됨
	 * @param req
	 * @return List<AttchFileInfoVO>
	 * @throws IOException
	 */
	public List<AttchFileInfoVO> upload(MultipartHttpServletRequest req) throws IOException;

	/**
	 * 파일 업로드
	 * @param req
	 * @param paramName
	 * @return List<AttchFileInfoVO>
	 * @throws IOException
	 */
	public List<AttchFileInfoVO> upload(MultipartHttpServletRequest req, String paramName) throws IOException;
	
	/**
	 * 파일업로드
	 * @param mfileList
	 * @return List<AttchFileInfoVO>
	 * @throws IOException
	 */
	public List<AttchFileInfoVO> upload(List<MultipartFile> mfileList) throws IOException;
	
	/**
	 * 파일 업로드 - ckEditor 
	 * @param req
	 * @return AttchFileInfoVO
	 * @throws IOException
	 */
	public AttchFileInfoVO uploadEditor(MultipartHttpServletRequest req) throws IOException;
	
	/**
	 * 파일 업로드 - CROSS UPLOADER
	 * @param req
	 * @param res
	 * @return AttchFileInfoVO
	 * @throws IOException
	 * @throws CrossUploaderException
	 */
	public AttchFileInfoVO crossUpload(HttpServletRequest req, HttpServletResponse res) throws IOException, CrossUploaderException;

	/**
	 * 파일다운로드
	 * @param res
	 * @param vo
	 * @throws IOException
	 * @throws SQLException
	 */
	public void download(HttpServletResponse res, AttchFileInfoVO vo) throws IOException, SQLException;
}
