<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>서울시 독성물질 중독관리센터</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/admin/css/style.css"/>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-3.5.1.min.js"></script>
<script type="text/javascript">
	$(function(){
		$('.btn').click(function(e){
			window.close();
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
				<div class="mt50 err_title">로그인 후 20분이 경과하였습니다.</div>
				<div class="mt50 err_text">
					개인정보보호와 보안강화를 위해 연결을 종료합니다. <br />
					종료하기 버튼을 눌러 창을 닫아 주시기 바랍니다.
				</div>
			</div>
			<div class="go_main">
				<a href="#" class="btn big blue">종료하기</a>
			</div>
		</div>
	</div>
</body>
</html>