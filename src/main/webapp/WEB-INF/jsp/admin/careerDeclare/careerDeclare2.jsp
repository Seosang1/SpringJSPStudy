<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/chosen/docsupport/prism.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/lib/chosen/chosen.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/static/lib/chosen/chosen.jquery.js"></script>
<script type="text/javascript">
	var uploader = null;
	
	$(function(){
		//초기화
		uploader = new CrossUploader({fileLayer:'fileDiv', parntsSe:'ATCH0009'});
		
		$('.title > em').text('근로직종확인');
		
		//목록버튼 이벤트
		$('.btnList').click(function(e){
			location.href = $(this).attr('href');
			e.preventDefault();
			return false;
		});
		
		$('#btnPrint').click(function(){
			if(!$('[name=snList]:checked').length){
				alert('근로직종확인신청 대상을 선택해주세요');
				return false;
			}
			$('#frm').attr('action', 'careerDeclareIns.do');
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					/* 미리보기 여부 */
					if(!$('#frm [name=deleteAt]').length){
						$('#frm').append('<input type="hidden" name="deleteAt" value="Y" >')
					}
					$('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', true);
					$('[name=snList]:checked').each(function(){
						$(this).parent().parent().parent().find('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', false);
					});
				}, success:function(res){
					$('#frm').append('<input type="hidden" name="careerNo" value="'+res.careerNo+'" >');
					window.open("", "careerDeclareReport","status=no,scrollbars=yes,resizable=no,top=100,left=100,width=790,height=550");
					$('#frm').attr('action', 'careerDeclareReportPop.do');
					$('#frm').attr('target', 'careerDeclareReport');
					$('#frm').submit();
					$('#frm').attr('target', '');
					$('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', false);
				}
			});
		});
		
		$('#btnSearch').click(function(e){
			e.preventDefault();
			
			if($.trim($('[name=jumin1]').val()) == "" || $.trim($('[name=jumin2]').val()) == ""){
				alert('주민등록번호를 입력하여 주십시오.');
				return false;
			}
			$('#frm').attr('action', '');
			$('#frm').submit();
		});
		
		$('[name=se]').change(function(){
			$('#frm').attr('action', '');
			$('#frm').submit();
		});

		$('[name=relate]').change(function(e){
			if("RELA0001" != $(this).val() && "" != $(this).val()){
				$('[name=relateDetail]').show();
				$('[name=relateDetail]').attr('disabled', false);
			}else{
				$('[name=relateDetail]').hide();
				$('[name=relateDetail]').val('');
				$('[name=relateDetail]').attr('disabled', true);
			} 
		});
		
		function setPopup(){
			var popup = $('a.popup');

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
		
		$('[name="rqstdt"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		
		setPopup();

		$('[name=eamilSelect]').change(function(){
			if($(this).val() == ""){
				$('[name=email2]').val('');
				$('[name=email2]').focus();
			}else{
				$('[name=email2]').val($(this).val());
			}
		});
		
		var config = {
		  '.chosen-select'           : {},
		  '.chosen-select-deselect'  : { allow_single_deselect: true },
		  '.chosen-select-no-single' : { disable_search_threshold: 10 },
		  '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' },
		  '.chosen-select-rtl'       : { rtl: true },
		  '.chosen-select-width'     : { width: '95%' }
		}
		
		for (var selector in config) {
		  $(selector).chosen(config[selector]);
		}
		
		$('#jssfcChkbox').change(function(){
			if($(this).is(":checked")){
				$('#jssfcChk').find('input:checkbox').each(function(){
					$(this).attr('checked', true);
				});
			}else{
				$('#jssfcChk').find('input:checkbox').each(function(){
					$(this).attr('checked', false);
				});
			}
		});
		
		$('[name=jumin1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin2]').focus();
			}
		});
		

		$('[name=tel1]').keyup(function(){
			if($(this).val().length == 4){
				$('[name=tel2]').focus();
			}
		});
		
		$('[name=tel2]').keyup(function(){
			if($(this).val().length == 4){
				$('[name=tel3]').focus();
			}
		});

		$('[name=tel21]').keyup(function(){
			if($(this).val().length == 4){
				$('[name=tel22]').focus();
			}
		});
		
		$('[name=tel22]').keyup(function(){
			if($(this).val().length == 4){
				$('[name=tel23]').focus();
			}
		});
		
		$('[name=bizno1]').keyup(function(){
			if($(this).val().length == 3){
				$('[name=bizno2]').focus();
			}
		});
		
		$('[name=bizno2]').keyup(function(){
			if($(this).val().length == 2){
				$('[name=bizno3]').focus();
			}
		});
		
		$('[name=jurirno1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jurirno2]').focus();
			}
		});
		
		//전체선택(체크박스)
		$('[name="checkAll"]').click(function(){
			$(this).parents('.tbl_data').find('tbody :checkbox').prop('checked', $(this).prop('checked'));
		});
		
		<c:if test='${not empty param.jumin1 and not empty param.jumin2 and empty eo.jumin1}'>
		$('#frm').submit();
		</c:if>
		
		<c:if test='${empty umvo.ihidnum and !empty param.jumin1}'>
		alert('주민등록번호로 조회된 결과가 없습니다.');
		</c:if>
		
		<c:if test="${!empty umvo and (empty umvo.userInfoVO || 'Y' ne umvo.userInfoVO.clmserEduComplAt)}">
		if(confirm('최초교육 미이수자 입니다.\n교육관리화면으로 이동하시겠습니까?')){
			$('#frm input').prop('disabled', true);
			$('#frm').attr('action', '../clmserEdu/list.do');
			$('#frm').append('<input type="hidden" name="ihidnum" value="${umvo.ihidnum}" />')
			$('#frm').submit();
		}
		</c:if>
	});
	
	function validation(){
		if(!uploader.getTotalFileCount()){
			alert('첨부파일을 입력해주세요');
			return false;
			
		}else if(!$('[name=snList]:checked').length){
			alert('근로직종확인신청 대상을 선택해주세요');
			return false;
			
		}
		
		return true;
	}
	
	function ipButton(){
		if(validation()){
			var txt = $(this).text().trim();
			$('#frm').attr('action', 'careerDeclareIns.do');
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					if(!validation()){
						return false;
					}
					
					$('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', true);
					$('[name=snList]:checked').each(function(){
						$(this).parent().parent().find('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', false);
					});
					
					$('[name=deleteAt]').remove();
					
					if($('[name="careerNo"]').val())
						$('#frm').attr('action', 'careerDeclareUpd.do');						
					
					$(uploader.modifiedFilesInfoList).each(function(){
						if(this.isDeleted){
							$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].parntsSn" value="'+this.parntsSn+'" />');
							$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].parntsSe" value="'+this.parntsSe+'" />');
							$('#frm').append('<input type="hidden" name="delFileVO['+(delIdx)+'].fileSn" value="'+this.fileSn+'" />');
							delIdx++;
						}
					});
					
					isUploading = true;
					uploader.startUpload();
				}, success:function(res){
					alert('신청 되었습니다');
					$('#frm').append('<input type="hidden" name="careerNo" value="'+res.careerNo+'">');
					$('#frm').attr('action', 'careerDeclareView.do');
					$('#frm').submit();
				}
			});
			return false;
		}
	}

	function resetButton(){
		if(confirm("입력내용이 초기화됩니다. 계속 진행하시겠습니까?")){
			cwmaFile.setFileList(true);
			$('#frm')[0].reset();
		}
	}
	
	window.addEventListener('message', function (e) {
		if(e.data.callback == 'adrs'){
			$('[name="zip"]').val(e.data.zip);
			$('[name="adres"]').val(e.data.adrs);
		}else if(e.data.callback == 'adrs2'){
			$('[name="zip2"]').val(e.data.zip);
			$('[name="adres2"]').val(e.data.adrs);
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
	
	/* 퇴직공제 공사명 클릭시 확인자 정보 setting */
	function fn_infoInsert(corpNm,bizno,bplcNo,mbtlnum,rprsntvNm,zip,adres){
		$("[name=cmpnmNm]").val(corpNm);				//상호명
		$("[name=rprsntvNm]").val(rprsntvNm);			//대표자명
		$("[name=bizno1]").val(bizno.split("-")[0]);		//사업자번호1
		$("[name=bizno2]").val(bizno.split("-")[1]);		//사업자번호2
		$("[name=bizno3]").val(bizno.split("-")[2]);		//사업자번호3
		$("[name=jurirno1]").val(bplcNo.slice(0,6));		//법인등록번호1
		$("[name=jurirno2]").val(bplcNo.slice(7));	//법인등록번호2
		$("[name=tel21]").val(mbtlnum.split("-")[0]);	//전화번호1
		$("[name=tel22]").val(mbtlnum.split("-")[1]);	//전화번호2
		$("[name=tel23]").val(mbtlnum.split("-")[2]);	//전화번호3
		$("[name=zip2]").val(zip);								//우편번호
		$("[name=adres2]").val(adres);						//주소
	}
</script>
</head>
<body>
<form action="" id="frm" method="post">
	<div class="data_wrap">
		<div>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col width="10%" />
					<col width="90%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><em class="required">*</em>구분</th>
						<td>
							<input type="radio" id="rad201" name="se" value="CASE0001" title="구분"><label for="rad201">경력인정신청</label>
							<input type="radio" id="rad202" name="se" value="CASE0002" title="구분" checked><label for="rad202">근로직종확인신청</label>
						</td>
					</tr>
				</tbody>
			</table>
	
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>신청자정보  (건설근로자)</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col width="10%" />
					<col width="40%" />
					<col width="10%" />
					<col width="40%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><em class="required">*</em>주민등록번호<br>(외국인등록번호)</th>
						<td colspan="3">
							<input type="text" class="w150" name="jumin1" title="주민등록번호 앞자리" maxlength="6" value="${empty param.jumin1?eo.jumin1:param.jumin1}" required number>
							-
							<input type="text" class="w150" name="jumin2" title="주민등록번호 뒷자리" maxlength="7" value="${empty param.jumin2?eo.jumin2:param.jumin2}" required number>
							<a href="#" id="btnSearch" class="btn btn_search" style="color:#fff"> 조회</a></td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>성명</th>
						<td>
							<input type="text" class="w100p" maxlength="30" name="nm" title="성명" value="${eo.nm}" required />
						</td>
						<th scope="row"><em class="required">*</em>신청자와 관계</th>
						<td>
							<select name="relate" class="w20p" required title="유형">
	<!-- 							<option value="">유형선택</option> -->
								<c:forEach var="relateList" items="${relateList}">
									<option value="${relateList.cdId}"
										${relateList.cdId eq eo.relate?'selected':''}>${relateList.cdNm}</option>
								</c:forEach>
							</select>
							<input type="text" class="w80p" maxlength="100" name="relateDetail" title="관계 상세" value="${eo.relateDetail}" disabled style="display:none">
						</td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>휴대폰</th>
						<td>
							<input type="text" class="w20p" maxlength="4" name="tel1" title="휴대폰번호1" value="${eo.tel1}" required number/>
							- <input type="text" class="w20p" maxlength="4" name="tel2" title="휴대폰번호2" value="${eo.tel2}" required number/>
							- <input type="text" class="w20p" maxlength="4" name="tel3" title="휴대폰번호3" value="${eo.tel3}" required number/>
						</td>
						<th scope="row">이메일</th>
						<td>
							<input type="text" class="w20p" maxlength="30" name="email1" title="이메일 앞" value="${eo.email1}" /> 
							@ <input type="text" class="w30p" maxlength="30" name="email2" title="이메일 뒤" value="${eo.email2}" />
							<input type="hidden" name="email" title="이메일" value="${eo.email}" />
							<select name="eamilSelect" class="w20p" title="이메일 뒤">
								<option value="">직접입력</option>
								<option value="naver.com">naver.com</option>
								<option value="hanmail.net">hanmail.net</option>
								<option value="daum.net">daum.net</option>
								<option value="gmail.com">gmail.com</option>
								<option value="nate.com">nate.com</option>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3">
							<a data-pw="700" data-ph="620" target="p129334" href="${pageContext.request.contextPath}/common/adrsPop.do?cb=adrs" class="btn btn_search popup" style="color:#fff"> 주소검색</a>
							<input type="text" class="w20p" maxlength="30" name="zip" title="우편번호" value="${eo.zip }" readonly >
							<input type="text" class="w70p"	maxlength="30" name="adres" title="주소" value="${eo.adres }" readonly >
						</td>
					</tr> 
					<tr>
						<th scope="row"><em class="required">*</em>신청일</th>
						<td colspan="3">
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="rqstdt" title="신청일" value="${eo.rqstdt}">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div>
						</td>
					</tr>
				</tbody>
			</table>
	
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>확인자 정보</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col width="10%" />
					<col width="40%" />
					<col width="10%" />
					<col width="40%" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><em class="required">*</em>상호명</th>
						<td><input type="text" class="w100p" name="cmpnmNm" maxlength="30" title="상호명" required/></td>
						<th scope="row"><em class="required">*</em>대표자명</th>
						<td><input type="text" class="w100p" name="rprsntvNm" maxlength="30" title="대표자명" required/></td>
					</tr>
					<tr>
						<th scope="row"><em class="required">*</em>사업자등록번호</th>
						<td>
							<input type="text" class="w20p" maxlength="3" name="bizno1" title="사업자등록번호1" value="${eo.bizno1}" required number/>
							- <input type="text" class="w20p" maxlength="2" name="bizno2" title="사업자등록번호2" value="${eo.bizno2}" required number/>
							- <input type="text" class="w20p" maxlength="5" name="bizno3" title="사업자등록번호3" value="${eo.bizno3}" required number/>
						</td>
						<th scope="row">법인등록번호</th>
						<td>
							<input type="text" class="w20p" maxlength="6" name="jurirno1" title="법인등록번호1" value="${eo.jurirno1}" number/>
							- <input type="text" class="w20p" maxlength="7" name="jurirno2" title="법인등록번호2" value="${eo.jurirno2}" number/>
						</td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td colspan="3">
							<input type="text" class="w20p" maxlength="4" name="tel21" title="휴대폰번호1" value="${eo.tel21}" number/>
							- <input type="text" class="w20p" maxlength="4" name="tel22" title="휴대폰번호2" value="${eo.tel22}" number/>
							- <input type="text" class="w20p" maxlength="4" name="tel23" title="휴대폰번호3" value="${eo.tel23}" number/>
						</td>
					</tr>
					<tr>
						<th scope="row">주소</th>
						<td colspan="3">
							<a data-pw="700" data-ph="620" target="p129334" href="${pageContext.request.contextPath}/common/adrsPop.do?cb=adrs2" class="btn btn_search popup" style="color:#fff"> 주소검색</a>
							<input type="text" class="w20p" maxlength="30" name="zip2" title="우편번호" value="" readonly >
							<input type="text" class="w70p"	maxlength="30" name="adres2" title="주소" value="" readonly	>
						</td>
					</tr>
				</tbody>
			</table>

			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 40%;">
					<col style="width: 10%;">
					<col style="width: 40%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 퇴직공제</th>
					</tr>
				</thead>
			</table>
			
			<div class="tableWrap careerCheck">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="5%" />
							<col width="30%" />
							<col width="15%" />
							<col width="20%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<tr>
								<th><span><input type="checkbox" name="checkAll" value="0"></span></th>
								<th><span>공사명</span></th>
								<th><span>업체명</span></th>
								<th><span>근로년월</span></th>
								<th><span>근로일수</span></th>
								<th><span>신고직종</span></th>
								<th><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="list" items="${workList }" varStatus="sts">
							<tr>
								<td><input type="checkbox" name="snList" value="${list.sn }"><input type="hidden" name="cntcCodeList" value="${list.cntcCode }"></td>
								<td><a href='javascript:fn_infoInsert("${list.corpNm}","${list.bizno}","${list.bplcNo}","${list.mbtlnum}","${list.rprsntvNm}","${list.zip}","${list.adres}");'>${list.bplcNm }</a></td>
								<td>${list.corpNm }</td>
								<td date="yy-mm">${list.laborYm }</td>
								<td money>${list.laborDaycnt }</td>
								<td>${list.jssfcNm }</td>
								<td>
									<select name="jssfcNoList">
										<c:forEach var="ceo" items="${jssfcList}">
											<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq list.jssfcNo?'selected':''}>${ceo.jssfcNm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>고용보험(상용)</th>
					</tr>
				</thead>
			</table>
			
			<div class="tableWrap careerCheck">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="5%" />
							<col width="30%" />
							<col width="15%" />
							<col width="20%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<th><span><input type="checkbox" name="checkAll" value="0"></span></th>
							<th><span>공사명</span></th>
							<th><span>업체명</span></th>
							<th><span>근로년월</span></th>
							<th><span>근로일수</span></th>
							<th><span>신고직종</span></th>
							<th><span>통합직종</span></th>
						</thead>
						<tbody>
							<c:forEach var="list" items="${workCmclList }" varStatus="sts">
							<tr>
								<td><input type="checkbox" name="snList" value="${list.sn }"><input type="hidden" name="cntcCodeList" value="${list.cntcCode }"></td>
								<td><a href='javascript:fn_infoInsert("${list.corpNm}","${list.bizno}","${list.bplcNo}","${list.mbtlnum}","${list.rprsntvNm}","${list.zip}","${list.bplcAdres}");'>${list.bplcNm }</a></td>
								<td>${list.corpNm }</td>
								<td dateToDate>${list.laborAcqdt} ~ ${list.laborFrfdt}</td>
								<td money>${list.laborDaycnt }</td>
								<td>${list.jssfcNm }</td>
								<td>
									<select name="jssfcNoList">
										<c:forEach var="ceo" items="${jssfcList}">
											<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq list.jssfcNo?'selected':''}>${ceo.jssfcNm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>고용보험(일용)</th>
					</tr>
				</thead>
			</table>
			
			
			<div class="tableWrap careerCheck">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="5%" />
							<col width="30%" />
							<col width="15%" />
							<col width="20%" />
							<col width="10%" />
							<col width="10%" />
							<col width="10%" />
						</colgroup>
						<thead>
							<th><span><input type="checkbox" name="checkAll" value="0"></span></th>
							<th><span>공사명</span></th>
							<th><span>업체명</span></th>
							<th><span>근로년월</span></th>
							<th><span>근로일수</span></th>
							<th><span>신고직종</span></th>
							<th><span>통합직종</span></th>
						</thead>
						<tbody>
							<c:forEach var="list" items="${workDlyList }" varStatus="sts">
							<tr>
								<td><input type="checkbox" name="snList" value="${list.sn }"><input type="hidden" name="cntcCodeList" value="${list.cntcCode }"></td>
								<td><a href='javascript:fn_infoInsert("${list.corpNm}","${list.bizno}","${list.bplcNo}","${list.mbtlnum}","${list.rprsntvNm}","${list.zip}","${list.bplcAdres}");'>${list.bplcNm }</a></td>
								<td>${list.corpNm }</td>
								<td date="yy-mm">${list.laborYm}</td>
								<td money>${list.laborDaycnt }</td>
								<td>${list.jssfcNm }</td>
								<td>
									<select name="jssfcNoList">
										<c:forEach var="ceo" items="${jssfcList}">
											<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq list.jssfcNo?'selected':''}>${ceo.jssfcNm}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
	
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>제출서류</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<tbody>
					<tr>
						<td class="p5" id="fileDiv"></td>
					</tr>
				</tbody>
			</table>
		</div>

		<div class="btn_wrap">
			<div class="fl txt_left">
				<button type="button" id="btnPrint" class="btn normal purple mr10"> <i class="far fa-file-alt mr5"></i> 신청서 미리보기</button>
			</div>
			<div class="fr txt_right">
				<button type="button" onclick="javascript:ipButton();" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 신청 </button>
				<button type="reset" onclick="javascript:resetButton();" class="btn normal grey mr10"> <i class="fas fa-list mr5"></i> 초기화</button>
			</div>
		</div>
	</div>
</form>
</body>
</html>
