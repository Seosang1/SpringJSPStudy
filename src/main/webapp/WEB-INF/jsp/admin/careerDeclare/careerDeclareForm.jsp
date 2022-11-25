<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var uploader = null;
	
	$(function(){
		//초기화
		uploader = new CrossUploader({fileLayer:'fileDiv', parntsSe:'ATCH0009', parntsSn:$('[name="careerNo"]').val()});
		
		$('[name="jssfcNoList"]').each(function(){
		    if($(this).find('option').length <= 1)
		        $(this).hide();
		});
		
		//목록버튼 이벤트
		$('.btnList').click(function(e){
			location.href = $(this).attr('href');
			e.preventDefault();
			return false;
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
		
		//$('[name=eamilSelect]').change();
		
		$('[name=jumin1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin2]').focus();
			}
		});
		
		//전체선택(체크박스)
		$('[name="allCheck"]').click(function(){
			$(this).parents('.tbl_data').find('tbody :checkbox').prop('checked', $(this).prop('checked'));
		});
		
		$('[name=relate]').change();
	});
	
	function validation(){
		return true;
	}
	
	function ipButton(){
		if(validation()){
			var txt = $(this).text().trim();
			$('#frm').attr('action', 'careerDeclareUpd.do');
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					if(!validation()){
						return false;
					}
					
					$('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', true);
					$('[name=snList]:checked').each(function(){
						$(this).parent().parent().find('[name=cntcCodeList], [name="jssfcNoList"]').prop('disabled', false);
					});
					
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
				}, success:function(res){
					alert('수정 되었습니다');
					$('#frm').attr('action', 'careerDeclareView.do');
					$('#frm').submit();
				}
			});
			return false;
		}
	}
	
	window.addEventListener('message', function (e) {
		if(e.data.callback == 'adrs'){
			$('[name="zip"]').val(e.data.zip);
			$('[name="adres"]').val(e.data.adrs);
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
</script>
</head>
<body>
	<form action="" id="frm" method="post">
		<input type="hidden" name="careerNo" value="${eo.careerNo }" >
		<input type="hidden" name="sptSe" value="${eo.sptSe }" >
		<table class="tbl tbl_form mt5">
			<colgroup>
				<col width="10%" />
				<col width="90%" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row"><em class="required">*</em>구분</th>
					<td>
						<input type="radio" id="se1" name="se" value="CASE0001" title="구분" checked><label for="se1">경력인정신고</label>
						<input type="radio" id="se2" name="se" value="CASE0002" title="구분"><label for="se2">근로직종확인</label>
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
					<th scope="row" class=""><i class="fas fa-th-large mr10"></i>신청자정보</th>
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
						<input type="text" class="w150" name="jumin1" title="주민등록번호 앞자리" maxlength="6" value="${eo.jumin1}" required number>
						-
						<input type="text" class="w150" name="jumin2" title="주민등록번호 뒷자리" maxlength="7" value="${eo.jumin2}" required number>
						<a href="#" id="btnSearch" class="btn btn_search"> 조회</a></td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>성명</th>
					<td>
						<input type="text" class="w100p" maxlength="30" name="nm" title="성명" value="${eo.nm}" required />
					</td>
					<th scope="row"><em class="required">*</em>신청자와 관계</th>
					<td>
						<select name="relate" class="w20p" required title="신청자와 관계">
							<option value="">유형선택</option>
							<c:forEach var="relateList" items="${relateList}">
								<option value="${relateList.cdId}" ${relateList.cdId eq eo.relate?'selected':''}>${relateList.cdNm}</option>
							</c:forEach>
						</select>
						<input type="text" class="w70p" maxlength="100" name="relateDetail" title="관계 상세" value="${eo.relateDetail}" disabled style="display:none">
					</td>
				</tr>
				<tr>
					<th scope="row"><em class="required">*</em>휴대폰</th>
					<td>
						<input type="text" class="w20p" maxlength="30" name="tel1" title="휴대폰번호1" value="${eo.tel1}" required />
						- <input type="text" class="w20p" maxlength="30" name="tel2" title="휴대폰번호2" value="${eo.tel2}" required />
						- <input type="text" class="w20p" maxlength="30" name="tel3" title="휴대폰번호3" value="${eo.tel3}" required />
					</td>
					<th scope="row"><em class="required">*</em>이메일</th>
					<td>
						<input type="text" class="w20p" maxlength="30" name="email1" title="이메일 앞" value="${eo.email1}" /> 
						@ <input type="text" class="w30p" maxlength="30" name="email2" title="이메일 뒤" value="${eo.email2}" />
						<input type="hidden" name="email" title="이메일" value="${eo.email}" />
						<select name="eamilSelect" class="w20p" title="유형">
							<option value="">직접입력</option>
							<option value="naver.com" ${"naver.com" == eo.email2 ? "selected" : "" }>naver.com</option>
							<option value="hanmail.net" ${"hanmail.net" == eo.email2 ? "selected" : "" }>hanmail.net</option>
							<option value="daum.net" ${"daum.net" == eo.email2 ? "selected" : "" }>daum.net</option>
							<option value="gmail.com" ${"gmail.com" == eo.email2 ? "selected" : "" }>gmail.com</option>
							<option value="nate.com" ${"nate.com" == eo.email2 ? "selected" : "" }>nate.com</option>
						</select>
					</td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td colspan="3">
						<a data-pw="700" data-ph="620" target="p129334" href="${pageContext.request.contextPath}/common/adrsPop.do?cb=adrs" class="btn btn_search popup"> 주소검색</a>
						<input type="text" class="w20p" maxlength="30" name="zip" title="우편번호" value="${eo.zip }" readonly>
						<input type="text" class="w70p"	maxlength="30" name="adres" title="주소" value="${eo.adres }" readonly>
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

<script type="text/javascript">
var tabDisplay = function(str) {
	if(str == "P") {		
        $("#tab1").addClass("on");
        $("#tab2").removeClass("on");
        $("#tab3").removeClass("on");
        $('#catab_1').show();
        $('#catab_2').hide();
        $('#catab_3').hide();
	} else if(str == "R") {
        $("#tab1").removeClass("on");
        $("#tab2").addClass("on");
        $("#tab3").removeClass("on");
        $('#catab_1').hide();
        $('#catab_2').show();
        $('#catab_3').hide();
	} else if(str == "E") {
        $("#tab1").removeClass("on");
        $("#tab2").removeClass("on");
        $("#tab3").addClass("on");
        $('#catab_1').hide();
        $('#catab_2').hide();
        $('#catab_3').show();
	}
}
</script>
		<ul class="tab200 mt10">
			<li class="on" id="tab1" name="tab1" onClick="tabDisplay('P');">
				자격</li>
			<li id="tab2" name="tab2" onClick="tabDisplay('R');">교육훈련</li>
			<li id="tab3" name="tab3" onClick="tabDisplay('E');">포상</li>
		</ul>

		<div id="catab_1" name="catab_1" style="display: block;">
			<!-- 자격 -->
			<table class="tbl tbl_data mt5">
				<colgroup>
					<col width="5%" />
					<col width="" />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="allCheck" value="0"></th>
						<th scope="col"><span>과정명</span></th>
						<th scope="col"><span>등록번호</span></th>
						<th scope="col"><span>발급기관</span></th>
						<th scope="col"><span>통합직종</span></th>
						<th scope="col"<span>직종선택</span></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="list" items="${licenseList }" varStatus="sts">
					<tr>
						<td><input type="checkbox" name="snList" value="${list.sn }" ${not empty list.careerNo?'checked':''}><input type="hidden" name="cntcCodeList" value="${list.cntcCode }"></td>
						<td>${list.lcnsNm }</td>
						<td>${list.lcnsNo }</td>
						<td>${list.lcnsInst }</td>
						<td>${list.stdrJssfcNm }</td>
						<td>
							<select name="jssfcNoList">
								<option value="">선택하세요.</option>
								<c:forEach var="jssfcList" items="${list.multiJssfcVO }">
									<option value="${jssfcList.jssfcNo }" ${list.jssfcNo eq jssfcList.jssfcNo?'selected':''}>${jssfcList.jssfcNm }</option>
								</c:forEach>
								<c:if test="${empty list.multiJssfcVO }">
									<option value="${list.stdrJssfcNo }" selected>${list.stdrJssfcNm }</option>
								</c:if>
							</select>
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
		<div id="catab_2" name="catab_2" style="display: none;">
			<!-- 교육훈련 -->
			<table class="tbl tbl_data mt5">
				<colgroup>
					<col width="5%" />
					<col width="" />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="allCheck" value="0"></th>
						<th scope="col"><span>과정명</span></th>
						<th scope="col"><span>기간</span></th>
						<th scope="col"><span>교육·훈련기관</span></th>
						<th scope="col"><span>통합직종</span></th>
						<th scope="col"><span>직종선택</span></th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="list" items="${eduList }" varStatus="sts">
					<tr>
						<td><input type="checkbox" name="snList" value="${list.sn }" ${not empty list.careerNo?'checked':''}><input type="hidden" name="cntcCodeList" value="${list.cntcCode }"></td>
						<td>${list.crseNm }</td>
						<td>${list.traingDe }</td>
						<td>${list.cntcNm }</td>
						<td>${list.stdrJssfcNm }</td>
						<td>
							<select name="jssfcNoList">
								<option value="">선택하세요.</option>
								<c:forEach var="jssfcList" items="${list.multiJssfcVO }">
									<option value="${jssfcList.jssfcNo }" ${list.jssfcNo eq jssfcList.jssfcNo?'selected':''}>${jssfcList.jssfcNm }</option>
								</c:forEach>
								<c:if test="${empty list.multiJssfcVO }">
									<option value="${list.stdrJssfcNo }" selected>${list.stdrJssfcNm }</option>
								</c:if>
							</select>
						</td>
					</tr>
				</c:forEach>
				</tbody>
			</table>
		</div>
		<div id="catab_3" name="catab_3" style="display: none;">
			<!-- 포상 -->
			<table class="tbl tbl_data mt5">
				<colgroup>
					<col width="5%" />
					<col width="" />
					<col width="10%" />
					<col width="5%" />
					<col width="10%" />
					<col width="15%" />
					<col width="10%" />
					<col width="10%" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><input type="checkbox" name="allCheck" value="0"></th>
						<th scope="col"><span>대회명</span></th>
						<th scope="col"><span>종목</span></th>
						<th scope="col"><span>순위</span></th>
						<th scope="col"><span>수여일자</span></th>
						<th scope="col"><span>수여기관</span></th>
						<th scope="col"><span>통합직종</span></th>
						<th scope="col"><span>직종선택</span></th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="list" items="${rewardList }" varStatus="sts">
					<tr>
						<td><input type="checkbox" name="snList" value="${list.sn }" ${not empty list.careerNo?'checked':''}><input type="hidden" name="cntcCodeList" value="${list.cntcCode }"></td>
						<td>${list.cnfrncNm }</td>
						<td>${list.item }</td>
						<td>${list.grad }</td>
						<td>${list.rwardDe }</td>
						<td>${list.cntcNm }</td>
						<td>${list.stdrJssfcNm }</td>
						<td>
							<select name="jssfcNoList">
								<option value="">선택하세요.</option>
								<c:forEach var="jssfcList" items="${list.multiJssfcVO }">
									<option value="${jssfcList.jssfcNo }" ${list.jssfcNo eq jssfcList.jssfcNo?'selected':''}>${jssfcList.jssfcNm }</option>
								</c:forEach>
								<c:if test="${empty list.multiJssfcVO }">
									<option value="${list.stdrJssfcNo }" selected>${list.stdrJssfcNm }</option>
								</c:if>
							</select>
						</td>
					</tr>
					</c:forEach>
				</tbody>
			</table>
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
					<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 제출서류</th>
				</tr>
			</thead>
		</table>
		<table class="tbl tbl_form mt5">
			<tbody>
				<tr>
					<td colspan="3" class="p5" id="fileDiv"></td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<button type="button" onclick="javascript:ipButton();" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 수정 </button>
				<button type="button" onclick="javascript:history.back();" class="btn normal grey mr10"> <i class="fas fa-list mr5"></i> 취소</button>
			</div>
		</div>
	</form>
</body>
</html>
