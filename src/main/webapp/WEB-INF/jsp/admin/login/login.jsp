<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>서울시 독성물질 중독관리센터</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	
	<!-- 퍼블영역 -->
	<link rel="shortcut icon" type="x-icon" href="${pageContext.request.contextPath}/static/skill/img/icon.ico">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/admin/css/style.css"/>
	<script src="${pageContext.request.contextPath}/static/lib/jquery/jquery-3.5.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-ui-1.12.1.min.js"></script>
	<!-- //퍼블영역 -->
	
	<!-- 개발영역 -->
    <script type="text/javascript">
    	var contextPath = '${pageContext.request.contextPath}';
    </script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.form.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.cookie.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/admin/js/cwma/init.js"></script>
	<script type="text/javascript">
		$(function(){
			$('#frm').submit(function(e){
				$(this).ajaxSubmit({
					beforeSubmit: function(){ 
						var isErr = false;
						
						//필수값 체크
						$('[type="text"]').each(function(){
							if(!$(this).val()){
								isErr = true;
								alert($(this).attr('title')+'을(를) 입력해주세요');
								$(this).focus();
								return false;
							}
						});
						
						if($('#saveId').prop('checked'))
							$.cookie('loginId', $('[name="userId"]').val(), {expires:3650, path:'/admin'});
						else
							$.removeCookie('loginId', {path:'/admin'});
						
						return !isErr;
					},success:function(res){
						location.href = contextPath+'/admin/index.do';
						if(null != res.errors[0].defaultMessage && "" != res.errors[0].defaultMessage){
							alert(res.errors[0].defaultMessage);
						}
						
					},error:function(res){
						if(res.status == 400){
							//validation 처리
							if(res.responseJSON){
								$(res.responseJSON.errors).each(function(){
									obj = $('[name="'+this.field+'"]');
									alert(this.defaultMessage);
									$(obj).focus();
									return false;
								});
							}
							
						}else{
							alert('오류가 발생하였습니다.');
						}
					}
				});
				e.preventDefault();
				return false;
			});
			
			if($.cookie('loginId')){
				$('[name="userId"]').val($.cookie('loginId'))
				$('#saveId').prop('checked', true);
			}
		});
	</script>
</head>
<body>
	<div id="wrap">

		<!--head-->
		<div id="head"></div>
		<!--head end-->
		<!--background-->
		<ul class="bgSlide">
			<li></li>
			<li></li>
		</ul>
		<!--//background-->

		<!--container-->
		<div id="login-container">
			<div class="login_wrap">
				<div class="inner_wrap">
					<div class="login_form">
						<div class="logo">
							<a href="${pageContext.request.contextPath}/admin/index.do">
								<%-- <img src="${pageContext.request.contextPath}/static/admin/images/logo_cwma.png" alt="logo" /> --%>
							</a>
						</div>

						<div class="form_wrap">
							<form id="frm" action="login.do" method="post">
								<div class="input_wrap">
									<div class="">
										<input class="w100p" type="text" maxlength="15" placeholder="관리자 아이디를 입력하세요" name="userId" value="" title="아이디" />
									</div>
									<div class="txt_left">
										<input type="checkbox" id="saveId" value="">
										<label class="mt10" for="saveId">아이디 저장</label>
									</div>
									<div class="">
										<input class="mt10 w100p" type="password" maxlength="20" placeholder="비밀번호를 입력하세요" name="password" value="" title="비밀번호" />
									</div>
									<div class="">
										<input class="btn_login mt30" type="submit" value="로그인" style="cursor: pointer" />
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!--container end-->

		<!--foot-->
		<div id="foot"></div>
		<!--foot end-->
	</div>
</body>
</html>