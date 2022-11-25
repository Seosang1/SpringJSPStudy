<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaList;
	
	$(function(){
		cwmaList = new cwma.list({pageLayer:$('.paging')});
		
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
			cwma.showExcelPop('/admin/stats/clmserEduListExcelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
			e.preventDefault();
			return false;
		});
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'clmserEduList.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td>'+this.nm+'</td>';
					html += '<td>'+this.ihidnum+'</td>';
					html += '<td>'+this.answer1+'</td>';
					html += '<td>'+this.answer2+'</td>';
					html += '<td>'+this.answer3+'</td>';
					html += '<td>'+this.answer4+'</td>';
					html += '</tr>';
				});
				
				if(!html)
					html = '<tr><td colspan="7">조회결과가 없습니다</td></tr>';
						
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo.formatMoney()+'/'+res.vo.totalPage.formatMoney()+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	}
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">성명</th>
						<td><input type="text" name="nm" class="w100p"></td>
					</tr>
					<tr>
						<th scope="row">주민등록번호</th>
						<td><input type="text" name="ihidnum" class="w100p"></td>
					</tr>
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
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
			<div class="fr txt_right">
				<a href="#" class="btn normal green ml20 btnExcelForm"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="8%" />
				<col width="10%" />
				<col width="6%" />
				<col width="6%" />
				<col width="6%" />
				<col />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col"><span>이름</span></th>
					<th scope="col"><span>주민등록번호</span></th>
					<th scope="col"><span>1번</span></th>
					<th scope="col"><span>2번</span></th>
					<th scope="col"><span>3번</span></th>
					<th scope="col"><span>4번</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>
		
	</div>
</body>
</html>
