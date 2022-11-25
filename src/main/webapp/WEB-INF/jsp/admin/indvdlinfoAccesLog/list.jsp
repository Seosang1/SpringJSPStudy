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
		$('#btnSearch').click(function(e){
			$('#frm').attr('action', 'list.do');
			ajaxList(1);
			e.preventDefault();
			return false;
		});

		//엑셀다운버튼 이벤트
		$('.excel').click(function(e){
			cwma.showExcelPop('/admin/indvdlinfoAccesLog/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), false);
			e.preventDefault();
			return false;
		});

		$('#btnSearch').click();
	});

	//리스트조회 함수
	function ajaxList(pageNo){
		$('[name="pageNo"]').val(pageNo);
		$('#frm').attr('action', 'list.do');
		$('#frm').ajaxCwma({
			success:function(res){
			var html = '';
			$(res.list).each(function(){
				html += '<tr>';
				html += '<td>'+this.rownum+'</td>';
				html += '<td>'+this.userVO.userName+'</td>';
				html += '<td>'+this.userVO.brffcNm+'</a></td>';
				html += '<td>'+this.accesDt+'</td>';
				html += '<td>'+this.ip+'</td>';
				html += '<td>'+this.trgetId+'</td>';
				html += '<td>'+this.nwDdcerNo+'</td>';
				html += '<td>'+this.seNm+'</td>';
				html += '<td>'+this.menuNm+'</td>';
				html += '</tr>';
			});

			$('#result').html(html);
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
					<col style="width: 120px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">접속일자</th>
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
						<th scope="row">접근메뉴</th>
						<td>
							<select class="w20p" name="menuSn" title="조회조건-접근메뉴">
								<option value="0">전체</option>
							<c:forEach var="ceo" items="${menuList}">
								<option value="${ceo.menuSn}">${ceo.menuDc}</option>
							</c:forEach>
							</select>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<button type="submit" id="btnSearch" class="btn btn_search mr10"> <i class="fas fa-search mr5"></i> 조회</button>
				<button type="reset" class="btn normal grey"> <i class="far fa-sticky-note mr5"></i> 초기화</button>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 0 건 | 1/1 페이지 </span>
			<div class="fr txt_right">
				<button type="button" class="btn normal green mr10 excel"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드 </button>
			</div>
		</div>
		
		<table class="tbl tbl_data">
			<colgroup>
				<col width="7%" />
				<col width="10%" />
				<col width="12%" />
				<col width="15%" />
				<col width="10%" />
				<col width="12%" />
				<col width="12%" />
				<col width="8%" />
				<col width="15%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>접근자명</span></th>
					<th scope="col"><span>접근자부서</span></th>
					<th scope="col"><span>접근일시</span></th>
					<th scope="col"><span>접근IP</span></th>
					<th scope="col"><span>대상ID</span></th>
					<th scope="col"><span>신피공제자번호</span></th>
					<th scope="col"><span>구분</span></th>
					<th scope="col"><span>메뉴명</span></th>
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
