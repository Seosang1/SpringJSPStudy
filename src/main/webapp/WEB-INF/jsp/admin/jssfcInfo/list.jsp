<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
$(function(){
	//저장버튼 이벤트
	$('.btnSubmit').click(function(e){
		var txt = $(this).text();
		$('#frm').attr('action', $(this).attr('href'));
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				$('[name="jssfc"]').each(function(i){
				    $('#frm').append('<input type="hidden" name="JssfcInfoVO['+i+'].jssfcNo" value="'+$(this).data('no')+'" />');
				    $('#frm').append('<input type="hidden" name="JssfcInfoVO['+i+'].jssfcNm" value="'+$(this).data('nm')+'" />');
				    $('#frm').append('<input type="hidden" name="JssfcInfoVO['+i+'].se" value="'+$(this).data('se')+'" />');
				    $('#frm').append('<input type="hidden" name="JssfcInfoVO['+i+'].actvtyAt" value="'+$(this).data('at')+'" />');
				    $('#frm').append('<input type="hidden" name="JssfcInfoVO['+i+'].stdrDaycnt" value="'+$(this).val()+'" />');
				});
			}, success:function(res){
				alert('저장 되었습니다');
	
			}, complete:function(){
				 $('#frm').find('[name^="JssfcInfoVO"]').remove();
			}
		});
		e.preventDefault();
		return false;
	});
	
	//변경이력버튼 클릭이벤트
	$('.btnList').click(function(e){
		ajaxList(1);
		e.preventDefault();
		return false;
	});
	
	//등록버튼 클릭이벤트
	$('.btnForm').click(function(e){
		cwma.showMask();
		$('#jssfcFormLayer').css("top",(($(window).height() - $('#jssfcFormLayer').outerHeight()) / 2) + $(window).scrollTop());
		$('#jssfcFormLayer').css("left",(($(window).width() - $('#jssfcFormLayer').outerWidth()) / 2) + $(window).scrollLeft());
		
		if($('.right_cont .layerpop')[0]){
			$('#jssfcFormLayer').draggable();
			$('body').append($('.right_cont .layerpop'));
		}
		
		$('#frmPop')[0].reset();
		$('.btnAdd').show();
		$('.btnEdit').hide();
        $('#jssfcFormLayer').show();
        
		e.preventDefault();
		return false;
	});
	
	//직종 클릭이벤트
	$('#frm .tbl_form').on('click', '.btnView', function(e){
		var obj = $(this).parent().next().find('input');
		
		//값세팅
		$('#frmPop [name="jssfcNo"]').val(obj.data('no'));
		$('#frmPop [name="jssfcNm"]').val(obj.data('nm'));
		$('#frmPop [name="stdrDaycnt"]').val(obj.val());
		$('#frmPop [name="se"]').prop('checked', false);
		$('#frmPop [name="actvtyAt"]').prop('checked', false);
		$('#frmPop [value="'+obj.data('se')+'"]').prop('checked', true);
		$('#frmPop [name="actvtyAt"]').prop('checked', false);
		$('#frmPop [name="actvtyAt"]').each(function(){
			if($(this).val() == obj.data('at'))
				$(this).prop('checked', true);
		});
		
		cwma.showMask();
		$('#jssfcFormLayer').css("top",(($(window).height() - $('#jssfcFormLayer').outerHeight()) / 2) + $(window).scrollTop());
		$('#jssfcFormLayer').css("left",(($(window).width() - $('#jssfcFormLayer').outerWidth()) / 2) + $(window).scrollLeft());
		
		if($('.right_cont .layerpop')[0]){
			$('#jssfcFormLayer').draggable();
			$('body').append($('.right_cont .layerpop'));
		}
		
		$('.btnAdd').hide();
		$('.btnEdit').show();
        $('#jssfcFormLayer').show();
		e.preventDefault();
		return false;
	});
	
	//등록버튼 클릭이벤트
	$('.btnAdd').click(function(e){
		if($('#frm .tbl_form tr:last td').length == 2)
			$('#frm .tbl_form').append('<tr></tr>');
			
		var parent = $('#frm .tbl_form tr:last');

		parent.append('<th scope="row"><em class="required">*</em><a href="#" class="btnView">'+$('#frmPop [name="jssfcNm"]').val()+'</a></th>');
		parent.append('<td><input type="text" name="jssfc" title="'+$('#frmPop [name="jssfcNm"]').val()+'" class="w80p" value="'+$('#frmPop [name="stdrDaycnt"]').val()+'" data-nm="'+$('#frmPop [name="jssfcNm"]').val()+'" data-no="'+($('[name="jssfc"]:last').data('no')+1)+'" data-se="'+$('#frmPop [name="se"]:checked').val()+'" data-at="'+$('#frmPop [name="actvtyAt"]:checked').val()+'" required maxlength="10"/>일</td>');
		$('.layerpop_close').click();
		e.preventDefault();
		return false;
	});
	
	//수정버튼 클릭이벤트
	$('.btnEdit').click(function(e){
		var obj = $('#frm [data-no="'+$('#frmPop [name="jssfcNo"]').val()+'"]');
		obj.data('no', $('#frmPop [data="jssfcNo"]').val());
		obj.data('nm', $('#frmPop [name="jssfcNm"]').val());
		obj.val($('#frmPop [name="stdrDaycnt"]').val());
		obj.data('se', $('#frmPop [name="se"]:checked').val());
		obj.data('at', $('#frmPop [name="actvtyAt"]:checked').val());
		$('.layerpop_close').click();
		e.preventDefault();
		return false;
	});
	
	//팝업닫기 버튼 클릭이벤트
	$('.layerpop_close, .btnClose').click(function(e){
		cwma.hideMask();
		$('#jssfcHistLayer').hide();
		$('#jssfcFormLayer').hide();
		
		e.preventDefault();
		return false;			
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'histList.do');
		$('#frm').ajaxCwma({
			beforeValid:false,
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>'
					html += '<td>'+this.applcDe+'</td>';
					html += '<td>'+this.rgstNm+'</td>';
					html += '</tr>'
				});
				
				if(!res.list || !res.list.length)
					alert('변경이력이 없습니다');
				else{
					$('#result').html(html);
					
					cwma.showMask();
					$('#jssfcHistLayer').css("top",(($(window).height() - $('#jssfcHistLayer').outerHeight()) / 2) + $(window).scrollTop());
					$('#jssfcHistLayer').css("left",(($(window).width() - $('#jssfcHistLayer').outerWidth()) / 2) + $(window).scrollLeft());
					
					if($('.right_cont .layerpop')[0]){
						$('#jssfcHistLayer').draggable();
						$('body').append($('.right_cont .layerpop'));
					}
					
			        $('#jssfcHistLayer').show();
				}
			}
		});
	};
	
	//팝업닫기 버튼 클릭이벤트
	$('.btnTab').click(function(e){
		location.href = $(this).attr('href');
		e.preventDefault();
		return false;			
	});
});
</script>
</head>
<body>

	<div class="search_wrap">
		<ul class="tab200">
			<li class="on">직종</li>
			<li class="btnTab" href="../careerStdr/form.do?se=CSSE0001">자격증</li>
			<li class="btnTab" href="../careerStdr/form.do?se=CSSE0003">교육</li>
			<li class="btnTab" href="../careerStdr/form.do?se=CSSE0002">포상</li>
		</ul>
	</div>

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
							<input type="text" name="applcDe" title="적용일" class="datepicker" style="width:105px;" value="${list[0].applcDe}" required date/>
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<button type="button" class="btn btn_form mr10 btnList">변경이력</button>
					</td>
				</tr>

				<tr>
					<th scope="row" colspan="4" class="txt_center">기능등급직종</th>
				</tr>
				<tr>
				<c:forEach var="eo" items="${list }" varStatus="sts">
					<th scope="row"><em class="required">*</em><a href="#" class="btnView">${eo.jssfcNm }</a></th>
					<td>
						<input type="text" name="jssfc" title="${eo.jssfcNm }" class="w80p" value="${eo.stdrDaycnt}" data-nm="${eo.jssfcNm }" data-no="${eo.jssfcNo }" data-se="${eo.se }" data-at="${eo.actvtyAt }" required maxlength="10"/>일
					</td>
					<c:if test="${sts.count % 2 eq 0}">
						</tr>
						<tr>
					</c:if>
				</c:forEach>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="insert.do" class="btn normal green mr10 btnSubmit"><i class="far fa-save mr5"></i> 저장</a>
				<a href="#" class="btn normal green mr10 btnForm"><i class="far fa-edit mr5"></i> 등록</a>
			</div>
		</div>
	</form>
	
	<div id="jssfcHistLayer" class="layerpop" style="width: 500px; height: 500px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">변경이력</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<table class="tbl tbl_data">
					<colgroup>
						<col width="50%">
						<col width="50%">
					</colgroup>
					<thead>
						<tr>
							<th scope="row">적용일자</th>
							<th scope="row">담당자</th>
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
	
	<div id="jssfcFormLayer" class="layerpop" style="width: 900px; height: 250px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">통합직종 등록</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<form id="frmPop" action="insert.do" method="post">
					<input type="hidden" name="jssfcNo" value="" />
					<table class="tbl tbl_form">
						<colgroup>
							<col width="20%">
							<col width="30%">
							<col width="20%">
							<col width="30%">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">직종명</th>
								<td><input type="text" class="w100p" maxlength="8" name="jssfcNm" title="코드ID" required></td>
								<th scope="row">평균연근로일수</th>
								<td><input type="text" class="w100p" maxlength="30" name="stdrDaycnt" title="부모코드ID" required></td>
							</tr>
							<tr>
								<th scope="row">유형</th>
								<td>
									<c:forEach var="eo" items="${seList}">
										<label><input type="radio" name="se" title="유형" value="${eo.cdId}" /> ${eo.cdNm}</label>
									</c:forEach>
								</td>
								<th scope="row">활성화여부</th>
								<td>
									<label><input type="radio" name="actvtyAt" title="활성화여부" value="Y" /> Y</label>
									<label><input type="radio" name="actvtyAt" title="활성화여부" value="N" /> N</label>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
				
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="#" class="btn normal blue mr10 btnAdd"><i class="far fa-save mr5"></i> 등록</a>
						<a href="#" class="btn normal blue mr10 btnEdit"><i class="far fa-edit mr5"></i> 수정</a>
						<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
					</div>
				</div>

			</div>
		</div>
	</div>
</body>
</html>
