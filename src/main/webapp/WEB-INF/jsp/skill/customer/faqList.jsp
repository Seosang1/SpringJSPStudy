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
		
		$('.faq').on('click','dt', function(event){
			if($(this).is('.on')) {
				$(this).removeClass('on');
				$(this).next().slideUp('fast');
			}else {
				$('.faq dt').removeClass('on');
				$('.faq dd').slideUp('fast');
				$(this).addClass('on');
				$(this).next().slideDown('fast');
			}
		});
		
		//검색버튼 클릭이벤트
		$('#button-addon2').click(function(e){
			ajaxList(1);
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
		
		//검색버튼 클릭이벤트
		$('#button-addon2').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', '../bbs/list.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				$('[name="searchWord"]').val($('[aria-describedby="button-addon2"]').val());
			},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(i){
					html += '<dl>';
					html += '<dt>'+this.sj+'</dt>';
					html += '<dd>'+this.cn.replace(/\n/g, '<br />')+'</dd>';
					html += '</dl>';
				});
				
				
				$('#faqList').html(html);
				cwmaList.setPage(res.vo);
			}
		});
	};
</script>
</head>
<body>
<div id="wrap">
	<form id="frm" action="" method="post">
		<input type="hidden" name="searchWord" value="${param.searchWord }" />
		<input type="hidden" name="searchKey" value="${param.searchKey }" />
		<input type="hidden" name="se" value="BSSE0004" />
	</form>
	<div id="contents">

		<div id="subTop" class="bg06">
			<div class="container">
				<h2 class="subTitle">중독상담</h2>
			</div>
			<div class="subNav">
				<div class="container">
					<ul>
						<li>홈</li>
						<li>중독상담</li>
						<li>FAQ</li>
					</ul>
				</div>
			</div>
		</div><!-- subTop -->
		
		<div id="subCont">
			<div class="container">

				<h4 class="subName">FAQ</h4>
				
				<div class="brdSch">
					<dl>
						<dt>
							<select name="searchValue" id="searchValue">
								<option value="">전체</option>
								<option value="sj">제목</option>
								<option value="cn">내용</option>
							</select>
						</dt>
						<dd>
							<input type="text" class="form-control" placeholder="검색어를 입력해주세요"  title="검색어를 입력해주세요." aria-label="검색어를 입력해주세요" aria-describedby="button-addon2" value="${param.searchWord}" />
							<a href="#" id="button-addon2">검색</a>
						</dd>
					</dl>
				</div>
				<br>

				<div class="faq" id="faqList">
				</div>


				<div class="paging">
				</div><!-- paging -->


			</div><!-- container -->
		</div><!-- subCont -->



	</div><!-- contents -->
</div>
</body>
</html>
