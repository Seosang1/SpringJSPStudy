package kr.or.cwma.common.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFSheet;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

public class ExcelUtil {

	public static List<Map<String, String>> getXlsToMap(File xls) throws IOException{
		Map<String, String> map = new HashMap<String, String>();
		List<Map<String, String>> ret = new ArrayList<Map<String, String>>();
		List<String> header = new ArrayList<String>();
		Iterator<Row> iter = null;
		Iterator<Cell> cellIter = null;

		DataFormatter formatter = new DataFormatter();
		FileInputStream fis = new FileInputStream(xls);
		Workbook work = null;
	    Sheet sheet;
		Row row;
		Cell cell;
		
		try{
		    if (xls.getName().endsWith("xlsx")) {
		    	work = new XSSFWorkbook(fis);
		    } else if (xls.getName().endsWith("xls")) {
		    	work = new HSSFWorkbook(fis);
		    } else {
		        throw new IllegalArgumentException("The specified file is not Excel file");
		    }
		    
		    sheet = work.getSheetAt(0);
			iter = sheet.rowIterator();
			
			while(iter.hasNext()){
				row = iter.next();
				map = new HashMap<String, String>();
	
				if(header.size() != 0){
					ret.add(map);
					
					for(int i = 0;i<header.size();i++)
						map.put(header.get(i), formatter.formatCellValue(row.getCell(i)));
					
				}else{
					cellIter = row.cellIterator();
					while(cellIter.hasNext()){
						cell  = cellIter.next();
						header.add(cell.getStringCellValue());
					}
				}
			}
		}catch(IOException e){
			throw e;
			
		}finally{
			cell = null;
			row = null;
			sheet = null;
			formatter = null;
			
			if(iter != null) iter.remove();
			if(cellIter != null) cellIter.remove();
			if(header != null) header.clear();
			if(work != null) work.close();
			if(fis != null) fis.close();
		}

		return ret;
	}
	
	public static void createXls(List<Map<String, Object>> list, String sheetNm, HttpServletResponse res) throws IOException{
		createXls(list, sheetNm, res, false);
	}

	public static void createXls(List<Map<String, Object>> list, String sheetNm, HttpServletResponse res, boolean isXlsx) throws IOException{
		int rowIdx = 0, cellIdx = 0;

		Iterator<String> key = null;
		Workbook wb = null;
		
		if(isXlsx)
			wb = new SXSSFWorkbook(4096);
		else
			wb = new HSSFWorkbook();
		
		Sheet sheet = wb.createSheet(sheetNm);
		Row row = null;
	    Cell cell = null;
	    CellStyle titleStyle = wb.createCellStyle();
	    CellStyle style = wb.createCellStyle();
	    
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
	    
	    try{
		    //제목스타일
		    titleStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		    titleStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		    titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		    titleStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    titleStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    titleStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    titleStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	
		    //일반셀스타일
		    style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		    style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	
		    for(Map<String, Object> map : list){
		    	if(!isXlsx && rowIdx >= 65535)
	    			break;
		    	
		    	//제목세팅
		    	if(key == null){
		    		row = sheet.createRow(rowIdx++);
			    	key = map.keySet().iterator();
	
			    	while(key.hasNext()){
			    		cell = row.createCell(cellIdx++);
			    		cell.setCellStyle(titleStyle);
			    		cell.setCellValue(key.next());
			    	}
		    	}
	
		    	//값세팅
		    	cellIdx = 0;
		    	row = sheet.createRow(rowIdx++);
		    	key = map.keySet().iterator();
	
		    	while(key.hasNext()){
		    		cell = row.createCell(cellIdx++);
		    		cell.setCellStyle(style);
		    		cell.setCellValue(String.valueOf(map.get(key.next())));
		    	}
		    }
	
		    //셀 너비 설정
		    if(isXlsx){
		    	for(int i=0; i<cellIdx; i++){
		            if(((SXSSFSheet)sheet).isColumnTrackedForAutoSizing(i))
		            	sheet.autoSizeColumn(i);
		        }
		    }else{
			    for(int i=0; i<cellIdx; i++){
			    	sheet.autoSizeColumn(i);
			    	sheet.setColumnWidth(i, Math.min(255 * 256, sheet.getColumnWidth(i) + (short)512));
			    }
		    }
	
		    res.setContentType("ms-vnd/excel");
		    res.setHeader("Content-Disposition", "attachment; filename=\"".concat(URLEncoder.encode(sheetNm.concat("_").concat(sdf.format(new Date())),"UTF-8")).concat(isXlsx?".xlsx\";":".xls\";"));
		    wb.write(res.getOutputStream());
		    
		    
	    }catch(IOException e){
	    	throw e;
	    	
	    }finally{
	    	sdf = null;
	    	sheet = null;
			row = null;
		    cell = null;
		    titleStyle = null;
		    style = null;
	    	
	    	if(list != null) list.clear();
	    	if(key != null) key.remove();
	    	if(wb != null) {
	    		if(isXlsx)
	    			((SXSSFWorkbook)wb).dispose();
	    			
	    		wb.close();
	    	}
	    }
	}

