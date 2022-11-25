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
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/stats/crtfListExcelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
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
	  	
	  	//상단탭 클릭
	  	$('.tab200 li').click(function(e){
	  		$('.tab200 li').attr('class', 'btnTab');
	  		$(this).attr('class', 'on');
	  		
	  		$('#frm [name="type"]').val($(this).data('type'));
	  		$('.btn_search').click();
	    	e.preventDefault();
	    	return false;
	    });
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'crtfList.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					if($('#frm [name="type"]').val() == 'age'){
						html += '<tr>';
						html += '<td>'+this.seNm+'</td>';
						html += '<td>'+(this.totalCnt?this.totalCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age20Cnt?this.age20Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age30Cnt?this.age30Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age40Cnt?this.age40Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age50Cnt?this.age50Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age60Cnt?this.age60Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.age70Cnt?this.age70Cnt.formatMoney():'0')+'</td>';
						html += '</tr>';
						
					}else{
						html += '<tr>';
						html += '<td>'+this.seNm+'</td>';
						html += '<td>'+(this.totalCnt?this.totalCnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad1Cnt?this.grad1Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad2Cnt?this.grad2Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad3Cnt?this.grad3Cnt.formatMoney():'0')+'</td>';
						html += '<td>'+(this.grad4Cnt?this.grad4Cnt.formatMoney():'0')+'</td>';
						html += '</tr>';
					}
				});
				
				if(!html)
					html = '<tr><td colspan="6">조회결과가 없습니다</td></tr>';

				$('[view]').hide();
				
				if($('#frm [name="type"]').val() == 'age'){
					$('[view="age"]').show();
					$('#ageResult').html(html);
					
				}else{
					$('[view="grad"]').show();
					$('#gradResult').html(html);
					
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="search_wrap">
		<ul class="tab200">
			<li class="on" data-type="jssfc">등급별(직종)발급통계</li>
			<li class="btnTab" data-type="spt">등급별(신청방법)발급통계</li>
			<li class="btnTab" data-type="age">연령대별(신청방법)발급통계</li>
		</ul>
	</div>
	
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="type" value="jssfc" />
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

		<table class="tbl tbl_data" view="grad">
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
					<th scope="col"><span>계</span></th>
					<th scope="col"><span>초급</span></th>
					<th scope="col"><span>중급</span></th>
					<th scope="col"><span>고급</span></th>
					<th scope="col"><span>특급</span></th>
				</tr>
			</thead>
			<tbody id="gradResult">
			</tbody>
		</table>

		<table class="tbl tbl_data" view="age" style="display:none">
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
	</div>
</body>
</html>