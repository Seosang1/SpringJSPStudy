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
			$('#frm').attr('action', 'list.do');
			ajaxList(1);
			e.preventDefault();
			return false;
		});
		
		//초기화버튼 클릭이벤트
		$('.btnReset').click(function(){
			$('#frm')[0].reset();
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
		$('#result').on('click', '.btnView', function(e){
			$('#frm').attr('action', 'form.do');
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		$('.btn_search').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				if($('.datepicker:eq(0)').val() && $('.datepicker:eq(1)').val()){
					if($('.datepicker:eq(0)').val() > $('.datepicker:eq(1)').val()){
						alert('종료일은 시작일보다 크게 입력해주세요');
						return false;
					}
				}
			},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr class="btnView" style="cursor:pointer" data-sn="'+this.sn+'">';
					html += '<td>'+((res.vo.pageNo-1)*res.vo.numOfPage+this.rownum)+'</td>';
					html += '<td>'+this.rgstDt+'</td>';
					html += '<td>'+this.seNm+'</td>';
					html += '<td>'+this.moblphonNo+'</td>';
					html += '<td>'+this.sttusNm+'</td>';
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
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">발송일자</th>
						<td colspan="3">
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnDt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endDt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">구분</th>
						<td>
							<select class="w60p" name="se">
								<option value="">전체</option>
							<c:forEach var="ceo" items="${seList}">
								<option value="${ceo.cdId}">${ceo.cdNm}</option>
							</c:forEach>
							</select>
						</td>
						<th scope="row">상태</th>
						<td>
							<select class="w60p" name="sttus">
								<option value="">전체</option>
							<c:forEach var="ceo" items="${sttusList}">
								<option value="${ceo.cdId}">${ceo.cdNm}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">수신번호</th>
						<td colspan="3"><input type="text" class="w100p" name="moblphonNo" /></td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search mr10"><i class="fas fa-search mr5"></i> 조회</a>
				<a href="#" class="btn normal grey btnReset"><i class="far fa-sticky-note mr5"></i> 초기화</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
		</div>
		
		<table class="tbl tbl_data">
			<colgroup>
				<col width="10%" />
				<col width="" />
				<col width="20%" />
				<col width="20%" />
				<col width="20%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>발송일시</span></th>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>수신번호</span></th>
					<th scope="col"><span>상태</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		<div class="paging">
		</div>
		<div class="fr txt_right">
			<a href="form.do" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 등록</a>
		</div>
	</div>

</body>
</html>
