<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
		//전화번호 세팅
		$($('[name="moblphonNo"]').val().split('-')).each(function(i){
			$('[name="phone"]:eq('+i+')').val(this);
		});
		
		//목록버튼 이벤트
		$('.btnList').click(function(e){
			location.href = $(this).attr('href');
			e.preventDefault();
			return false;
		});
		
		//발송버튼 이벤트
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					$('[name="moblphonNo"]').val($('[name="phone"]').get().map(function(o){return o.value;}).join('-'));
					return confirm(txt+'하시겠습니까?');
					
				}, success:function(res){
					alert(txt+'되었습니다');
					$('.btnList').click();
				}
			});
			e.preventDefault();
			return false;
		});
		
		//구분 변경이벤트
		$('[name="se"]').change(function(){
			var val = $(this).val();
			$(this).children().each(function(){
			    if($(this).val() == val)
					$('[name="cn"]').val($(this).data('dc'));
			});
		});
	});
</script>
</head>
<body>
	<form action="insert.do" id="frm" method="post">
		<input type="hidden" name="moblphonNo" title="수신번호" value="${eo.moblphonNo }"/>
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>수신번호</th>
					<td colspan="3">
						<input type="text" class="w30p" name="phone" maxlength="3" value="" hasnext required /> - 
						<input type="text" class="w30p" name="phone" maxlength="4" value="" hasnext required /> -
						<input type="text" class="w30p" name="phone" maxlength="4" value="" required />
					</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td>
						<select class="w60p" name="se" required title="구분">
							<option value="">전체</option>
						<c:forEach var="ceo" items="${seList}">
							<option value="${ceo.cdId}" data-dc="${ceo.cdDc}" ${eo.se eq ceo.cdId?'selected':'' }>${ceo.cdNm}</option>
						</c:forEach>
						</select>
					</td>
					<th scope="row">상태</th>
					<td>
						<select class="w60p" name="sttus" required title="상태">
							<option value="">전체</option>
						<c:forEach var="ceo" items="${sttusList}">
							<c:choose>
								<c:when test="${!empty eo.sttus }">
									<option value="${ceo.cdId}" ${eo.sttus eq ceo.cdId?'selected':'' }>${ceo.cdNm}</option>
								</c:when>
								<c:otherwise>
									<option value="${ceo.cdId}" ${'SSST0002' eq ceo.cdId?'selected':'' }>${ceo.cdNm}</option>
								</c:otherwise> 
							</c:choose>
						</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">내용</th>
					<td colspan="3" class="p10">
						<textarea class="w100p" name="cn" title="내용" required style="height:150px">${eo.cn }</textarea>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="#" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i>${!empty eo?'재':''}발송</a>
				<a href="list.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
</body>
</html>
