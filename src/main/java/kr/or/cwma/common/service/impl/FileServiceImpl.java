package kr.or.cwma.common.service.impl;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.microsoft.sqlserver.jdbc.StringUtils;
import com.namo.crossuploader.CrossUploaderException;
import com.namo.crossuploader.FileItem;
import com.namo.crossuploader.FileUpload;

import kr.or.cwma.common.service.AttchFileInfoService;
import kr.or.cwma.common.service.FileService;
import kr.or.cwma.common.vo.AttchFileInfoVO;

/**
 * 파일관리 비지니스로직
 * @author sichoi
 */
@Service
public class FileServiceImpl implements FileService{
	
	@Value("#{prop['file.uploadDir']}")
	String uploadDir;
	
	@Value("#{prop['file.tempDir']}")
	String tempDir;
	
	@Value("#{prop['file.ext']}")
	String allowExt;
	
	@Value("#{prop['file.editor.ext']}")
	String editorExt;
	
	@Autowired
	AttchFileInfoService attchFileInfoService;
	
	public List<AttchFileInfoVO> upload(MultipartHttpServletRequest req) throws IOException{
		return upload(req, "file");
	}
	
	public List<AttchFileInfoVO> upload(MultipartHttpServletRequest req, String paramName) throws IOException{
		return upload(req.getFiles(paramName));
	}
	
	public List<AttchFileInfoVO> upload(List<MultipartFile> mfileList) throws IOException{
		boolean isUploadable = false;
		String ym = null, ext = null, fileName = null;
		String[] arrExt = allowExt.split(",");
		
		File file = null, dir = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		
		AttchFileInfoVO avo = new AttchFileInfoVO();
		List<AttchFileInfoVO> list = new ArrayList<AttchFileInfoVO>();
		
		ym = sdf.format(new Date());
		dir = new File(uploadDir, ym.replaceAll("-", "/"));
		
		if(!dir.exists())
			dir.mkdirs();
		
		if(mfileList != null){
			for(MultipartFile mfile : mfileList) {
				avo = new AttchFileInfoVO();
				fileName = mfile.getOriginalFilename();
				
				if(fileName.lastIndexOf(".") < 0)
					throw new IOException("확장자 없음");
	
				ext = fileName.substring(fileName.lastIndexOf(".")+1);
				
				for(String tmpExt : arrExt){
					if(tmpExt.equals(ext.toUpperCase())){
						isUploadable = true;
						break;
					}
				}
				
				if(!isUploadable)
					throw new IOException("허용되지 않는 확장자");
				
				file = new File(dir, UUID.randomUUID().toString().concat(".").concat(ext));
				
				avo.setFileNm(file.getName());
				avo.setSize(mfile.getSize());
				avo.setOrginlFileNm(fileName);
				avo.setPath(file.getAbsolutePath());
				avo.setExtsn(ext);
				
				mfile.transferTo(file);
				list.add(avo);
			}
		}
		
		return list;
	}
	
