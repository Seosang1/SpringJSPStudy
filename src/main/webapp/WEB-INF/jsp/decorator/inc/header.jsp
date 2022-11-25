<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<script type="text/javascript">
</script>

	<h1 id="title">서울시 독성물질 중독관리센터</h1>
	<dl id="skip">
		<dt class="hidden">바로가기 메뉴</dt>
		<dd><a href="#gnb">주메뉴 바로가기</a></dd>
		<dd><a href="#contents">본문 바로가기</a></dd>
	</dl>
	<!-- gnb -->
	<div id="gnb">

		<div id="gnbTop">
			<div class="container">
				<a href="${pageContext.request.contextPath}/index.do" class="gtLogo">서울시 독성물질 중독관리센터</a>
				<ul class="gtSns">
					<li><a href="http://pf.kakao.com/_txaups" target="_blank">카카오톡</a></li>
					<li><a href="https://www.instagram.com/seoulpcc/" target="_blank">인스타그램</a></li>
					<li><a href="https://www.facebook.com/seoulpcc" target="_blank">페이스북</a></li>
				</ul>
				<button id="gnbMo"><span class="hidden">전체메뉴 열기</span></button>
			</div>
		</div><!-- gnbTop -->

		<div id="gnbBot">
			<div class="container">				
				<div class="gbWrap">
					<ul class="gbMenu">
						<li>
							<a href="${pageContext.request.contextPath}/skill/info/centerInfo.do">센터소개</a>
							<ul>
								<li><a href="${pageContext.request.contextPath}/skill/info/centerInfo.do">서울시 중독관리 센터 소개</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/info/group.do">조직도</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/info/plan.do">운영안내 및 오시는길</a></li>
							</ul>	
						</li>
						<li>
							<a href="#">독성물질 정보제공</a>
							<ul>
								<li><a href="${pageContext.request.contextPath}/skill/poison/search.do">전체</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/poison/material.do">화학물질</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/poison/product.do">화학제품</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/poison/medical.do">의약품</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/poison/farm.do">농약</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/poison/live.do">동 · 식물</a></li>
							</ul>	
						</li>
						<li>
							<a href="${pageContext.request.contextPath}/skill/observer/table.do">중독질환 감시지표</a>
						</li>
						<li>
							<a href="${pageContext.request.contextPath}/skill/bbs/noticeList.do">알림마당</a>
							<ul>
								<li><a href="${pageContext.request.contextPath}/skill/bbs/noticeList.do">공지사항</a></li>
								<li><a href="#">카드뉴스</a></li>
							</ul>	
							
						</li>
						<li>
							<a href="${pageContext.request.contextPath}/skill/bbs/dataList.do">자료실</a>
						</li>
						<li>
							<a href="${pageContext.request.contextPath}/skill/customer/faqList.do">중독상담</a>
							<ul>
								<li><a href="${pageContext.request.contextPath}/skill//customer/faqList.do">FAQ</a></li>
								<li><a href="${pageContext.request.contextPath}/skill/customer/qnaForm.do">1:1 문의하기</a></li>
							</ul>	
						</li>
					</ul>	
				</div><!-- gbWrap -->
			</div><!-- container -->
		</div><!-- gnbBot -->
	</div><!-- gnb -->

