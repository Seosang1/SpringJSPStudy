<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/decorator" prefix="decorator" %>
<%@ taglib uri="http://www.opensymphony.com/sitemesh/page" 		prefix="page"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title><decorator:title default="서울시 독성물질 중독관리센터"/></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
	<meta http-equiv="Expires" content="-1">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	
	<!-- 퍼블영역 -->
	<link rel="shortcut icon" type="x-icon" href="${pageContext.request.contextPath}/static/skill/img/icon.ico">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/admin/css/style.css"/>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/admin/css/modal.css"/>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/jquery/fancytree/skin-lion/ui.fancytree.css"/>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-1.12.3.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery-ui-1.12.1.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/fancytree/jquery.fancytree-all.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/admin/js/design.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/admin/js/modal.js"></script>
	<!-- //퍼블영역 -->
		
    <!-- 개발영역 -->
    <script type="text/javascript">
    	var contextPath = '${pageContext.request.contextPath}';
    </script>
	<link rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/zTree/zTreeStyle.css">
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.mask.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/zTree/jquery.ztree.all.min.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.form.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/common/js/cwma.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/admin/js/cwma/cwma.list.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/admin/js/cwma/cwma.file.js" charset="UTF-8"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/static/admin/js/cwma/init.js"></script>
	<script type="text/javascript">
		$(function(){
			var accessTime = new Date();
			var remainTime = 1200;
			var visible = true;
			
			//로그인시간 체크
			setInterval(function(){
				remainTime = 1200 - ((new Date().getTime() - accessTime.getTime())/1000);
				
				$('.util li:eq(1) span').text(Math.floor(remainTime/60)+':'+(remainTime%60<10?'0':'')+Math.floor(remainTime%60));
				
				if(remainTime <= 0)
					$('#logoutLayer .gray-btn').click();
					
				else if(remainTime <= 300 && !$('#logoutLayer:visible')[0] && visible)
					$('[href="#btnLogoutPop"]').click();
				
			}, 1000);
			
			//로그인연장 팝업 로그인연장버튼 클릭이벤트
			$('#logoutLayer .ok-btn').click(function(){
				visible = false;
				
				$.ajax({
					url:contextPath+'/admin/index.do',
					success:function(res){
						accessTime = new Date();
						visible = true;
					}
				});
			});
			
			//로그인연장 팝업 로그아웃버튼 클릭이벤트
			$('#logoutLayer .gray-btn').click(function(){
				location.href = $(this).attr('href');
			});
			
			//로그인연장 버튼 클릭이벤트
			$('.util li:eq(0) button').click(function(){
				$.ajax({
					url:contextPath+'/admin/index.do',
					success:function(res){
						accessTime = new Date();
					}
				});
			});
		});
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
	<form id="namoCrossForm" method="post" action="">
		<input type="hidden" name="uploadedFilesInfo" />
	</form>

	<div id="wrap">
		<!--head-->
		<page:applyDecorator name="adminHeader" />
		<!--head end-->

		<!--container-->
		<div id="container">
			<div class="cont_wrap">
				<div class="container">
					<div class="left_cont">
						<h2 class="sub_tit"></h2>
						<ul class="gnb"></ul>
					</div>

					<div class="right_cont">
						<div class="title">
							<em></em>
							<span class="crumbs"></span>
						</div>

						<decorator:body />
					</div>
				</div>
			</div>
		</div>
		<!--container end-->

		<!--foot-->
		<page:applyDecorator name="adminFooter" />
		<!--foot end-->
	</div>

	<div id="mask" style="display: none; position: absolute; width: 100%; height: 100%; z-index:9999;">
	</div>

	<div class="loader" style="display: none; position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgb(0, 0, 0, 0.8); z-index:9999; text-align: center; line-height: 1000px;">
		<div style="vertical-align: middle;position:relative;">
			<img src="${pageContext.request.contextPath}/static/admin/images/loading.gif" style="width:350px;opacity:0.7" alt="로딩 중"/>
		</div>
	</div>
	
	<div id="excelLayer" class="layerpop" style="width: 700px; height: 395px; display: none; position:absolute; z-index:10000">
		<div class="layerpop_area">
			<div class="title">엑셀 다운로드</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<form id="excelPopDownFrm" method="post">
				</form>
				<form id="excelPopFrm" action="../insertExcelDwldHist.do" method="post">
					<input type="hidden" name="url" value="" />
					<table class="tbl tbl_form">
						<colgroup>
							<col width="100%">
						</colgroup>
						<tbody>
							<tr>
								<td class="pt10 pb10">
									<textarea class="w100p h200" name="cn" title="엑셀 다운로드 사유" required></textarea>
								</td>
							</tr>
							<tr>
								<td class="pt10 pb10">
									<input type="checkbox" id="rad201" name="ihidnumIndictAt" value="Y">
									<label for="rad201">다운로드 시 주민등록번호 뒷자리 표기</label>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="#" class="btn normal green mr10 btnExcelLayerDown"><i class="far fa-file-excel mr5"></i> 다운로드</a>
						<a href="#" class="btn normal black mr10 btnExcelLayerClose"><i class="fas fa-power-off mr5"></i> 취소</a>
					</div>
				</div>

			</div>
		</div>
	</div>

	<button href="#btnLogoutPop" type="button" class="btn btn-light issu-btn" data-toggle="modal" data-target="#logoutLayer" style="display:none">로그아웃팝업</button>
	<div id="logoutLayer" class="modal fade in" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-backdrop fade in"></div>
		<div class="modal-dialog">
			<div class="modal-content">

				<div class="modal-header">
					<h5 class="modal-title">자동 로그아웃 안내</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="창닫기">
						<span aria-hidden="true">×</span>
					</button>
				</div>

				<div class="modal-body text-center">
					<i class="fas fa-user-clock" style="font-size: 2rem; padding-bottom: 2px; color: #007A6D; margin-bottom: 13px; border-bottom: 2px solid #007A6D"></i>
					<h1>5분 후 자동으로 접속이 종료 될 예정입니다.</h1>
					<ul class="cwma-tab-text-depth2 text-left">
						<li>안전한 사이트 이용을 위하여 로그인 유지시간(20분)동안 사용하지 않을 경우 자동으로 접속이 종료됩니다.</li>
						<li>계속 사용하실 경우 '로그인 연장'을 클릭해주세요.</li>
					</ul>
				</div>

				<div class="modal-footer">
					<button type="button" class="ok-btn" data-dismiss="modal" aria-hidden="true">로그인 연장</button>
					<button type="button" class="gray-btn" href="${pageContext.request.contextPath}/common/timeoutPop.do">로그아웃</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>