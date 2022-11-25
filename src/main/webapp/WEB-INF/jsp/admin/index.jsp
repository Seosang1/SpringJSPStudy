<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
	});
</script>
</head>
<body>

	<!--home-->
	<!---------- Left-------------->
	<div class="home_content_70 fl">
		<div class="home_content_outbox bg-white">
			<div class="title">
				<span class="h2tit"><i class="fas fa-align-justify mr5"></i> 공지사항</span>
				<div class="fr txt_right"><a href="${pageContext.request.contextPath}/admin/bbs/noticeList.do"><i class="fas fa-plus"></i></a></div>
			</div>
			<table class="tbl tbl_data">
				<colgroup>
					<col>
					<col style="width: 15%;">
				</colgroup>
				<tbody>
				<c:forEach var="list" items="${noticeList}">
					<tr>
						<td class="txt_left pl20"><a href="${pageContext.request.contextPath}/admin/bbs/noticeForm.do?sn=${list.sn }">${list.sj }</a></td>
						<td class="txt_center" date>${list.rgstDt }</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
	<!---------- //Left-------------->
	
	<!---------- Right-------------->
	<div class="home_content_30 fr">
		<!--온라인상담-->
		<div class="home_content_outbox">
			<div class="title">
				<span class="h2tit"><i class="far fa-address-card mr5"></i> 온라인상담</span>
				<div class="fr txt_right"><a href="${pageContext.request.contextPath}/admin/bbs/qnaList.do"><i class="fas fa-plus"></i></a>
				</div>
			</div>
			<table class="tbl tbl_data">
				<colgroup>
					<col style="width: 25%;" />
					<col style="width: 25%;" />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">답변대기</th>
						<th scope="col"><span>답변완료</span></th>
						<th scope="col"><span>전체</span></th>
					</tr>
				</thead>
				<tbody>
					<tr class="bg-white">
						<td class="txt_center brd-btm-1p">
							<em class="em.bold" money=" 건">${qnaCnt.notAnswerCnt}</em>
						</td>
						<td class="txt_center brd-btm-1p">
							<em class="em.bold" money=" 건">${qnaCnt.answerCnt}</em>
						</td>
						<td class="txt_center brd-btm-1p">
							<em class="em.bold" money=" 건">${qnaCnt.totalCnt}</em>
						</td>
					</tr>
				</tbody>
			</table>
		</div>
		<!--//온라인상담-->
		<!--방문자-->
		<div class="home_content_outbox">
			<div class="title">
				<span class="h2tit"><i class="far fa-user mr5"></i> 방문자</span>
				<div class="fr txt_right"><a href="${pageContext.request.contextPath}/admin/userInfo/personalList.do"><i class="fas fa-plus"></i></a></div>
			</div>
			<table class="tbl tbl_data">
				<colgroup>
					<col style="width: 30%;" />
					<col />
				</colgroup>
				<thead>
					<tr>
						<th scope="col">오늘</th>
						<th scope="col">
							<span class="txt_right pr10" money>${vsitCntToday}</span>
						</th>
					</tr>
					<tr>
						<th class="brd-btm-1p" scope="col">누적</th>
						<th class="brd-btm-1p" scope="col">
							<span class="txt_right pr10" money>${vsitCntTotal}</span>
						</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_data">
				<colgroup>
					<col style="width: 30%;" />
					<col />
				</colgroup>
				<thead>
				<c:forEach var="list" items="${loginSeCnt }">
					<tr>
						<th scope="col">${list.seNm }</th>
						<th class="bg-white" scope="col">
							<span class="txt_right pr10" money>${list.cnt }</span>
						</th>
					</tr>
				</c:forEach>
				</thead>
			</table>
		</div>
		<!--//방문자-->
	</div>
	<!---------- //Right-------------->
	<!--//home-->

</body>
</html>