	public static <T> void createObjectToXls(List<T> list, String sheetNm, HttpServletResponse res) throws IOException, IllegalAccessException, IllegalArgumentException, InvocationTargetException{
		List<Map<String, Object>> mapList = new ArrayList<Map<String, Object>>();

		for(T t : list)
			mapList.add(voToMap(t));

		createXls(mapList, sheetNm, res);
		mapList.clear();
	}

	public static <T> Map<String, Object> voToMap(T t) throws IllegalAccessException, IllegalArgumentException, InvocationTargetException{
		String name = "", key = "";
		Method[] voMethod = t.getClass().getMethods();
		Map<String, Object> map = new HashMap<String, Object>();

		for(Method m : voMethod){
			name = m.getName();

			if(name.startsWith("get")){
				key = name.replaceFirst("get", "");
				key = key.substring(0, 1).toLowerCase() + key.substring(1);

				map.put(key, String.valueOf(m.invoke(t)));
			}

		}

		return map;
	}

	public static void createXls(String[] headers, List<Map<String, Object>> list, String sheetNm, HttpServletResponse res) throws IOException{
		int rowIdx = 0, cellIdx = 0;

		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet(sheetNm);
		HSSFRow row = null;
	    HSSFCell cell = null;
	    HSSFCellStyle titleStyle = wb.createCellStyle();
	    HSSFCellStyle style = wb.createCellStyle();
	    
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

	    try{
		    //제목스타일
		    titleStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		    titleStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		    titleStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		    titleStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    titleStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    titleStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    titleStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	
		    //일반셀스타일
		    style.setAlignment(HSSFCellStyle.ALIGN_LEFT);
		    style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
	
	
	    	//제목세팅
	    	row = sheet.createRow(rowIdx++);
	    	for (String title : headers) {
	    		cell = row.createCell(cellIdx++);
	    		cell.setCellStyle(titleStyle);
	    		cell.setCellValue(title);
			}
	
		    for(Map<String, Object> map : list){
		    	if(rowIdx >=65535)
		    		break;
		    	//값세팅
		    	cellIdx = 0;
		    	row = sheet.createRow(rowIdx++);
		    	for (String title : headers) {
		    		cell = row.createCell(cellIdx++);
		    		cell.setCellStyle(style);
		    		cell.setCellValue(String.valueOf(map.get(title)));
				}
		    }
	
		    //셀 너비 설정
		    for (int i=0; i<cellIdx; i++){
		    	sheet.autoSizeColumn(i);
		    	sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+(short)512);
		    }
	
		    res.setContentType("ms-vnd/excel");
		    res.setHeader("Content-Disposition", "attachment; filename=\"".concat(URLEncoder.encode(sheetNm.concat("_").concat(sdf.format(new Date())),"UTF-8")).concat(".xls\";"));
		    wb.write(res.getOutputStream());
		    
	    }catch(IOException e){
	    	throw e;
	    	
	    }finally{
	    	sdf = null;
	    	if(list != null) list.clear();
	    	if(wb != null) wb.close();
	    }
	}

}
