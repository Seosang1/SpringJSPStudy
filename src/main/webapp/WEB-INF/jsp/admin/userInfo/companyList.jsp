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
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(e){
			$('#frm').attr('action', 'companyForm.do');
			$('#frm [name="userId"]').val($(this).data('sn'));
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		//검색버튼 클릭이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('.btn_search').click();
				e.preventDefault();
			}
			return false;
		});
		
		//가입일자설정버튼 클릭이벤트
		$('.btn_form').click(function(){
			var date = new Date();
			var val = Number($(this).data('date'))
			if(val<365)
				date.add(val*-1);
			
			else if(val == 365){
				date.setMonth('00');
				date.setDate('01');
				
			}
			
			$('[name="bgnDt"]').val($.datepicker.formatDate('yy-mm-dd', date));
			$('[name="endDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
			
			if(val == 3650){
				$('[name="bgnDt"]').val('');
				$('[name="endDt"]').val('');				
			}

		});
		
		//탭 클릭이벤트
		$('.tab200 li').click(function(){
			$('.tab200 li').removeClass('on');
			$(this).addClass('on');
			$('[name="sttus"]').val($(this).data('sttus'));
			$('.btn_search').click();
		});
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/userInfo/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'));
			e.preventDefault();
			return false;
		});
		
		$('.tab200 li:eq(0)').click();
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
				
				if($('[name="corpNo"]:eq(1)').val() && !$('[name="corpNo"]:eq(0)').val()){
					alert('법인번호 앞자리를 입력해주세요');
					return false;
				}else
					$('[name="corpInfoVO.corpNo"]').val($('[name="corpNo"]:eq(0)').val()+'-'+$('[name="corpNo"]:eq(1)').val());
				
			},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td class="txt_left pl20"><a href="#" class="btnView" data-sn="'+this.userId+'">'+this.corpInfoVO.corpNm+'</a></td>';
					html += '<td>'+this.userId+'</td>';
					html += '<td>'+this.corpInfoVO.ceoNm+'</td>';
					html += '<td>'+this.bizno+'</td>';
					html += '<td>'+this.corpInfoVO.corpNo+'</td>';
					html += '<td>'+this.rgstDt.formatDate()+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="7">조회결과가 없습니다</td></tr>';
				
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
			<input type="hidden" name="sttus" value="USST0001" />
			<input type="hidden" name="se" value="USSE0002" />
			<input type="hidden" name="corpInfoVO.corpNo" value="" />
			
			<ul class="tab200" style="display:none">
				<li data-sttus="USST0001">사업주회원</li>
				<li data-sttus="USST0003">탈퇴회원</li>
			</ul>

			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">사업자등록번호</th>
						<td>
							<input type="text" class="w30p" name="bizno1" maxlength="3" hasnext number /> -
							<input type="text" class="w20p" name="bizno2" maxlength="2" hasnext number /> - 
							<input type="text" class="w40p" name="bizno3" maxlength="5" number />
						</td>
						<th scope="row">법인등록번호</th>
						<td>
							<input type="text" class="w40p" name="corpNo" maxlength="6" hasnext number /> -
							<input type="text" class="w40p" name="corpNo" maxlength="7" number /> 
						</td>
					</tr>
					<tr>
						<th scope="row">아이디</th>
						<td><input type="text" class="w100p" name="userId" /></td>
						<th scope="row">상호명</th>
						<td><input type="text" class="w100p" name="corpInfoVO.corpNm" /></td>
					</tr>
					<tr>
						<th scope="row">가입일자</th>
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
							<a href="#" class="btn btn_form ml10" data-date="0">오늘</a>
							<a href="#" class="btn btn_form ml10" data-date="1">어제</a>
							<a href="#" class="btn btn_form ml10" data-date="7">1주</a>
							<a href="#" class="btn btn_form ml10" data-date="30">1개월</a>
							<a href="#" class="btn btn_form ml10" data-date="60">2개월</a>
							<a href="#" class="btn btn_form ml10" data-date="365">당해년도</a>
							<a href="#" class="btn btn_form ml10" data-date="3650">전체</a>
						</td>
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
			<div class="fr txt_right">
				<a href="#" class="btn normal green mr10 btnExcelForm"><i class="far fa-file-excel mr5"></i> 엑셀다운로드</a>
			</div>
		</div>
		
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%">
				<col width="15%">
				<col width="15%">
				<col width="15%">
				<col width="17%">
				<col width="18%">
				<col width="15%">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>상호명</span></th>
					<th scope="col"><span>아이디</span></th>
					<th scope="col"><span>대표자명</span></th>
					<th scope="col"><span>사업자등록번호</span></th>
					<th scope="col"><span>법인등록번호</span></th>
					<th scope="col"><span>가입일</span></th>
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
