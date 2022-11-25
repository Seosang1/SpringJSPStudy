<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
		//수정버튼 이벤트
		$('#btnUpd').click(function(e){
			var txt = $(this).text();
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					alert(txt+'되었습니다');
					$('#btnList').click();
				}
			});
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 이벤트
		$('#btnDel').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					alert('삭제되었습니다');
					$('#btnList').click();
				}
			});
			e.preventDefault();
			return false;
		});
		
		$('#btnList').click(function(e){
			location.href = $(this).attr('href');
		});
	
	});
</script>
</head>
<body>
	<section id="content" class="popup">
		<h1>코드등록</h1>

		<form action="" id="frm" method="post">
			<input type="hidden" name="gParntsCdId" value="CODE0002">
			<table class="dataInput">
				<colgroup>
					<col style="width: 149px">
					<col>
				</colgroup>
				<tr>
					<th scope="row">코드ID</th>
					<td>
					<c:if test="${empty eo }">
						<input type="text" name="cdId" value="${eo.cdId}" title="코드ID">
					</c:if>
					<c:if test="${!empty eo }">
						<input type="hidden" name="cdId" value="${eo.cdId}" title="코드ID">
						${eo.cdId}
					</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">부모코드ID</th>
					<td>
					<c:if test="${empty eo }">
						<input type="text" name="parntsCdId" value="${eo.parntsCdId}" title="부모코드ID">
					</c:if>
					<c:if test="${!empty eo }">
						<input type="hidden" name="parntsCdId" value="${eo.parntsCdId}" title="부모코드ID">
						${eo.parntsCdId}
					</c:if>
					</td>
				</tr>
				<tr>
					<th scope="row">코드명</th>
					<td><input type="text" name="cdNm" value="${eo.cdNm}" title="코드명"></td>
				</tr>
				<tr>
					<th scope="row">코드설명</th>
					<td colspan="5"><textarea name="cdDc" title="코드설명">${eo.cdDc}</textarea></td>
				</tr>
			</table>

			<div class="buttonBox">
				<button type="submit" class="big orange" id="btnUpd" href="${empty eo?'insert':'update'}.do">${empty eo?'등록':'수정'}</button>
				<c:if test="${!empty eo}">
					<button type="submit" class="big orange" id="btnDel" href="delete.do">삭제</button>
				</c:if>
				<button type="button" class="big" id="btnList" href="list.do">목록</button>
			</div>
		</form>
	</section>
</body>
</html>
