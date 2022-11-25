<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
</head>
<body>

<div id="wrap">

	<div id="contents">
		
		<div class="mainCont">
			<div class="mcSldr">
				<div class="mcBg">
					<div style="background: url('${pageContext.request.contextPath}/static/skill/img/main/main_content_bg01.jpg')no-repeat center center;"></div>
					<div style="background: url('${pageContext.request.contextPath}/static/skill/img/main/main_content_bg02.jpg')no-repeat center center;"></div>
				</div><!-- mcBg -->
				<div class="container">
					<div class="mcTitle">
						<div class="mctCont">
							<h6>서울시 독성물질 중독관리센터</h6>
							<h5>Seoul <span class="red">Poison</span><br/>Control Center</h5>
							<p>화학사고를 일으키는 화학물질 정보와 물질별 사고대응, <br/>응급처치 방법에 대해 알아보세요.</p>
						</div>
						<div class="mctCont wh">
							<h6>서울시 독성물질 중독관리센터</h6>
							<h5>Seoul <span>Poison</span><br/>Control Center</h5>
							<p>화학사고를 일으키는 화학물질 정보와 물질별 사고대응, <br/>응급처치 방법에 대해 알아보세요.</p>
						</div>
					</div><!-- mcTitle -->
				</div>
			</div>
			<div class="container">				
				<div class="mcWrap">
					<div class="mcBox">
						<div class="mcSch">
							<div class="mscTitle">
								<h5>독성물질 정보 검색</h5>
								<p>독성물질 정보에 대해 검색해보세요.</p>
							</div>
							<form action="">
							<div class="mscForm">
								<input type="text" name="" id="" placeholder="독성물질 정보에 대해 검색해보세요."/>
								<a href="#">검색하기</a>
							</div>
							</form>
							<dl class="mscRcm">
								<dt>인기검색어</dt>
								<dd>
									<ul>
										<li><a href="#">#포름알데히드</a></li>
										<li><a href="#">#과산화수소</a></li>
										<li><a href="#">#일염화황</a></li>
										<li><a href="#">#벤젠</a></li>
										<li><a href="#">#카페인</a></li>
									</ul>
								</dd>
							</dl>
						</div><!-- mcSch -->
					</div><!-- mcBox -->
					<div class="mcBox">
						<div class="mcQck">
							<ul>
								<li><a href="#">독성물질정보제공</a></li>
								<li><a href="#">중독사고감시체계​</a></li>
								<li><a href="#">중독상담</a></li>
							</ul>
						</div><!-- mcQck -->
					</div><!-- mcBox -->
					<div class="mcBox">
						<div class="mcCmt">
							<div class="mccTab">
								<ul>
									<li><a onclick="mccTab(this, '01');" class="on">공지사항</a></li>
									<li><a onclick="mccTab(this, '02');">자료실</a></li>
									<li><a onclick="mccTab(this, '03');">카드뉴스</a></li>
								</ul>
								<a href="#" class="mccMore">더보기</a>
							</div><!-- mccTab -->
							<div class="mccCont" id="mcc01" style="display: block;">
								<ul class="mccList">
									<c:forEach var="eo" items="${noticeList}">
										 <c:set var = "string1" value = "${fn:substring(eo.rgstDt, 0, 10)}" />
										<li><a href="${pageContext.request.contextPath}/skill/bbs/noticeView.do?sn=${eo.sn }"><p>${eo.sj }<span>${string1 }</span></p></a></li>
									</c:forEach>
								</ul>
							</div><!-- mccCont -->
							<div class="mccCont" id="mcc02">
								<ul class="mccList">
									<c:forEach var="eo" items="${dataList}">
										 <c:set var = "string2" value = "${fn:substring(eo.rgstDt, 0, 10)}" />
										<li><a href="${pageContext.request.contextPath}/skill/bbs/dataView.do?sn=${eo.sn }"><p>${eo.sj }<span>${string2 }</span></p></a></li>
									</c:forEach>
								</ul>
							</div><!-- mccCont -->
							<div class="mccCont" id="mcc03">
								<div class="mccCard">
									<a href="#" style="background: url('${pageContext.request.contextPath}/static/skill/img/main/main_card_sample.jpg')no-repeat center center;"></a>
								</div>
							</div><!-- mccCont -->
						</div><!-- mcCmt -->
					</div><!-- mcBox -->
				</div><!-- mcWrap -->
			</div><!-- container -->
		</div><!-- mainCont -->

		<div class="mainCnt">
			<div class="container">
				<ul>
					<li>
						<h5 class="timer count-title count-number" data-to="${qnaCnt }" data-speed="1500">0</h5>
						<p>콜센터 누적 상담건수</p>
					</li>
					<li>
						<h5 class="timer count-title count-number" data-to="${vsitCntTotal }" data-speed="1500">0</h5>
						<p>누적 방문수</p>
					</li>
					<li>
						<h5 class="timer count-title count-number" data-to="${vsitCntToday }" data-speed="1500">0</h5>
						<p>방문자 수</p>
					</li>
				</ul>
			</div>
		</div><!-- mainCnt -->

		<div class="mainFmy">
			<div class="container">
				<div class="mfSldr">
					<c:forEach var="eo" items="${bannerList1}">
						<div><img src="${pageContext.request.contextPath}/common/download.do?fileSn=${eo.fileVO.fileSn }&parntsSe=${eo.fileVO.parntsSe }&parntsSn=${eo.fileVO.parntsSn}" alt="${eo.imageDc}"></div>
					</c:forEach>
				</div>
			</div>
		</div><!-- mainFmy -->
		
	</div><!-- contents -->


</div><!-- wrap -->
<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/jquery-2.2.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/slick.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/count.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/jquery.waypoints.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/skill/js/main.js"></script>
</body>
</html>
