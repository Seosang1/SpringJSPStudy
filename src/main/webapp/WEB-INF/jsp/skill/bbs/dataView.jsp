<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaFile;
	
	$(function(){
		cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0001', parntsSn:$('[name="sn"]').val()});
		cwmaFile.setFileList();
		
		if(location.host.indexOf('cw.or.kr') >= 0)
			$('.board-read-contants').html($('.board-read-contants').text().replace('https://mplus.cw.or.kr', '/plus'));
		
		$('.board-read-contants').html($('.board-read-contants').html().replace(/\&lt;/g,'<').replace(/\&gt\;/g,'>'));
		
		//목록버튼 클릭이벤트
		$('.btn-main-yellow').click(function(e){
			cwma.queryStringToInput($('[name="queryStr"]').val(), $('#frm'));
			$('[name="queryStr"]').remove();
			$('#frm').attr('method', 'get');
			$('#frm').attr('action', 'dataList.do');
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		//페이지이동 클릭이벤트
		$('.btnView').click(function(){
			cwma.queryStringToInput($('[name="queryStr"]').val(), $('#frm'));
			$('[name="queryStr"]').remove();
			$('#frm').attr('action', 'dataView.do');
			$('[name="sn"]').val($(this).data('sn'));
			$('#frm').submit();
		});
		
		//파일다운로드이벤트
		$('#fileLayer').on('click', 'a', function(e){
			var url = $(this).attr('href');
			
			$('#frm').append('<input type="hidden" name="sn" value="'+cwma.parseQueryString($(this).attr('href'))['parntsSn']+'" />');
			$('#frm').attr('action', 'updateDwldCo.do');
			$('#frm').ajaxCwma({
				success:function(res){
					location.href = url;
				}
			});
			
			e.preventDefault();
			return false;
		});
	});
</script>
</head>
<body>
	<form id="frm" action="" method="post">
		<input type="hidden" name="queryStr" value="${vo.queryStr}" />
		<input type="hidden" name="sn" value="${vo.sn}" />
	</form>
	
<div id="wrap">
	<div id="contents">

		<div id="subTop" class="bg04">
			<div class="container">
				<h2 class="subTitle">알림마당</h2>
			</div>
			<div class="subNav">
				<div class="container">
					<ul>
						<li>홈</li>
						<li>알림마당</li>
						<li>자료실</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">자료실</h4>

				<ul class="subTab col5">
					<li><a href="#" class="${empty param.cl?'on':''}">전체</a></li>
					<li><a href="#" class="${param.cl eq 'BDSE0001'?'on':''}">관련 법령</a></li>
					<li><a href="#" class="${param.cl eq 'BDSE0002'?'on':''}">연간 보고서</a></li>
					<li><a href="#" class="${param.cl eq 'BDSE0003'?'on':''}">교육 자료</a></li>
					<li><a href="#" class="${param.cl eq 'BDSE0004'?'on':''}">해외 동향</a></li>
				</ul><!-- subTab -->

				<div class="bdView">
					<div class="bdvTop">
						<h5>${eo.sj }</h5>
						<ul>
							<li>조회수 <fmt:formatNumber value="${eo.rdcnt }" pattern="#,###"/></li>
							<li>다운로드수 <fmt:formatNumber value="${eo.dwldCo }" pattern="#,###"/></li>
							<li>${fn:substring(eo.rgstDt, 0, 10)}</li>
						</ul>
					</div><!-- bdvTop -->
					<dl class="bdvFile board-read-file">
						<dt>첨부파일</dt>
						<dd id="fileLayer"></dd>
					</dl>
					
					<div class="bdvTxt board-read-contants">
						${eo.cn }
					</div><!-- bdvTxt -->
					<ul class="bdvNav">
						<c:forEach var="list" items="${list}">
							<li>
								<dl>
									<dt class="board-read-pre"><i class="fas fa-angle-${list.se eq 'U'?'up':'down'} mr-2"></i> ${list.se eq 'U'?'다음':'이전'}글</dt>
									<dd class="text-left"><a href="#" class="btnView" data-sn="${list.sn }">${list.sj }</a></dd>
									<dd class="board-read-pre-next-set-date" date>${list.rgstDt }</dd>
								</dl>
							</li>
						</c:forEach>
					</ul><!-- bdvNav -->
					<div class="bdvBtn ">
						<a href="#" class="btn-main-yellow">목록</a>
					</div>
				</div><!-- bdView -->

			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>	
</body>
</html>
