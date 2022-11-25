<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
</script>
</head>
<body>
	<div class="mt20 ml20">연계기관 정보와 로그조회/출력 기능을 제공합니다.</div>

	<table class="tbl tbl_form">
		<colgroup>
			<col width="10%">
			<col width="40%">
			<col width="10%">
			<col width="40%">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">연계코드</th>
				<td colspan="3">${eo.batchCd}</td>
			</tr>
			<tr>
				<th scope="row">연계데이터</th>
				<td colspan="3">${eo.batchNm}</td>
			</tr>
			<tr>
				<th scope="row">수집상태</th>
				<td>${eo.batchResult}</td>
				<th scope="row">건수</th>
				<td>10건</td>
			</tr>
			<tr>
				<th scope="row">실행일</th>
				<td colspan="3">${eo.executDe}</td>
			</tr>
			<tr>
				<th scope="row" colspan="4">로그</th>
			</tr>
			<tr>
				<td colspan="4" class="p20">
					<div class="w100p h600" style="overflow-y:auto">${eo.mssage}</div>
				</td>
			</tr>
		</tbody>
	</table>


	<div class="btn_wrap">
		<div class="fl txt_left"></div>
		<div class="fr txt_right">
			<a href="list.do" class="btn normal black mr10">목록</a>
		</div>
	</div>
</body>
</html>
