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
		cwmaList = new cwma.list({pageLayer:'.paging'});
		
		//검색버튼 클릭이벤트
		$('.btn_search').click(function(e){
			$('#frm').attr('action', 'list.do');
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
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'form.do');
			$('#frm').append('<input type="hidden" name="surveySn" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
		});
		
		//결과보기버튼 클릭이벤트
		$('#result').on('click', '.btn_form', function(){
			$('#frm').attr('action', 'view.do');
			$('#frm').append('<input type="hidden" name="surveySn" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
		});
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td style="text-align:left;"><a href="#" class="btnView" data-sn="'+this.surveySn+'">'+this.sj+'</a></td>';
					html += '<td>'+this.bgnde+' ~ '+this.endde+'</td>';
					html += '<td><a href="#" class="btn btn_form" data-sn="'+this.surveySn+'">결과보기</a></td>';
					html += '<td>'+(this.useAt == 'Y'?'사용':'미사용')+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="5">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo.formatMoney()+'/'+res.vo.totalPage.formatMoney()+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	};
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="10" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 40%;">
					<col style="width: 10%;">
					<col style="width: 40%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">설문기간</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnde">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt=""></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endde">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt=""></a>
							</div>
						</td>
						<th scope="row">사용여부</th>
						<td>
							<input type="radio" id="rad301" name="useAt" value="Y">
							<label for="rad301">사용</label>
							<input type="radio" id="rad302" name="useAt" value="N">
							<label for="rad302">미사용</label>
						</td>
					</tr>
					<tr>
						<th scope="row">조회조건</th>
						<td colspan="3">
							<select name="searchKey" title="조회조건" class="w20p mr10">
								<option value="">전체</option>
								<option value="sj">제목</option>
								<option value="cn">내용</option>
							</select>
							<input type="text" name="searchWord" title="검색어" class="w70p">
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
		</div>
		
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%">
				<col>
				<col width="20%">
				<col width="10%">
				<col width="10%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>제목</span></th>
					<th scope="col"><span>기간</span></th>
					<th scope="col"><span>결과보기</span></th>
					<th scope="col"><span>상태</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		<div class="paging">
		</div>
		<div class="fr txt_right">
			<a href="form.do" class="btn normal blue mr10"><i class="far fa-save mr5"></i> 등록</a>
		</div>
	</div>

</body>
</html>
