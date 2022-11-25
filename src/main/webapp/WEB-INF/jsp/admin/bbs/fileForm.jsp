<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaFile;
	
	$(function(){
		cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0001', parntsSn:$('[name="sn"]').val()});
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
					
					if(confirm(txt+'하시겠습니까?')){
						
					}else{
						return false;
					}
					
					return true;
					
				}, success:function(res){
					alert(txt+'되었습니다');
					$('.btnList').click();
				}
			});
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 클릭이벤트
		$('.btnDel').click(function(){
			if(confirm('삭제하시겠습니까?')){
				$('#frm').attr('action', 'delete.do');
				$('#frm').ajaxCwma({
					success:function(){
						alert('삭제되었습니다');
						$('.btnList').click();
					}
				});
			}
		});
		
	});
	
</script>
</head>
<body>
	<form action="${empty eo?'insert':'update'}.do" id="frm" method="post" enctype="multipart/form-data"> 
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="seqList" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="se" value="BSSE0005" />
		<input type="hidden" name="displayAt" value="Y">
		<input type="hidden" name="cn" value="file"/>
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>제목</th>
					<td colspan="3">
						<input type="text" class="w100p" name="sj" title="제목" value="${eo.sj}" required/>
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>작성자</th>
					<td colspan="3">
						<c:if test="${!empty eo}">
							${eo.userVO.brffcAbrvtNm } ${eo.userVO.brffcNm } ${eo.userVO.userName }
						</c:if>
						<c:if test="${empty eo}">
							${adminLoginInfo.brffcAbrvtNm } ${adminLoginInfo.brffcNm } ${adminLoginInfo.userName }
						</c:if>
					</td>
				</tr>
				<tr>
					<td colspan="4" class="p5">
						<div id="fileLayer"></div>
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
				<a href="fileList.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
</body>
</html>
