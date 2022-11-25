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
		
		//등록/수정버튼 이벤트 - submit
		$('.btnSubmit').click(function(e){
			$('#updFrm').attr('action', $(this).attr('href'));
			$('#updFrm').ajaxCwma({
				success:function(res){
					$('#updFrm input').val('');
					alert('등록 되었습니다');
					$('.btn_search').click();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 이벤트
		$('.btnDel').click(function(e){
			if($('#result [name="ip"]:checked').length){
			    $('#frm [name="ip"]').val($('#result [name="ip"]:checked').val());
			    
			}else{
			    alert('삭제할 접속IP를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			if(!confirm('삭제하시겠습니까?')){
				e.preventDefault();
				return false;
			}
			
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					$('#frm [name="ip"]').val('');
					alert('삭제되었습니다');
					$('.btn_search').click();
				}
			});
			
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
					html += '<tr>';
					html += '<td><input type="radio" name="ip" value="'+this.ip+'"></td>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td>'+this.ip+'</td>';
					html += '<td>'+this.se+'</td>';
					html += '</tr>';
				});
				
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
			<input type="hidden" name="ip" value="">
		</form>
		
		<form action="" id="updFrm" method="post">
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 40%;">
					<col style="width: 10%;">
					<col style="width: 40%;">
				</colgroup>
				<tbody>
					<tr>
						<td colspan="2" class="pl20">접속가능IP를 관리할 수 있습니다.</td>
					</tr>
					<tr>
						<th scope="row">접속IP</th>
						<td>
							<input type="text" class="w100p" name="ip" title="접속IP" value="" required>
						</td>
						<th scope="row">구분</th>
						<td>
							<input type="text" class="w100p" name="se" title="구분" required>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 등록</a>
				<a href="#" class="btn btn_search" style="display:none">조회</a>
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
				<col style="width: 40%;">
				<col style="">
			</colgroup>
			<thead>
				<tr>
					<th scope="col">선택</th>
					<th scope="col"><span>No</span></th>
					<th scope="col"><span>접속IP</span></th>
					<th scope="col"><span>구분</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>

		<div class="fr txt_right">
			<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>접속IP삭제</a>
		</div>
	</div>

</body>
</html>
