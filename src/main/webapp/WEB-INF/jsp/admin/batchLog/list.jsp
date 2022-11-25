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

		//상세보기버튼 클릭이벤트 
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'view.do');
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('seq')+'" />');
			$('#frm').submit();
		});
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/batchLog/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'));
			e.preventDefault();
			return false;
		});
		
		//엔터 이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('#btnSearch').click();
				e.preventDefault();
			}
			return false;
		});

		$('.btn_search').click();
	});

	//리스트조회 함수
	function ajaxList(pageNo){
		$('[name="pageNo"]').val(pageNo);
		$('#frm').attr('action', 'list.do');
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
				html += '<tr>';
				html += '<td>'+this.rownum+'</td>';
				html += '<td>'+this.batchCd+'</td>';
				html += '<td class="txt_left pl20"><a href="#" class="btnView" data-seq="'+this.sn+'">'+this.batchNm+'</a></td>';
				html += '<td>'+this.batchResult+'</td>';
				html += '<td>'+this.cnt+'</td>';
				html += '<td>'+this.executDe+'</td>';
				html += '</tr>';
			});
			
			if(!res.vo.totalCnt)
				html = '<tr><td colspan="6">조회결과가 없습니다</td></tr>';

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
			<input type="hidden" name="numOfPage" value="20" />
			
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 120px;">
					<col>
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">연계정보</th>
						<td>
							<select class="w100p" name="batchCd" title="연계정보">
								<option value="">전체</option>
							<c:forEach var="ceo" items="${batchCd}">
								<option value="${ceo.batchCd}">${ceo.batchNm}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">수집상태</th>
						<td>
							<select class="w100p" name="batchResult" title="수집상태">
								<option value="">전체</option>
							<c:forEach var="ceo" items="${resultCd}">
								<option value="${ceo.cdId}">${ceo.cdNm}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">실행일</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnDt" title="시작일">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt=""></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endDt" title="종료일">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt=""></a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="list.do" class="btn btn_search"><i class="fas fa-search mr5"></i>조회</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
			<div class="fr txt_right">
				<a href="#" class="btn normal green mr10 btnExcelForm"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%">
				<col width="20%">
				<col>
				<col width="10%">
				<col width="10%">
				<col width="15%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>연계코드</span></th>
					<th scope="col"><span>연계정보</span></th>
					<th scope="col"><span>수집상태</span></th>
					<th scope="col"><span>건수</span></th>
					<th scope="col"><span>실행일</span></th>
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
