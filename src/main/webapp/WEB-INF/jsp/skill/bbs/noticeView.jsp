<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<script type="text/javascript">
		$(function(){
			
			if(location.host.indexOf('cw.or.kr') >= 0)
				$('.board-read-contants').html($('.board-read-contants').text().replace('https://mplus.cw.or.kr', '/plus'));
			
			$('.board-read-contants').html($('.board-read-contants').html().replace(/\&lt;/g,'<').replace(/\&gt\;/g,'>'));
			
			//목록버튼 클릭이벤트
			$('.btn-main-yellow').click(function(e){
				cwma.queryStringToInput($('[name="queryStr"]').val(), $('#frm'));
				$('#frm').attr('method', 'get');
				$('#frm').attr('action', 'noticeList.do');
				$('#frm').submit();
				e.preventDefault();
				return false;
			});
			
			//페이지이동 클릭이벤트
			$('.btnView').click(function(){
				cwma.queryStringToInput($('[name="queryStr"]').val(), $('#frm'));
				$('#frm').attr('action', 'noticeView.do');
				$('[name="sn"]').val($(this).data('sn'));
				$('#frm').submit();
			});
		});
	</script>
</head>
<body>
	<form id="frm" action="" method="post">
		<input type="hidden" name="queryStr" value="${vo.queryStr}" />
		<input type="hidden" name="sn" value="${eo.sn}" />
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
						<li>공지사항</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">공지사항</h4>

				<ul class="subTab col5">
					<li><a href="#" class="${empty param.cl?'on':''}">전체</a></li>
					<li><a href="#" class="${param.cl eq 'BNSE0001'?'on':''}">센터 소식</a></li>
					<li><a href="#" class="${param.cl eq 'BNSE0002'?'on':''}">뉴스보도</a></li>
					<li><a href="#" class="${param.cl eq 'BNSE0003'?'on':''}">관련 사례</a></li>
					<li><a href="#" class="${param.cl eq 'BNSE0004'?'on':''}">기타</a></li>
				</ul><!-- subTab -->

				<div class="bdView">
					<div class="bdvTop">
						<h5>${eo.sj }</h5>
						<ul>
							<li>조회수 <fmt:formatNumber value="${eo.rdcnt }" pattern="#,###"/></li>
							<li>${fn:substring(eo.rgstDt, 0, 10)}</li>
						</ul>
					</div><!-- bdvTop -->
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
					<div class="bdvBtn">
						<a href="#" class="btn-main-yellow">목록</a>
					</div>
				</div><!-- bdView -->

			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</body>
</html>
