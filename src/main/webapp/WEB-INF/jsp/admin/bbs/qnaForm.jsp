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
		//초기화
		cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0001', parntsSn:$('[name="sn"]').val()});
		cwmaFile.setFileList();		
		
		//초기화
		$('#editor').summernote({
			  height: 300,                 // 에디터 높이
			  minHeight: null,             // 최소 높이
			  maxHeight: null,             // 최대 높이
			  focus: true,                  // 에디터 로딩후 포커스를 맞출지 여부
			  lang: "ko-KR",					// 한글 설정
		});
		
		$('.xssContent').html($('.xssContent').text().replace(/&lt;/g,'<').replace(/&gt;/g,'>'));
		
		//목록버튼 이벤트
		$('.btnList').click(function(e){
			location.href = $(this).attr('href');
			e.preventDefault();
			return false;
		});
		
		//답변버튼 이벤트
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					if($("#editor").val() == null || $("#editor").val() == ""){
						alert('내용을 입력해주세요');
						return false;						
					}
					
					$('[name="answer"]').val($("#editor").val());
					
					if(confirm(txt+'하시겠습니까?')){
						return true;
					}else{
						return false;
					}
					
					
				}, success:function(res){
					if($('[name="smsRecptnAgreAt"]').val() == 'Y'){
						if(txt == '수정'){
							alert(txt+'되었습니다');
							$('.btnList').click();					
						}else{
							alert(txt+'되었습니다');
							$('.btnList').click();
						}
					}else{
						alert(txt+'되었습니다');
						$('.btnList').click();
					}
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
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#smsLayer').hide();
			
			e.preventDefault();
			return false;			
		});
		
		//SMS발송버튼 클릭 이벤트 - 팝업오픈
		$('.btnSms').click(function(e){
			$('#frmPop textarea').val('');
			cwma.showMask();
	        $('#smsLayer').css("top",(($(window).height() - $('#smsLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#smsLayer').css("left",(($(window).width() - $('#smsLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
			if($('.data_wrap .layerpop')[0]){
				$('#smsLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}

			$('#smsLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//SMS발송버튼 클릭 이벤트 - submit
		$('.btnSendSms').click(function(e){
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				success:function(res){
					alert('발송되었습니다');
					$('.btnClose').click();
				}
			});
			
			e.preventDefault();
			return false;
		});
	});
	
	function OnInitCompleted(){
		editor.SetBodyValue($('[name="answer"]').val());
	}
</script>
</head>
<body>
	<form action="updateAnswer.do" id="frm" method="post">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="seqList" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="se" value="BSSE0003" />
		<input type="hidden" name="smsRecptnAgreAt" value="${eo.smsRecptnAgreAt }" />
		<textarea name="answer" style="display:none">${eo.answer }</textarea>
		
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
					<th scope="row">상태</th>
					<td>${empty eo.answerId?'대기중':'답변완료'}</td>
					<th scope="row">유형</th>
					<td>${eo.clNm }</td>
				</tr>
				<tr>
					<th scope="row">작성자</th>
					<td>${eo.rgstNm}</td>
					<th scope="row">이메일</th>
					<td>${eo.email }</td>
				</tr>
				<tr>
					<th scope="row">휴대폰</th>
					<td>${eo.userInfoVO.moblphonNo }</td>
					<th scope="row">전화번호</th>
					<td>${eo.callNumber}</td>
				</tr>
				<tr>
					<th scope="row">등록일</th>
					<td date colspan="3">${eo.rgstDt}</td>
				</tr>
				<tr>
					<td colspan="4" class="p20 xssContent">${eo.cn}</td>
				</tr>
				<tr>
					<td colspan="4" class="p5" id="fileLayer"></td>
				</tr>
			</tbody>
		</table>
	
		<table class="tbl tbl_form">
			<colgroup>
				<col width="100%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row" class="txt_center">답변</th>
				</tr>
				<tr>
					<td colspan="4" class="p10">
						<textarea id="editor" name="editor">${eo.answer }</textarea>
					</td>
					
				</tr>
			</tbody>
		</table>
		
		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="#" class="btn normal ${empty eo.answer?'blue':'green'} mr10 btnSubmit">
					<i class="far ${empty eo.answer?'fa-save':'fa-edit' } mr5"></i>
					${empty eo.answer?'등록':'수정'}
				</a>
			<c:if test="${!empty eo}">
				<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
			</c:if>
				<a href="qnaList.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</form>
	
	<div id="smsLayer" class="layerpop" style="width: 700px; height: 280px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">SMS발송</div>
			<a href="#" class="layerpop_close"><i class="far fa-window-close"></i></a>

			<div class="pop_content">
				<form id="frmPop" action="sendSMS.do" method="post">
					<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
					<input tyupe="hidden" name="mbtlnum" value="${eo.userInfoVO.moblphonNo}" />
					<input tyupe="hidden" name="nm" value="${eo.userInfoVO.nm}" />
					<table class="tbl tbl_form">
						<colgroup>
							<col width="100%">
						</colgroup>
						<tbody>
							<tr>
								<td class="p10 h120"><textarea class="w100p h100" name="smsSj"></textarea></td>
							</tr>
						</tbody>
					</table>
				</form>
				
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="sendSMS.do" class="btn normal blue mr10 btnSendSms"><i class="far fa-share-square mr5"></i> 발송</a>
						<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
					</div>
				</div>

			</div>
		</div>
	</div>
	
</body>
</html>
