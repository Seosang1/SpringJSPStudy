<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaFile, namoCrossUploader;
	
	$(function(){
		cwmaFile = new CrossDownloader({fileLayer:'fileLayer', parntsSe:'ATCH0001', parntsSn:$('[name="sn"]').val()});
		namoCrossUploader = cwmaFile.crossUploader;
		
		$('.content').html($('.content').text().replace(/\&lt\;/g,'<').replace(/\&gt\;/g,'>'));
		
		//수정버튼 이벤트
		$('.btnForm').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 클릭이벤트
		$('.btnDel').click(function(e){
			if(confirm('삭제하시겠습니까?')){
				$('#frm').attr('action', $(this).attr('href'));
				$('#frm').ajaxCwma({
					success:function(){
						alert('삭제되었습니다');
						$('.btnList').click();
					}
				});
			}
			e.preventDefault();
			return false;
		});
		
		//목록버튼 클릭이벤트
		$('.btnList').click(function(e){
			cwma.queryStringToInput($('[name="queryStr"]').val());
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
	});
</script>
</head>
<body>
	<form action="" id="frm" method="post" enctype="multipart/form-data">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="seqList" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="se" value="BSSE0002" />
		<input type="hidden" name="queryStr" value="${vo.queryStr}" />
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" colspan="4" class="brdtit">${eo.sj}</th>
				</tr>
				<tr>
					<th scope="row">상태</th>
					<td>${empty eo.answer?'대기중':'답변완료'}</td>
					<th scope="row">유형</th>
					<td>${eo.clNm }</td>
				</tr>
				<tr>
					<th scope="row">구분</th>
					<td>${eo.userInfoVO.seNm}</td>
					<th scope="row">아이디</th>
					<td>${eo.rgstId }</td>
				</tr>
				<tr>
					<th scope="row">이메일</th>
					<td money>${eo.userInfoVO.email }</td>
					<th scope="row">등록일</th>
					<td date>${eo.rgstDt }</td>
				</tr>
				<tr>
					<th scope="row">작성자</th>
					<td>${eo.userInfoVO.nm}</td>
					<th scope="row">휴대폰</th>
					<td>${eo.userInfoVO.moblphonNo}</td>
				</tr>
				<tr>
					<td colspan="4" class="p20 content">
						${eo.cn}
					</td>
				</tr>
				<tr>
					<td colspan="4" class="" id="fileLayer">
					</td>
				</tr>
			</tbody>
		</table>
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="100%">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="txt_center">답변</th>
				</tr>
				<tr>
					<td class="p10">
						<textarea class="w100p" name="answer" title="답변" id="editor" required>${eo.answer}</textarea>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="qnaForm.do" class="btn normal green mr10 btnForm"><i class="far fa-edit mr5"></i>수정</a>
				<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
				<a href="qnaForm.do" class="btn normal black mr10 btnList"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
</body>
</html>
