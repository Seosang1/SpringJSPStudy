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
			$('#frm').attr('action', 'view.do');
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('seq')+'" />');
			$('#frm').submit();
		});

		//엑셀다운버튼 이벤트
		$('.excel').click(function(e){
			cwma.showExcelPop('excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), true);
			e.preventDefault();
			return false;
		});
		
		//기간설정버튼 클릭이벤트
		$('.btn_form').click(function(){
			var date = new Date();
			var type = $(this).data('type');
			
			if(type == 'full'){
				$(this).parent().find('input').val('');
				
			}else{
				if(type == 'year'){
					date.setMonth('00');
					date.setDate('01');
				}else{
					date.add(Number(type));
				}
				
				$(this).parent().find('input:eq(0)').val($.datepicker.formatDate('yy-mm-dd', date));
			}
		});
		
		$('.btn_form:eq(0)').click();
		$('#btnSearch').click();
	});

	//리스트조회 함수
	function ajaxList(pageNo){
		var bizno = $('[name^="bizno"]').get().map(function(o){return o.value}).join('-');
		var data = {};
		
		if(bizno != '--')
			data.bizno = bizno;
		
		$('[name="pageNo"]').val(pageNo);
		$('#frm').attr('action', 'issuList.do');
		$('#frm').ajaxCwma({
			data:data,
			beforeSubmit:function(res){
				if($('[name="bizno1"]').val() || $('[name="bizno2"]').val() || $('[name="bizno3"]').val()){
					if($('[name="bizno1"]').val().length < 3){
						alert('사업자등록번호 앞자리를 입력해주세요')
						return false;
						
					}else if($('[name="bizno2"]').val().length < 2){
						alert('사업자등록번호 가운데자리를 입력해주세요')
						return false;
						
					}else if($('[name="bizno3"]').val().length < 5){
						alert('사업자등록번호 뒷자리를 입력해주세요')
						return false;
					}
				}
				
			},
			success:function(res){
			var html = '';
			$(res.list).each(function(){
				html += '<tr>';
				html += '<td>'+this.rownum+'</td>';
				html += '<td>'+(this.issuVO.issuDt?this.issuVO.issuDt.formatDate():'')+'</td>';
				html += '<td>'+this.issuVO.issuNo+'</td>';
				html += '<td>'+this.se+(this.se == '발주자'?'('+this.cl+')':'')+'</td>';
				html += '<td>'+this.corpNm+'</td>';
				html += '<td>'+this.applcntBizno+'</td>';
				html += '<td>'+this.issuVO.issuLabrrCo+'명</td>';
				html += '<td>'+this.issuCo+'</td>';
				html += '<td>'+this.userVO.brffcNm+'</td>';
				html += '<td>'+this.userVO.userName+'</td>';
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
		<form id="frm" action="" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">지사/센터</th>
					<td>
						<select class="w30p" name="userVO.ddcAstcCd">
							<option value="">전체</option>
							<c:forEach var="list" items="${ddcAsctList }" varStatus="sts">
							<option value="${list.ddcAsctCd }">${list.ddcAsctNm }</option>
							</c:forEach>
						</select>
					</td>
					<th scope="row">사업자등록번호(고유번호)</th>
					<td>
						<input type="text" name="bizno1" title="사업자등록번호 앞 자리" maxlength="3" hasnext number value="" class="w30p"> -
						<input type="text" name="bizno2" title="사업자등록번호 가운데 자리" maxlength="2" hasnext number value="" class="w30p"> -
						<input type="text" name="bizno3" title="사업자등록번호 뒷 자리" maxlength="5" number value="" class="w30p">
					</td>
				</tr>
				<tr>
					<th scope="row">상호 또는 기관명</th>
					<td><input type="text" class="w100p" name="corpNm" title="상호 또는 기관명" /></td>
					<th scope="row">발급번호</th>
					<td><input type="text" class="w100p" name="issuVO.issuNo" /></td>
				</tr>
				<tr>
					<th scope="row">발급일</th>
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
						<button type="button" class="btn btn_form ml10" data-type="0">오늘</button>
						<button type="button" class="btn btn_form ml10" data-type="-1">어제</button> 
						<button type="button" class="btn btn_form ml10" data-type="-7">1주</button>
						<button type="button" class="btn btn_form ml10" data-type="-30">1개월</button>
						<button type="button" class="btn btn_form ml10" data-type="-60">2개월</button>
						<button type="button" class="btn btn_form ml10" data-type="year">당해년도</button>
						<button type="button" class="btn btn_form ml10" data-type="full">전체</button>
					</td>
				</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<button type="submit" id="btnSearch" class="btn btn_search mr10"> <i class="fas fa-search mr5"></i> 조회</button>
				<button type="reset" class="btn normal grey"> <i class="far fa-sticky-note mr5"></i>  초기화</button>
			</div>
		</form>
	</div>
	
	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건  |	1/1 페이지 </span>
			<div class="fr txt_right">
				<button type="button" class="btn normal green mr10 excel"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드 </button>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="8%" />
				<col width="10%" />
				<col width="5%" />
				<col />
				<col width="10%" />
				<col width="8%" />
				<col width="5%" />
				<col width="8%" />
				<col width="7%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">일련번호</th>
					<th scope="col"><span>발급일자</span></th>
					<th scope="col"><span>발급번호</span></th>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>상호 또는 기관명</span></th>
					<th scope="col"><span>사업자등록번호</span></th>
					<th scope="col"><span>보유 근로자 수</span></th>
					<th scope="col"><span>발급부수</span></th>
					<th scope="col"><span>소속부서</span></th>
					<th scope="col"><span>담당자</span></th>
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
