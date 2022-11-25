<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<style type="text/css">
	table{
		margin-top:10px;
	}

	table, input[type="text"]{
		width:100%;
		border-spacing: 0;
	}
	
	th{
		background-color: #f55;
	}
	
	td, th{
		border:1px solid red;
		text-align:center;
	}
	
	#pageDiv a{
		margin: 0 5px;
	}
</style>
<script type="text/javascript">
	$(function(){
		var cwmaList = new cwma.list({useFunc:false});
		cwmaList.setPage({startPage:${vo.startPage}, endPage:${vo.endPage}, numOfPage:${vo.numOfPage}, totalPage:${vo.totalPage}});
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'noticeForm.do');
			$('#frm').append('<input type="hidden" name="seq" value="'+$(this).data('seq')+'" />');
			$('#frm').submit();
		});
		
	});
</script>
</head>
<body>
	<form action="pageList.do" id="frm" method="post">
		<input type="hidden" name="pageNo" value="1" />
		<input type="hidden" name="numOfPage" value="10" />
		
		<table class="dataInput">
			<colgroup>
				<col style="width: 149px">
				<col>
			</colgroup>
			<tr>
				<th scope="row">조회조건</th>
				<td>
					<select name="searchKey" title="조회조건">
						<option value="">전체</option>
						<option value="title">제목</option>
						<option value="cn">내용</option>
						<option value="rgstId">작성자</option>
					</select>
					<input type="text" name="searchWord" title="검색어" style="width: 900px;">
					<button type="submit" class="big orange">조회</button>
				</td>
			</tr>
		</table>
	</form>

	<table>
		<thead>
			<tr>
				<th>No</th>
				<th>제목</th>
				<th>작성자</th>
				<th>등록일</th>
				<th>공지여부</th>
				<th>노출여부</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="eo" items="${list}">
			<tr>
				<td>${eo.rownum}</td>
				<td style="text-align:left;"><a href="#" class="btnView" data-seq="${eo.seq}">${eo.title}</a></td>
				<td>${eo.rgstNm}</td>
				<td date>${eo.rgstDt}</td>
				<td>${eo.noticeAt}</td>
				<td>${eo.viewAt}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	
	<div id="pageDiv" style="text-align:center">
	</div>
	
	<div class="buttonBox tableFunction">
		<a class="button" href="noticeForm.do">등록</a>
	</div>

</body>
</html>
