<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
var cwmaFile;

$(function(){
	cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0007', parntsSn:$('[name="sn"]').val(), allowExt:['JPG', 'JPEG', 'PNG'], maxSize:1});
	cwmaFile.setFileList(true);
	
	//목록버튼 이벤트
	$('.btnList').click(function(e){
		location.href = $(this).attr('href');
		e.preventDefault();
		return false;
	});

	//수정버튼 이벤트
	$('.btnSubmit').click(function(e){
		var txt = $(this).text().trim();
		var delIdx = 0;
		
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				if($('.datepicker:eq(0)').val() && $('.datepicker:eq(1)').val()){
					if($('.datepicker:eq(0)').val() > $('.datepicker:eq(1)').val()){
						alert('노출기간 종료일은 시작일보다 크게 입력해주세요');
						return false;
					}
				}
				
				if($(".btnFileDel").length == 0){
					alert('이미지를 입력해주세요.');
					return false;
				}
				
				return true;
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

</script>
</head>
<body>
	<form action="${empty eo?'insert':'update'}.do" id="frm" method="post">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="se" value="${empty eo?param.se:eo.se}" />
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="15%" />
				<col width="" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>배너명</th>
					<td>
						<input type="text" class="w100p" name="bannerNm" title="배너명" value="${eo.bannerNm}" required/>
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>대체 텍스트</th>
					<td>
						<input type="text" class="w100p" name="imageDc" title="대체 텍스트" value="${eo.imageDc}" required/>
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>사용 여부</th>
					<td>
						<label><input type="radio" class="" name="useYn" title="사용" value="Y" ${eo.useYn eq 'Y'?'checked':'' or eo.useYn eq null ?'checked':''}/>사용</label>
						<label><input type="radio" class="" name="useYn" title="미사용" value="N" ${eo.useYn eq 'N'?'checked':'' }/>미사용</label>
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>이미지</th>
					<td class="p5" id="fileLayer"></td>
				</tr>
				<tr>
					<th scope="row">링크URL</th>
					<td>
						<input type="text" class="w50p" name="url" title="URL" value="${eo.url}" />
					</td>
				</tr>
				<tr>
					<th scope="row">노출기간</th>
					<td>
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="bgnde" title="노출기간 시작일" value="${eo.bgnde}">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<span class="fuhao"> ~ </span>
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="endde" title="노출기간 종료일" value="${eo.endde}">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>노출순서</th>
					<td><input type="text" class="w100p" name="ordr" title="순서" value="${eo.ordr}" required/></td>
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
				<a href="list.do?se=${eo.se }" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>

</body>
</html>
