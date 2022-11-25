<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>서울시 독성물질 중독관리센터</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link rel="shortcut icon" type="x-icon" href="${pageContext.request.contextPath}/static/skill/img/icon.ico">
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/admin/css/style.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-3.5.1.min.js"></script>
<script type="text/javascript">
	$(function(){
		$('.btn').click(function(e){
			if(location.pathname.split('/')[2] == 'admin')
				location.href = '${pageContext.request.contextPath}/admin/index.do';
			else
				location.href = '${pageContext.request.contextPath}/index.do';
				
			e.preventDefault();
			return false;
		});
	});
</script>
</head>
<body>
	<div class="err_outer">
		<div class="err_inner">
			<div class="mb50">
				<img src="${pageContext.request.contextPath}/static/skill/img/common/gnb_logo.png" alt="서울시 독성물질 중독관리센터" />
			</div>
			<div class="err_box">
				<div class="err_icon">
					<i class="fas fa-info-circle"></i>
				</div>
				<div class="mt50 err_title">서비스에 접속할 수 없습니다.</div>
				<div class="mt50 err_text">
					죄송합니다. 기술적인 문제로 인해 일시적으로 접속되지 않았습니다. <br />
					이용에 불편을 드려 사과드리며, 잠시 후 접속해 주시기 바랍니다.
				</div>
			</div>
			<div class="go_main">
				<a href="#" class="btn big blue"><i class="fas fa-home mr10"></i>메인으로 이동</a>
			</div>
		</div>
	</div>
</body>
</html>