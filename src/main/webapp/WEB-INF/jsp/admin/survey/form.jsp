<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var uploader;
	
	//초기화
	$(function(){
		uploader = new CrossUploader({fileLayer:'fileLayer', parntsSe:'ATCH0002', parntsSn:$('[name="surveySn"]').val()});
		
		//추가,기타추가버튼 설정
		$('[name="ty"]').each(function(){
			var ty = $(this).val();
			
			if('SQTY0001' == ty || 'SQTY0002' == ty || 'SQTY0005' == ty){
				$(this).parents('.tdItmEx').find('.btnItmExAdd').show();
				
				if('SQTY0001' == ty || 'SQTY0002' == ty)
					$(this).parents('.tdItmEx').find('[data-etc]').show();
				else
					$(this).parents('.tdItmEx').find('[data-etc]').hide();
				
			}else{
				$(this).parents('.tdItmEx').find('.btnItmExAdd').hide();
				
			}
		});
		
		//페이지구분 설정
		$('[name="pageNo"]').each(function(){
		    var pageNo = 1;
			var html = '<div class="div-line">';
			html += '<div class="div-line-next-btn">';
			html += '다음페이지<a href="#" class="btn small ml10 red btnPageDel"><i class="fas fa-eraser"></i></a>';
			html += '</div>';
			html += '</div>';

		    if(this.value && Number(this.value) > pageNo)
		    	$(this).parents('.tblItm').before(html);
		});
	});
		
	//이벤트
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
					var isErr = false;
					
					if($('.datepicker:eq(0)').val() && $('.datepicker:eq(1)').val()){
						if($('.datepicker:eq(0)').val() > $('.datepicker:eq(1)').val()){
							alert('설문조사기간 종료일은 시작일보다 크게 입력해주세요');
							return false;
						}
					}
					
					$('.tdItmEx').each(function(){
					    if($(this).find('[name="ty"]').val() == 'SQTY0001' || $(this).find('[name="ty"]').val() == 'SQTY0002'){
					    	$(this).find('[name="cn"]').each(function(){
					    		if(!$(this).hasClass('etc') && !$(this).val()){
					    			$(this).focus();
					    			isErr = true;
					    			alert('내용이 입력되지 않은 항목이 있습니다');
					    			return false;
					    		}
					    	});
					    }
					    
					    if(isErr)
					    	return false;
					});
					
					if(isErr)
						return false;
					
					$('.btnPage').click();
					
					$('.tblItm').each(function(i){
						var arr;
						
						$(this).find('input, textarea, select').not('.tdItmEx input, .tdItmEx textarea').each(function(){
							arr = $(this).attr('name').split('.');
							$(this).attr('name', 'itmVO['+i+'].'+arr[arr.length-1]);
							
						});
						
						$(this).find('.tdItmEx').each(function(){
							var j = 0;
							$(this).find('input, textarea').each(function(){
								if($(this).attr('name')){
									arr = $(this).attr('name').split('.');
									$(this).attr('name', 'itmVO['+i+'].exVO['+j+'].'+arr[arr.length-1]);
								}
								
								if(/cn$/.test($(this).attr('name')))
									j++;
							});
						});
					});
					
					if(confirm(txt+'하시겠습니까?')){
						$(uploader.modifiedFilesInfoList).each(function(){
							if(this.isDeleted){
								$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].parntsSn" value="'+this.parntsSn+'" />');
								$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].parntsSe" value="'+this.parntsSe+'" />');
								$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].fileSn" value="'+this.fileSn+'" />');
								delIdx++;
							}
						});
						if(uploader.getTotalFileCount()){
							isUploading = true;
							uploader.startUpload();
						}
					}else{
						return false;
					}
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
		
		//주관식단답형 크기조절 이벤트
		$('#frm').on('change', '[name$="setSize"]', function(){
			if($(this).parents('.tdItmEx').find('[name="ty"]').val() == 'SQTY0003'){
				$(this).parents('.tdItmEx').find('[name="fakeCn"]').css('width',$(this).val()+'px');
				$(this).parents('.tdItmEx').find('[name="cn"]').val($(this).val());
			}
		});
		
		//순위선택형 화살표
		$('#frm').on('click', '.btnArrowUp, .btnArrowDn', function(e){
// 			if($(this).hasClass('btnArrowUp'))
// 				$(this).parent().parent().prev().before($(this).parent().parent());
// 			else
// 				$(this).parent().parent().next().after($(this).parent().parent());
			
			e.preventDefault();
			return false;
		});
		
		
		
		/* ---------- 문항영역 ---------- */
		//문항삭제버튼 클릭이벤트
		$('#frm').on('click', '.btnItmDel', function(){
			if($('.tblItm').length > 1)
				$(this).parents('.tblItm').remove();
			else
				alert('문항을 1개 이상 입력해주세요');
			
			event.preventDefault();
			return false;
		});
		
		//문항추가버튼 클릭이벤트
		$('.btnItmAdd').click(function(){
			var obj = $('.tblItm:eq(0)').clone();
			
			obj.find('[type="file"]').remove();
			obj.find('.tdItmEx [name="cn"]').remove();
			obj.find('input, textarea').val('');
			obj.find('select').find('option:eq(0)').prop('selected', true);
			obj.find('[name="qesitmSn"]').val(0);
			obj.find('.itmFile label').next().remove();
			obj.find('.itmFile label').remove();
			
			$(this).parents('.btn_wrap').before(obj);
			
			$(this).parents('.btn_wrap').prev().find('[name="ty"]').change();
			
			event.preventDefault();
			return false;			
		});
		
		
		/* ---------- 유형영역 ---------- */
		//유형삭제버튼 클릭이벤트
		$('#frm').on('click', '.btnItmExDel', function(){
			if($(this).parents('.tdItmEx').find('input').length > 1)
				$(this).parent().remove();
			
			event.preventDefault();
			return false;
		});
		
		//유형추가버튼 클릭이벤트
		$('#frm').on('click', '.btnItmExAdd', function(){
			var str = '';
			var isEtc = eval($(this).data('etc'));
			var ty = $(this).parents('.tdItmEx').find('[name="ty"]').val();
			var idx = $(this).parents('.tdItmEx').find('[name="ty"]').index($('[name="ty"]'));
			
			str += '<div class="mt10">';
			
			//단일,복수 선택형, 목록형
			if('SQTY0001' == ty || 'SQTY0002' == ty || 'SQTY0005' == ty){
				str += '<label>';
				
				if('SQTY0001' == ty)
					str += '<input type="radio" name="radio_'+idx+'" value="">';
				else if('SQTY0002' == ty)
					str += '<input type="checkbox" name="check_'+idx+'" value="">';
				else{
					str += '<a href="#" class="btnArrowUp"><i class="fas fa-arrow-up mr5"></i></a>';
					str += '<a href="#" class="btnArrowDn"><i class="fas fa-arrow-down mr5"></i></a>';
				}
					
				str += '</label> ';
					
				str += (isEtc?'기타 :':'')+'<input type="text" name="cn" class="w60p '+(isEtc?'etc':'')+'"'+(isEtc?'style="background-color:#f5f5f5" readonly':'')+'/> ';
				str += '<a href="#" class="btn small ml10 red btnItmExDel"><i class="fas fa-eraser mr5"></i>삭제</a>';
				
			//연락처
			}else if('SQTY0007' == ty){
				str += '<input type="text" name="cn" class="w100p" maxlength="12" />';
				
			//파일
			}else if('SQTY0009' == ty){
				str += '<div class="exFile" data-sn=""></div>';
				
			}
			
			str += '</div>';
			
			$(this).parent().prev().append(str);
			event.preventDefault();
			return false;
		});
		
		//유형 변경이벤트
		$('#frm').on('change', '[name="ty"]', function(){
			var str = '', ty = $(this).val();
			var idx = $(this).parents('.tdItmEx').find('[name="ty"]').index($('[name="ty"]'));

			$(this).parent().find('label, em').remove();
			
			//단일, 복수, 순위 선택형
			if('SQTY0001' == ty || 'SQTY0002' == ty || 'SQTY0005' == ty){
				for(var i=0;i<4;i++){
					str += '<div class="mt10">';
					str += '<label>';
					
					if('SQTY0001' == ty)
						str += '<input type="radio" name="radio_'+idx+'" value="">';
					else if('SQTY0002' == ty)
						str += '<input type="checkbox" name="check_'+idx+'" value="">';
					else{
						str += '<a href="#" class="btnArrowUp"><i class="fas fa-arrow-up mr5"></i></a>';
						str += '<a href="#" class="btnArrowDn"><i class="fas fa-arrow-down mr5"></i></a>';
					}
						
						
					str += '</label> ';
					
					str += '<input type="text" name="cn" class="w60p"/> ';
					
					if(i > 0)
						str += '<a href="#" class="btn small ml10 red btnItmExDel"><i class="fas fa-eraser mr5"></i>삭제</a>';
						
					str += '</div>';
				}
		
			//주관식 단답형
			}else if('SQTY0003' == ty){
				str += '<div class="mt10"><input type="text" name="fakeCn" class="w100p" readonly style="background-color:#f5f5f5"/>';
				str += '<input type="hidden" name="cn" value=""/></div>';
				
				$(this).parent().append('<em class="bold">크기(사이즈)</em>');
				$(this).parent().append('<label><input type="radio" name="exVO['+$(this).parents('.tblItm').index('.tblItm')+'].setSize" value="w-30" /> 작게</label>');
				$(this).parent().append('<label><input type="radio" name="exVO['+$(this).parents('.tblItm').index('.tblItm')+'].setSize" value="w-50" checked /> 중간</label>');
				$(this).parent().append('<label><input type="radio" name="exVO['+$(this).parents('.tblItm').index('.tblItm')+'].setSize" value="w-100" /> 크게</label>');
				
			//주관식 서술형
			}else if('SQTY0004' == ty){
				str += '<div class="mt10"><textarea name="cn" class="w100p h100"></textarea></div>';
		
			//연락처
			}else if('SQTY0007' == ty){
				str += '<div class="mt10"><input type="text" name="cn" class="w100p" maxlength="12" /></div>';
				
			//금액/숫자
			}else if('SQTY0008' == ty){
				str += '<div class="mt10"><input type="number" name="cn" class="w100p" /></div>';
				
			//파일
			}else if('SQTY0009' == ty){
				str += '<div class="mt10"><div class="exFile" data-sn="" data-idx="'+cwmaFileList.length+'"></div>';
				
			}
			
			$(this).parents('.tblItm').find('.itmExList').html(str);
			
			
			if('SQTY0001' == ty || 'SQTY0002' == ty || 'SQTY0005' == ty){
				$(this).parents('.tdItmEx').find('.btnItmExAdd').show();
				
				if('SQTY0001' == ty || 'SQTY0002' == ty)
					$(this).parents('.tdItmEx').find('[data-etc]').show();
				else
					$(this).parents('.tdItmEx').find('[data-etc]').hide();
				
			}else{
				$(this).parents('.tdItmEx').find('.btnItmExAdd').hide();
				
			}
			
			$(this).parent().find('[name$="setSize"]:checked').change();
			
			if('SQTY0009' == ty){
				cwmaFileList.push(new cwma.file({fileLayer:'.exFile:eq('+($('.exFile').length-1)+')', parntsSe:'ATCH0004', fileName:'exFile'}));
				cwmaFileList[cwmaFileList.length-1].setFileList(true);
			}
			
			event.preventDefault();
			return false;
		});
		
		//페이지구분버튼클릭
		$('.btnPage').click(function(e){
			var idx = $('.data_wrap').children('.div-line:last').index();
			if($('.tblItm:last').next().hasClass('div-line')){
				alert('페이지에 들어갈 문항이 없습니다');
				return false;
			}
			
			var html = '<div class="div-line">';
			html += '<div class="div-line-next-btn">';
			html += '다음페이지<a href="#" class="btn small ml10 red btnPageDel"><i class="fas fa-eraser"></i></a>';
			html += '</div>';
			html += '</div>';
			
			$('.data_wrap').children().each(function(i){
				if($(this).hasClass('tblItm') && i > idx){
					if($(this).find('[name="pageNo"]')[0])
						$(this).find('[name="pageNo"]').val($('.div-line').length+1);
					else
						$(this).find('[name="sj"]').after('<input type="hidden" name="pageNo" value="'+($('.div-line').length+1)+'" />');
				}
			});
			
			$('.tblItm:last').after(html);
			
			e.preventDefault();
			return false;
		});
		
		//페이지구분삭제
		$('.data_wrap').on('click', '.btnPageDel', function(e){
			$(this).parents('.div-line').remove();
			var idx = $('.data_wrap').children('.div-line:last').index();
			
			$('.data_wrap').children().each(function(i){
				if($(this).hasClass('tblItm') && i > idx)
					$(this).find('[name="pageNo"]').remove();
			});
			
			e.preventDefault();
			return false;
		});
		
		//미리보기버튼
		$('.btnPreview').click(function(e){
			var mainTbl = $('.data_wrap .tbl_form:first');
			var itmTbl = $('.data_wrap .tblItm');
			var file = mainTbl.find('#fileLayer').clone();
			var itmFiles = [];
			var reader = [];
			var html = '';
			
			file.find('.input-file').remove();
			file.find('input').remove();
			file.find('label').remove();
			file.children('div:last').remove();
			file.children('div:last').remove();
			file.find('.btnFileDel').remove();
			
			html += '<div class="bold fs16">'+mainTbl.find('[name="sj"]').val()+'</div>';
			html += '<div class="mt10 fs14">'+mainTbl.find('.input_date input').get().map(function(o){return o.value}).join(' ~ ')+'</div>';
			html += '<div class="mt10 p20 bg-f9 w90p">';
			html += mainTbl.find('[name="cn"]').val().replace(/\n/g, '<br>');
			html += '</div>';
			html += '<div class="mt10 p10 bg-f2 w90p">';
			html += '<span class="spib w10p"> 첨부파일 </span>';
			html += '<span class="spib w80p">';
			
			file.find('div.mb5').each(function(){
				html += $(this).html();
			});
			
			html += '</div>';

			//문항반복
			itmTbl.each(function(){
				html += '<div class="mt20" data-page="'+$(this).find('[name="pageNo"]').val()+'" style="display:none">';
				
				html += '<div class="bold">'+$(this).find('[name="sj"]').val()+'</div>';
				
				//이미지
				if($(this).find('.itmFile .mt5 a')[0])
					html += '<div class="prv-img"><img src="'+$(this).find('.itmFile .mt5 a').attr('href')+'"></div>';
				
				if($(this).find('.itmFile label.purple [name="itmFile"]').val()){
					itmFiles[itmFiles.length] = $(this).find('.itmFile label.purple [name="itmFile"]');
					html += '<div class="prv-img"><img src="" class="itmFileImg'+itmFiles.length+'"></div>';
				}

				html += '<div class="mt5">';

				if($(this).find('[name="sj"]').val())
					html += '<span class="spib w100p ml10 mt5">' + $(this).find('[name="sj"]').val() + '</span>';

				if($(this).find('[name="ty"]').val() == 'SQTY0001' || $(this).find('[name="ty"]').val() == 'SQTY0002'){
					$(this).find('.itmExList > div').each(function(){
						html += '<span class="spib w100p ml10 mt5">';
						html += '<label>';
						html += $(this).find('label').html();
						html += $(this).find('[name="cn"]').val();
						html += '</label>';
						html += '</span>';
					});

				}else if($(this).find('[name="ty"]').val() == 'SQTY0003'){
					html += '<span class="spib w100p ml10 mt5">';
					html += '<input type="text" class="' + $(this).find('[name="cn"]').val().replace('-', '') + 'p">';
					html += '</span>';

				}else if($(this).find('[name="ty"]').val() == 'SQTY0004'){
					html += '<span class="spib w100p ml10 mt5">';
					html += '<textarea class="ml10 w90p h180"></textarea>';
					html += '</span>';

				}else if($(this).find('[name="ty"]').val() == 'SQTY0005'){
					$(this).find('.itmExList > div').each(function(){
						html += '<span class="spib w100p ml10 mt5">';
						html += '<i class="fas fa-arrow-up mr5 fs12"></i>';
						html += '<i class="fas fa-arrow-down mr5 fs12"></i>';
						html += '<span class="ml20">' + $(this).find('[name="cn"]').val() + '</span>';
						html += '</span>';
					});

				}else if($(this).find('[name="ty"]').val() == 'SQTY0007'){
					html += '<span class="spib w100p ml10 mt5">';
					html += '<input type="text" class="w100p" maxlength="12">';
					html += '</span>';

				}else if($(this).find('[name="ty"]').val() == 'SQTY0008'){
					html += '<span class="spib w100p ml10 mt5">';
					html += '<input type="number" class="w10p" maxlength="">';
					html += '</span>';

				}

				html += '</div>';
				html += '</div>';
			});

			$('#surveyLayer .cont_wrap').html(html);
			
			//첨부파일 읽기
			$(itmFiles).each(function(i){
				reader[i] = new FileReader();
				reader[i].readAsDataURL($(this).get()[0].files[0]);
				
				reader[i].onload = function(e){
					$('.itmFileImg'+(i+1)).attr('src', e.target.result);
				}
			});

			cwma.showMask();
			$('#surveyLayer').css("top", (($(window).height() - $('#surveyLayer').outerHeight()) / 2) + $(window).scrollTop());
			$('#surveyLayer').css("left", (($(window).width() - $('#surveyLayer').outerWidth()) / 2) + $(window).scrollLeft());

			if($('#container .layerpop')[0]){
				$('#surveyLayer').draggable();
				$('body').append($('#container .layerpop'));
			}

			$('div[data-page="1"]').show();
			$('#surveyLayer').show();

			e.preventDefault();
			return false;
		});
		
		$('.btnNextPage').click(function(e){
			var page = $('div[data-page]:visible').eq(0).data('page')+1;
			$('div[data-page]:visible').hide();
			$('div[data-page="'+page+'"]').show();
			e.preventDefault();
			return false;
		});

		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#surveyLayer').hide();

			e.preventDefault();
			return false;
		});

		$('[name$="setSize"]:checked').change();
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
	
	// 예외 발생 시 호출됩니다.
	var onExceptionCu = function(){
	    var exceptionInfo = uploader.getLastExceptionInfo();
	    var obj = jQuery.parseJSON(exceptionInfo);
	    
	    alert('[예외 정보]\n' + 'code : ' + obj.code + '\n' + 'message : ' + obj.message + '\n' + 'detailMessage : ' + obj.detailMessage);
	}
