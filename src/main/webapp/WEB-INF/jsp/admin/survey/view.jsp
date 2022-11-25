<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	//초기화
	$(function(){
		//참여자수 및 분포도 산출
		$('.exTr').each(function(){
			var cnt = 0;
			var len = $('em.bold').length;
			
			cnt = eval($('.exTr em.bold').text().replace(/명/g, '+')+'0');
			
			$('em.bold').each(function(){
				var per = Math.floor((Number($(this).text().replace(/[\D]/g, ''))/cnt)*10000)/100;
				$(this).parent().prev().find('span').css('width', per+'%');
				$(this).next().text('('+per+'%)');
			});
		});
	});
	
	//이벤트
	$(function(){
		//엑셀다운로드
		$('.btnExcel').click(function(e){
			if($('.totalCnt').text().replace(/[\D]/g,'') != '0')
				cwma.showExcelPop('/admin/survey/excelDown.do?surveySn=${eo.surveySn}', false);
			else
				alert('참여자가 없습니다.');
			
			e.preventDefault();
			return false;
		});
	});
</script>
</head>
<body>
	<div class="data_wrap">

		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="30%" />
				<col width="10%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">제목</th>
					<td colspan="4">${eo.sj}</td>
				</tr>
				<tr>
					<th scope="row">설명</th>
					<td colspan="4" class="h200">${eo.cn}</td>
				</tr>
				<tr>
					<th scope="row">설문조사기간</th>
					<td>${eo.bgnde} ~ ${eo.endde}</td>
					<th scope="row">상태</th>
					<td colspan="2">${eo.useAt eq 'Y'?'사용':'미사용'}</td>
				</tr>
				<tr>
					<th scope="row">참여자수</th>
					<td colspan="4">${eo.answrrCnt }</td>
				</tr>
		<c:forEach items="${eo.itmVO}" var="itmEO">
			<c:if test="${itmEO.ty eq 'SQTY0001' or itmEO.ty eq 'SQTY0002'}">
				<tr>
					<th scope="row">문항 제목</th>
					<td colspan="4">${itmEO.sj}</td>
				</tr>
				<tr>
					<th scope="row">문항 설명</th>
					<td colspan="4" class="h200">${itmEO.cn}</td>
				</tr>
				<tr class="exTr">
					<th scope="row">유형</th>
					<td colspan="4">
					<c:forEach items="${itmEO.exVO}" var="exEO" varStatus="exSts">
						<div class="mt10 ${exSts.last?'mb10':'' }">
							<span class="spib w40p" style="display: inline-block;">${empty exEO.cn?'기타':exEO.cn}</span>
							<span class="spib w40p">
								<span style="width: 0%; height: 20px; display: inline-block; background-color: #ffac49"></span>
							</span>
							<span class="spib w10p">
								<em class="bold" money="명">${exEO.answerCnt}</em>
								<span>(0%)</span>
							</span>
						</div>
					</c:forEach>
					</td>
				</tr>
			</c:if>
		</c:forEach>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="txt_center mt20">
				<a href="list.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr20"></i> 목록</a>
				<a href="#" class="btn normal green btnExcel"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>
	</div>
</body>
</html>
