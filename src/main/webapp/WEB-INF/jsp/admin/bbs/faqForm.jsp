<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
		//목록버튼 이벤트
		$('.btnList').click(function(e){
			location.href = $(this).attr('href');
			e.preventDefault();
			return false;
		});
		
		//수정버튼 이벤트
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					return confirm(txt+'하시겠습니까?');
				},
				success:function(res){
					alert(txt+'되었습니다');
					$('.btnList').click();
				}
			});
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 클릭이벤트
		$('.btnDel').click(function(e){
			if(confirm('삭제하시겠습니까?')){
				$('#frm').attr('action', 'delete.do');
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
		
		//게시기간 변경이벤트
		$('[name="displayAt"]').change(function(){
			if($('[name="displayAt"]:checked').val() == 'Y'){
				$('[name="ntceBgnde"]').val('');
				$('[name="ntceEndde"]').val('');
				$('[name="ntceBgnde"]').prop('disabled', true);
				$('[name="ntceEndde"]').prop('disabled', true);
			}else{
				$('[name="ntceBgnde"]').prop('disabled', false);
				$('[name="ntceEndde"]').prop('disabled', false);
			}
		});
	});
</script>
</head>
<body>
	<form action="${empty eo?'insert':'update'}.do" id="frm" method="post" enctype="multipart/form-data">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="seqList" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="se" value="BSSE0004" />
		<input type="hidden" name="displayAt" value="Y">
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" colspan="4" class="txt_center">질문</th>
				</tr>
				<tr>
					<td colspan="4" class="p10">
						<input type="text" class="w100p" name="sj" title="제목" value="${eo.sj}" required/>
					</td>
				</tr>
				<tr>
					<th scope="row" colspan="4" class="txt_center">답변</th>
				</tr>
				<tr>
					<td colspan="4" class="p10">
						<textarea class="w100p" name="cn" title="내용" required rows="8">${eo.cn }</textarea>
					</td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="#" class="btn normal ${empty eo?'blue':'green'} mr10 btnSubmit">
					<i class="far ${empty eo?'fa-save':'fa-edit' } mr5"></i>
					${empty eo?'등록':'수정'}
				</a>
			<c:if test="${!empty eo}">
				<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
			</c:if>
				<a href="faqList.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
</body>
</html>
