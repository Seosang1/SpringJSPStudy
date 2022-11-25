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
		$('#result').on('click', '.btnView', function(e){
			$('#frm').attr('action', 'dataView.do');
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		//검색버튼 클릭이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('#btnSearch').click();
				e.preventDefault();
			}
			return false;
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
					html += '<td class="txt_left pl20"><a href="#" class="btnView" data-sn="'+this.sn+'">'+this.sj+'</a></td>';
					html += '<td>';
					
					$(this.fileVO).each(function(){
						html +='<a href="../../common/download.do?fileSn='+this.fileSn+'&parntsSe='+this.parntsSe+'&parntsSn='+this.parntsSn+'" title="'+this.orginlFileNm+'">';
						html +='<img src="../../static/admin/images/file_icon/'+(this.extsn.toLowerCase())+'.gif" alt="'+this.orginlFileNm+'" />';
						html +='</a>';
					});
					
					html += '</td>';
					html += '<td>'+this.rgstId+'</td>';
					html += '<td>'+this.rdcnt+'</td>';
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
			<input type="hidden" name="se" value="BSSE0002" />
			
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 120px;" />
					<col />
				</colgroup>
				<tbody>
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
							<select class="w20p" name="cl" title="조회조건-서식분류">
								<option value="">전체</option>
							<c:forEach var="ceo" items="${clList}">
								<option value="${ceo.cdId}" ${ceo.cdId eq eo.cl?'selected':''}>${ceo.cdNm}</option>
							</c:forEach>
							</select>
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
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="8%" />
				<col />
				<col width="8%" />
				<col width="8%" />
				<col width="8%" />
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>유형</span></th>
					<th scope="col"><span>제목</span></th>
					<th scope="col"><span>첨부</span></th>
					<th scope="col"><span>작성자</span></th>
					<th scope="col"><span>조회수</span></th>
					<th scope="col"><span>등록일</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>
		
		<div class="fr txt_right">
			<a href="dataForm.do" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 등록</a>
		</div>
	</div>

</body>
</html>
