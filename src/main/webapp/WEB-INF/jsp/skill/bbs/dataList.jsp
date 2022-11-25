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
		$('#button-addon2').click(function(e){
			$('#frm').attr('action', 'list.do');
			ajaxList(1);
			e.preventDefault();
			return false;
		});
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(e){
			$('#frm').attr('action', 'dataView.do');
			$('[name="sn"]').remove();
			$('#frm').append('<input type="hidden" name="sn" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
			
			e.preventDefault();
			return false;
		});
		
		//엔터 이벤트
		$('[aria-describedby="button-addon2"]').keyup(function(e){
			if(e.keyCode == 13){
				$('#button-addon2').click();
				e.preventDefault();
			}
			return false;
		});
		
		//검색조건변경 이벤트
		$('#searchValue').change(function(e){
			$('[name="searchKey"]').val($("#searchValue option:selected").val());
		});
		
		
		//탭클릭 이벤트
		$('.file-tab a').click(function(){
			$('[name="cl"]').val($(this).data('cl'));
			$(".nav-link").removeClass("on");
			$("#file-"+$(this).attr("aria-controls")).addClass("on");
			$('#button-addon2').click();
		});
		
		//파일다운로드이벤트
		$('#result').on('click', 'a', function(e){
			var url = $(this).attr('href');
			
			if(!$(this).hasClass('btnView')){
				$('#frm').append('<input type="hidden" name="sn" value="'+cwma.parseQueryString($(this).attr('href'))['parntsSn']+'" />');
				$('#frm').attr('action', 'updateDwldCo.do');
				$('#frm').ajaxCwma({
					success:function(res){
						location.href = url;
					}
				});
			}
			
			e.preventDefault();
			return false;
		});
		
		$('.file-tab a.on').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				$('[name="searchWord"]').val($('[aria-describedby="button-addon2"]').val());
			},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					
					html +='<tr>';
					html +='<td class="bdtNoti">'+this.rownum+'</td>';
					html +='<td class="bdtTitle"><a href="#" class="btnView" data-sn="'+this.sn+'">'+this.sj+'</a></td>';
					html +='<td class="bdtFile">';
					$(this.fileVO).each(function(){
						html +='<a href="../../common/download.do?fileSn='+this.fileSn+'&parntsSe='+this.parntsSe+'&parntsSn='+this.parntsSn+'" title="'+this.orginlFileNm+'">';
						html +='<img src="../../static/skill/img/icon-'+(this.extsn.toLowerCase())+'.png" alt="'+(this.extsn.toLowerCase())+'아이콘">';
						html +='</a>';
					});
					html +='</td>';
					html +='<td class="bdtDwn">'+this.dwldCo.formatMoney()+'</td>';
					html +='<td class="bdtDate">'+this.rgstDt.formatDate()+'</td>';
					html +='<td class="bdtView">'+this.rdcnt.formatMoney()+'</td>';
					html +='</tr>';
				});
				
				if(!res.vo.totalCnt){
					html = '<tr><td colspan="6"><div class="text-center w-100 py-4">';
					html += '<i class="fas fa-edit none-page-icon-sm"></i><h5 class="color-md-gray mt-2">등록된 게시글이 없습니다.</h5>';
					
					if($('[name="searchWord"]').val())
						html += '<p class="color-md-gray" style="font-size: 0.9rem">※철자나 맞춤법 오류가 있는지 확인해주세요.<br>※여러 단어로 나누거나 다른 검색어로 검색해주세요.</p>';
						
					html += '</div></td></tr>';
				}
				
				$('#result').html(html);
				cwmaList.setPage(res.vo);
			}
		});
	};
	
</script>
</head>
<body>
	<form id="frm" action="" method="post">
		<input type="hidden" name="searchWord" value="${param.searchWord }" />
		<input type="hidden" name="searchKey" value="${param.searchKey }" />
		<input type="hidden" name="se" value="BSSE0002" />
		<input type="hidden" name="cl" value="${param.cl }" />
	</form>
<div id="wrap">
	<div id="contents">

		<div id="subTop" class="bg04">
			<div class="container">
				<h2 class="subTitle">알림마당</h2>
			</div>
			<div class="subNav">
				<div class="container">
					<ul>
						<li>홈</li>
						<li>알림마당</li>
						<li>자료실</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">자료실</h4>

				<ul class="subTab col5 file-tab">
					<li><a class="nav-link ${empty param.cl?'on':''}" id="file-tab1" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="${empty param.cl?'true':'false'}" data-cl="">전체</a></li>
					<li><a class="nav-link ${param.cl eq 'BDSE0001'?'on':''}" id="file-tab2" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="${param.cl eq 'BDSE0001'?'true':'false'}" data-cl="BDSE0001">관련 법령</a></li>
					<li><a class="nav-link ${param.cl eq 'BDSE0002'?'on':''}" id="file-tab3" data-toggle="tab" href="#tab3" role="tab" aria-controls="tab3" aria-selected="${param.cl eq 'BDSE0002'?'true':'false'}" data-cl="BDSE0002">연간 보고서</a></li>
					<li><a class="nav-link ${param.cl eq 'BDSE0003'?'on':''}" id="file-tab4" data-toggle="tab" href="#tab4" role="tab" aria-controls="tab4" aria-selected="${param.cl eq 'BDSE0003'?'true':'false'}" data-cl="BDSE0003">교육 자료</a></li>
					<li><a class="nav-link ${param.cl eq 'BDSE0004'?'on':''}" id="file-tab5" data-toggle="tab" href="#tab5" role="tab" aria-controls="tab5" aria-selected="${param.cl eq 'BDSE0004'?'true':'false'}" data-cl="BDSE0004">해외 동향</a></li>
				</ul><!-- subTab -->

				<table class="bdTb">
					<caption>자료실 번호, 제목, 글쓴이, 등록일, 조회수</caption>
					<colgroup>
						<col style="width: 100px" />
						<col style="width: auto" />
						<col style="width: 120px" />
						<col style="width: 120px" />
						<col style="width: 120px" />
						<col style="width: 120px" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>첨부파일</th>
							<th>다운로드수</th>
							<th>등록일</th>
							<th>조회수</th>
						</tr>
					</thead>
					<tbody id="result">
					</tbody>
				</table><!-- bdTb -->
			
				<div class="paging">
				</div><!-- paging -->
				

				<div class="brdSch">
					<select name="searchValue" id="searchValue">
						<option value="">전체</option>
						<option value="sj">제목</option>
						<option value="cn">내용</option>
					</select>
					<input type="text" name="" id="" placeholder="검색어를 입력해주세요" title="검색어를 입력해주세요." aria-label="검색어를 입력해주세요" aria-describedby="button-addon2" value="${param.searchWord}" />
					<a href="#" id="button-addon2">검색</a>
				</div>


			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</body>
</html>
