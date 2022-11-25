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

		<div id="subTop" class="bg01">
			<div class="container">
				<h2 class="subTitle">센터소개</h2>
			</div>
			<div class="subNav">
				<div class="container">
					<ul>
						<li>홈</li>
						<li>센터소개</li>
						<li>운영안내 및 오시는길</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">운영안내 및 오시는길</h4>
				<h5 class="plnTitle">운영안내</h5>

				<table class="subTb">
					<caption>연도별 운영계획 대상, 이용방법, 상담시간, 이용료, 상담전화, 팩스번호, 야간 및 공휴일, 주말, 이메일 정보제공</caption>
					<colgroup>
						<col style="width: 30%" />
						<col style="width: auto" />
					</colgroup>						
					<tbody>
						<tr>
							<th>전화 상담(헬프콜)</th>
							<td>1855-2221</td>
						</tr>
						<tr>
							<th>대표메일</th>
							<td>seoulpcc@gmail.co</td>
						</tr>
						<tr>
							<th>공식SNS</th>
							<td>
								<ul class="locSns">
									<li><a href="http://pf.kakao.com/_txaups" target="_blank"><img src="/static/skill/img/common/gnb_sns03.png" alt="카카오톡"></a></li>
									<li><a href="https://www.instagram.com/seoulpcc/" target="_blank"><img src="/static/skill/img/common/gnb_sns04.png" alt="인스타그램"></a></li>
									<li><a href="https://www.facebook.com/seoulpcc" target="_blank"><img src="/static/skill/img/common/gnb_sns01.png" alt="페이스북"></a></li>
								</ul>
							</td>
						</tr>
						<tr>
							<th>운영시간</th>
							<td>월-금 / 오전 8:30 – 오후 5:30    ※ 추후 운영시간 확대 시, 홈페이지 공지 예정</td>
						</tr>
					</tbody>
				</table>

				<div class="plnTb">
					<h5 class="plnTitle">운영안내</h5>

					<!--
						* 카카오맵 - 약도서비스
						* 한 페이지 내에 약도를 2개 이상 넣을 경우에는
						* 약도의 수 만큼 소스를 새로 생성, 삽입해야 합니다.
					-->
					<!-- 1. 약도 노드 -->
					<div id="daumRoughmapContainer1638078895098" class="root_daum_roughmap root_daum_roughmap_landing"></div>

					<!-- 2. 설치 스크립트 -->
					<script charset="UTF-8" class="daum_roughmap_loader_script" src="https://ssl.daumcdn.net/dmaps/map_js_init/roughmapLoader.js"></script>

					<!-- 3. 실행 스크립트 -->
					<script charset="UTF-8">
						new daum.roughmap.Lander({
							"timestamp" : "1638078895098",
							"key" : "288oo",
							"mapWidth" : "1120",
							"mapHeight" : "460"
						}).render();
					</script>
				</div>



			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</body>
</html>
