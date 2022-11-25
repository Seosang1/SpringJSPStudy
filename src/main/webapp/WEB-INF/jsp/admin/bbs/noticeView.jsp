<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<script type="text/javascript">
		
		$(function(){
			
			$('.content').html($('.content').text().replace(/\&lt;/g,'<').replace(/\&gt\;/g,'>'));
			
			//수정버튼 이벤트
			$('.btnForm').click(function(e){
				$('#frm').attr('action', $(this).attr('href'));
				$('#frm').submit();
				e.preventDefault();
				return false;
			});
			
			//삭제버튼 클릭이벤트
			$('.btnDel').click(function(e){
				if(confirm('삭제하시겠습니까?')){
					$('#frm').attr('action', $(this).attr('href'));
					$('#frm').ajaxCwma({
						success:function(){
							alert('삭제되었습니다');
							$('.btnList').click();
						}
					});
				}
				e.preventDefault();
				return false;
			});
			
			//목록버튼 클릭이벤트
			$('.btnList').click(function(e){
				cwma.queryStringToInput($('[name="queryStr"]').val());
				$('#frm').attr('action', $(this).attr('href'));
				$('#frm').submit();
				e.preventDefault();
				return false;
			});
		});
	</script>
</head>
<body>
	<form action="" id="frm" method="post">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="seqList" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="se" value="BSSE0001" />
		<input type="hidden" name="queryStr" value="${vo.queryStr}" />
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" colspan="4" class="brdtit">${eo.sj}</th>
				</tr>
				<tr>
					<th scope="row">유형</th>
					<td>${empty eo.clNm?'전체':eo.clNm}</td>
					<th scope="row">작성자</th>
					<td>${eo.userVO.brffcAbrvtNm } ${eo.userVO.brffcNm } ${eo.userVO.userName }</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td date>${eo.rgstDt }</td>
					<th scope="row">조회수</th>
					<td money>${eo.rdcnt }</td>
				</tr>
				<tr>
					<td colspan="4" class="p20 content">
						${eo.cn}
					</td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="noticeForm.do" class="btn normal green mr10 btnForm"><i class="far fa-edit mr5"></i>수정</a>
				<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
				<a href="noticeList.do" class="btn normal black mr10 btnList"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
</body>
</html>
