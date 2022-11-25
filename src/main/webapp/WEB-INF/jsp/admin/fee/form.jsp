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
	$('.btnSubmit').click(function(e){
		var txt = $(this).text();
		$('#frm').attr('action', $(this).attr('href'));
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				$('[money]').each(function(){
					$(this).val($(this).val().replace(/[,]/g, ''));
				});
			}, success:function(res){
				alert('수정 되었습니다');
	
			}, complete:function(){
				$('[money]').each(function(){
					$(this).val($(this).val().formatMoney());
				});
			}
		});
		e.preventDefault();
		return false;
	});
	
	//변경이력버튼 클릭이벤트
	$('.btnList').click(function(e){
		$('#frm').attr('action', 'list.do');
		ajaxList(1);
		e.preventDefault();
		return false;
	});
	
	//팝업닫기 버튼 클릭이벤트
	$('.layerpop_close, .btnClose').click(function(e){
		cwma.hideMask();
		$('#feeLayer').hide();
		
		e.preventDefault();
		return false;			
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<td>'+this.applcDe+'</td>';
					html += '<td>'+this.rgstNm+'</td>';
					html += '<td>'+this.frst.formatMoney()+'</td>';
					html += '<td>'+this.grad.formatMoney()+'</td>';
					html += '<td>'+this.gradOnline.formatMoney()+'</td>';
					html += '<td>'+this.hold.formatMoney()+'</td>';
					html += '<td>'+this.holdOnline.formatMoney()+'</td>';
				});
				
				if(!res.list || !res.list.length)
					alert('변경이력이 없습니다');
				else{
					$('#result').html(html);
					
					cwma.showMask();
					$('#feeLayer').css("top",(($(window).height() - $('#feeLayer').outerHeight()) / 2) + $(window).scrollTop());
					$('#feeLayer').css("left",(($(window).width() - $('#feeLayer').outerWidth()) / 2) + $(window).scrollLeft());
					
					if($('.right_cont .layerpop')[0]){
						$('#feeLayer').draggable();
						$('body').append($('.right_cont .layerpop'));
					}
					
			        $('#feeLayer').show();
				}
			}
		});
	};
});
</script>
</head>
<body>
	<form action="" id="frm" method="post">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="15%" />
				<col width="" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>적용일</th>
					<td>
						<div class="input_date">
							<input type="text" name="applcDe" title="적용일" class="datepicker" style="width:105px;" value="${eo.applcDe}" required date/>
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<button type="button" class="btn btn_form mr10 btnList">변경이력</button>
					</td>
				</tr>

				<tr>
					<th scope="row" colspan="4" class="txt_center">기능등급증명서</th>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>최초발급</th>
					<td>
						<input type="text" name="frst" title="최초" class="w50p" value="${eo.frst}" money required/>
						※최초출력은 기능인 생애최초 1매 발급에 한함
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>방문발급</th>
					<td><input type="text" name="grad" title="방문발급-기능등급증명서" class="w50p" value="${eo.grad}" money required maxlength="10" /></td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>온라인발급</th>
					<td><input type="text" name="gradOnline" title="온라인발급-기능등급증명서" class="w50p" value="${eo.gradOnline}" money required maxlength="10" /></td>
				</tr>
				<tr>
					<th scope="row" colspan="4" class="txt_center">보유증명서</th>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>방문발급</th>
					<td><input type="text" name="hold" title="방문발급-보유증명서" class="w50p" value="${eo.hold}" money required maxlength="10" /></td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>온라인발급</th>
					<td><input type="text" name="holdOnline" title="온라인발급-보유증명서" class="w50p" value="${eo.holdOnline}" money required maxlength="10" /></td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="insert.do" class="btn normal green mr10 btnSubmit"><i class="far fa-edit mr5"></i> 수정</a>
			</div>
		</div>
	</form>
	
	<div id="feeLayer" class="layerpop" style="width: 900px; height: 500px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">변경이력</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<table class="tbl tbl_data">
					<colgroup>
						<col width="">
						<col width="14%">
						<col width="14%">
						<col width="14%">
						<col width="14%">
						<col width="14%">
						<col width="14%">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row" rowspan="2">적용일자</th>
							<th scope="row" rowspan="2">담당자</th>
							<th scope="row" colspan="3">기능등급증명서</th>
							<th scope="row" colspan="2">보유증명서</th>
						</tr>
						<tr>
							<th scope="row">최초</th>
							<th scope="row">방문</th>
							<th scope="row">온라인</th>
							<th scope="row">방문</th>
							<th scope="row">온라인</th>
						</tr>
						<tr id="result">
						</tr>
					</tbody>
				</table>
				
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 닫기</a>
					</div>
				</div>

			</div>
		</div>
	</div>
</body>
</html>