</script>
</head>
<body>
	<form action="${empty eo?'insert':'update'}.do" id="frm" method="post">
		<input type="hidden" name="surveySn" value="${empty eo?0:eo.surveySn}" />

		<div class="data_wrap">
			<table class="tbl tbl_form">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="30%">
					<col width="10%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><em class="required">*</em> 제목</th>
						<td colspan="4">
							<input type="text" class="w100p" maxlength="30" name="sj" title="제목" value="${eo.sj}" required />
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em> 설명</th>
						<td colspan="4" class="h200" id="infoFile">
							<textarea class="w90p h180" name="cn" title="내용" required>${eo.cn}</textarea>
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em> 설문조사기간</th>
						<td colspan="4">
							<div class="input_date">
								<input type="text" name="bgnde" title="시작일" value="${eo.bgnde}" style="width: 105px;" class="datepicker" required>
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt=""></a>
							</div>
							<span class="fuhao"> ~ </span>
							<div class="input_date">
								<input type="text" name="endde" title="종료일" value="${eo.endde}" style="width: 105px;" class="datepicker" required>
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt=""></a>
							</div>
						</td>
					</tr>
				<c:if test="${!empty eo}">
					<tr>
						<th scope="row">등록일</th>
						<td date>${eo.rgstDt }</td>
						<th scope="row">작성자</th>
						<td colspan="2">${eo.rgstId }</td>
					</tr>
				</c:if>
					<tr>
						<th scope="row"><em class="required">*</em>사용여부</th>
						<td colspan="4">
							<input type="radio" id="rad201" name="useAt" value="Y" ${empty eo or eo.useAt eq 'Y'?'checked="checked"':''}>
							<label for="rad201">사용</label>
							<input type="radio" id="rad202" name="useAt" value="N" ${eo.useAt eq 'N'?'checked="checked"':''}>
							<label for="rad202">미사용</label>
						</td>
					</tr>
					<tr>
						<th scope="row">첨부파일</th>
						<td colspan="4" id="fileLayer"></td>
					</tr>
				</tbody>
			</table>

		<c:forEach items="${eo.itmVO}" var="itmEO">
			<table class="tbl tbl_form tblItm">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="30%">
					<col width="10%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><em class="required">*</em>문항제목</th>
						<td colspan="4">
							<input type="hidden" name="qesitmSn" value="${itmEO.qesitmSn}" required>
							<input type="text" class="w100p" name="sj" title="제목" value="${itmEO.sj}" required>
							<input type="hidden" name="pageNo" value="${itmEO.pageNo}">
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>문항설명</th>
						<td colspan="4" class="itmFile" data-sn="${itmEO.qesitmSn}">
							<input type="text" class="w90p" name="cn" title="내용" value="${itmEO.cn}" required />
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>유형</th>
						<td colspan="3" class="tdItmEx">
							<div class="mt10">
								<select name="ty" class="w30p" title="유형">
									<c:forEach var="ceo" items="${clList}">
										<option value="${ceo.cdId}" ${ceo.cdId eq itmEO.ty?'selected':''}>${ceo.cdNm}</option>
									</c:forEach>
								</select>
								<c:if test="${'SQTY0003' eq itmEO.ty}">
									<em class="bold">크기(사이즈)</em>
									<label><input type="radio" name="setSize" value="w-30" ${itmEO.exVO[0].cn eq 'w-30'?'checked':''} />작게</label>
									<label><input type="radio" name="setSize" value="w-50" ${itmEO.exVO[0].cn eq 'w-50'?'checked':''} />중간</label>
									<label><input type="radio" name="setSize" value="w-100" ${itmEO.exVO[0].cn eq 'w-100'?'checked':''} />크게</label>
								</c:if>
							</div>
							<div class="itmExList">
							<c:forEach items="${itmEO.exVO}" var="exEO" varStatus="exSts">
								<div class="mt10">
									<input type="hidden" name="sn" value="${exEO.sn}" />
								<c:if test="${'SQTY0001' eq itmEO.ty or 'SQTY0002' eq itmEO.ty or 'SQTY0005' eq itmEO.ty}">
									<label>
									<c:if test="${'SQTY0001' eq itmEO.ty}">
										<input type="radio" name="radio_${exSts.index}" value="">
									</c:if>
									<c:if test="${'SQTY0002' eq itmEO.ty}">
										<input type="checkbox" name="check_${exSts.index}" value="">
									</c:if>
									<c:if test="${'SQTY0005' eq itmEO.ty}">
										<a href="#" class="btnArrowUp"><i class="fas fa-arrow-up mr5"></i></a>
										<a href="#" class="btnArrowDn"><i class="fas fa-arrow-down mr5"></i></a>
									</c:if>
									</label>
									
									${empty exEO.cn?'기타 :':''}
									<input type="text" name="cn" class="w60p ${empty exEO.cn?'etc':''}" ${empty exEO.cn?'style="background-color:#f5f5f5" readonly':''} value="${exEO.cn}" />
									<a href="#" class="btn small ml10 red btnItmExDel"><i class="fas fa-eraser mr5"></i>삭제</a>
								</c:if>
								<c:if test="${'SQTY0003' eq itmEO.ty}">
									<input type="text" name="fakeCn" class="w100p" readonly style="background-color:#f5f5f5"/>
									<input type="hidden" name="cn" value="${exEO.cn}" />
								</c:if>
								<c:if test="${'SQTY0004' eq itmEO.ty}">
									<textarea name="cn" class="w100p h100">${exEO.cn}</textarea>
								</c:if>
								<c:if test="${'SQTY0007' eq itmEO.ty}">
									<input type="text" name="cn" class="w100p" maxlength="12" value="${exEO.cn}" />
								</c:if>
								<c:if test="${'SQTY0008' eq itmEO.ty}">
									<input type="number" name="cn" class="w100p" value="${exEO.cn}" />
								</c:if>
								<c:if test="${'SQTY0009' eq itmEO.ty}">
									<div class="exFile" data-sn="${exEO.sn}"></div>
								</c:if>
								</div>
							</c:forEach>
							</div>
							<div class="mt10 mb10">
								<a href="#" class="btn small ml10 sky btnItmExAdd"><i class="fas fa-plus mr5"></i>추가</a>
								<a href="#" class="btn small ml10 sky btnItmExAdd" data-etc="true"><i class="fas fa-plus mr5"></i>기타 추가</a>
							</div>
						</td>
						<td class="txt_center">
							<a href="#" class="btn small red btnItmDel"><i class="fas fa-trash-alt mr5"></i>삭제</a>
						</td>
					</tr>
				</tbody>
			</table>
		</c:forEach>
		
		<c:if test="${empty eo }">
			<table class="tbl tbl_form tblItm">
				<colgroup>
					<col width="10%">
					<col width="40%">
					<col width="10%">
					<col width="30%">
					<col width="10%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><em class="required">*</em>문항제목</th>
						<td colspan="4">
							<input type="text" class="w100p" name="sj" title="제목" value="" required>
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>문항설명</th>
						<td colspan="4" class="itmFile">
							<input type="text" class="w90p" name="cn" title="내용" value="" required />
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>유형</th>
						<td colspan="3" class="tdItmEx">
							<div class="mt10">
								<select name="ty" class="w30p" title="유형">
									<c:forEach var="ceo" items="${clList}">
										<option value="${ceo.cdId}">${ceo.cdNm}</option>
									</c:forEach>
								</select>
							</div>
							<div class="itmExList">
								<div class="mt10">
									<label><input type="radio" name="radio_0" value=""></label>
									<input type="text" name="cn" class="w60p" value="" />
								</div>
								<div class="mt10">
									<label><input type="radio" name="radio_0" value=""></label>
									<input type="text" name="cn" class="w60p" value="" />
									<a href="#" class="btn small ml10 red btnItmExDel"><i class="fas fa-eraser mr5"></i>삭제</a>
								</div>
								<div class="mt10">
									<label><input type="radio" name="radio_0" value=""></label>
									<input type="text" name="cn" class="w60p" value="" />
									<a href="#" class="btn small ml10 red btnItmExDel"><i class="fas fa-eraser mr5"></i>삭제</a>
								</div>
								<div class="mt10">
									<label><input type="radio" name="radio_0" value=""></label>
									<input type="text" name="cn" class="w60p" value="" />
									<a href="#" class="btn small ml10 red btnItmExDel"><i class="fas fa-eraser mr5"></i>삭제</a>
								</div>
							</div>
							<div class="mt10 mb10">
								<a href="#" class="btn small ml10 sky btnItmExAdd"><i class="fas fa-plus mr5"></i>추가</a>
								<a href="#" class="btn small ml10 sky btnItmExAdd" data-etc="true"><i class="fas fa-plus mr5"></i>기타 추가</a>
							</div>
						</td>
						<td class="txt_center">
							<a href="#" class="btn small red btnItmDel"><i class="fas fa-trash-alt mr5"></i>삭제</a>
						</td>
					</tr>
				</tbody>
			</table>
		</c:if>

			<div class="btn_wrap">
				<div class="txt_center mt20">
					<a href="#" class="btn normal blue mr10 btnItmAdd"><i class="fas fa-folder-plus mr5"></i>항목 추가</a>
					<a href="#" class="btn normal wood mr10 btnPage"><i class="fas fa-columns mr5"></i>페이지구분</a>
				</div>
			</div>

			<div class="btn_wrap">
				<div class="fr txt_right">
					<a href="#" class="btn normal ${empty eo?'blue':'green'} mr10 btnSubmit">
						<i class="far ${empty eo?'fa-save':'fa-edit' } mr5"></i>${empty eo?'등록':'수정'}
					</a>
				<c:if test="${!empty eo}">
					<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i>삭제</a>
				</c:if>
					<a href="#" class="btn normal grey mr10 btnPreview"> 미리보기 </a>
					<a href="list.do" class="btn normal black mr10 btnList"><i class="fas fa-list mr5"></i> 목록</a>
				</div>
			</div>
		</div>
	</form>

	<div id="surveyLayer" class="layerpop" style="width: 1200px; height: 700px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title txt_center">설문조사</div>
			<a href="#" class="layerpop_close"> <i class="far fa-window-close"></i></a>
			<div class="pop_content">
				<div class="cont_wrap" style="width: 100%; height: 560px; overflow-y: auto; overflow-x: hidden;">
				</div>
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="#" class="btn normal black mr10 btnNextPage">
							<i class="fas fa-step-forward mr5"></i> 다음페이지
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