	public AttchFileInfoVO uploadEditor(MultipartHttpServletRequest req) throws IOException{
		boolean isUploadable = false;
		String ym = null, ext = null, fileName = null;
		String[] arrExt = editorExt.split(",");
		
		File file = null, dir = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		
		AttchFileInfoVO avo = new AttchFileInfoVO();
		MultipartFile mfile = req.getFile("upload");
		
		ym = sdf.format(new Date());
		dir = new File(uploadDir.concat("/editor"), ym.replaceAll("-", "/"));
		
		if(!dir.exists())
			dir.mkdirs();
		
		if(mfile != null){
			fileName = mfile.getOriginalFilename();
			
			if(fileName.lastIndexOf(".") < 0)
				throw new IOException("확장자 없음");

			ext = fileName.substring(fileName.lastIndexOf(".")+1);
			
			for(String tmpExt : arrExt){
				if(tmpExt.equals(ext.toUpperCase())){
					isUploadable = true;
					break;
				}
			}
			
			if(!isUploadable)
				throw new IOException("허용되지 않는 확장자");
			
			file = new File(dir, UUID.randomUUID().toString().concat(".").concat(ext));
			
			avo.setFileNm(file.getName());
			avo.setSize(mfile.getSize());
			avo.setOrginlFileNm(fileName);
			avo.setPath(file.getAbsolutePath());
			avo.setExtsn(ext);
			
			mfile.transferTo(file);
		}
		
		return avo;
	}
	
	
	public AttchFileInfoVO crossUpload(HttpServletRequest req, HttpServletResponse res) throws IOException, CrossUploaderException{
		boolean isUploadable = false;
		String ym = null;
		String[] arrExt = allowExt.split(",");
		
		File dir = null;
		FileItem fileItem = null;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
		
		AttchFileInfoVO avo = new AttchFileInfoVO();
		FileUpload fileUpload = new FileUpload(req, res);
		
		ym = sdf.format(new Date());
		dir = new File(uploadDir, ym.replaceAll("-", "/"));
		
		if(!dir.exists())
			dir.mkdirs();
		
		try { 
			fileUpload.setAutoMakeDirs(true);
			fileUpload.startUpload(tempDir);
			fileItem = fileUpload.getFileItem("CU_FILE"); 

			if(fileItem != null){
				if(StringUtils.isEmpty(fileItem.getFileExtension())){
					fileItem.deleteFile();
					throw new IOException("확장자 없음");
				}
	
				for(String tmpExt : arrExt){
					if(tmpExt.equals(fileItem.getFileExtension().toUpperCase())){
						isUploadable = true;
						break;
					}
				}
				
				if(!isUploadable){
					fileItem.deleteFile();
					throw new IOException("허용되지 않는 확장자");
				}
				
				fileItem.saveAs(dir.getAbsolutePath(), UUID.randomUUID().toString().concat(".").concat(fileItem.getFileExtension()));
				
				avo.setFileNm(fileItem.getLastSavedFileName());
				avo.setSize(fileItem.getFileSize());
				avo.setOrginlFileNm(new String(fileItem.getFileName().getBytes("8859_1"), "UTF-8"));
				avo.setPath(fileItem.getLastSavedFilePath());
				avo.setExtsn(fileItem.getFileExtension());
			}
			
		}catch(CrossUploaderException ex){
			throw ex;
			
		}finally{ 
			fileUpload.clear(); 
		}
		
		return avo;
	}
	
	public void download(HttpServletResponse res, AttchFileInfoVO vo) throws IOException, SQLException{
		int read = 0;
		byte b[] = new byte[4096];
		
		BufferedInputStream bis = null;
		BufferedOutputStream bos = null;
		FileInputStream fis = null;
		
		AttchFileInfoVO eo = attchFileInfoService.selectAttchFileInfo(vo);
		File file = new File(eo.getPath());
		
		if(file.exists()){
			if("jpeg|bmp|png|jpg|gif".indexOf(eo.getExtsn().toLowerCase()) >= 0)
				res.setContentType("image/".concat(eo.getExtsn().toLowerCase().replace("jpg", "jpeg")));
			
			res.setHeader("Content-Disposition","attachment;filename=".concat(URLEncoder.encode(eo.getOrginlFileNm(), "UTF-8")).concat(";"));
			res.setContentLength((int)file.length());
			fis = new FileInputStream(file);
	
			try {
				bis = new BufferedInputStream(fis);
				bos = new BufferedOutputStream(res.getOutputStream());
				
				while((read = bis.read(b)) != -1)
					bos.write(b, 0, read);
				
				bos.flush();
				
			}finally {
				if(bis != null) bis.close();
				if(bos != null) bos.close();
				if(fis != null) fis.close();
				
			}
			
		}else{
			throw new FileNotFoundException("파일을 찾을수 없습니다(".concat(file.getAbsolutePath()).concat(")"));
			
		}
	}
}
