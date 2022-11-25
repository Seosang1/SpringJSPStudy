<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var uploader = null;
	var fee, careerNoReqCnt = 0;
	
	$(function(){
		uploader = new CrossUploader({fileLayer:'fileDiv', parntsSe:'ATCH0011', parntsSn:$('[name="reqstNo"]').val()});
		
		$('[name=relate]').change(function(e){
			if("RELA0001" != $(this).val() && "" != $(this).val()){
				$('[name=relateDetail]').show();
				$('[name=relateDetail]').attr('disabled', false);
			}else{
				$('[name=relateDetail]').hide();
				$('[name=relateDetail]').val('');
				$('[name=relateDetail]').attr('disabled', true);
			}
			/* 사업주/수요기관일때 주민번호공개여부 :비공개 */
			let value = $(this).val();
			if("RELA0003" == value || "RELA0004" == value){
				$("#publicNo").prop("checked", true);
				$("#publicNo").attr("onclick", "return false;");
				$("#publicYes").attr("onclick", "return false;");
			}else
				$("[name=ihidnumOthbcAt]").attr("onclick","");
		});
		
		$('#btnSearch').click(function(e){
			$('#sFrm').attr('action', 'crtfIssuSearch.do');
			$('#sFrm [name=jumin3]').val($('#frm [name=jumin3]').val());
			$('#sFrm [name=jumin4]').val($('#frm [name=jumin4]').val());
			$('#sFrm [name=jssfcNo]').val($('#frm [name=jssfcNo]').val());
			$('#sFrm').ajaxCwma({
				beforeSubmit:function(){
					if($.trim($('#sFrm [name=jumin3]').val()) == "" || $.trim($('#sFrm [name=jumin4]').val()) == ""){
						alert('주민등록번호를 확인해주세요.');
						return false;
					}else if(/^(5|6|7|8)/.test($('#frm [name="jumin4"]').val())){
						alert('외국인은 발급받을 수 없습니다.');
						return false;						
					}
				}, success:function(res){
					if(!res.user){
						alert('등록된 근로자정보가 없습니다.');
						return false;						
						
					}else if(!res.user.userInfoVO || res.user.userInfoVO.clmserEduComplAt != 'Y'){
						if(confirm('최초교육 미이수자 입니다.\n교육관리화면으로 이동하시겠습니까?')){
							$('#frm input').prop('disabled', true);
							$('#frm').attr('action', '../clmserEdu/list.do');
							$('#frm').append('<input type="hidden" name="ihidnum" value="'+$('#frm [name="jumin3"]').val()+'-'+$('#frm [name="jumin4"]').val()+'" />')
							$('#frm').submit();
						}
						
						return false;
						
					}else{
						$('[name=issuTrgterNm]').val(res.data.issuTrgterNm);
						if(res.data.issuTrgterMoblphon != null){
							var issuTrgterMoblphon = res.data.issuTrgterMoblphon.split("-");
							$('[name=issuTrgterMoblphon1]').val(issuTrgterMoblphon[0]);
							$('[name=issuTrgterMoblphon2]').val(issuTrgterMoblphon[1]);
							$('[name=issuTrgterMoblphon3]').val(issuTrgterMoblphon[2]);
						}
						$('[name=issuTrgterZip]').val(res.data.issuTrgterZip);
						$('[name=issuTrgterAdres]').val(res.data.issuTrgterAdres);
					}
					
					$('[name=jssfcNo] option').each(function(){
						$(this).remove();
					});
					
					var optionTxt = '';
					$(res.jssfcList).each(function(){
						optionTxt = '<option value="'+this.jssfcNo+'" ' + (this.jssfcNo == res.user.jssfcNo? 'selected':'') + '>'+this.jssfcNm+'</option>';
						$('#frm [name=jssfcNo]').append(optionTxt);
					});
					
					$('[name=jssfcNoSub]').val(res.data.jssfcNo);
					$('[name=cnvrsnDaycnt]').val(Math.floor(Number(res.data.gradCnt)*100)/100);	//환산근로년수
					$('[name=grad]').val(res.data.grad);
					$('[name=workDaycnt]').val(res.data.workDaycnt);
					$('[name=etcWorkDaycnt]').val(res.data.etcWorkDaycnt);
					$('[name=emplyminsrncDaycnt]').val(res.data.emplyminsrncDaycnt);
					$('[name=crqfcDaycnt]').val(res.data.crqfcDaycnt);
					$('[name=edcTraingDaycnt]').val(res.data.edcTraingDaycnt);
					$('[name=etcDaycnt]').val(res.data.etcDaycnt);
					careerNoReqCnt = res.careerNoReqCnt;
					
					if(careerNoReqCnt)
						$('.btnSave').addClass('openLayer');
					
					fee = res.fee;
					$('[name=feeSn]').val(res.fee.sn);
					$('[name=crtfFirstCnt]').val(res.crtfFirstCnt);
					$('[name=issuCo]').change();
				}
			});
			
			e.preventDefault();
		});
		
		/* 경력사항정정 이동 */
		$("#btnCareerDeclare").click(function(e){
			$("#frm").attr("action", "${pageContext.request.contextPath}/admin/careerDeclare/careerDeclare.do").submit();
		});
		
		/* 발급신청자와 동일 체크 */
		$('#btnSame').click(function(){
			if($('[name=jumin3]').val() != "" && $('[name=jumin4]').val() != ""){
				$('[name=jumin1]').val($('[name=jumin3]').val());
				$('[name=jumin2]').val($('[name=jumin4]').val());
			}
			
			if($('[name=jumin1]').val() != "" && $('[name=jumin2]').val() != ""){
				$('[name=jumin3]').val($('[name=jumin1]').val());
				$('[name=jumin4]').val($('[name=jumin2]').val());
			}
			
			if($('[name=issuTrgterNm]').val() != "")
				$('[name=applcntNm]').val($('[name=issuTrgterNm]').val());
			
			if($('[name=applcntNm]').val() != "")
				$('[name=issuTrgterNm]').val($('[name=applcntNm]').val());
			
			if($('[name=issuTrgterMoblphon1]').val() != "" && $('[name=issuTrgterMoblphon2]').val() != "" && $('[name=issuTrgterMoblphon3]').val() != ""){
				$('[name=applcntMoblphon1]').val($('[name=issuTrgterMoblphon1]').val());
				$('[name=applcntMoblphon2]').val($('[name=issuTrgterMoblphon2]').val());
				$('[name=applcntMoblphon3]').val($('[name=issuTrgterMoblphon3]').val());
			}
			
			if($('[name=applcntMoblphon1]').val() != "" && $('[name=applcntMoblphon2]').val() != "" && $('[name=applcntMoblphon3]').val() != ""){
				$('[name=issuTrgterMoblphon1]').val($('[name=applcntMoblphon1]').val());
				$('[name=issuTrgterMoblphon2]').val($('[name=applcntMoblphon2]').val());
				$('[name=issuTrgterMoblphon3]').val($('[name=applcntMoblphon3]').val());
			}
			if($(this).prop("checked")){
				$("[name=relate]").val("RELA0001");
				$("[name=relate]").change();
				$("[name=relate]").prop("disabled","true");
			}else
				$("[name=relate]").prop("disabled","");
		});
		
		/* 발급대상자와 관계 클릭 */
		$("#relateTd").click(function(){
			if($("[name=relate]").prop("disabled")){
				alert("발급신청자와 동일 체크박스를 해제해주세요.");
			}
		});
		
		/* 태블릿 서명 */
		$("#btnPrint").click(function(e){
// 			e.preventDefault();

// 			alert($('#frm [name=jssfcNo]').val());

			$('#frm').attr('action', 'crtfIssuPreViewSave.do');
			$('#frm').ajaxCwma({
				beforeSubmit:function(){

				},success:function(res){
					$("[name=reqstNo]").val(res.reqstNo);
					window.open("", "preView","status=no,scrollbars=yes,resizable=no,top=100,left=100,width=900,height=680");
					$('#frm').attr('action', 'crtfIssuPreViewReportPop.do');
					$('#frm').attr('target', 'preView');
					$('#frm').submit();
					$('#frm').attr('target', '');
					$("[name=reqstNo]").val("");
				}
			});
			
		});
		
		$('.btnSave').click(function(e){
			e.preventDefault();
			
			if(!careerNoReqCnt)
				$('#btnSave').click();
		});
		
		$('#btnSave').click(function(){
			var txt = $('.btnSave').text().trim();
			$('#frm').attr('action', 'crtfIssuFormIns.do');
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					if($('[name=relate]').val() == "RELA0001"){
						if($('#frm [name=jumin1]').val() != $('#frm [name=jumin3]').val()){
							alert('주민등록번호 앞자리가 발급대상자와 다릅니다.');
							return false;
						}
						if($('#frm [name=jumin2]').val() != $('#frm [name=jumin4]').val()){
							alert('주민등록번호 뒷자리가 발급대상자와 다릅니다.');
							return false;
						}
						if($('#frm [name=applcntNm]').val() != $('#frm [name=issuTrgterNm]').val()){
							alert('대상자와 성명이 다릅니다.');
							return false;
						}
						if($('#frm [name=applcntMoblphon1]').val() != $('#frm [name=issuTrgterMoblphon1]').val()){
							alert('대상자와 연락처1(이)가 다릅니다.');
							return false;
						}
						if($('#frm [name=applcntMoblphon2]').val() != $('#frm [name=issuTrgterMoblphon2]').val()){
							alert('대상자와 연락처2(이)가 다릅니다.');
							return false;
						}
						if($('#frm [name=applcntMoblphon3]').val() != $('#frm [name=issuTrgterMoblphon3]').val()){
							alert('대상자와 연락처3(이)가 다릅니다.');
							return false;
						}
						if(!$("[name=detailHistInclsAt]:checked").val()){
							alert("세부이력 포함여부는 필수입니다.");
							return false;
						}
						if(!$("[name=ihidnumOthbcAt]:checked").val()){
							alert("주민등록번호 공개여부는 필수입니다.");
							return false;
						}
						if(!$('#frm [name="jssfcNo"]').val()){
							alert("발급 직종은 필수입니다.");
							return false;
						}
					}
					
					/* 수수료감면신청시 유형 check */
					if($("[name=feeRdcxptReqst]:checked").val()=="Y"){
						if(!$("[name=feeRdcxptTy] option:selected").val()){
							alert("수수료감면 유형을 선택해주세요.");
							return false;
						}
						if(!uploader.getTotalFileCount()){
							alert('수수료감면 첨부파일을 등록해주세요');
							return false;
						}
					}
					
					if($('[name="stateMatterAditAt"]:checked').val() == 'Y'){
						if(!$('[name="stateMatter"]').val()){
							alert("이력사항을 입력해주세요.");
							$('[name="stateMatter"]').focus();
							return false;
						}
						
						if(!uploader.getTotalFileCount()){
							alert('기재사항 첨부파일을 등록해주세요');
							return false;
						}
					}
					
					$('#frm [name="jssfcNo"]').prop('disabled', false);
					
					$(uploader.modifiedFilesInfoList).each(function(){
						if(this.isDeleted){
							$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].parntsSn" value="'+this.parntsSn+'" />');
							$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].parntsSe" value="'+this.parntsSe+'" />');
							$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].fileSn" value="'+this.fileSn+'" />');
							delIdx++;
						}
					});
					
					if($('[name="feeRdcxptReqst"]:checked').val() == 'Y' || $('[name="stateMatterAditAt"]:checked').val() == 'Y'){
						isUploading = true;
						uploader.startUpload();
					}
					
				},success:function(res){
					alert(txt + ' 되었습니다');
					$('#sFrm').attr('action', 'crtfIssuReqView.do');
					$('#sFrm').append('<input type="hidden" name="reqstNo" value="'+res.reqstNo+'">');
					$('#sFrm').submit();
				}
			});
			return false;
		});
		
		// 동명이인 세부내역 조회 이동
		$('#btnLink').click(function(){
			location.href = '${pageContext.request.contextPath}/admin/careerDeclare/careerDeclare.do';
		});
		
		$('[name=issuCo]').change(function(){
			var grad = $('[name=grad]').val();
			var ammount = 0;
			var issuCo = Number($('[name=issuCo]').val())
			var firstCnt = Number($('[name=crtfFirstCnt]').val());
			
			ammount = (firstCnt?fee.grad:fee.frst) * issuCo;
			
			if(ammount > 50000){
				alert('전체 금액은 50,000원을 넘을 수 없습니다.')
				$('[name=issuCo]').val(1);
				$('[name=issuCo]').change();
				return false;
			}
			
			$('[name=issuAmount]').val(ammount);
		});
		
		//직종변경
		$('#chkJssfcNo').click(function(){
			if($(this).prop('checked'))
				$('[name="jssfcNo"]').prop('disabled', false)
			else
				$('[name="jssfcNo"]').prop('disabled', true)
		});
		
		$('[name="jssfcNo"]').change(function(e){
			$('#sFrm').attr('action', 'crtfIssuSearch.do');
			$('#sFrm [name="jssfcNo"]').val($(this).val());
			$('#sFrm').ajaxCwma({
				success:function(res){
					$('[name=jssfcNoSub]').val(res.data.jssfcNo);
					$('[name=cnvrsnDaycnt]').val(Math.floor(Number(res.data.gradCnt)*100)/100);	//환산근로년수
					$('[name=grad]').val(res.data.grad);
					$('[name=workDaycnt]').val(res.data.workDaycnt);
					$('[name=etcWorkDaycnt]').val(res.data.etcWorkDaycnt);
					$('[name=emplyminsrncDaycnt]').val(res.data.emplyminsrncDaycnt);
					$('[name=crqfcDaycnt]').val(res.data.crqfcDaycnt);
					$('[name=edcTraingDaycnt]').val(res.data.edcTraingDaycnt);
					$('[name=etcDaycnt]').val(res.data.etcDaycnt);
				}
			});
			
			e.preventDefault();
		});

		setPopup();
		$('[name=rqstdt]').val($.datepicker.formatDate('yy-mm-dd', new Date()))
		$('[name=issuOn]').val($.datepicker.formatDate('yy-mm-dd', new Date()))
		$('[name=relate]').change();
		
		$('[name=jumin1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin2]').focus();
			}
		});
		
		$('[name=jumin3]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin4]').focus();
			}
		});
		
		$('.btn_wrap').on('click', '.openLayer', function(e){
			e.preventDefault();
			var isErr = false;
			
			$('#frm').find('[required]').each(function(){
				if(!$(this).val() || $(this).val() == $(this).data('replace') || ($(this).attr('type') == 'radio' && !$('[name="'+$(this).attr('name')+'"]:checked').length)){
					isErr = true;
					alert($(this).attr('title')+'을(를) 입력해주세요');
					$(this).focus();
					return false;
				}
			});
			
			if(isErr)
				return false;

			var layer = $($(this).attr('href'));
			var indexCnt = parseInt($('div.pageDisabled').css('z-index'));
			var visibleCnt = $('div.layer').is(':visible') ? 0 : parseInt($('layer').is(':visible').length);

			if($('div.pageDisabled').not(':visible')){
				$('div.pageDisabled').show();
			}

			layer.css({
				marginTop : -(layer.outerHeight() / 2),
				marginLeft : -(layer.outerWidth() / 2),
				zIndex : indexCnt + 3
			}).show();

			if($('div.layer').is(':visible')){
				$('div.pageDisabled').css('z-index', indexCnt + 2);
			}
		});
		
		$(document).on('click', 'div.layer .close', function(){
			$(this).parents('div.layer:first').hide();
			if(!$('div.layer').is(':visible')){
				$('div.pageDisabled').hide();
			}else{
				$('div.pageDisabled').css('z-index', back.css('z-index') - 2);
			}
		});
		
		<c:if test='${not empty param.jumin1 and not empty param.jumin2 and empty eo.jumin3}'>
			$('#btnSearch').click();
		</c:if>
		
		/* 수수료감면 신청 */
		$("[name=feeRdcxptReqst]").change(function(){
			if($(this).val()=="Y"){
				$("[name=feeRdcxptTy]").attr("disabled",false);
				$(".docCheckBtn").show();
			}else{
				$("[name=feeRdcxptTy]").val("");
				$("[name=feeRdcxptTy]").attr("disabled",true);
				$(".docCheckBtn").hide();
			}
			
		});
		
		/* 제출서류확인 버튼 클릭 */
		var back = $('div.pageDisabled');
		$(".docCheckBtn").click(function(){
			if(back.not(':visible'))
				back.show();
			
			modalAlign();
			$("#docCheckPop").show();
		});
		
		//새부이력포함여부 변경
		$('[name="detailHistInclsAt"]').change(function(){
			if($(this).attr('id') == 'detailYes'){
				$('[detailYes]').show();
				$('[detailYes] input').prop('disabled', false);
			}else{
				$('[detailYes]').hide();
				$('[detailYes] input').prop('disabled', true);
			}
		});
		
		//기재사항추가여부 변경
		$('[name="stateMatterAditAt"]').change(function(){
			if($(this).attr('id') == 'stateMatter2'){
				$('[stateMatter2]').show();
				$('[stateMatter2]').prop('disabled', false);
			}else{
				$('[stateMatter2]').hide();
				$('[stateMatter2]').prop('disabled', true);
			}
			
		});
		
		$('[name="detailHistInclsAt"]:checked').change();
		$('[name="stateMatterAditAt"]:checked').change();
	});

	var setPopup = function(){
		var popup = $('button.popup');

		popup.each(function(){
			$(this).on('click', function(e){
				e.preventDefault();
				var top = screen.height/2 - $(this).data('ph')/2;
				var left = screen.width/2 - $(this).data('pw')/2;
				var option = 'width = ' + $(this).data('pw') + 'px , height = ' + $(this).data('ph') + 'px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no'; 
				window.open($(this).attr('href'), $(this).attr('target'), option);
			});
		});
	}
	
	function resetButton(){
		if(confirm("입력내용이 초기화됩니다. 계속 진행하시겠습니까?")){
			$('#frm')[0].reset();
			cwmaFile.setFileList(true);
			$('[name=jssfcNo]').val("");
		}
	}
	
	window.addEventListener('message', function (e) {
		if(e.data.callback == 'adrs'){
			$('[name="issuTrgterZip"]').val(e.data.zip);
			$('[name="issuTrgterAdres"]').val(e.data.adrs);
		}
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
	
	function modalAlign(){
		$('div.layer').each(function(){
			$(this).css({
				marginTop : -($(this).outerHeight() / 2),
				marginLeft : -($(this).outerWidth() / 2)
			});
		});
	}
</script>
</head>
<body>
	<form id="sFrm"  action="" method="post">
		<input type="hidden" name="jumin3">
		<input type="hidden" name="jumin4">
		<input type="hidden" name="jssfcNo">
	</form>
	<input type="hidden" name="crtfFirstCnt" >
	<form id="frm" action="" method="post">
	<input type="hidden" name="mode" value="${empty eo.reqstNo ? 'add' : 'edit' }" >
	<input type="hidden" name="reqstNo" value="${eo.reqstNo }" >
	<input type="hidden" name="feeSn">
	<div class="data_wrap">
		<div>
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 발급대상자</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 15%;" />
					<col style="width: 35%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">주민등록번호(외국인등록번호)</th>
						<td colspan="3">
							<input type="text" class="w10p" title="주민등록번호 앞자리" maxlength="6" name="jumin3" value="${empty eo.jumin3?param.jumin1:eo.jumin3 }" required number/> 
							- <input type="text" class="w10p" title="주민등록번호 뒷자리" maxlength="7"  name="jumin4" value="${empty eo.jumin4?param.jumin2:eo.jumin4 }" required number/> 
							 <button type="button" id="btnSearch" class="btn btn_search mr10">조회</button>
<!-- 							 <button type="button" id="btnSame" class="btn btn_form mr10">신청자동일</button> -->
							 <input type="checkbox" id="btnSame" ><label for="btnSame">발급신청자와 동일</label>
						</td>
					</tr>
					<tr>
						<th scope="row">성명</th>
						<td><input type="text" class="w100p" name="issuTrgterNm" title="발급대상자 성명" required value="${eo.issuTrgterNm }" readonly  /></td>
						<th scope="row">휴대폰</th>
						<td>
							<input type="text" class="w10p" title="발급대상자 휴대폰" required maxlength="3" number name="issuTrgterMoblphon1" value="${eo.issuTrgterMoblphon1 }" required hasnext/>
							- <input type="text" class="w10p" title="발급대상자 휴대폰" required maxlength="4" number name="issuTrgterMoblphon2" value="${eo.issuTrgterMoblphon2 }" required hasnext/>
							- <input type="text" class="w10p" title="발급대상자 휴대폰" required maxlength="4" number name="issuTrgterMoblphon3" value="${eo.issuTrgterMoblphon3 }" required hasnext/>
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3">
							<button type="button" data-pw="700" data-ph="620" target="p129334" href="${pageContext.request.contextPath}/common/adrsPop.do?cb=adrs" class="btn btn_form mr10 popup">주소검색</button>
							<input type="text" class="w10p mr10" title="발급대상자 우편번호" required name="issuTrgterZip"  value="${eo.issuTrgterZip }" readonly/> <input type="text" class="w70p mr10" title="발급대상자 주소" required name="issuTrgterAdres"  value="${eo.issuTrgterAdres }" readonly/>
						</td>
					</tr>
				</tbody>
			</table>
			
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 발급신청자</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">성명</th>
						<td><input type="text" class="w100p" title="신청자 성명" name="applcntNm" value="${eo.applcntNm }" maxlength="10" required/></td>
						<th scope="row">주민등록번호</th>
						<td>
							<input type="text" class="w30p" title="신청자 주민등록번호 앞자리" name="jumin1" value="${eo.jumin1 }" maxlength="6" required number/> 
							- <input type="text" class="w30p" title="신청자 주민등록번호 뒷자리" name="jumin2" value="${eo.jumin2 }" maxlength="7" required number/>
						</td>
					</tr>
					<tr>
						<th scope="row">휴대폰</th>
						<td>
							<input type="text" class="w10p" title="신청자 휴대폰 앞자리" maxlength="3" name="applcntMoblphon1" value="${eo.applcntMoblphon1 }" number hasnext/>
							 - <input type="text" class="w10p" title="신청자 휴대폰 중간자리" name="applcntMoblphon2" value="${eo.applcntMoblphon2 }" maxlength="4" number hasnext/>
							  - <input type="text" class="w10p" title="신청자 휴대폰 뒷자리" name="applcntMoblphon3" value="${eo.applcntMoblphon3 }" maxlength="4" number hasnext/>
						</td>
						<th scope="row">발급대상자와 관계</th>
						<td id="relateTd">
							<select name="relate" class="w20p" required title="신청자와 관계" title="발급대상자와 관계">
<!-- 								<option value="">유형선택</option> -->
								<c:forEach var="relateList" items="${relateList}">
									<c:if test="${relateList.cdId eq 'RELA0001' or relateList.cdId eq 'RELA0002'}">
										<option value="${relateList.cdId}" ${relateList.cdId eq eo.relate?'selected':''}>${relateList.cdNm}</option>
									</c:if>
								</c:forEach>
							</select>
							<input type="text" class="w70p" maxlength="100" name="relateDetail" title="관계 상세" value="${eo.relateDetail}" disabled style="display:none">
						</td>
					</tr>
					<tr>
						<th scope="row">신청일</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" title="신청일" name="rqstdt" value="${eo.rqstdt }">
								<button type="button"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></button>
							</div>
						</td>
						<th scope="row">발급일</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" title="발급일" name="issuOn" value="${eo.issuOn }">
								<button type="button"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></button>
							</div>
						</td>
					</tr>
				</tbody>
			</table>

			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 발급정보</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">직종</th>
						<td colspan="3">
							<select class="w30p" name="jssfcNo" disabled>
								<option value="">직종선택</option>
							<c:forEach var="ceo" items="${jssfcList}">
								<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq eo.jssfcNo?'selected':''}>${ceo.jssfcNm}</option>
							</c:forEach>
							</select>
							<input type="hidden" name="jssfcNoSub" value="${eo.jssfcNo }">
							<input type="checkbox" id="chkJssfcNo">
							<label for="chkJssfcNo">변경</label>
						</td>
					</tr>
					<tr>
						<th scope="row">환산근로년수</th>
						<td>
							<input type="text" class="w100p" title="환산근로일수" required name="cnvrsnDaycnt" value="<fmt:formatNumber value="${eo.gradCnt }" pattern="###.##" />" number maxlength="6" disabled="disabled" />
							<input type="hidden" name="grad" value="${eo.grad }" >
							<input type="hidden" name="sptSe" value="${empty eo.sptSe ? 'SPTS0002' : eo.sptSe }" >
							<input type="hidden" name="workDaycnt" value="${eo.workDaycnt }" >
							<input type="hidden" name="etcWorkDaycnt" value="${eo.etcWorkDaycnt }" >
							<input type="hidden" name="emplyminsrncDaycnt" value="${eo.emplyminsrncDaycnt }" >
							<input type="hidden" name="crqfcDaycnt" value="${eo.crqfcDaycnt }" >
							<input type="hidden" name="edcTraingDaycnt" value="${eo.edcTraingDaycnt }" >
							<input type="hidden" name="etcDaycnt" value="${eo.etcDaycnt }" >
						</td>
						<th scope="row">발급매수</th>
						<td><input type="text" class="w20p" title="발급매수" required  name="issuCo" value="${empty eo.issuCo?'1':eo.issuCo }" number /> <input type="text" class="w30p" title="발급가격" name="issuAmount" value="${eo.issuAmount }" value="0" readonly /> 원</td>
					</tr>
					<tr>
						<th>세부이력 포함여부</th>
						<td colspan="3">
							<input type="radio" name="detailHistInclsAt" id="detailNo" value="N" ${empty eo or eo.detailHistInclsAt eq 'N'?'checked':'' }><label for="detailNo">미포함</label> 
							<input type="radio" name="detailHistInclsAt" id="detailYes" value="Y" ${eo.detailHistInclsAt eq 'Y'?'checked':'' }><label for="detailYes">포함</label>
						</td>
					</tr>
					<tr style="display:none" detailYes>
						<th>기재사항 추가여부</th>
						<td colspan="3">
							<input type="radio" name="stateMatterAditAt" id="stateMatter1" value="N" ${empty eo or eo.stateMatterAditAt eq 'N'?'checked':'' }><label for="stateMatter1">아니오</label> 
							<input type="radio" name="stateMatterAditAt" id="stateMatter2" value="Y" ${eo.stateMatterAditAt eq 'Y'?'checked':'' }><label for="stateMatter2">예</label>
							<input type="text" class="w50p" title="기재사항" name="stateMatter" value="${eo.stateMatter}" style="display:none" stateMatter2/>
						</td>
					</tr>
					<tr>
						<th>주민등록번호<br>(뒷부분6자리)<br>공개여부</th>
						<td colspan="3">
							<input type="radio" name="ihidnumOthbcAt" id="publicNo" value="N" ${empty eo or eo.ihidnumOthbcAt eq 'N'?'checked':'' }><label for="publicNo">비공개</label>
							<input type="radio" name="ihidnumOthbcAt" id="publicYes" value="Y" ${eo.ihidnumOthbcAt eq 'Y'?'checked':'' }><label for="publicYes">공개</label>
						</td>
					</tr>
				</tbody>
			</table>
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 수수료감면 대상</th>
					</tr>
				</thead>
			</table>
			<!-- 수수료감면 대상 START -->
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">수수료감면 신청</th>
						<td colspan="3">
							<input type="radio" name="feeRdcxptReqst" id="feeNo" value="N" ${empty eo or eo.feeRdcxptReqst eq 'N'?'checked':'' }><label for="feeNo">해당없음</label> 
							<input type="radio" name="feeRdcxptReqst" id="feeYes" value="Y" ${eo.feeRdcxptReqst eq 'Y'?'checked':'' }><label for="feeYes">수수료감면 신청</label>
							<select name="feeRdcxptTy" class="custom-select w-100" disabled="disabled">
								<option value="" selected>유형 선택</option>
								<option value="RDCX0001">의료급여 수급자</option>
								<option value="RDCX0002">국가유공자 혹은 그 유족·가족</option>
								<option value="RDCX0003">참전유공자</option>
								<option value="RDCX0004">5·18민주유공자 혹은 그 유족·가족</option>
								<option value="RDCX0005">고엽제후유증환자 · 고엽제후유의증환자 · 고엽제후유증 2세 환자</option>
								<option value="RDCX0006">특수임무유공자 혹은 그 유족·가족</option>
								<option value="RDCX0007">독립유공자 혹은 그 유족·가족</option>
								<option value="RDCX0008">「장애인복지법」제32조 1항에 따라 등록된 장애인</option>
								<option value="RDCX0009">「병역법」제5조 1항 1호 및 3호에 따른 병(兵) 또는 사회복무요원</option>
								<option value="RDCX0010">「병역법」 제25조에 따른 전환복무 수행자</option>
							</select>
							<a href="#docCheckPop" class="openLayer confirm btn normal black ml10 docCheckBtn" style="display:none">제출서류확인</a>
						</td>
					</tr>
				</tbody>
				<!-- 수수료감면 대상 END -->
			</table>
			
			<table class="tbl tbl_search mt10 tbl_attch">
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 첨부서류
						</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5 tbl_attch">
				<tbody>
					<tr>
						<td class="p5" id="fileDiv"></td>
					</tr>
				</tbody>
			</table>

		</div>
		<div class="btn_wrap">
			<div class="fl txt_left">
				<button type="button" id="btnPrint" class="btn normal purple mr10"> <i class="far fa-file-alt mr5"></i> 신청서출력</button>
			</div>
			<div class="fr txt_right">
<!-- 					<button type="button" id="btnPrint" class="btn normal sky mr10"> <i class="fas fa- mr5"></i> 태블릿 서명</button> -->
				<a href="#checkAlert" class="btn normal blue mr10 btnSave"> <i class="far fa-save mr5"></i> ${empty eo.reqstNo ? "신청" : "수정" }</a>
				<c:if test='${empty eo.reqstNo}'>
				<button type="button" onclick="javascript:resetButton();" class="btn normal grey mr10"> <i class="fas fa-list mr5"></i> 초기화</button>
				</c:if>
				<c:if test='${not empty eo.reqstNo}'>
				<button type="button" onclick="history.back();" class="btn normal grey mr10"> <i class="fas fa-list mr5"></i> 취소</button>
				</c:if>
			</div>
		</div>
	</div>
	</form>

		<div class="pageDisabled"></div>	
		<div id="checkAlert" class="layer">
			<h1>동명이인 안내</h1>
			<button type="button" class="close">×</button>
			<div>
				<i class="fas fa-exclamation-triangle big my-3 "></i>
				<p>
					동명이인 정보가 확인됩니다<br>
					자세한 사항은 세부내용을 확인해주시기 바랍니다.<br>
					※이름 및 주민번호 앞자리 숫자가 동일할 경우 경력사항정정를 통해 신청하실 수 있으며, 현재 조회정보로 증명서 발급신청이 가능합니다.
				</p>

				<div class="mt30 txt_center">
					<button type="button" id="btnSave" class="btn normal blue">계속발급(무시)</button>
					<button type="button" id="btnLink" class="btn normal black">세부내역 조회</button>
				</div>

			</div>
		</div>
		
		<!-- 제출서류확인 팝업 START-->
		<div id="docCheckPop" class="layer" style="margin-top: -440px; margin-left: -500px; z-index: 7788; display: none;">
		<h1>발급수수료 감면 사유별 구비서류</h1>
		<button type="button" class="close">×</button>
		<p style="margin-top: 15px;margin-left: 15px;">&nbsp;&nbsp;&nbsp;· 증명서발급 수수료를 감면 받고자 할 경우 해당 유형임을 증명하는 서류를 반드시 제출하여야 합니다.</p>
		<em style="margin-left: 15px;" class="red">&nbsp;&nbsp;&nbsp;· 제출서류 중 1부만 첨부하시면 됩니다.</em>
		<div>
			<table>
				<colgroup>
					<col style="width:8%">
					<col style="width:*%">
					<col style="width:20%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">번호</th>
						<th scope="col">감면 사유</th>
						<th scope="col">제출서류 (택 1)</th>
					</tr>
				</thead>
				<tbody style="background-color: gray;">
					<c:forEach var="list" items="${codeRDCXList }" varStatus="sts">
					<tr>
						<td>${sts.count }</td>
						<td>${list.cdNm }</td>
						<c:if test="${sts.count ne 3 and sts.count ne 10}">
						<td <c:if test="${sts.count eq 2 or sts.count eq 9}" >rowspan="2"</c:if> >${list.cdDc }</td>
						</c:if>
					</tr>
					</c:forEach>
				</tbody>
			</table>
	
			<div class="mt30 txt_center">
<!-- 				<button type="button " class="btn normal green"><i class="fas fa-folder-plus mr5"></i>추가</button> -->
				<button type="button " class="close btn normal black"><i class="fas fa-times mr5"></i>확인</button>
			</div>
		</div>
	</div>
	<!-- 제출서류확인 팝업 END-->
	
</body>
</html>
