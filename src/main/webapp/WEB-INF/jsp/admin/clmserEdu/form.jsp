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

});


onCloseMonitorWindowCu = function(){
	if(uploader.getUploadStatus() == 'COMPLETION'){
		// 업로드된 전체 파일의 정보를 가져옵니다.
		var uploadedFilesInfo = uploader.getUploadedFilesInfo();
		var obj = jQuery.parseJSON(uploadedFilesInfo);
		$('[name^="fileVO."]').remove();
		
		$(obj).each(function(i){
			for(var key in this){
				$('#frm').append('<input type="hidden" name="fileVO['+i+'].'+key+'" value="'+this[key]+'" />');
			}
		});
		
		isUploading = false;
	}
}
</script>
</head>
<body>
<form action="${empty eo?'insert':'update'}.do" id="frm" method="post">
	<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
	
	<table class="tbl tbl_form">
		<colgroup>
			<col width="15%" />
			<col width="" />
		</colgroup>
		<tbody>
			<tr>
				<th scope="row"><em class="required">*</em>제목</th>
				<td>
					<input type="text" class="w100p" name="sj" title="제목" value="${eo.sj}" required/>
				</td>
			</tr>
			<tr>
				<th scope="row"><em class="required">*</em>영상URL</th>
				<td>
					<input type="text" class="w100p" name="vidoUrl" title="영상URL" value="${eo.vidoUrl}" required/>
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
			<a href="list.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
		</div>
	</div>
</form>
</body>
</html>
