<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/jquery/yearpicker/yearpicker.css" />
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/jquery.ui.monthpicker.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/jquery/yearpicker/yearpicker.js"></script>
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
	  	
	  	//year피커 초기화
	    $('.yearpicker').yearpicker();
	  	$('.yearpicker-container .yearpicker-current').text($.datepicker.formatDate('yy', new Date()));
	  	
	  	//데이트피커 버튼클릭
	    $('.yearpicker').next().next().click(function(e){
	    	$(this).prev().prev().focus();
	    	e.preventDefault();
	    	return false;
	    });
	  	
	  	//상단탭 클릭
	  	$('.tab200 li').click(function(e){
	  		$('.tab200 li').attr('class', 'btnTab');
	  		$(this).attr('class', 'on');
	  		$('#frm [name="type"]').val($(this).data('type'));
	  		
	  		if($(this).data('type') == 'quarter'){
	  			$('.yearpicker').parent().show();
	  			$('.monthpicker').parent().hide();
	  			$('.yearpicker').prop('disabled', false);
	  			$('.monthpicker').prop('disabled', true);
	  		}else{
	  			$('.yearpicker').parent().hide();
	  			$('.monthpicker').parent().show();
	  			$('.yearpicker').prop('disabled', true);
	  			$('.monthpicker').prop('disabled', false);
	  		}
	  		
	  		$('.btn_search').click();
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
				var type = $('#frm [name="type"]').val();
				
				$(res.list).each(function(i){
					html += '<tr>';
					
					if(type.indexOf('Gender') >= 0){
						if((i-1)%3 == 0 || i == 0) html += '<td '+(this.seNm == '계'?'colspan="2"':'rowspan="3"')+'>'+this.seNm+'</td>';
						if(this.seNm != '계') html += '<td>'+this.sexdstn+'</td>';
						
					}else{
						if((i-1)%5 == 0 || i == 0) html += '<td '+(this.seNm == '계'?'colspan="2"':'rowspan="5"')+'>'+this.seNm+'</td>';
						if(this.seNm != '계') html += '<td>'+this.grad+'</td>';
						
					}
					
					if(type.indexOf('age') >= 0){
						html += '<td>'+(this.totalCnt?this.totalCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age20Cnt?this.age20Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age30Cnt?this.age30Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age40Cnt?this.age40Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age50Cnt?this.age50Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age60Cnt?this.age60Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age70Cnt?this.age70Cnt.formatMoney():'0')+'</td>';
						
					}else if(type.indexOf('area') >= 0){
						html += '<td>'+(this.totalCnt?this.totalCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.seoulCnt?this.seoulCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.incheonCnt?this.incheonCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.busanCnt?this.busanCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.kyeongkiCnt?this.kyeongkiCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.kangwonCnt?this.kangwonCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.daejeonCnt?this.daejeonCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.sejongCnt?this.sejongCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.kwangjuCnt?this.kwangjuCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.daeguCnt?this.daeguCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.ulsanCnt?this.ulsanCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.jejuCnt?this.jejuCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.chungbukCnt?this.chungbukCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.chungnamCnt?this.chungnamCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.jeonbukCnt?this.jeonbukCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.jeonnamCnt?this.jeonnamCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.kyeongbukCnt?this.kyeongbukCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.kyeongnamCnt?this.kyeongnamCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.etcCnt?this.etcCnt.formatMoney():'0')+'</td>';
						
					}else{
						html += '<td>'+(this.grad1Cnt?this.grad1Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad2Cnt?this.grad2Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad3Cnt?this.grad3Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad4Cnt?this.grad4Cnt.formatMoney():'0')+'</td>';
						
					}
					
					html += '</tr>';
				});
				
				if(!html)
					html = '<tr><td colspan="'+(type.indexOf('age') >= 0?'9':(type.indexOf('area') >= 0?'21':'7'))+'">조회결과가 없습니다</td></tr>';

				$('[view]').hide();
				
				if(type.indexOf('age') >= 0){
					$('[view="age"]').show();
					$('#ageResult').html(html);
					
				}else if(type.indexOf('area') >= 0){
					$('[view="area"]').show();
					$('#areaResult').html(html);
					
				}else{
					$('[view="quarter"]').show();
					$('#quarterResult').html(html);					
				}
				
				if(type.indexOf('Gender') >= 0)
					$('.tbl_data:visible thead tr:first th:eq(1)').text('성별');
				else
					$('.tbl_data:visible thead tr:first th:eq(1)').text('등급');
				
				if(type == 'quarter'){
					$('[view="quarter"] thead th').slice(2).each(function(i){
						$(this).text($('.yearpicker-container .yearpicker-current').text()+'년 '+(i+1)+'분기');
					});
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="search_wrap">
		<ul class="tab200">
			<li class="on" data-type="ageGender">연령별(성별)통계</li>
			<li class="btnTab" data-type="ageGrad">연령별(등급)통계</li>
			<li class="btnTab" data-type="areaGender">지역별(성별)통계</li>
			<li class="btnTab" data-type="areaGrad">지역별(등급)통계</li>
			<li class="btnTab" data-type="quarter">분기별통계</li>
		</ul>
	</div>
	
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="type" value="ageGender" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">통계일</th>
						<td>
							<div class="input_date">
								<input type="text" name="statsDe" style="width: 105px;" class="monthpicker">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<div class="input_date" style="display:none">
								<input type="text" name="statsDe" style="width: 105px;" class="yearpicker" disabled>
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search mr10"><i class="fas fa-search mr5"></i> 조회</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<div class="fr txt_right">
				<a href="#" class="btn normal green ml20 btnExcelForm"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>

		<table class="tbl tbl_data" view="age">
			<colgroup>
				<col style="width: 10%;">
				<col style="width:;">
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
					<th scope="col" rowspan="2">직종</th>
					<th scope="col" rowspan="2"><span>성별</span></th>
					<th scope="col" rowspan="2"><span>계</span></th>
					<th scope="col" colspan="6"><span>연령대</span></th>
				</tr>
				<tr>
					<th scope="col"><span>20대 이하</span></th>
					<th scope="col"><span>30대</span></th>
					<th scope="col"><span>40대</span></th>
					<th scope="col"><span>50대</span></th>
					<th scope="col"><span>60대</span></th>
					<th scope="col"><span>70대 이상</span></th>
				</tr>
			</thead>
			<tbody id="ageResult">
			</tbody>
		</table>
		
		<table class="tbl tbl_data" view="area" style="display:none">
			<thead>
				<tr>
					<th scope="col" rowspan="2">직종</th>
					<th scope="col" rowspan="2"><span>성별</span></th>
					<th scope="col" rowspan="2"><span>계</span></th>
					<th scope="col" colspan="18">지역</th>
				</tr>
				<tr>
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
			<tbody id="areaResult">
			</tbody>
		</table>
		
		<table class="tbl tbl_data" view="quarter">
			<colgroup>
				<col style="width: 10%;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
				<col style="width:;">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">직종</th>
					<th scope="col"><span>등급</span></th>
					<th scope="col"><span>1분기</span></th>
					<th scope="col"><span>2분기</span></th>
					<th scope="col"><span>3분기</span></th>
					<th scope="col"><span>4분기</span></th>
				</tr>
			</thead>
			<tbody id="quarterResult">
			</tbody>
		</table>
	</div>
</body>
</html>
