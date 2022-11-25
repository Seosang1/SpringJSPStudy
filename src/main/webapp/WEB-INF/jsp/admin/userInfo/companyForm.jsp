<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaList;
	
	//기본값 세팅
	$(function(){
		cwmaList = new cwma.list();
		//휴대폰
		$($('[name="moblphonNo"]').val().split('-')).each(function(i){
			$('[name="phone"]:eq('+i+')').val(String(this));
		});
		
		//이메일
		if($('[name="email"]').val().replace('@', '')){
			$('[name="mail"]:eq(0)').val($('[name="email"]').val().split('@')[0]);
			$('[name="mail"]:eq(1)').val($('[name="email"]').val().split('@')[1]);
			$('[name="mail"]:eq(2)').val($('[name="email"]').val().split('@')[1]);
		}
	});
	
	//이벤트
	$(function(){
		//삭제버튼
		$('.btnDel').click(function(e){
			if(!confirm('삭제하시겠습니까?'))
				return false;
			
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					alert('삭제되었습니다');
					location.href='personalList.do';
				}
			});
			e.preventDefault();
			return false;
		});
		
		//수정버튼
		$('.btnUpd').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					$('[name="moblphonNo"]').val($('[name="phone"]').map(function(i, o){return o.value;}).get().join('-'));
					$('[name="email"]').val($('[name="mail"]').map(function(i, o){return o.value;}).get().join('@'));
				},
				success:function(res){
					alert('수정되었습니다');
				}
			});
			e.preventDefault();
			return false;
		});
	});
</script>
</head>
<body>
	<div class="data_wrap">
		<div>
			<form id="frm" action="" method="post">
				<input type="hidden" name="moblphonNo" value="${eo.moblphonNo}" />
				<input type="hidden" name="email" value="${eo.email}" />
				
				<table class="tbl tbl_form mt5">
					<colgroup>
						<col style="width: 10%;">
						<col style="width: 40%;">
						<col style="width: 10%;">
						<col style="width: 40%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">구분</th>
							<td>${eo.seNm}</td>
							<th scope="row">상호명</th>
							<td>${eo.corpInfoVO.corpNm}</td>
						</tr>
						<tr>
							<th scope="row">사업자등록번호</th>
							<td>${eo.bizno}</td>
							<th scope="row">법인등록번호</th>
							<td>${eo.corpInfoVO.corpNo}</td>
						</tr>
						<tr>
							<th scope="row">대표자명</th>
							<td>${eo.corpInfoVO.ceoNm}</td>
							<th scope="row">아이디</th>
							<td>${eo.userId}</td>
						</tr>
						<tr>
							<th scope="row">휴대폰</th>
							<td>
								<input type="text" class="w30p" name="phone" maxlength="3" value="" number /> - 
								<input type="text" class="w30p" name="phone" maxlength="4" value="" number /> -
								<input type="text" class="w30p" name="phone" maxlength="4" value="" number />
							</td>
							<th scope="row">이메일</th>
							<td>
								<input type="text" class="w30p" name="mail" value="">@<input type="text" class="w30p" name="mail" value="">
								<select class="w30p" name="mail">
									<option value="">직접입력</option>
									<option value="naver.com">naver.com</option>
									<option value="hanmail.net">hanmail.net</option>
									<option value="daum.net">daum.net</option>
									<option value="gmail.com">gmail.com</option>
									<option value="nate.com">nate.com</option>
									<option value="hotmail.com">hotmail.com</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">본사소재지</th>
							<td colspan="3">[${eo.zip}] ${eo.adres}</td>
						</tr>
						<tr>
							<th scope="row">가입일시</th>
							<td>${eo.rgstDt }</td>
							<th scope="row">최종로그인</th>
							<td>${eo.lastLoginDt }</td>
						</tr>
					</tbody>
				</table>
		<div class="btn_wrap">
			<div class="fr txt_right">
				<a href="update.do" class="btn normal green mr10 btnUpd"><i class="far fa-edit mr5"></i> 수정</a>
				<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i> 삭제</a>
				<a href="companyList.do" class="btn normal black mr10"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</div>
</body>
</html>
