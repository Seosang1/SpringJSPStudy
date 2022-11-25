<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaList;
	var uploader;

	$(function(){
		cwmaList = new cwma.list();
		uploader = new CrossUploader({parntsSe:'ATCH0012', parntsSn:$('.data_wrap [name="sn"]:eq(0)')[0]?$('[name="sn"]').data('relsn'):0});
		
		//탭 클릭이벤트
		$('.tab200 li').click(function(e){
			$('#frm [name="se"]').val($(this).data('se'));
			$('#frm').submit();
	        
			e.preventDefault();
			return false;
		});
		
		//등록버튼 클릭 이벤트 - 팝업오픈
		$('.btnReg').click(function(e){
			$('#frmPop')[0].reset();
			
			cwma.showMask();
	        $('#clmserEduLayer').css("top",(($(window).height() - $('#clmserEduLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#clmserEduLayer').css("left",(($(window).width() - $('#clmserEduLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
			if($('.right_cont .layerpop')[0]){
				$('#clmserEduLayer').draggable();
				$('body').append($('.data_wrap .layerpop'));
			}

			$('#clmserEduLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#clmserEduLayer').hide();
			
			e.preventDefault();
			return false;			
		});
		
		//등록/수정버튼 이벤트 - submit
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				success:function(res){
					alert(txt+'되었습니다');
					$('#frm').submit();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 이벤트
		$('.btnDel').click(function(e){
			if($('[name="sn"]:checked').length){
			    $('#frmPop [name="sn"]').val($('[name="sn"]:checked').val());
			    
			}else{
			    alert('삭제할 목록를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			if(!confirm('삭제하시겠습니까?')){
				e.preventDefault();
				return false;
			}
			
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				beforeValid:false,
				success:function(res){
					alert('삭제되었습니다');
					$('#frm').submit();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//저장버튼 클릭이벤트
		$('.btnSave').click(function(e){
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				beforeValid:false,
				beforeSubmit:function(){
					$('[name="eduSn"]').val($('.data_wrap [name="sn"]:eq(0)').val());
					
					if(uploader.getTotalFileCount()){
						isUploading = true;
						uploader.startUpload();
					}else{
						alert('첨부파일을 선택해주세요');
						return false;
					}
					
					return true;
				},
				success:function(res){
					alert('저장되었습니다');
					$('#frm').submit();
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		
		//발송버튼 이벤트
		$('.btnSms').click(function(e){
			if(!confirm('발송하시겠습니까?')){
				e.preventDefault();
				return false;
			}
			
			$('#smsFrm').attr('action', $(this).attr('href'));
			$('#smsFrm').ajaxCwma({
				beforeValid:false,
				beforeSubmit:function(){
					$('#smsFrm [name="mobile"]').val($('#smsFrm [name^="mobile"]').not('[name="mobile"]').get().map(function(o){return o.value}).join('-'));
				},
				success:function(res){
					$('.education tbody:eq(0) tr:eq(0) td:eq(3)').html('<em class="blue">이수완료</em>')
					alert('발송되었습니다');
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//하단 보라색버튼 클릭
		$('.txt_left .purple').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').append('<input type="hidden" name="jumin1" value="'+$('[name="ihidnum"]').val().split('-')[0]+'" />');
			$('#frm').append('<input type="hidden" name="jumin2" value="'+$('[name="ihidnum"]').val().split('-')[1]+'" />');
			$('#frm').submit();
			e.preventDefault();
			return false;
		});
		
		var back = $('div.pageDisabled');

		// 팝업 오픈 이벤트
		var isIssuPop = false;
		$('a.openLayer').on('click', function(e){
			e.preventDefault();

			var layer = $($(this).attr('href'));
			var indexCnt = parseInt(back.css('z-index'));
			var visibleCnt = $('div.layer').is(':visible') ? 0 : parseInt($('layer').is(':visible').length);

			if(back.not(':visible')){
				back.show();
			}

			if("#issueAgreement" == $(this).attr('href') && !isIssuPop){
				layer.css({
					marginTop : -((layer.outerHeight() / 2) + (layer.outerHeight() / 4)),
					marginLeft : -(layer.outerWidth() / 2),
					zIndex : indexCnt + 3
				}).show();
				isIssuPop = true;
			}else{
				layer.css({
					marginTop : -(layer.outerHeight() / 2),
					marginLeft : -(layer.outerWidth() / 2),
					zIndex : indexCnt + 3
				}).show();
			}

			if($('div.layer').is(':visible')){
				back.css('z-index', indexCnt + 2);
			}
			
			if(!uploader){
				uploader = new CrossUploader({fileLayer:'fileDiv'});
			}
		});
		
		// 팝업 닫기 이벤트
		$(document).on('click', 'div.layer .close', function(){
			$(this).parents('div.layer:first').hide();
			if(!$('div.layer').is(':visible')){
				back.hide();
			}else{
				back.css('z-index', back.css('z-index') - 2);
			}
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
					$('#frmPop').append('<input type="hidden" name="fileVO['+i+'].'+key+'" value="'+this[key]+'" />');
				}
			});
			
			isUploading = false;
		}
	}
</script>
</head>
<body>
	<div class="search_wrap">
		<ul class="tab200">
		<c:forEach var="eo" items="${seList }" varStatus="sts">
			<li class="btnTab ${eo.cdId eq vo.se?'on':''} ${empty vo.se and sts.first?'on':''}" data-se="${eo.cdId }">${eo.cdNm }</li>
		</c:forEach>
		</ul>
	
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="100" />
			<input type="hidden" name="se" value="${vo.se }" />
			<input type="hidden" name="ihidnum" value="${param.ihidnum }" />
			<a href="#" id="btnSearch" style="display:none"> 조회</a>
		</form>
	</div>
	
	<div class="data_wrap mt0">
		<table class="tbl tbl_data">
			<colgroup>
				<col width="4%">
				<col width="10%">
				<col width="50%">
				<col width="18%">
				<col width="18%">
			</colgroup>
			<thead>
				<tr>
					<td scope="col" colspan="3" class="brd-top-none txt_left pl30 bg-f2 bold">
						<span><i class="fas fa-th-list mr10"></i>최초교육</span>
					</td>
					<td scope="col" colspan="2" class="brd-top-none txt_right pl30 bg-f2 p5">
						<a href="form.do" class="btn normal blue mr10 btnReg"><i class="far fa-save mr5"></i>교육등록</a>
						<a href="delete.do" class="btn normal black mr10 btnDel"><i class="fas fa-trash-alt mr5"></i>삭제</a>
					</td>
				</tr>
				<tr>
					<th scope="col"><span>선택</span></th>
					<th scope="col"><span>No</span></th>
					<th scope="col"><span>제목</span></th>
					<th scope="col"><span>문자발송</span></th>
					<th scope="col"><span>이수상태</span></th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="eo" items="${list }" varStatus="sts">
				<tr>
					<td><input type="radio" name="sn" value="${eo.sn }" data-relsn="${eo.relVO.sn }" /></td>
					<td>${eo.rownum }</td>
					<td style="text-align:left;">${eo.sj }</td>
				<c:if test="${sts.first }">
					<td rowspan="${vo.totalCnt }" class="p5"><a href="#sendSMS" class="openLayer btn normal black">발송</a></td>
					<td rowspan="${vo.totalCnt }">${eo.relVO.complAt eq 'Y'?'<em class="blue">이수완료</em>':'<em class="red">미이수</em>'}</td>
				</c:if>	
					</tr>
			</c:forEach>
			<c:if test="${vo.totalCnt == 0}">
				<tr><td colspan="5">조회결과가 없습니다</td></tr>
			</c:if>
			</tbody>
		</table>

		<div id="fileDiv"></div>

		<div class="fl txt_left">
			<a href="../crtfIssu/crtfIssuForm.do" class="btn normal purple mr10"><i class="far fa-file-alt mr5"></i> 증명서발급신청</a>
			<a href="${pageContext.request.contextPath}/static/skill/document/별첨2)최초교육 설문조사지.zip" class="btn normal purple mr10"><i class="far fa-file-alt mr5"></i> 설문조사지 출력</a>
		</div>
		<div class="fr txt_right">
			<a href="insertUserClmserEduRel.do" class="btn normal blue mr10 btnSave"><i class="far fa-save mr5"></i>저장</a>
			<a href="../userInfo/personalList.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
		</div>
	</div>
	
	<div id="clmserEduLayer" class="layerpop" style="width: 900px; height: 260px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">교육추가</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<form id="frmPop" action="insert.do" method="post">
					<input type="hidden" name="sn" value="0" />
					<input type="hidden" name="eduSn" value="" />
					<input type="hidden" name="se" value="${vo.se }" />
					<input type="hidden" name="ihidnum" value="${vo.ihidnum }" />
					<table class="tbl tbl_form">
						<colgroup>
							<col width="20%">
							<col width="">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">제목</th>
								<td><input type="text" class="w100p" name="sj" title="제목" required></td>
							</tr>
							<tr>
								<th scope="row">링크URL</th>
								<td><input type="text" class="w100p" name="vidoUrl" title="링크URL" required></td>
							</tr>
						</tbody>
					</table>
				</form>
				
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 등록</a>
						<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
					</div>
				</div>

			</div>
		</div>
	</div>
	
	<div class="pageDisabled"></div>
	<div id="sendSMS" class="layer">
		<h1>SMS 발송</h1>
		<button type="button" class="close">×</button>
		<div>
			<form id="smsFrm" action="" method="post">
				<input type="hidden" name="ihidnum" value="${vo.ihidnum}" />
				<input type="hidden" name="mobile" value="" />
				<table>
					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">휴대폰 번호</th>
							<td>
								<input type="text" name="mobile1" title="전화번호 앞자리" style="width:30%;" maxlength="3" hasnext>
								-&nbsp;
								<input type="text" name="mobile2" title="전화번호 가운데자리" style="width:30%;" maxlength="4" hasnext>
								-&nbsp;
								<input type="text" name="mobile3" title="전화번호 뒷자리" style="width:30%;" maxlength="4">
							</td>
						</tr>
					</tbody>
				</table>
				<div class="mt30 txt_center">
					<button type="submit" href="sendSms.do" class="btn normal blue btnSms">발송</button>
					<button type="button" class="close btn normal black">닫기</button>
				</div>
			</form>
		</div>
	</div>

</body>
</html>
