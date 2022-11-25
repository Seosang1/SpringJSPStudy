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

		<div id="subTop" class="bg02">
			<div class="container">
				<h2 class="subTitle">독성물질 정보제공</h2>
			</div>
			<div class="subNav">
				<div class="container">
					<ul>
						<li>홈</li>
						<li>독성물질 정보제공</li>
						<li>독성물질 정보 검색조건</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">독성물질 정보 검색조건</h4>

				<ul class="subTab col6">
					<li><a href="${pageContext.request.contextPath}/skill/poison/search.do">전체</a></li>
					<li><a href="${pageContext.request.contextPath}/skill/poison/material.do" class="on">화학물질</a></li>
					<li><a href="${pageContext.request.contextPath}/skill/poison/product.do">화학제품</a></li>
					<li><a href="${pageContext.request.contextPath}/skill/poison/medical.do">의약품</a></li>
					<li><a href="${pageContext.request.contextPath}/skill/poison/farm.do">농약</a></li>
					<li><a href="${pageContext.request.contextPath}/skill/poison/live.do">동 · 식물</a></li>
				</ul><!-- subTab -->
				
				<form>
					<div class="dsSch">
						<div class="dssInr">
							<input type="text" name="dsSch" id="dsSch" />
							<label for="dsSch" class="hidden">검색어 입력</label>
							<ul class="dssBtn">
								<li><a href="#" class="txsSch"><span>검색</span></a></li>
								<li><a href="#" class="txsRst"><span>초기화</span></a></li>
							</ul>
						</div>
					</div><!-- dsSch -->
				</form>

				<div class="txrTitle">
					<h5>화학물질등 정보 검색</h5>
					<p>단어나 문장 특정 성분 검색을 원하실 경우 검색 조건을 설정하여 검색해 주세요</p>
				</div>

				<div class="txRst over">
					<table class="txrTb">
						<caption>화학물질 - No, 국문물질명, 영문물질명, 요약, 독성효과, 증상, 응급 처치, 경구, 경피, 흡입, 안구, 기타</caption>
						<colgroup>
							<col style="width: 50px;">
							<col style="width: 140px;">
							<col style="width: 140px;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
							<col style="width: auto;">
						</colgroup>
						<thead>
							<tr>
								<th>No <button class="txAlgn">정렬</button></th>
								<th>국문물질명</th>
								<th>영문물질명</th>
								<th>요약</th>
								<th>독성효과</th>
								<th>증상</th>
								<th>응급 처치</th>
								<th>경구</th>
								<th>경피</th>
								<th>흡입</th>
								<th>안구</th>
								<th>기타</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>120</td>
								<td>과산화수소</td>
								<td>Hydrogen peroxide</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
							</tr>
							<tr>
								<td>120</td>
								<td>과산화수소</td>
								<td>Hydrogen peroxide</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
							</tr>
							<tr>
								<td>120</td>
								<td>과산화수소</td>
								<td>Hydrogen peroxide</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
							</tr>
							<tr>
								<td>120</td>
								<td>과산화수소</td>
								<td>Hydrogen peroxide</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
								<td>데이터들어가는곳입니다<br/>데이터들어가는곳입니다</td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="paging">
					<a href="#" class="prev">이전</a>
					<ul>
						<li><a href="#">1</a></li>
						<li><a href="#" class="on">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
						<li><a href="#">5</a></li>
					</ul>
					<a href="#" class="next">다음</a>
				</div><!-- paging -->


			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</body>
</html>
