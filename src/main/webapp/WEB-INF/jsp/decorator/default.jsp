<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" 		prefix="page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<meta name="HandheldFriendly" content="True">
	<meta name="MobileOptimized" content="320">
	<meta name="viewport" content="width=device-width, initial-scale=1, minimal-ui">
	<meta name="mobile-web-app-capable" content="yes">	
	<meta name="apple-mobile-web-app-capable" content="yes">
	<meta name="apple-mobile-web-app-status-bar-style" content="black">
	<meta name="format-detection" content="telephone=no">
	<meta name="Robots" content="ALL" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>서울시 독성물질 중독관리센터</title>

	<!-- 퍼블영역 -->
	<%-- <link rel="shortcut icon" type="x-icon" href="${pageContext.request.contextPath}/static/skill/img/icon.ico"> --%>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/skill/css/default.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/skill/css/slick.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/skill/css/animate.min.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/skill/css/common.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/skill/css/style.css">
	
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/jquery-2.2.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/placeholders.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/slick.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/common.js"></script>
	
	<!-- Date Picker -->
	
	<!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
	
	<!--확대축소 버튼 -->
	<!-- //퍼블영역 -->
		
    <!-- 개발영역 -->
    <script type="text/javascript">
    	var contextPath = '${pageContext.request.contextPath}';
    	var csrfToken = '${SESSION_CSRF_TOKEN}';
    </script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.mask.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.form.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/common/js/cwma.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/cwma/cwma.list.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/cwma/cwma.file.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/cwma/init.js"></script>
	
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-ui-1.12.1.min.js"></script>
	<!-- Date Picker -->
	<script src="${pageContext.request.contextPath}/static/skill/lib/jquery/user.datepicker/jquery.ui.datepicker-ko.js"></script>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/static/skill/lib/jquery/user.datepicker/jquery-ui.min.css">
	
	
	<script type="text/javascript">
	</script>
	
	<!-- 섬머노트 시작  -->
	
	<script src="${pageContext.request.contextPath}/static/lib/summernote/summernote-lite.js"></script>
	<script src="${pageContext.request.contextPath}/static/lib/summernote/lang/summernote-ko-KR.js"></script>
	
	<link rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/summernote/summernote-lite.css">
	
	<!-- 섬머노트 끝  -->
	<!--//개발영역  -->
	<decorator:head />
</head>
<body>
	<!--==========================
	Sub Header
	============================-->
	<page:applyDecorator name="header" />
	<!--==========================
	//Sub Header
	============================-->
	

	<!--==========================
	sub-section
	============================-->				
	<decorator:body />
	<!--==========================
	// sub-section
	============================-->		
    
	<!--==========================
	footer
	============================-->
	<page:applyDecorator name="footer" />
	<!--==========================
	//footer
	============================-->
	
</body>
</html>