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
			cwma.showExcelPop('/admin/holdCrtf/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
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
		
		//영수증버튼 클릭
		$('#result').on('click', 'button', function(){
			var top = screen.height/2 - 620/2;
			var left = screen.width/2 - 700/2;
			var option = 'width = 700px , height = 620px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no';
			
			window.name ="CWMA_SKILL_WINDOW";
			window.open('', 'holdCrtpRptPop', option);
			
			$('#rptFrm [name="sn"]').val($(this).data('sn'));
			$('#rptFrm').attr('action', 'rptPop.do');
			$('#rptFrm').attr('target', 'holdCrtpRptPop');
			$('#rptFrm').submit();
		});
		
		$('[data-type="0"]').click();
		$('#btnSearch').click();
	});

	//리스트조회 함수
	function ajaxList(pageNo){
		var bizno = $('[name^="bizno"]').get().map(function(o){return o.value}).join('-');
		var data = {};
		
		if(bizno != '--')
			data.bizno = bizno;
		
		$('[name="pageNo"]').val(pageNo);
		$('#frm').attr('action', 'list.do');
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
					html += '<td>'+this.se+(this.se == '발주자'?'<br />('+this.cl+')':'')+'</td>';
					html += '<td>'+(this.sptSe?this.sptSe:'')+'</td>';
					html += '<td>'+this.recptSe+'</td>';
					html += '<td><a href="#" class="btnView" data-seq="'+this.sn+'">'+this.rgstId+'</a></td>';
					html += '<td><a href="#" class="btnView" data-seq="'+this.sn+'">'+this.corpNm+'</a></td>';
					html += '<td>'+this.applcntBizno+'</td>';
					html += '<td>'+this.reqstDt.formatDate()+'</td>';
					html += '<td>'+(this.issuDt?this.issuDt.formatDate():'')+'</td>';
					html += '<td>'+this.issuCo+'</td>';
					html += '<td><a href="#" class="btnView" data-seq="'+this.sn+'">'+(this.progrsVO?this.progrsVO.progrsSttusNm:'해당없음')+'</a></td>';
					html += '<td style="display:none">'+this.setleSe+'</td>';
					html += '<td style="display:none"><button type="button" class="btn btn_form mr10" data-sn="'+this.sn+'">영수증</button></td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="13">조회결과가 없습니다</td></tr>';
	
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo.formatMoney()+'/'+res.vo.totalPage.formatMoney()+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	}
</script>
</head>
<body>
	<form id="rptFrm" action="" method="post">
		<input type="hidden" name="sn" value="" />
		<input type="hidden" name="title" value="건설기능인보유증명서영수증" />
	</form>

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
					<th scope="row">상호 또는 기관명</th>
					<td><input type="text" class="w100p" name="corpNm" title="상호 또는 기관명" /></td>
					<th scope="row">결제구분</th>
					<td>
						<select class="w30p" name="setleSe">
							<option value="">전체</option>
							<c:forEach var="list" items="${payList }" varStatus="sts">
							<option value="${list.cdId }">${list.cdNm }</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">아이디</th>
					<td><input type="text" class="w100p" name="rgstId" /></td>
					<th scope="row">사업자등록번호(고유번호)</th>
					<td>
						<input type="text" name="bizno1" title="사업자등록번호 앞 자리" maxlength="3" hasnext number value="" class="w30p"> -
						<input type="text" name="bizno2" title="사업자등록번호 가운데 자리" maxlength="2" hasnext number value="" class="w30p"> -
						<input type="text" name="bizno3" title="사업자등록번호 뒷 자리" maxlength="5" value="" number class="w30p">
					</td>
				</tr>
				<tr>
					<th scope="row">증빙서류 신청</th>
					<td colspan="3">
						<label><input name="progrsVO.progrsSttus" value="" type="radio" checked>전체</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0001" type="radio">해당없음</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0002" type="radio">접수</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0003" type="radio">처리중</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0004" type="radio">보완</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0006" type="radio">반려</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0007" type="radio">제출완료</label>
						<label><input name="progrsVO.progrsSttus" value="CAPG0009" type="radio">처리완료</label>
					</td>
				</tr>
				<tr>
					<th scope="row">신청일</th>
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
				<tr>
					<th scope="row">발급일</th>
					<td colspan="3">
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="issuBgnDt">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<span class="fuhao">~</span>
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="issuEndDt">
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
			<em class="ml10 orange">* 증빙서류 신청 승인 절차는 온라인 신청만 해당됩니다.</em>
			<div class="fr txt_right">
				<button type="button" class="btn normal green mr10 excel"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드 </button>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="11%" />
				<col width="5%" />
				<col width="5%" />
				<col width="5%" />
				<col />
				<col width="8%" />
				<col width="7%" />
				<col width="7%" />
				<col width="5%" />
				<col width="5%" />
<%-- 				<col width="5%" /> --%>
<%-- 				<col width="5%" /> --%>
			</colgroup>
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>접수방법</span></th>
					<th scope="col"><span>발급형태</span></th>
					<th scope="col"><span>등록ID</span></th>
					<th scope="col"><span>상호 또는 기관명</span></th>
					<th scope="col"><span>사업자등록번호</span></th>
					<th scope="col"><span>신청일</span></th>
					<th scope="col"><span>발급일</span></th>
					<th scope="col"><span>발급부수</span></th>
					<th scope="col"><span>증빙서류신청</span></th>
<!-- 					<th scope="col"><span>결재구분</span></th> -->
<!-- 					<th scope="col"><span>영수증</span></th> -->
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
