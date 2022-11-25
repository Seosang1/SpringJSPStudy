<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:if test="${not empty no }">
<!DOCTYPE html>
<html lang="ko">
<head>
    	<title>증명서 출력</title>
    	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
        <script src="${ozServer }/oz60/ozhviewer/jquery-2.0.3.min.js"></script>
		<link rel="stylesheet" href="${ozServer }/oz60/ozhviewer/jquery-ui.css" type="text/css"/>
		<script src="${ozServer }/oz60/ozhviewer/jquery-ui.min.js"></script>
		<link rel="stylesheet" href="${ozServer }/oz60/ozhviewer/ui.dynatree.css" type="text/css"/>
		<script type="text/javascript" src="${ozServer }/oz60/ozhviewer/jquery.dynatree.js" charset="utf-8"></script>
		<script type="text/javascript" src="${ozServer }/oz60/ozhviewer/OZJSViewer.js" charset="utf-8"></script>
    </head>
    <body>
		<div id="OZViewer" style="width:100%;height:100%"></div>
		<script type="text/javascript" >
			function SetOZParamters_OZViewer(){
				let fileName = "grade/건설기능인등급증명서_상세미포함.ozr";
				/* 세부이력 포함여부 */
				if("${detailHistInclsAt}" == "Y"){
					fileName = "grade/건설기능인등급증명서_상세포함.ozr";
				}
				
				var oz;
				oz = document.getElementById("OZViewer");
				oz.sendToActionScript("information.debug","false");//디버그
				oz.sendToActionScript("connection.servlet","${ozServer }/oz60/server");
				oz.sendToActionScript("connection.reportname",fileName);
				oz.sendToActionScript("connection.pcount", "1");
				oz.sendToActionScript("connection.args1", "no=${no}");
				oz.sendToActionScript("export.format","pdf");
				oz.sendToActionScript("export.filename","기능등급증명서_"+'${brffcNm}');
				return true;
			}
			start_ozjs("OZViewer","${ozServer }/oz60/ozhviewer/");
		</script>
    </body>
</html>
<head>
</c:if>