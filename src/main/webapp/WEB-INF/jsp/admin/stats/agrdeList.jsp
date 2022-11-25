<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.ui.monthpicker.js"></script>
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
		
		//초기화버튼클릭이벤트
		$('.search_wrap .grey').click(function(){
			$('[name="bgnDt"]').val('');
			$('[name="endDt"]').val('');			
		});
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/stats/gradListExcelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
			e.preventDefault();
			return false;
		});
		
		//데이트피커 초기화
	    $('.monthpicker').monthpicker({
			buttonText : '년월 선택',
			yearRange : 'c-10:c+0',
			dateFormat : 'yy-mm',
			prevText : '이전', 
			nextText : '다음', 
	        monthNames : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	        monthNamesShort : ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	        showButtonPanel:true,
	        currentText:'',
	        closeText:'취소',
	        isRTL:true
	    }).mask('0000-00');
	    
	  	//데이트피커 버튼클릭
	    $('.monthpicker').next().click(function(e){
	    	$(this).prev().focus();
	    	e.preventDefault();
	    	return false;
	    });
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'gradList.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				var jssfcSum = [0, 0, 0, 0];
				var totalSum = 0;
				
				$(res.list).each(function(){
					if(this.statsDe){
						html += '<tr>';
						html += '<td>'+this.jssfcNm+'</td>';
						html += '<td>'+(this.totalCnt?this.totalCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age20Cnt?this.age20Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age30Cnt?this.age30Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age40Cnt?this.age40Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age50Cnt?this.age50Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age60Cnt?this.age60Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age70Cnt?this.age70Cnt.formatMoney():'0')+'</td>';
						html += '</tr>';
					}else{
						$('em.fs16').eq(0).text(this.age20Cnt.formatMoney()+' 명 ('+(Math.floor(this.age20Cnt/this.totalCnt*10000)/100)+'%)');
						$('em.fs16').eq(1).text(this.age30Cnt.formatMoney()+' 명 ('+(Math.floor(this.age30Cnt/this.totalCnt*10000)/100)+'%)');
						$('em.fs16').eq(2).text(this.age40Cnt.formatMoney()+' 명 ('+(Math.floor(this.age40Cnt/this.totalCnt*10000)/100)+'%)');
						$('em.fs16').eq(3).text(this.age50Cnt.formatMoney()+' 명 ('+(Math.floor(this.age50Cnt/this.totalCnt*10000)/100)+'%)');
						$('em.fs16').eq(4).text(this.age60Cnt.formatMoney()+' 명 ('+(Math.floor(this.age60Cnt/this.totalCnt*10000)/100)+'%)');
						$('em.fs16').eq(5).text(this.age70Cnt.formatMoney()+' 명 ('+(Math.floor(this.age70Cnt/this.totalCnt*10000)/100)+'%)');
					}
				});
				
				if(!html)
					html = '<tr><td colspan="8">조회결과가 없습니다</td></tr>';

				$('#result').html(html);
			}
		});
	}
</script>
</head>
<body>
	<div class="data_wrap">
		<table class="tbl tbl_data">
			<colgroup>
				<col width="8%">
				<col width="23%">
				<col width="23%">
				<col width="23%">
				<col width="23%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">구분</th>
					<th scope="col"><span>20대</span></th>
					<th scope="col"><span>30대</span></th>
					<th scope="col"><span>40대</span></th>
					<th scope="col"><span>50대</span></th>
					<th scope="col"><span>60대</span></th>
					<th scope="col"><span>70대</span></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>인원수</td>
					<td><em class="blue fs16">6,850,025 명 (47%)</em></td>
					<td><em class="blue fs16">6,850,025 명 (47%)</em></td>
					<td><em class="blue fs16">6,850,025 명 (47%)</em></td>
					<td><em class="blue fs16">6,850,025 명 (47%)</em></td>
					<td><em class="blue fs16">6,850,025 명 (47%)</em></td>
					<td><em class="blue fs16">6,850,025 명 (47%)</em></td>
				</tr>
			</tbody>
		</table>
	</div>
	
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">직종</th>
						<td>					
							<select class="w100p chosen-select" name="jssfcNo">
								<option value="0">전체</option>
								<c:forEach var="ceo" items="${jssfcList}">
									<option value="${ceo.jssfcNo}">${ceo.jssfcNm}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">통계일</th>
						<td>
							<div class="input_date">
								<input type="text" name="statsDe" style="width: 105px;" class="monthpicker">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
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
				<a href="#" class="btn normal green ml20 btnExcelForm"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>

		<table class="tbl tbl_data">
			<colgroup>
				<col style="width: 10%;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">직종</th>
					<th scope="col"><span>계</span></th>
					<th scope="col"><span>20대</span></th>
					<th scope="col"><span>30대</span></th>
					<th scope="col"><span>40대</span></th>
					<th scope="col"><span>50대</span></th>
					<th scope="col"><span>60대</span></th>
					<th scope="col"><span>70대</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
	</div>
</body>
</html>
