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
					<li><a href="${pageContext.request.contextPath}/skill/poison/search.do" class="on">전체</a></li>
					<li><a href="${pageContext.request.contextPath}/skill/poison/material.do">화학물질</a></li>
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
					<h5>화학물질</h5>
				</div>

				<div class="txRst">
					<table class="txrTb">
						<caption>화학물질 - No, 국문물질명, 영문물질명, 요약, 독성효과, 증상, 응급 처치, 경구, 경피, 흡입, 안구, 기타</caption>
						<colgroup>
							<col style="width: 50px;">
							<col style="width: 120px;">
							<col style="width: 120px;">
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
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="txMore">
					<a href="#"><em></em><span>더보기</span></a>
				</div>


				<div class="txrTitle">
					<h5>화학제품</h5>
				</div>

				<div class="txRst">
					<table class="txrTb">
						<caption>화학제품 - No, 제품명 국문, 제품명 영문, 제품분류명, GHS 그림문자, GHS 유해위험문구, 표준사용량, 사용상주의사항</caption>
						<colgroup>
							<col style="width: 50px;">
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
								<th>제품명 국문</th>
								<th>제품명 영문</th>
								<th>제품분류명</th>
								<th>GHS 그림문자</th>
								<th>GHS 유해위험문구</th>
								<th>표준사용량</th>
								<th>사용상주의사항</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="txMore">
					<a href="#"><em></em><span>더보기</span></a>
				</div>


				<div class="txrTitle">
					<h5>의약품</h5>
				</div>

				<div class="txRst">
					<table class="txrTb">
						<caption>의약품 - No, 제품명, 이미지, 유효성분, 문항1(효능), 문항2(사용법), 문항4(주의사항), 문항6(부작용), 금기내용, 문항3(주의사항경고)</th></caption>
						<colgroup>
							<col style="width: 50px;">
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
								<th>제품명</th>
								<th>이미지</th>
								<th>유효성분</th>
								<th>문항1(효능)</th>
								<th>문항2(사용법)</th>
								<th>문항4(주의사항)</th>
								<th>문항6(부작용)</th>
								<th>금기내용</th>
								<th>문항3(주의사항경고)</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="txMore">
					<a href="#"><em></em><span>더보기</span></a>
				</div>


				<div class="txrTitle">
					<h5>농약</h5>
				</div>

				<div class="txRst">
					<table class="txrTb">
						<caption>농약 - No, 상표명, 일반명(한글), 일반명(영문), 품목명, 용도, 주성분, 주성분함량, 독성구분코드, 어독성</caption>
						<colgroup>
							<col style="width: 50px;">
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
								<th>상표명</th>
								<th>일반명(한글)</th>
								<th>일반명(영문)</th>
								<th>품목명</th>
								<th>용도</th>
								<th>주성분</th>
								<th>주성분함량</th>
								<th>독성구분코드</th>
								<th>어독성</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>2</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>3</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>4</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>5</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>6</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>7</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>8</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="txMore">
					<a href="#"><em></em><span>더보기</span></a>
				</div>


				<div class="txrTitle">
					<h5>동식물</h5>
				</div>

				<div class="txRst">
					<table class="txrTb">
						<caption>동식물 - No, 국문물질명, 이미지, 임상서론, 독성동력학, 급성 중독시 임상양상, 만성중독시 임상양상, 중독 현장 및 응급실 처치</caption>
						<colgroup>
							<col style="width: 50px;">
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
								<th>이미지</th>
								<th>임상서론</th>
								<th>독성동력학</th>
								<th>급성 중독시 임상양상</th>
								<th>만성중독시 임상양상</th>
								<th>중독 현장 및 응급실 처치</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
							<tr>
								<td>120</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
								<td>항목내용<br/>항목내용</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="txMore">
					<a href="#"><em></em><span>더보기</span></a>
				</div>


			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</body>
</html>
