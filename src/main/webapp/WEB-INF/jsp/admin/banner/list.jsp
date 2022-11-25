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
		$('#result').on('click', '.btnView', function(ㄷ){
			$('#frm').attr('action', 'form.do');
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('seq')+'" />');
			$('#frm').submit();
			
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
		
		$('.blue').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').submit();
			
			e.preventDefault();
			return false;
		});
		
		//탭클릭 이벤트
		$('.tab200 li').click(function(){
			$('.tab200 li').removeClass('on');
			$(this).addClass('on');
			$('#frm [name="se"]').val($(this).data('se'));
			$('#btnSearch').click();
		});

		$('.tab200 li.on').click();
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
					html += '<td style="text-align:left;"><a href="#" class="btnView" data-seq="'+this.sn+'">'+this.bannerNm+'</a></td>';
					html += '<td>'+this.ordr+'</td>';
					html += '<td>'+this.bgnde+' ~ '+this.endde+'</td>';
					html += '<td>'+this.displayAt+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="5">조회결과가 없습니다</td></tr>';
	
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
		<ul class="tab200">
			<li ${empty param.se or param.se eq 'BASE0001'?'class="on"':''} data-se="BASE0001">알림배너</li>
		</ul>
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="10" />
			<input type="hidden" name="se" value="" />
			
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 120px;" />
					<col />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">등록일</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnde">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
							<span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endde">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" class="ui-datepicker-trigger" /></a>
							</div>
						</td>
					</tr>
					<tr>
						<th scope="row">배너명</th>
						<td>
							<input type="text" class="w100p" name="bannerNm" title="검색어" />
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
				<col />
				<col width="8%" />
				<col width="17%" />
				<col width="7%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">No</th>
					<th scope="col"><span>배너명</span></th>
					<th scope="col"><span>노출순서</span></th>
					<th scope="col"><span>노출기간</span></th>
					<th scope="col"><span>게시상태</span></th>
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		
		<div class="paging">
		</div>
		
		<div class="fr txt_right">
			<a href="form.do" class="btn normal blue mr10"><i class="far fa-save mr5"></i>등록</a>
		</div>
	</div>

</body>
</html>
