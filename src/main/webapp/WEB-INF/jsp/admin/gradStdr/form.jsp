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
				alert('저장 되었습니다');
	
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
		$('#gradStdrLayer').hide();
		
		e.preventDefault();
		return false;			
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('#frm').ajaxCwma({
			beforeValid:false,
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+this.applcDe+'</td>';
					html += '<td>'+this.rgstNm+'</td>';
					html += '<td>'+this.grad1.formatMoney()+'</td>';
					html += '<td>'+this.grad2.formatMoney()+'</td>';
					html += '<td>'+this.grad3.formatMoney()+'</td>';
					html += '<td>'+this.grad4.formatMoney()+'</td>';
					html += '</tr>';
				});
				
				if(!res.list || !res.list.length)
					alert('변경이력이 없습니다');
				else{
					$('#result').html(html);
					
					cwma.showMask();
					$('#gradStdrLayer').css("top",(($(window).height() - $('#gradStdrLayer').outerHeight()) / 2) + $(window).scrollTop());
					$('#gradStdrLayer').css("left",(($(window).width() - $('#gradStdrLayer').outerWidth()) / 2) + $(window).scrollLeft());
					
					if($('.right_cont .layerpop')[0]){
						$('#gradStdrLayer').draggable();
						$('body').append($('.right_cont .layerpop'));
					}
					
			        $('#gradStdrLayer').show();
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
					<th scope="row" colspan="4" class="txt_center">등급별 경력연수</th>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>초급</th>
					<td>
						<input type="text" name="grad1" title="초급" class="w50p" value="${eo.grad1}" money required maxlength="10"/> 년 이상
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>중급</th>
					<td>
						<input type="text" name="grad2" title="중급" class="w50p" value="${eo.grad2}" money required maxlength="10" /> 년 이상
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>고급</th>
					<td>
						<input type="text" name="grad3" title="고급" class="w50p" value="${eo.grad3}" money required maxlength="10" /> 년 이상
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>특급</th>
					<td>
						<input type="text" name="grad4" title="특급" class="w50p" value="${eo.grad4}" money required maxlength="10" /> 년 이상
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="4" class="txt_center">환산기준</th>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>활용직종</th>
					<td><input type="text" name="useJssfc" title="활용직종" class="w50p" value="${eo.useJssfc}" money required maxlength="10" /> %</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>기타직종</th>
					<td><input type="text" name="etcJssfc" title="기타직종" class="w50p" value="${eo.etcJssfc}" money required maxlength="10" /> %</td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="insert.do" class="btn normal green mr10 btnSubmit"><i class="far fa-save mr5"></i> 저장</a>
			</div>
		</div>
	</form>
	
	<div id="gradStdrLayer" class="layerpop" style="width: 900px; height: 500px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">변경이력</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<table class="tbl tbl_data">
					<colgroup>
						<col width="">
						<col width="16%">
						<col width="16%">
						<col width="16%">
						<col width="16%">
						<col width="16%">
					</colgroup>
					<thead>
						<tr>
							<th scope="row" rowspan="2">적용일자</th>
							<th scope="row" rowspan="2">담당자</th>
							<th scope="row" colspan="4">등급별 경력연수</th>
						</tr>
						<tr>
							<th scope="row">초급</th>
							<th scope="row">중급</th>
							<th scope="row">고급</th>
							<th scope="row">특급</th>
						</tr>
					</thead>
					<tbody id="result">
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
