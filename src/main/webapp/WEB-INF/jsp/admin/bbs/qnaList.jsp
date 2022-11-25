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
		$('#btnSearch').click(function(e){
			$('#frm').attr('action', 'list.do');
			ajaxList(1);
			e.preventDefault();
			return false;
		});
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'qnaForm.do');
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
		});
		
		$('#btnSearch').click();
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
					html += '<tr>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td>'+this.clNm+'</td>';
					html += '<td>'+this.rgstNm+'</td>';
					html += '<td class="txt_left pl20"><a href="#" class="btnView" data-sn="'+this.sn+'">'+this.sj+'</a></td>';
					html += '<td>'+this.rgstDt.formatDate()+'</td>';
					html += '<td>'+(this.answerNm?this.answerNm:'')+'</td>';
					html += '<td>'+(this.answerId?'답변완료':'대기중')+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="10">조회결과가 없습니다</td></tr>';
				
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
			<input type="hidden" name="se" value="BSSE0003" />
			
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 120px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">상담유형</th>
						<td>
							<select class="w20p" name="cl" title="상담유형">
								<option value="">전체</option>
							<c:forEach var="ceo" items="${clList}">
								<option value="${ceo.cdId}" ${ceo.cdId eq eo.cl?'selected':''}>${ceo.cdNm}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">상태</th>
						<td>
							<label><input type="radio" name="answerAt" value="" checked>전체</label>
							<label><input type="radio" name="answerAt" value="N">대기중</label>
							<label><input type="radio" name="answerAt" value="Y">답변완료</label>
						</td>
					</tr>
					<tr>
						<th scope="row">등록일자</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnDt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endDt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" class="ui-datepicker-trigger" /></a>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">조회조건</th>
						<td>
							<select class="w20p" name="searchKey" title="조회조건">
								<option value="">전체</option>
								<option value="sj">제목</option>
								<option value="cn">내용</option>
							</select>
							<input type="text" class="w50p" name="searchWord" title="검색어" />
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" id="btnSearch" class="btn btn_search"> 조회</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
			<div class="fr txt_right">
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="6%" />
				<col width="7%" />
				<col />
				<col width="10%" />
				<col width="7%" />
				<col width="7%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>유형</span></th>
					<th scope="col"><span>이름</span></th>
					<th scope="col"><span>제목</span></th>
					<th scope="col"><span>등록일</span></th>
					<th scope="col"><span>담당자</span></th>
					<th scope="col"><span>답변상태</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>
		
		<div class="fr txt_right">
		</div>
	</div>

</body>
</html>
