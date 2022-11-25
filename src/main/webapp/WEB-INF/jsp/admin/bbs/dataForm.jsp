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
		
		//초기화
		$('#editor').summernote({
			  height: 300,                 // 에디터 높이
			  minHeight: null,             // 최소 높이
			  maxHeight: null,             // 최대 높이
			  focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
			  lang: "ko-KR",					// 한글 설정
		});
		
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
					if($('[name="displayAt"]:checked').val() == 'N'){
						if(!$('[name="ntceBgnde"]').val()){
							alert('게시기간 시작일을 입력해주세요');
							return false;
							
						}else if(!$('[name="ntceEndde"]').val()){
							alert('게시기간 종료일을 입력해주세요');
							return false;
						}
					}
					
					if($('.datepicker:eq(0)').val() && $('.datepicker:eq(1)').val()){
						if($('.datepicker:eq(0)').val() > $('.datepicker:eq(1)').val()){
							alert('게시기간 종료일은 시작일보다 크게 입력해주세요');
							return false;
						}
					}
					
					if($("#editor").val() == null || $("#editor").val() == ""){
						alert('내용을 입력해주세요');
						return false;						
					}
					
					$('[name="cn"]').val($("#editor").val());
					
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
		<input type="hidden" name="se" value="BSSE0002" />
		<input type="hidden" name="displayAt" value="Y">
		<textarea name="cn" style="display:none">${eo.cn }</textarea>
		
		<table class="tbl tbl_form">
			<colgroup>
				<col width="10%" />
				<col width="40%" />
				<col width="10%" />
				<col width="40%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>유형</th>
					<td colspan="3">
						<select name="cl" class="w20p" required title="유형">
							<option value="">유형선택</option>
						<c:forEach var="ceo" items="${clList}">
							<option value="${ceo.cdId}" ${ceo.cdId eq eo.cl?'selected':''}>${ceo.cdNm}</option>
						</c:forEach>
						</select>
					</td>
				</tr>
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
					<td colspan="4" class="p10">
						<textarea id="editor" name="editor">${eo.cn }</textarea>
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
				<a href="dataList.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
</body>
</html>
