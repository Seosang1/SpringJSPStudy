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
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'form.do');
			$('#frm').append('<input type="hidden" name="cdId" value="'+$(this).data('seq')+'" />');
			$('#frm').submit();
		});
		
		//등록버튼 클릭 이벤트 - 팝업오픈
		$('.btnReg').click(function(e){
			$('#frmPop input').val('');
			$('#frmPop [name="cdId"]').prop('readonly', false);
			$('#frmPop [name="parntsCdId"]').prop('readonly', false);
		    $('#cmmnCdLayer .blue').show();
		    $('#cmmnCdLayer .green').hide();
			
			cwma.showMask();
	        $('#cmmnCdLayer').css("top",(($(window).height() - $('#cmmnCdLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#cmmnCdLayer').css("left",(($(window).width() - $('#cmmnCdLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
			if($('.data_wrap .layerpop')[0]){
				$('#cmmnCdLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}

			$('#cmmnCdLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//수정 버튼 클릭 이벤트 - 팝업오픈
		$('.btnUpd').click(function(e){
			if($('#result [name="cdId"]:checked').length){
				var tr = $('#result [name="cdId"]:checked').parents('tr');
				$('#frmPop [name="cdId"]').val(tr.find('td:eq(2)').text());
				$('#frmPop [name="parntsCdId"]').val(tr.find('td:eq(3)').text());
				$('#frmPop [name="cdNm"]').val(tr.find('td:eq(4)').text());
				$('#frmPop [name="cdDc"]').val(tr.find('td:eq(5)').text());
				$('#frmPop [name="sort"]').val(tr.data('sort'));
				$('#frmPop [name="cdId"]').prop('readonly', true);
				$('#frmPop [name="parntsCdId"]').prop('readonly', true);
			    
				$('#cmmnCdLayer .blue').hide();
				$('#cmmnCdLayer .green').show();
			    
			}else{
			    alert('수정할 코드를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			cwma.showMask();
			$('#cmmnCdLayer').css("top",(($(window).height() - $('#cmmnCdLayer').outerHeight()) / 2) + $(window).scrollTop());
			$('#cmmnCdLayer').css("left",(($(window).width() - $('#cmmnCdLayer').outerWidth()) / 2) + $(window).scrollLeft());
			
			if($('.data_wrap .layerpop')[0]){
				$('#cmmnCdLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}
			
	        $('#cmmnCdLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#cmmnCdLayer').hide();
			
			e.preventDefault();
			return false;			
		});
		
		//등록/수정버튼 이벤트 - submit
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#gParntsCdId').val("CODE0001");
			$('#frmPop').ajaxCwma({
				success:function(res){
					alert(txt+'되었습니다');
					$('.btn_search').click();
					$('.btnClose').click();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 이벤트
		$('.btnDel').click(function(e){
			if($('#result [name="cdId"]:checked').length){
			    $('#frmPop [name="cdId"]').val($('#result [name="cdId"]:checked').parents('tr').find('td:eq(2)').text());
			    
			}else{
			    alert('삭제할 코드를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			if(!confirm('삭제하시겠습니까?')){
				e.preventDefault();
				return false;
			}
			
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				beforeValid:false,
				success:function(res){
					alert('삭제되었습니다');
					$('.btn_search').click();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		$('#frm').submit(function(e){
			$('.btn_search').click();
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
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr data-sort='+this.sort+'>';
					html += '<td><input type="radio" name="cdId" value="'+this.cdId+'"></td>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td>'+this.cdId+'</td>';
					html += '<td>'+this.parntsCdId+'</td>';
					html += '<td>'+this.cdNm+'</td>';
					html += '<td>'+this.cdDc+'</td>';
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
			<input type="hidden" name="numOfPage" value="10" />
			<input type="hidden" name="gParntsCdId" value="CODE0001">
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;">
					<col style="">
				</colgroup>
				<tbody>
					<tr>
						<td colspan="2" class="pl20">시스템에 등록되어 있는 세부코드를 관리할 수 있습니다.</td>
					</tr>
					<tr>
						<th scope="row">검색대상</th>
						<td>
							<input type="radio" id="rad101" name="searchKey" value="" checked>
							<label for="rad101">전체</label>
							<input type="radio" id="rad102" name="searchKey" value="cdId">
							<label for="rad102">코드ID</label>
							<input type="radio" id="rad103" name="searchKey" value="parntsCdId">
							<label for="rad103">부모코드ID</label>
							<input type="radio" id="rad104" name="searchKey" value="cdNm">
							<label for="rad104">코드명</label>
							<input type="radio" id="rad105" name="searchKey" value="cdDc">
							<label for="rad105">코드설명</label>
						</td>
					</tr>
					<tr>
						<th scope="row">검색어</th>
						<td>
							<input type="text" class="w50p" name="searchWord" title="검색어">
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search"><i class="fas fa-search mr5"></i>조회</a>
			</div>
		</form>
	</div>
	
	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col style="width: 5%;">
				<col style="width: 5%;">
				<col style="width: 15%;">
				<col style="width: 15%;">
				<col style="width: 20%;">
				<col style="">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col"><span>No</span></th>
					<th scope="col"><span>코드ID</span></th>
					<th scope="col"><span>부모코드ID</span></th>
					<th scope="col"><span>코드명</span></th>
					<th scope="col"><span>코드설명</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>

		<div class="fr txt_right">
			<a href="#" class="btn normal blue mr10 btnReg"><i class="far fa-save mr5"></i>등록</a>
			<a href="#" class="btn normal green mr10 btnUpd"><i class="far fa-edit mr5"></i>수정</a>
			<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
		</div>
		
		<div id="cmmnCdLayer" class="layerpop" style="width: 900px; height: 220px; display: none; position:absolute; z-index:99999">
			<div class="layerpop_area">
				<div class="title">코드 등록 / 수정</div>
				<a href="#" class="layerpop_close">
					<i class="far fa-window-close"></i>
				</a>
	
				<div class="pop_content">
					<form id="frmPop" action="insert.do" method="post">
					<input type="hidden" name="gParntsCdId" id="gParntsCdId" value="CODE0001">
						<table class="tbl tbl_form">
							<colgroup>
								<col width="13%">
								<col width="20%">
								<col width="13%">
								<col width="20%">
								<col width="13%">
								<col width="21%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">코드ID</th>
									<td><input type="text" class="w100p" maxlength="8" name="cdId" title="코드ID" required></td>
									<th scope="row">부모코드ID</th>
									<td><input type="text" class="w100p" maxlength="30" name="parntsCdId" title="부모코드ID" required></td>
									<th scope="row">코드명</th>
									<td><input type="text" class="w100p" maxlength="30" name="cdNm" title="코드명" required></td>
								</tr>
								<tr>
									<th scope="row">코드설명</th>
									<td colspan="3"><input type="text" class="w100p" maxlength="30" title="코드설명" name="cdDc"></td>
									<th scope="row">순번</th>
									<td><input type="text" class="w100p" maxlength="30" name="sort" title="순번" number value="0"></td>
								</tr>
							</tbody>
						</table>
					</form>
					
					<div class="btn_wrap mb20">
						<div class="txt_center mt20">
							<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 등록</a>
							<a href="update.do" class="btn normal green mr10 btnSubmit"><i class="far fa-edit mr5"></i> 수정</a>
							<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>

</body>
</html>
