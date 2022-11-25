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
		 
		//초기화버튼클릭이벤트
		$('.search_wrap .grey').click(function(){
			$('[name="userId"]').val('');
			$('[name="nm"]').val('');
			$('[name="roleSn"]').val('0');
			$('[name="chgSe"]').val('');
			$('[name="bgnDt"]').val('');
			$('[name="endDt"]').val('');			
		});
			
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/stats/userListExcelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
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
					html += '<td>'+ this.rownum +'</td>';
					html += '<td>'+ this.trget +'</td>';
					html += '<td>'+ this.nm +'</td>';
					html += '<td>'+ this.roleNm +'</td>';
					html += '<td>'+ this.chgSeNm +'</td>';
					html += '<td>'+ this.rgstDt +'</td>';
					html += '<td>'+ this.rgstNM +'</td>';
					html += '</tr>';
				});
				
				if(!html){
					html = '<tr><td colspan="7">조회결과가 없습니다</td></tr>';
				
				}else{
					$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo+'/'+res.vo.totalPage+' 페이지 ');
					cwmaList.setPage(res.vo);	
				}
						
				$('#result').html(html);
			}
		});
	};
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">권한ID</th>
						<td>
							<input type="text" name="userId" title="권한ID"/>
						</td>
						<th scope="row">사용자명</th>
						<td>
							<input type="text" name="nm" title="사용자명"/>
						</td>
					</tr>
					<tr>
						<th scope="row">권한명</th>
						<td>
							<select class="w50p" name="roleSn" title="권한">
								<option value="0">전체</option>
								<c:forEach var="list" items="${roleList }" varStatus="sts">
									<option value="${list.roleSn }">${list.roleDc }</option>
								</c:forEach>
							</select>
							
						</td>
						<th scope="row">유형</th>
						<td>
							<select class="w50p" name="chgSe" title="유형">
								<option value="">전체</option>
								<c:forEach var="list" items="${codeList }" varStatus="sts">
									<option value="${list.cdId }">${list.cdNm }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">조회일</th>
						<td colspan="3">
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnDt" title="시작일">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endDt" title="종료일">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<a href="#" class="btn btn_search mr10"><i class="fas fa-search mr5"></i> 조회</a>
				<a href="#" class="btn normal grey"><i class="far fa-sticky-note mr5"></i> 초기화</a>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 ${vo.totalCnt} 건 | ${vo.pageNo}/${vo.totalPage} 페이지 </span>
		</div>
		<table class="tbl tbl_data">
			<thead>
				<tr>
					<th>번호</th>
					<th>권한ID</th>
					<th>사용자명</th>
					<th>권한명</th>
					<th>유형</th>
					<th>일자</th>
					<th>작업자</th>
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
