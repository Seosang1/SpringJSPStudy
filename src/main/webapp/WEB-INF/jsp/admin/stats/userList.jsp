<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
		//검색버튼 클릭이벤트
		$('.btn_search').click(function(e){
			ajaxList(1);
			e.preventDefault();
			return false;
		});
		
		//엔터이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('.btn_search').click();
				e.preventDefault();
			}
			return false;
		});
		
		//기간설정버튼 클릭이벤트
		$('.btn_form').click(function(){
			var date = new Date();
			var type = $(this).data('type');
			
			if(type == 'month'){
				date.setDate('01');
				
			}else if(type == 'quarter'){
				var month = (Math.ceil(((date.getMonth()+1)/12)*4)-1)*3;
				date.setMonth(month);
				date.setDate('01');
				
			}else if(type == 'half'){
				var month = (Math.ceil(((date.getMonth()+1)/12)*2)-1)*6;
				date.setMonth(month);
				date.setDate('01');
				
			}else if(type == 'year'){
				date.setMonth('00');
				date.setDate('01');
				
			}
			
			$('[name="bgnDt"]').val($.datepicker.formatDate('yy-mm-dd', date));
			$('[name="endDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
			
		});
		
		//초기화버튼클릭이벤트
		$('.search_wrap .grey').click(function(){
			$('[name="bgnDt"]').val('');
			$('[name="endDt"]').val('');			
		});
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			$('#frm [name="type"]').val($(this).data('type'));
			cwma.showExcelPop('/admin/stats/userListExcelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
			e.preventDefault();
			return false;
		});
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'userList.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+this.seNm+'</td>';
					html += '<td>'+(this.totalCnt?this.totalCnt.formatMoney():'0')+'</td>';
					html += '<td>'+(this.visitCnt?this.visitCnt.formatMoney():'0')+'</td>';
					html += '<td>'+(this.guyCnt?this.guyCnt.formatMoney():'0')+'</td>';
					html += '<td>'+(this.womanCnt?this.womanCnt.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range10?this.range10.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range20?this.range20.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range30?this.range30.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range40?this.range40.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range50?this.range50.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range60?this.range60.formatMoney():'0')+'</td>';
					html += '<td>'+(this.range70?this.range70.formatMoney():'0')+'</td>';
					html += '</tr>';
				});
				
				if(!html)
					html = '<tr><td colspan="11">조회결과가 없습니다</td></tr>';
						
				$('#result').html(html);
				
				html = '';
				$(res.area).each(function(){
					html += '<tr>';
					html += '<td>'+this.seNm+'</td>';
					html += '<td>'+(this.서울?this.서울.formatMoney():'0')+'</td>';
					html += '<td>'+(this.부산?this.부산.formatMoney():'0')+'</td>';
					html += '<td>'+(this.대구?this.대구.formatMoney():'0')+'</td>';
					html += '<td>'+(this.인천?this.인천.formatMoney():'0')+'</td>';
					html += '<td>'+(this.광주?this.광주.formatMoney():'0')+'</td>';
					html += '<td>'+(this.대전?this.대전.formatMoney():'0')+'</td>';
					html += '<td>'+(this.울산?this.울산.formatMoney():'0')+'</td>';
					html += '<td>'+(this.세종?this.세종.formatMoney():'0')+'</td>';
					html += '<td>'+(this.경기?this.경기.formatMoney():'0')+'</td>';
					html += '<td>'+(this.강원?this.강원.formatMoney():'0')+'</td>';
					html += '<td>'+(this.충북?this.충북.formatMoney():'0')+'</td>';
					html += '<td>'+(this.충남?this.충남.formatMoney():'0')+'</td>';
					html += '<td>'+(this.전북?this.전북.formatMoney():'0')+'</td>';
					html += '<td>'+(this.전남?this.전남.formatMoney():'0')+'</td>';
					html += '<td>'+(this.경북?this.경북.formatMoney():'0')+'</td>';
					html += '<td>'+(this.경남?this.경남.formatMoney():'0')+'</td>';
					html += '<td>'+(this.제주?this.제주.formatMoney():'0')+'</td>';
					html += '<td>'+(this.기타?this.기타.formatMoney():'0')+'</td>';
					html += '</tr>';
				});
				
				if(!html)
					html = '<tr><td colspan="18">조회결과가 없습니다</td></tr>';
						
				$('#result2').html(html);
			}
		});
	};
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="type" value="age" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">기간</th>
						<td>
							<div class="input_date">
								<input type="text" name="bgnDt" style="width: 105px;" class="datepicker">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" name="endDt" style="width: 105px;" class="datepicker">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<a href="#" class="btn btn_form ml10" data-type="day">일</a>
							<a href="#" class="btn btn_form ml10" data-type="month">월</a>
							<a href="#" class="btn btn_form ml10" data-type="quarter">분기</a>
							<a href="#" class="btn btn_form ml10" data-type="half">반기</a>
							<a href="#" class="btn btn_form ml10" data-type="year">당해년도</a>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search mr10"><i class="fas fa-search mr5"></i> 조회</a>
				<a href="#" class="btn normal grey "><i class="far fa-sticky-note mr5"></i> 초기화</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<div class="fr txt_right">
				<a href="#" class="btn normal green mr10 btnExcelForm" data-type="age"><i class="far fa-file-excel mr5"></i> 연령별통계 엑셀다운로드</a>
				<a href="#" class="btn normal green mr10 btnExcelForm" data-type="area"><i class="far fa-file-excel mr5"></i> 지역별통계 엑셀다운로드</a>
			</div>
		</div>
		<table class="tbl tbl_data">
			<thead>
				<tr>
					<th scope="col" rowspan="2">구분</th>
					<th scope="col" rowspan="2"><span>가입</span></th>
					<th scope="col" rowspan="2"><span>방문자</span></th>
					<th scope="col" colspan="2"><span>성별</span></th>
					<th scope="col" colspan="6"><span>나이</span></th>
				</tr>
				<tr>
					<th scope="col"><span>남</span></th>
					<th scope="col"><span>여</span></th>
					<th scope="col"><span>19세이하</span></th>
					<th scope="col"><span>20~29</span></th>
					<th scope="col"><span>30~39</span></th>
					<th scope="col"><span>40~49</span></th>
					<th scope="col"><span>50~59</span></th>
					<th scope="col"><span>60~69</span></th>
					<th scope="col"><span>70세이상</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<table class="tbl tbl_data">
			<thead>
				<tr>
					<th scope="col" colspan="19">지역</th>
				</tr>
				<tr>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>서울</span></th>
					<th scope="col"><span>부산</span></th>
					<th scope="col"><span>대구</span></th>
					<th scope="col"><span>인천</span></th>
					<th scope="col"><span>광주</span></th>
					<th scope="col"><span>대전</span></th>
					<th scope="col"><span>울산</span></th>
					<th scope="col"><span>세종</span></th>
					<th scope="col"><span>경기</span></th>
					<th scope="col"><span>강원</span></th>
					<th scope="col"><span>충북</span></th>
					<th scope="col"><span>충남</span></th>
					<th scope="col"><span>전북</span></th>
					<th scope="col"><span>전남</span></th>
					<th scope="col"><span>경북</span></th>
					<th scope="col"><span>경남</span></th>
					<th scope="col"><span>제주</span></th>
					<th scope="col"><span>기타</span></th>
				</tr>
			</thead>
			<tbody id="result2">
			</tbody>
		</table>
	</div>
</body>
</html>
