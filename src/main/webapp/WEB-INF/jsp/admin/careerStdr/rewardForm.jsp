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
			success:function(res){
				alert('저장 되었습니다');
	
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
		$('#rewardStdrLayer').hide();
		
		e.preventDefault();
		return false;			
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$.ajax({
			url:'list.do',
			type:'post',
			data:{'se':$('#frm [name="se"]:first').val()},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(i){
					html += '<tr>';
					html += '<td>'+this.applcDe+'</td>';
					html += '<td>'+this.rgstNm+'</td>';
					html += '<td>'+this.grad1+'</td>';
					html += '<td>'+this.grad2+'</td>';
					html += '<td>'+this.grad3+'</td>';
					html += '<td>'+this.grad4+'</td>';
					html += '<td>'+res.list1[i].grad1+'</td>';
					html += '<td>'+res.list1[i].grad2+'</td>';
					html += '<td>'+res.list1[i].grad3+'</td>';
					html += '<td>'+res.list1[i].grad4+'</td>';
					html += '<td>'+res.list2[i].grad1+'</td>';
					html += '<td>'+res.list2[i].grad2+'</td>';
					html += '<td>'+res.list2[i].grad3+'</td>';
					html += '<td>'+res.list2[i].grad4+'</td>';
					html += '<td>'+res.list3[i].grad1+'</td>';
					html += '<td>'+res.list3[i].grad2+'</td>';
					html += '<td>'+res.list3[i].grad3+'</td>';
					html += '<td>'+res.list3[i].grad4+'</td>';
					html += '</tr>';
				});
				
				if(!res.list || !res.list.length)
					alert('변경이력이 없습니다');
				else{
					$('#result').html(html);
					
					cwma.showMask();
					$('#rewardStdrLayer').css("top",(($(window).height() - $('#rewardStdrLayer').outerHeight()) / 2) + $(window).scrollTop());
					$('#rewardStdrLayer').css("left",(($(window).width() - $('#rewardStdrLayer').outerWidth()) / 2) + $(window).scrollLeft());
					
					if($('.right_cont .layerpop')[0]){
						$('#rewardStdrLayer').draggable();
						$('body').append($('.right_cont .layerpop'));
					}
					
			        $('#rewardStdrLayer').show();
				}
			}
		});
	};
	
	$('.btnTab').each(function(){
		if($(this).attr('href').split('/')[$(this).attr('href').split('/').length-1] == location.href.split('/')[location.href.split('/').length-1]){
			$(this).attr('class','on');
		}
	});
	
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
		<li class="btnTab" href="../jssfcInfo/list.do">직종</li>
		<li class="btnTab" href="../careerStdr/form.do?se=CSSE0001">자격증</li>
		<li class="btnTab" href="../careerStdr/form.do?se=CSSE0003">교육</li>
		<li class="btnTab" href="../careerStdr/form.do?se=CSSE0002">포상</li>
	</ul>
</div>
	
	<form action="" id="frm" method="post">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="voList[0].se" value="${empty eo?param.se:eo.se}" />
		<input type="hidden" name="voList[1].se" value="${empty eo1?'CSSE0004':eo1.se}" />
		<input type="hidden" name="voList[2].se" value="${empty eo2?'CSSE0005':eo2.se}" />
		<input type="hidden" name="voList[3].se" value="${empty eo3?'CSSE0006':eo3.se}" />
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="" />
				<col width="21%" />
				<col width="21%" />
				<col width="21%" />
				<col width="21%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>적용일</th>
					<td colspan="5">
						<div class="input_date">
							<input type="text" name="applcDe" title="적용일" class="datepicker" style="width:105px;" value="${eo.applcDe}" required date/>
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<button type="button" class="btn btn_form mr10 btnList">변경이력</button>
					</td>
				</tr>

				<tr>
					<th scope="row" colspan="5" class="txt_center">환산기준</th>
				</tr>
				<tr>
					<th scope="row" class="txt_center">구분</th>
					<th scope="row" class="txt_center">국제기능올림픽대회</th>
					<th scope="row" class="txt_center">전국기능경기대회</th>
					<th scope="row" class="txt_center">지방기능경기대회</th>
					<th scope="row" class="txt_center">민간기능경기대회</th>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>1위</th>
					<td>
						<input type="text" name="voList[0].grad1" title="1위" class="w80p" value="${eo.grad1}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[1].grad1" title="1위" class="w80p" value="${eo1.grad1}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[2].grad1" title="1위" class="w80p" value="${eo2.grad1}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[3].grad1" title="1위" class="w80p" value="${eo3.grad1}" required maxlength="10"/> 년
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>2위</th>
					<td>
						<input type="text" name="voList[0].grad2" title="2위" class="w80p" value="${eo.grad2}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[1].grad2" title="2위" class="w80p" value="${eo1.grad2}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[2].grad2" title="2위" class="w80p" value="${eo2.grad2}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[3].grad2" title="2위" class="w80p" value="${eo3.grad2}" required maxlength="10"/> 년
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>3위</th>
					<td>
						<input type="text" name="voList[0].grad3" title="3위" class="w80p" value="${eo.grad3}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[1].grad3" title="3위" class="w80p" value="${eo1.grad3}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[2].grad3" title="3위" class="w80p" value="${eo2.grad3}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[3].grad3" title="3위" class="w80p" value="${eo3.grad3}" required maxlength="10"/> 년
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>기타</th>
					<td>
						<input type="text" name="voList[0].grad4" title="기타" class="w80p" value="${eo.grad4}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[1].grad4" title="기타" class="w80p" value="${eo1.grad4}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[2].grad4" title="기타" class="w80p" value="${eo2.grad4}" required maxlength="10"/> 년
					</td>
					<td>
						<input type="text" name="voList[3].grad4" title="기타" class="w80p" value="${eo3.grad4}" required maxlength="10"/> 년
					</td>
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
	
	<div id="rewardStdrLayer" class="layerpop" style="width: 900px; height: 500px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">변경이력</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<table class="tbl tbl_data">
					<colgroup>
						<col width="10">
						<col width="10%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
						<col width="5%">
					</colgroup>
					<thead>
						<tr>
							<th scope="row" rowspan="3">적용일자</th>
							<th scope="row" rowspan="3">담당자</th>
							<th scope="row" colspan="16">환산기준</th>
						</tr>
						<tr>
							<th scope="row" colspan="4">국제기능올림픽대회</th>
							<th scope="row" colspan="4">전국기능경기대회</th>
							<th scope="row" colspan="4">지방기능경기대회</th>
							<th scope="row" colspan="4">민간기능경기대회</th>
						</tr>
						<tr>
							<th scope="row">1</th>
							<th scope="row">2</th>
							<th scope="row">3</th>
							<th scope="row">기타</th>
							<th scope="row">1</th>
							<th scope="row">2</th>
							<th scope="row">3</th>
							<th scope="row">기타</th>
							<th scope="row">1</th>
							<th scope="row">2</th>
							<th scope="row">3</th>
							<th scope="row">기타</th>
							<th scope="row">1</th>
							<th scope="row">2</th>
							<th scope="row">3</th>
							<th scope="row">기타</th>
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
