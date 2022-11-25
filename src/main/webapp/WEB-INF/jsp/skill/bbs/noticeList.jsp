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
			$('#frm').attr('action', 'noticeView.do');
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
		$('.notice-tab a').click(function(){
			$('[name="cl"]').val($(this).data('cl'));
			$(".nav-link").removeClass("on");
			$("#notice-"+$(this).attr("aria-controls")).addClass("on");
			$('#button-addon2').click();
		});
		
		$('#button-addon2').click();
		
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
					html +='<td class="bdtUser">'+this.rgstId+'</td>';
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
		<input type="hidden" name="se" value="BSSE0001" />
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
						<li>공지사항</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">공지사항</h4>

				<ul class="subTab col5 notice-tab">
					<li><a class="nav-link ${empty param.cl?'on':''}" id="notice-tab1" data-toggle="tab" href="#tab1" role="tab" aria-controls="tab1" aria-selected="${empty param.cl?'true':'false'}" data-cl="">전체</a></li>
					<li><a class="nav-link ${param.cl eq 'BNSE0001'?'on':''}" id="notice-tab2" data-toggle="tab" href="#tab2" role="tab" aria-controls="tab2" aria-selected="${param.cl eq 'BNSE0001'?'true':'false'}" data-cl="BNSE0001">센터 소식</a></li>
					<li><a class="nav-link ${param.cl eq 'BNSE0002'?'on':''}" id="notice-tab3" data-toggle="tab" href="#tab3" role="tab" aria-controls="tab3" aria-selected="${param.cl eq 'BNSE0002'?'true':'false'}" data-cl="BNSE0002">뉴스보도</a></li>
					<li><a class="nav-link ${param.cl eq 'BNSE0003'?'on':''}" id="notice-tab4" data-toggle="tab" href="#tab4" role="tab" aria-controls="tab4" aria-selected="${param.cl eq 'BNSE0003'?'true':'false'}" data-cl="BNSE0003">관련 사례</a></li>
					<li><a class="nav-link ${param.cl eq 'BNSE0004'?'on':''}" id="notice-tab5" data-toggle="tab" href="#tab5" role="tab" aria-controls="tab5" aria-selected="${param.cl eq 'BNSE0004'?'true':'false'}" data-cl="BNSE0004">기타</a></li>
				</ul><!-- subTab -->

				<table class="bdTb">
					<caption>공지사항 번호, 제목, 글쓴이, 등록일, 조회수</caption>
					<colgroup>
						<col style="width: 100px" />
						<col style="width: auto" />
						<col style="width: 120px" />
						<col style="width: 120px" />
						<col style="width: 120px" />
					</colgroup>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>글쓴이</th>
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
