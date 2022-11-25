<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<style type="text/css">
	#pageDiv a{
		margin: 0 5px;
	}
	
	div.layer table.cnstwk-info{
		margin-top: 20px;
	}
	
	div.layer table.cnstwk-info th {
		text-align: center;
	    padding: 0 20px;
		color: #f2f2f2;
	    background-color: #ffb500;
	}
	div.layer table.cnstwk-info td {
		text-align: center;
	}
</style>
<script type="text/javascript">
	var rgstDt = getFormatDate(0,0);
	var validDt = getFormatDate(0,90);
	
	var cwmaList;
	var uploader = null; 
	
	//기본값 세팅
	$(function(){
		var dayCnt = 0;
		
		cwmaList = new cwma.list({func: 'ajaxCnstwkList'});
		
		//휴대폰
		$($('[name="moblphonNo"]').val().split('-')).each(function(i){
			$('[name="phone"]:eq('+i+')').val(String(this));
		});
		
		//이메일
		if($('[name="email"]').val().replace('@', '')){
			$('[name="mail"]:eq(0)').val($('[name="email"]').val().split('@')[0]);
			$('[name="mail"]:eq(1)').val($('[name="email"]').val().split('@')[1]);
			$('[name="mail"]:eq(2)').val($('[name="email"]').val().split('@')[1]);
			
			if(!$('[name="grad"]').val())
				$('[name="grad"]').val('');
		}
		
		//상담일자
		$('[name="cnsltDe"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
		
		//일수계산
		//일용
		$('.tbl_data:eq(4) tbody tr').each(function(i){
			if($(this).find('td:eq(3)')[0] && $(this).find('td:eq(3)').text()){
				dayCnt += Number($(this).find('td:eq(3)').text());
			}
		});
		$('.tbl_data:eq(4) thead em').text(dayCnt.formatMoney());
		dayCnt = 0;
		
		//상용
		$('.tbl_data:eq(5) tbody tr').each(function(i){
			if($(this).find('td:eq(3)')[0] && $(this).find('td:eq(3)').text()){
				dayCnt += Number($(this).find('td:eq(3)').text());
			}
		});
		$('.tbl_data:eq(5) thead em').text(dayCnt.formatMoney());
		dayCnt = 0;
		
		$('[today]').text($.datepicker.formatDate('yy-mm-dd', new Date()));
	});
	
	//이벤트
	$(function(){
		//상담이력 목록조회
		function ajaxList(){
			$('#cnsltFrm').attr('action', 'cnsltHistList.do');
			$('#cnsltFrm').ajaxCwma({
				beforeValid:false,
				success:function(res){
					var html = '';
					
					$(res.list).each(function(){
						html += '<tr>';
						html += '<td>'+this.se+'</td>';
						html += '<td class="txt_left pl20">'+this.cn+'</td>';
						html += '<td>'+this.rgstDt.formatDate()+'</td>';
						html += '<td>'+this.rgstDept+'</td>';
						html += '<td>'+this.rgstNm+'</td>';
						html += '</tr>';
					});
					
					$('#result').html(html);
				}
			});
		}
		
		//직종변경 클릭
		$('#chkJssfcNo').click(function(){
			if($(this).prop('checked'))
				$('[name="jssfcNo"]').prop('disabled', false)
			else
				$('[name="jssfcNo"]').prop('disabled', true)
		});
		
		//직종변경시
		$('[name="jssfcNo"]').change(function(e){
			var tbody = $(this).parents('tbody');
			var isDisabled = false;
			
			if(!$('[name="jssfcNo"]').val())
				return false;
			
			if($('[name="jssfcNo"]').prop('disabled')){
				isDisabled = true;
				$('[name="jssfcNo"]').prop('disabled', false);
			}
			
			$('#frm').attr('action', 'userGrad.do');
			$('#frm').ajaxCwma({
				success:function(res){
					if(res.eo){
						tbody.find('.red:eq(0)').text(res.eo.gradNm);
						tbody.find('.red:eq(1)').text(parseFloat(res.eo.gradCnt).toFixed(2));
						tbody.find('th:contains(현장경력)').next().text((res.eo.emplyminsrncDaycnt/res.eo.stdrdaycnt).toFixed(2));
						tbody.find('th:contains(자격)').next().text((res.eo.crqfcDaycnt/res.eo.stdrdaycnt).toFixed(2));
						tbody.find('th:contains(교육훈련)').next().text((res.eo.edcTraingDaycnt/res.eo.stdrdaycnt).toFixed(2));
						tbody.find('th:contains(포상)').next().text((res.eo.etcDaycnt/res.eo.stdrdaycnt).toFixed(2));
						
						$('.eoYearCnt').text((res.eo.emplyminsrncDaycnt/res.eo.stdrdaycnt).toFixed(2));	//퇴직공제
						$('.licenseYearCnt').text((res.eo.crqfcDaycnt/res.eo.stdrdaycnt).toFixed(2));			//자격증
						$('.eduYearCnt').text((res.eo.edcTraingDaycnt/res.eo.stdrdaycnt).toFixed(2));		//교육훈련
						$('.rewardYearCnt').text((res.eo.etcDaycnt/res.eo.stdrdaycnt).toFixed(2));				//포상
					}
					
					if(isDisabled)
						$('[name="jssfcNo"]').prop('disabled', true);
				}
			});
			e.preventDefault();
			return false;
		});
		
		//이메일셀렉트 변경
		$('[name="mail"]:eq(2)').change(function(){
			$('[name="mail"]:eq(1)').val($(this).val());
		});
		
		//수정버튼
		$('.btnUpd').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				beforeSubmit:function(){
					$('[name="moblphonNo"]').val($('[name="phone"]').map(function(i, o){return o.value;}).get().join('-'));
					
					if($('[name="mail"]:eq(0)').val() && $('[name="mail"]:eq(1)').val())
						$('[name="email"]').val($('[name="mail"]:eq(0)').val()+'@'+$('[name="mail"]:eq(1)').val());
				},
				success:function(res){
					alert('수정되었습니다');
				}
			});
			e.preventDefault();
			return false;
		});
		
		//삭제버튼
		$('.btnDel').click(function(e){
			if(!confirm('삭제하시겠습니까?'))
				return false;
			
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					alert('삭제되었습니다');
					location.href='personalList.do';
				}
			});
			e.preventDefault();
			return false;
		});
		
		//상담이력 저장버튼
		$('.btnSave').click(function(e){
			$('#cnsltFrm').attr('action', $(this).attr('href'));
			$('#cnsltFrm').ajaxCwma({
				beforeSubmit:function(){
					if(!$('[name="etcAt"]:checked')[0] && !$('[name="skillAt"]:checked')[0]){
						alert('상담서비스를 선택해주세요');
						return false;
					}
					
					return true;
				},
				success:function(){
					alert('등록되었습니다');
					ajaxList();
				}
			});
			e.preventDefault();
			return false;
		});
		
		//우편번호
		$('.btnZip').click(function(){
			window.open('/common/adrsPop.do?cb=adrs', 'adresPop', 'width=500, height=500');
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
		
		ajaxList();
		$('[name="jssfcNo"]').change();
		
		//발급동의신청 팝업 클릭
		var jssfcList = '${issuJssfcList}';
		$('#btnIssuAgre').click(function(){
			if(jssfcList != null && jssfcList != '' && jssfcList != '[]'){
				$('[name="validDt"]').val(getFormatDate(0,30));
				
				$('#fileDiv').empty();
				uploader = null;
				$('[cntrwkSe]').val('');
				$('[name="deleteAt"]').val('');
				$('#frmPop [name="sn"]').val('');
				$('#frmPop .bizno').val('');
				setCorpInfo('');
				
				$('#btnIssuAgrePop').click();
			}else{
				alert('발급동의할 근로내역이 없습니다.');
			}
		});
		
		//발급동의신청 직종변경 클릭
		$('#chkJssfcNoModal').click(function(){
			if($(this).prop('checked')){
				$('[name="jssfcNo2"]').prop('disabled', false)
			}else{
				$('[name="jssfcNo2"]').prop('disabled', true)
			}
			$('[name="selectJssfcNo"]').val($('[name="jssfcNo2"]').val());// 직종값
			
		});
		
		// 사업자등록번호 조회 클릭
		$('#btnBiznoSearch').click(function(){
			ajaxCorpInfo();			
		});
		
		// 발급직종 변경
		$('[name="jssfcNo2"]').change(function(){
			setCorpInfo('');
		});
		
		// 사업자등록번호 변경
		$('.bizno').change(function(){
			setCorpInfo('');
		});
		
		// 공사 조회
		$('#btnSearch').click(function(){
			var pageNo = $('[name=pageNo]').val();
			$('[name="cnstwkNm"]').val('');
			ajaxCnstwkList(pageNo, true);
		});
		
		// 공사명 검색 클릭
		$('#btnSearchNm').click(function(){
			var pageNo = 1;
			ajaxCnstwkList(pageNo, false);
		});
		
		// 발급동의신청 등록 클릭
		$('.btnSubmit').click(function(){
			ajaxIssuAgre();
		});
		
		// 발급동의신청 태블릿서명 클릭
		$('.btnPreview').click(function(){
			ajaxIssuAgrePreview();
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
		
		$('.btnEdu').click(function(){
			$('#frm').attr('action', '../clmserEdu/list.do');
			$('#frm').submit();
		});
		
	});
	
	window.addEventListener('message', function(e){
		if(e.data.callback == 'adrs'){
			$('[name="zip"]').val(e.data.zip);
			$('[name="adres"]').val(e.data.adrs);
		}
	});

	// 발급동의신청 현황 취소
	function btnIssuAgreCancel(sn){
		if(confirm('정말 발급동의를 취소하시겠습니까?')){
			
			$('#sfrm [name="sn"]').val(sn);
			$('#sfrm').attr('action', '../issuAgre/deleteIssuAgre.do');
			$('#sfrm').ajaxCwma({
				success:function(res){
					alert(res.msg);
					if(res.success){
						location.reload(true);
					}
				}
			});
		}
	}
	
	// 사업자등록번호 조회
	function ajaxCorpInfo(){
		var html = '';
		$('#sfrm').attr('action', '../issuAgre/getCorpInfo.do');
		
		$('#sfrm').ajaxCwma({
			beforeSubmit:function(e){
				// 사업자등록번호 유효성
				if(!$('[name="bizno1"]').val().trim() || !$('[name="bizno2"]').val().trim() || !$('[name="bizno3"]').val().trim()){
					alert('사업자등록번호를 입력해주세요.');
					return false;
				}else{
					var bizno = $('[name="bizno1"]').val() +'-'+ $('[name="bizno2"]').val() +'-'+ $('[name="bizno3"]').val();
					$('[name="bizno"]').val(bizno);
				}
			},
			success:function(res){
				if(res.success){
					setCorpInfo(res.cvo);
				}else{
					alert(res.msg);
					setCorpInfo('');
				}
			},
			error:function(res){
				alert('사업자등록번호 조회에 실패했습니다.');
				setCorpInfo('');
			}
		});
	}
	
	// 업체 정보 새팅
	function setCorpInfo(data){
		if(data == ''){
			$('#corpNm').text('');
			$('#ceoNm').text('');
			$('#telNo').text('');
			
			// 조회관련 초기화
			$('[name="bizno"]').val('');
			$('[name="ddcJoinNo"]').val('');
			$('[name="searchCnstwkNm"]').val('');
			$('[name="cnstwkNm"]').text('');
		}else{
			$('#corpNm').text(data.corpNm);
			$('#ceoNm').text(data.ceoNm);
			$('#telNo').text(data.telNo);
		}
	}
	
	// 공사 조회 ajax
	function ajaxCnstwkList(pageNo, flag){
		var html = '';
		$('#crtfIssuConsResult').empty();
		$('[name="pageNo"]').val(pageNo);
		
		$('#sfrm').attr('action', '../issuAgre/getCnstwkList.do');
		$('#sfrm').ajaxCwma({
			beforeSubmit:function(e){
				
				if(!$('[name="bizno"]').val().trim()){
					alert('사업자등록번호를 조회해주세요.');
					return false;
				}
			},
			success:function(res){
				var dataStatus = false;
				if(res.success){
					if(res.cnstwkList != null && res.cnstwkList.length > 0){
						dataStatus = true;
						
						$(res.cnstwkList).each(function(){
							html += '<tr>';
							html += '	<td>'+ this.rownum +'</td>';
							html += '	<td>';
							if(this.seNm != '퇴직공제'){
								html += '	고용보험(' +this.seNm+ ')';
							}else{
								html += 	this.seNm;
							}
							html += '	</td>';
							html += '	<td onclick="btnChoice(\''+ $.trim(this.ddcJoinNo) + '\',\'' + $.trim(this.cntrctNm) + '\',\'' + $.trim(this.cntrwkSe) + '\')">';
							html += 		this.cntrctNm;
							html += '	</td>';
							html += '</tr>';
						});
						
						cwmaList.setPage(res.vo);//페이징
					}
				}
				
				if(!dataStatus){
					html += '<tr>';
					html += '	<td colspan="3">데이터가 존재하지 않습니다.</td>';
					html += '</tr>';
				}
				
				$('#crtfIssuConsResult').append(html);
				
				if(flag){
					$('#btnSearchPop').click();// 공사목록 모달 클릭
				}
			}
		});
	}
	
	// 공사 선택 클릭
 	function btnChoice(ddcJoinNo,cntrctNm,cntrwkSe){
		$('[name="ddcJoinNo"]').val(ddcJoinNo);
		$('[name="searchCnstwkNm"]').val(cntrctNm);
		$('[name="cntrwkSe"]').val(cntrwkSe);
		$('#construction .close').click();//공사 모달 닫기
	}
	 
	// 발급동의신청 등록
	function ajaxIssuAgre(){
		$('[name="selectJssfcNo"]').val($('[name="jssfcNo2"]').val());//직종값

		$('[name="deleteAt"]').val('N');// 등록
		$('#frmPop').attr('action', '../issuAgre/insertIssuAgre.do');
		$('#frmPop').ajaxCwma({
			beforeSubmit:function(){
				
				// 유효성 체크
				if(!validation()){
					return false;
				}
				
				// 파일업로드
				if(uploader.getTotalFileCount()){
					isUploading = true;
					uploader.startUpload();
				}
			},
			success:function(res){
				if(res.msg){
					alert(res.msg);
				}
				if(res.success){
					location.reload(true);
				}
			}
		});
	}
	
	function modalAlign(){
		$('div.layer').each(function(){
			$(this).css({
				marginTop : -($(this).outerHeight() / 2),
				marginLeft : -($(this).outerWidth() / 2),
			});
		});
	}
	
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
	
	// 예외 발생 시 호출됩니다.
	var onExceptionCu = function(){
	    var exceptionInfo = uploader.getLastExceptionInfo();
	    var obj = jQuery.parseJSON(exceptionInfo);
	    
	    alert('[예외 정보]\n' + 'code : ' + obj.code + '\n' + 'message : ' + obj.message + '\n' + 'detailMessage : ' + obj.detailMessage);
	}
	
	// yyyy-MM-dd 포멧
	function getFormatDate(mm, dd){
		var date = new Date();
		date.setMonth(date.getMonth() + mm);
		date.setDate(date.getDate() + dd);
		
		var year = date.getFullYear();
		var month = date.getMonth()+1;
		month = month >= 10 ? month : '0'+month;
		var day = date.getDate();
		day = day >= 10 ? day : '0'+day;
		
		return year +'-'+ month +'-' + day;
	}
	
	// 발급동의신청 유효성
	function validation(){
		if(!$('[name="selectJssfcNo"]').val().trim() || $('[name="selectJssfcNo"]').val() == '0'){
			alert('발급직종을 선택해주세요.');
			return false;
		}
		
		if(rgstDt > $('.datepicker').val()){
			alert('신청일보다 큰게 선택해주세요.');
			return false;
		}
		
		if(validDt < $('.datepicker').val()){
			alert('신청일부터 3개월 이내로 선택해주세요.');
			return false;
		}
		
		if(!$('[name="bizno"]').val().trim()){
			alert('사업자등록번호를 조회해주세요.');
			return false;
		}
		
		if(!$('[name="ddcJoinNo"]').val().trim()){
			alert('공사명 조회를 선택해주세요.');
			return false;
		}
		return true;
	}
	
	// 발급동의신청 태블릿서명
	function ajaxIssuAgrePreview(){
		$('[name="selectJssfcNo"]').val($('[name="jssfcNo2"]').val());//직종값

		$('#frmPop [name="sn"]').val('');
		$('[name="deleteAt"]').val('Y');// 미리보기
		$('#frmPop').attr('action', '../issuAgre/insertIssuAgre.do');
		$('#frmPop').ajaxCwma({
			beforeSubmit:function(){
				// 유효성 체크
				if(!validation()){
					return false;
				}
			},
			success:function(res){
				if(res.success){
					$('#frmPop [name="sn"]').val(res.sn);
					window.open("", "issuAgrePreView","status=no,scrollbars=yes,resizable=no,top=100,left=100,width=900,height=680");
					$('#frmPop').attr('action', '../issuAgre/issuAgrePreViewReportPop.do');
					$('#frmPop').attr('target', 'issuAgrePreView');
					$('#frmPop').submit();
					$('#frmPop').attr('target', '');
					$('#frmPop [name="sn"]').val('');
					
				}
			}
		});
	}
</script>
</head>
<body>
	<div class="data_wrap">
		<div>
			<form id="frm" action="" method="post">
				<input type="hidden" name="moblphonNo" value="${eo.telno}" />
				<input type="hidden" name="email" value="${eo.userInfoVO.email}" />
				<input type="hidden" name="ihidnum" value="${param.ihidnum}" />
				<input type="hidden" name="userId" value="${eo.userInfoVO.userId}" />
				<div class="content-col">
					<div>
						<table class="tbl tbl_search mt10">
							<colgroup>
								<col style="width: 20%;">
								<col style="width: 80%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 기본정보</th>
								</tr>
							</thead>
						</table>
						<table class="tbl tbl_search mt5">
							<colgroup>
								<col width="10%">
								<col width="40%">
								<col width="10%">
								<col width="40%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">구분</th>
									<td colspan="3">
									<c:forEach var="list" items="${clmserEduList}" varStatus="sts">
										<c:if test="${list.sn eq '1'}">
											${list.relVO.complAt eq 'Y'?'최초교육 이수':'최초교육 이수필요자'}
										</c:if>
									</c:forEach>
									</td>
								</tr>
								<tr>
									<th scope="row">성명</th>
									<td colspan="3">${eo.nm}</td>
								</tr>
								<tr>
									<th scope="row">주민등록번호</th>
									<td colspan="3">${eo.ihidnum}</td>
								</tr>
								<tr>
									<th scope="row">아이디</th>
									<td colspan="3">${eo.userInfoVO.userId}</td>
								</tr>
								<tr>
									<th scope="row">휴대폰</th>
									<td colspan="3">
										<c:if test="${empty eo.userInfoVO.userId}">
											${eo.telno}
										</c:if>
										<c:if test="${!empty eo.userInfoVO.userId}">
											<input type="text" class="w30p" name="phone" maxlength="3" value="" /> - 
											<input type="text" class="w30p" name="phone" maxlength="4" value="" /> -
											<input type="text" class="w30p" name="phone" maxlength="4" value="" />
										</c:if>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일</th>
									<td colspan="3">
									<c:if test="${!empty eo.userInfoVO.userId}">
										<input type="text" class="w30p" name="mail" value="">@<input type="text" class="w30p" name="mail" value="">
										<select class="w30p" name="mail">
											<option value="">직접입력</option>
											<option value="naver.com">naver.com</option>
											<option value="hanmail.net">hanmail.net</option>
											<option value="daum.net">daum.net</option>
											<option value="gmail.com">gmail.com</option>
											<option value="nate.com">nate.com</option>
											<option value="hotmail.com">hotmail.com</option>
										</select>
									</c:if>
									</td>
								</tr>
								<tr>
									<th scope="row">주소</th>
									<td colspan="3">
									<c:if test="${empty eo.userInfoVO.userId}">
										[${eo.zip}] ${eo.adres}
									</c:if>
									<c:if test="${!empty eo.userInfoVO.userId}">
										<a href="#" class="btn btn_form mr10 btnZip">주소검색</a>
										<input type="text" class="w50p mr10" name="zip" value="${eo.zip }" readonly /><br />
										<input type="text" class="w100p mr10" name="adres" value="${eo.adres}" readonly />
									</c:if>
									</td>
								</tr>
								<tr>
									<th scope="row">가입일시</th>
									<td colspan="3">${eo.userInfoVO.rgstDt }</td>
								</tr>
								<tr>
									<th scope="row">최종로그인</th>
									<td colspan="3">${eo.userInfoVO.lastLoginDt }</td>
								</tr>
								<tr>
									<th scope="row">선택동의(SNS아이디)</th>
									<td>
										 <c:choose>
											<c:when test="${eo.userInfoVO.stplatSnsAgreAt eq 'Y' or (!empty eo.userInfoVO.userSnsAuthorVO and !empty eo.userInfoVO.userSnsAuthorVO.rgstDt)}">
												Y	
												<c:if test="${!empty eo.userInfoVO.userSnsAuthorVO and !empty eo.userInfoVO.userSnsAuthorVO.rgstDt }">
													(${fn:substring( eo.userInfoVO.userSnsAuthorVO.rgstDt,0,10) })
												</c:if>
											</c:when>
											<c:otherwise>
												N
											</c:otherwise>
										</c:choose>
									</td>
									<th scope="row">선택동의(상담내용)</th>
									<td>
										<c:choose>
											<c:when test="${!empty eo.userInfoVO.userId and eo.userInfoVO.stplatOnlineCnsltAgreAt eq 'Y'}">
												Y
											</c:when>
											<c:when test="${empty eo.userInfoVO.userId and eo.customerAt eq 'Y'}">
												Y
											</c:when>
											<c:otherwise>
												N
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr>
									<th scope="row">이메일 수신 동의</th>
									<td>${!empty eo.userInfoVO.emailRecptnAgreAt ? eo.userInfoVO.emailRecptnAgreAt : 'N' }</td>
									<th scope="row">문자 수신 동의</th>
									<td>${!empty eo.userInfoVO.smsRecptnAgreAt ? eo.userInfoVO.smsRecptnAgreAt : 'N'}</td>
								</tr>
								<tr>
									<th scope="row">광고정보 활용 동의</th>
									<td colspan="3">${!empty eo.userInfoVO.advrtsInfoPrcuseAgreAt ? eo.userInfoVO.advrtsInfoPrcuseAgreAt : 'N'}</td>
								</tr>
							</tbody>
						</table>
					</div>
					
					<div class="education">
						<table class="tbl tbl_search mt10">
							<colgroup>
								<col style="width: 50%;">
								<col style="width: 50%;">
							</colgroup>
							<thead>
								<tr>
									<th scope="row">
										<i class="fas fa-th-large mr10"></i> 맞춤형 교육
									</th>
									<th scope="row" class="p5 txt_right">
										<a href="#" class="btn normal purple mr10 btnEdu"> <i class="far fa-file-alt mr5"></i> 맞춤형 교육</a>
									</th>
								</tr>
							</thead>
						</table>

						<div>
							<table class="tbl tbl_data">
								<colgroup>
									<col width="10%">
									<col width="50%">
									<col width="20%">
									<col width="20%">
								</colgroup>
								<thead>
									<tr>
										<td scope="col" colspan="4" class="brd-top-none txt_left pl30 bg-f2 bold">
											<span><i class="fas fa-th-list mr10"></i> 최초교육</span>
										</td>
									</tr>
									<tr>
										<th scope="col">No.</th>
										<th scope="col"><span>제목</span></th>
										<th scope="col"><span>문자발송</span></th>
										<th scope="col"><span>이수상태</span></th>
									</tr>
								</thead>
								<tbody>
								<c:forEach var="list" items="${clmserEduList}" varStatus="sts">
									<tr>
										<td>${list.rownum }</td>
										<td class="txt_left pl20">${list.sj }</td>
									<c:if test="${sts.first }">
										<td rowspan="${clmserEduVO.totalCnt }" class="p5"><a href="#sendSMS" class="openLayer btn normal black">발송</a></td>
										<td rowspan="${clmserEduVO.totalCnt }">${list.relVO.complAt eq 'Y'?'<em class="blue">이수완료</em>':'<em class="red">미이수</em>'}</td>
									</c:if>
									</tr>
								</c:forEach>
								</tbody>
							</table>

							<table class="tbl tbl_data mt5">
								<colgroup>
									<col width="10%">
									<col width="50%">
									<col width="20%">
									<col width="20%">
								</colgroup>
								<thead>
									<tr>
										<td scope="col" colspan="4" class="brd-top-none txt_left pl30 bg-f2 bold">
											<span><i class="fas fa-th-list mr10"></i> 승급교육</span>
										</td>
									</tr>
									<tr>
										<th scope="col">No.</th>
										<th scope="col"><span>제목</span></th>
										<th scope="col"><span>문자발송</span></th>
										<th scope="col"><span>이수상태</span></th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>

							<table class="tbl tbl_data mt5">
								<colgroup>
									<col width="10%">
									<col width="50%">
									<col width="20%">
									<col width="20%">
								</colgroup>
								<thead>
									<tr>
										<td scope="col" colspan="4" class="brd-top-none txt_left pl30 bg-f2 bold">
											<span><i class="fas fa-th-list mr10"></i> 기타교육</span>
										</td>
									</tr>
									<tr>
										<th scope="col">No.</th>
										<th scope="col"><span>제목</span></th>
										<th scope="col"><span>문자발송</span></th>
										<th scope="col"><span>이수상태</span></th>
									</tr>
								</thead>
								<tbody>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			
				<table class="tbl tbl_search mt10">
					<colgroup>
						<col style="width: 10%;">
						<col style="width: 40%;">
						<col style="width: 10%;">
						<col style="width: 40%;">
					</colgroup>
					<thead>
						<tr>
							<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 기능등급</th>
						</tr>
					</thead>
				</table>

				<table class="tbl tbl_search mt5">
					<colgroup>
						<col style="width: 10%;">
						<col style="width: 40%;">
						<col style="width: 10%;">
						<col style="width: 40%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">직종</th>
							<td colspan="3">
								<select class="w40p mr10" name="jssfcNo" disabled>
									<option value="">전체</option>
								<c:forEach var="ceo" items="${jssfcList}">
									<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq eo.jssfcNo?'selected':''}>${ceo.jssfcNm}</option>
								</c:forEach>
								</select>
								<input type="checkbox" id="chkJssfcNo">
								<label for="chkJssfcNo">변경</label>
							</td>
						</tr>
						<tr>
							<th scope="row">등급</th>
							<td><em class="red">${eo.gradNm }</em></td>
							<th scope="row">환산경력년수</th>
							<td><em class="red" money>${eo.workDaycnt+(eo.etcWorkDaycnt/2) } 일</em></td>
						</tr>
						<tr>
							<th scope="row">현장경력(퇴직공제 + 고용보험)</th>
							<td></td>
							<th scope="row">자격</th>
							<td></td>
						</tr>
						<tr>
							<th scope="row">교육훈련</th>
							<td></td>
							<th scope="row">포상</th>
							<td></td>
						</tr>
					</tbody>
				</table>
			</form>

			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 40%;">
					<col style="width: 10%;">
					<col style="width: 40%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 이력사항
							<span class="bg-none ml30 fs13">
								※직종확인 및 경력인정이 필요한 경력사항이 있는 경우
								<em class="btn btn_form bg-ffe4ca h20x">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</em> 표시
							</span>
						</th>
					</tr>
				</thead>
			</table>

			<div class="tableWrap career">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="">
							<col width="15%">
							<col width="20%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						<thead>
							<tr>
								<td scope="col" colspan="6" class="brd-top-none txt_left pl30 bg-f2 bold">
									<span>
										<span><i class="fas fa-th-list mr10"></i> 퇴직공제</span>
										<span class="ml20 fs13">[총 환산현장경력년수(퇴직공제+고용보험 일용 및 상용) : <em class="blue bold eoYearCnt" money ></em>년]</span>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="col"><span>공사명</span></th>
								<th scope="col"><span>시공사</span></th>
								<th scope="col"><span>근무기간</span></th>
								<th scope="col"><span>일수</span></th>
								<th scope="col"><span>신고직종</span></th>
								<th scope="col"><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="list" items="${eo.userCareerVO}">
							<tr>
								<td class="txt_left pl20">${list.nm }</td>
								<td>${list.prmtr}</td>
								<td dateToDate="yy-mm">${list.bgnDt} ~ ${list.endDt}</td>
								<td>${list.daycnt }</td>
								<td>${list.jssfc }</td>
								<td>${list.jssfcNm }</td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
			

			<div class="tableWrap career">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="">
							<col width="15%">
							<col width="20%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						<thead>
							<tr>
								<td scope="col" colspan="6" class="brd-top-none txt_left pl30 bg-f2 bold">
									<span>
										<span><i class="fas fa-th-list mr10"></i> 고용보험(일용)</span>
<!-- 										<span class="ml20 fs13">(년수 : <em class="blue bold dlyYearCnt" money>0</em>일)</span> -->
									</span>
								</td>
							</tr>
							<tr>
								<th scope="col"><span>공사명</span></th>
								<th scope="col"><span>시공사</span></th>
								<th scope="col"><span>근무기간</span></th>
								<th scope="col"><span>일수</span></th>
								<th scope="col"><span>신고직종</span></th>
								<th scope="col"><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="list" items="${dlyList}">
							<tr>
								<td class="txt_left pl20">${list.nm }</td>
								<td>${list.prmtr}</td>
								<td dateToDate="yy-mm">${list.bgnDt} ~ ${list.endDt}</td>
								<td>${list.daycnt }</td>
								<td>${list.jssfc }</td>
								<td data-se="${list.jssfcSe}">${list.jssfcNm }</td>
							</tr>
						</c:forEach>
						<c:if test="${empty dlyList }">
							<tr>
								<td colspan="6">조회된 고용보험(일용) 내역이 없습니다.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</div>
			</div>
			

			<div class="tableWrap career">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="">
							<col width="15%">
							<col width="20%">
							<col width="10%">
							<col width="10%">
							<col width="10%">
						</colgroup>
						<thead>
							<tr>
								<td scope="col" colspan="6" class="brd-top-none txt_left pl30 bg-f2 bold">
									<span>
										<span><i class="fas fa-th-list mr10"></i> 고용보험(상용)</span>
<!-- 										<span class="ml20 fs13">(일수 : <em class="blue bold cmclYearCnt" money>0</em>일)</span> -->
									</span>
								</td>
							</tr>
							<tr>
								<th scope="col"><span>공사명</span></th>
								<th scope="col"><span>시공사</span></th>
								<th scope="col"><span>근무기간</span></th>
								<th scope="col"><span>일수</span></th>
								<th scope="col"><span>신고직종</span></th>
								<th scope="col"><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="list" items="${cmclList}">
							<tr>
								<td class="txt_left pl20">${list.nm }</td>
								<td>${list.prmtr}</td>
								<td dateToDate="yy-mm-dd">${list.bgnDt} ~ ${list.endDt}</td>
								<td>${list.daycnt }</td>
								<td>${list.jssfc }</td>
								<td data-se="${list.jssfcSe}">${list.jssfcNm }</td>
							</tr>
						</c:forEach>
						<c:if test="${empty cmclList }">
							<tr>
								<td colspan="6">조회된 고용보험(상용) 내역이 없습니다.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</div>
			</div>
			
			<div class="tableWrap qualification">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="30%">
							<col width="30%">
							<col width="20%">
							<col width="20%">
						</colgroup>
						<thead>
							<tr>
								<td scope="col" colspan="5" class="brd-top-none txt_left pl30 bg-f2 bold">
									<span>
										<span><i class="fas fa-th-list mr10"></i> 기능자격증 사항</span>
										<span class="ml20 fs13">(년수 : <em class="blue bold licenseYearCnt">0</em>년)</span>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="col"><span>자격명</span></th>
								<th scope="col"><span>등록번호</span></th>
								<th scope="col"><span>발급기관</span></th>
								<th scope="col"><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="list" items="${licenseList}">
							<tr>
								<td class="txt_left pl20" data-cnt="${list.daycnt }">${list.nm }</td>
								<td>${list.ddcJoinNo }</td>
								<td>${list.prmtr}</td>
								<td>${list.jssfcNm }</td>
							</tr>
						</c:forEach>
						<c:if test="${empty licenseList}">
							<tr>
								<td colspan="4">조회된 기능자격증 내역이 없습니다.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</div>
			</div>

			<div class="tableWrap education">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="30%">
							<col width="30%">
							<col width="20%">
							<col width="20%">
						</colgroup>
						<thead>
							<tr>
								<td scope="col" colspan="4" class="brd-top-none txt_left pl30 bg-f2 bold">
									<span>
										<span><i class="fas fa-th-list mr10"></i> 교육․훈련 사항</span>
										<span class="ml20 fs13">(년수 : <em class="blue bold eduYearCnt">0</em>년)</span>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="col"><span>과정명</span></th>
								<th scope="col"><span>기간</span></th>
								<th scope="col"><span>교육․훈련 기관</span></th>
								<th scope="col"><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="list" items="${eduList}">
							<tr>
								<td class="txt_left pl20" data-cnt="${list.daycnt }">${list.nm }</td>
								<td dateToDate="yy-mm-dd">${list.bgnDt} ~ ${list.endDt}</td>
								<td>${list.prmtr}</td>
								<td>${list.jssfcNm }</td>
							</tr>
						</c:forEach>
						<c:if test="${empty eduList}">
							<tr>
								<td colspan="4">조회된 교육․훈련 내역이 없습니다.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</div>
			</div>

			<div class="tableWrap prize">
				<div>
					<span></span>
					<table class="tbl tbl_data mt5">
						<colgroup>
							<col width="30%">
							<col width="15%">
							<col width="10%">
							<col width="15%">
							<col width="20%">
							<col width="10%">
						</colgroup>
						<thead>
							<tr>
								<td scope="col" colspan="6" class="brd-top-none txt_left pl30 bg-f2 bold">
									<span>
										<span><i class="fas fa-th-list mr10"></i> 포상이력</span>
										<span class="ml20 fs13">(년수 : <em class="blue bold rewardYearCnt">0</em>년)</span>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="col"><span>대회명</span></th>
								<th scope="col"><span>종목</span></th>
								<th scope="col"><span>순위</span></th>
								<th scope="col"><span>수여일자</span></th>
								<th scope="col"><span>수여기관</span></th>
								<th scope="col"><span>통합직종</span></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="list" items="${rewardList}">
							<tr>
								<td class="txt_left pl20" data-cnt="${list.daycnt }">${list.nm }</td>
								<td>${list.jssfc }</td>
								<td>${list.rank}</td>
								<td date>${list.bgnDt}</td>
								<td>${list.prmtr}</td>
								<td>${list.jssfcNm }</td>
							</tr>
						</c:forEach>
						<c:if test="${empty rewardList}">
							<tr>
								<td colspan="6">조회된 포상이력 내역이 없습니다.</td>
							</tr>
						</c:if>
						</tbody>
					</table>
				</div>
			</div>
			
			<!-- 보유증명서 발급동의 -->
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 40%;">
					<col style="width: 10%;">
					<col style="width: 40%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>보유증명서 발급동의</th>
					</tr>
				</thead>
			</table>
			
			<table class="tbl tbl_data mt5">
				<colgroup>
					<col width="20%">
					<col width="15%">
					<col width="">
					<col width="15%">
					<col width="15%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><span>기업명</span></th>
						<th scope="col"><span>고용형태</span></th>
						<th scope="col"><span>공사명</span></th>
						<th scope="col"><span>동의만료일</span></th>
						<th scope="col"><span>동의취소</span></th>
					</tr>
				</thead>
				<tbody id="issuAgreResult">
					<c:choose>
						<c:when test="${!empty ivo}">
							<tr>
								<td>${ ivo.corpNm }</td>
								<td>
									<c:choose>
										<c:when test="${ivo.cntrwkSeNm != '퇴직공제' }">
											고용보험(${ ivo.cntrwkSeNm })
										</c:when>
										<c:otherwise>
											${ ivo.cntrwkSeNm }
										</c:otherwise>
									</c:choose>
								</td>
								<td>${ ivo.cnstwkNm }</td>
								<td>${ ivo.validDt }</td>
								<td class="p5">
									<a href="javascript:btnIssuAgreCancel('${ ivo.sn }');" class="btn normal black"> <i class="fas fa-undo mr5"></i> 동의취소</a>
								</td>
							</tr>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="5">증명서 발급동의 신청내역이 없습니다.</td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>
			<c:if test="${empty ivo}">
				<div class="btn_wrap txt_center">
					<a href="#none;" class="btn normal blue mr10" id="btnIssuAgre"><i class="far fa-edit mr5"></i> 발급동의 신청</a>
				</div>
			</c:if>
			<!-- //증명서 발급동의 -->

			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;">
					<col style="width: 40%;">
					<col style="width: 10%;">
					<col style="width: 40%;">
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i>상담내역</th>
					</tr>
				</thead>
			</table>

			<form id="cnsltFrm" method="post" action="">
				<input type="hidden" name="ihidnum" value="${param.ihidnum }" />
				
				<table class="tbl tbl_form">
					<colgroup>
						<col width="10%">
						<col width="23%">
						<col width="10%">
						<col width="23%">
						<col width="10%">
						<col width="24%">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">신피공제자</th>
							<td colspan="5">
								<select name="ddcerSn">
								<c:forEach var="list" items="${ddcerSnList}" varStatus="sts">
									<option value="${list.cdId }">${list.cdId }</option>
								</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">구분</th>
							<td>
								<select name="se">
								<c:forEach var="list" items="${cnsltSeList}" varStatus="sts">
									<option value="${list.cdId }">${list.cdNm }</option>
								</c:forEach>
								</select>
							</td>
							<th scope="row">대상</th>
							<td>
								<select name="trgt">
								<c:forEach var="list" items="${cnsltTrgtList}" varStatus="sts">
									<option value="${list.cdId }">${list.cdNm }</option>
								</c:forEach>
								</select>
							</td>
							<th scope="row">상담서비스</th>
							<td>
								<!-- <label><input type="checkbox" name="descriptionAt" value="1" /> 제도설명</label> --><!-- 07/02 삭제요청 -->
								<label><input type="checkbox" name="etcAt" value="1" /> 기타</label>
								<label><input type="checkbox" name="skillAt" value="1" /> 기능등급</label>
							</td>
						</tr>
						<tr>
							<th scope="row">상담일자</th>
							<td today></td>
							<th scope="row">처리부서</th>
							<td>${adminLoginInfo.brffcAbrvtNm} ${adminLoginInfo.brffcNm}</td>
							<th scope="row">담당자</th>
							<td>${adminLoginInfo.userName}</td>
						</tr>
						<tr>
							<th scope="row">상담내용</th>
							<td colspan="5" class="p10">
								<input type="text" class="w100p" name="cn" required title="상담내용" />
							</td>
						</tr>
					</tbody>
				</table>
			</form>
			<div class="btn_wrap txt_center">
				<a href="insertCnsltHist.do" class="btn normal blue btnSave"><i class="far fa-save mr5"></i> 저장</a>
			</div>

			<table class="tbl tbl_data mt5">
				<colgroup>
					<col width="10%">
					<col width="">
					<col width="15%">
					<col width="10%">
					<col width="10%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><span>구분</span></th>
						<th scope="col"><span>상담내용</span></th>
						<th scope="col"><span>일시</span></th>
						<th scope="col"><span>처리부서</span></th>
						<th scope="col"><span>담당자</span></th>
					</tr>
				</thead>
				<tbody id="result">
				</tbody>
			</table>
		</div>
		<div class="btn_wrap">
			<div class="fl txt_left">
				<a href="${pageContext.request.contextPath}/admin/crtfIssu/crtfIssuForm.do" class="btn normal purple mr10"><i class="far fa-file-alt mr5"></i> 증명서발급신청</a>
				<a href="${pageContext.request.contextPath}/admin/careerDeclare/careerDeclare.do" class="btn normal purple mr10"><i class="far fa-file-alt mr5"></i> 경력인정신청</a>
				<a href="${pageContext.request.contextPath}/admin/careerDeclare/careerDeclare.do?se=CASE0002" class="btn normal purple mr10"><i class="far fa-file-alt mr5"></i> 근로직종확인신청</a>
			</div>
			<div class="fr txt_right">
			<c:if test="${!empty eo.userInfoVO.userId}">
				<a href="update.do" class="btn normal green mr10 btnUpd"><i class="far fa-edit mr5"></i> 수정</a>
				<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i> 삭제</a>
			</c:if>
				<a href="personalList.do" class="btn normal black mr10"><i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</div>

	
	<!-- layer -->	
	<div class="pageDisabled"></div>
	<!-- //layer -->
	<!------------ modal 발급동의신청 ------------>
	<form id="frmPop" method="post">
	<input type="hidden" name="ddcJoinNo" />
	<input type="hidden" name="ihidnum" value="${param.ihidnum}" />
	<input type="hidden" name="SptSe" value="SPTS0002" /><!-- 방문 -->
	<input type="hidden" name="selectJssfcNo" />
	<input type="hidden" name="cntrwkSe" /><!-- 공사구분 -->
	<input type="hidden" name="deleteAt" /><!-- 미리보기 여부 -->
	<input type="hidden" name="sn" />
	
	<div id="issueAgreement" class="layer">
		<h1>증명서 발급동의</h1>
		<button type="button" class="close">×</button>
		<div>
			<table>
				<colgroup>
					<col style="width:30%;">
					<col style="width:70%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">발급 직종</th>
						<td>
							<select class="w30p mr10" name="jssfcNo2" disabled required title="발급 직종">
								<option value="">전체</option>
								<c:forEach var="ceo" items="${issuJssfcList}">
									<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq eo.jssfcNo?'selected':''}>${ceo.jssfcNm}</option>
								</c:forEach>
							</select>
							<input type="checkbox" id="chkJssfcNoModal">
							<label for="chkJssfcNo">변경</label>
						</td>
					</tr>
					<tr>
						<th scope="row">동의만료일</th>
						<td>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="validDt" readonly required title="동의만료일">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div> 
						</td>
					</tr>
					<tr>
						<th scope="row">사업자등록번호</th>
						<td>
							<input type="hidden" name="bizno" title="사업자등록번호" readonly >
							<input type="text" class="bizno" name="bizno1" number required title="사업자등록번호 앞자리" hasnext maxlength="3" style="width:25%;"/>
							-&nbsp;
							<input type="text" class="bizno" name="bizno2" number required title="사업자등록번호 중간자리" hasnext maxlength="2" style="width:25%;"/>
							-&nbsp;
							<input type="text" class="bizno" name="bizno3" number required title="사업자등록번호 끝자리" maxlength="5" style="width:25%;"/>
							<a href="#none;" class="btn normal black" id="btnBiznoSearch">조회</a>
						</td>
					</tr>
					<tr>
						<th scope="row">기업명</th>
						<td id="corpNm"></td>
					</tr>
					<tr>
						<th scope="row">대표자</th>
						<td id="ceoNm"></td>
					</tr>
					<tr>
						<th scope="row">전화번호</th>
						<td id="telNo"></td>
					</tr>
					<tr>
						<th scope="row">공사명</th>
						<td>
							<a href="#none;" class="btn normal black" id="btnSearch">조회</a>
							<input type="text" name="searchCnstwkNm"  title="공사명" disabled placeholder="조회 버튼을 클릭하여 공사명을 선택해주세요." style="width:80%;"/>
						</td>
					</tr>
					<tr>
						<th scope="row">파일첨부</th>
						<td class="p5" id="fileDiv"></td>
					</tr>
				</tbody>
			</table>
			<div class="mt30 txt_right">
				<button type="button" class="btn normal purple btnPreview">신청서 출력</button>
				<button type="button" class="btn normal blue btnSubmit">등록</button>
				<button type="button" class="close btn normal black">취소</button>
			</div>
		</div>
	</div>
	</form>
	<!------------ //modal 발급동의신청 ------------>
	
	<!------------ modal2 공사 ------------>
	<form id="sfrm" method="post" action="" onsubmit="return false;">
	<input type="hidden" name="selectJssfcNo" value="0"/>
	<input type="hidden" name="ihidnum" value="${param.ihidnum}" />
	<input type="hidden" name="sn" />
	<input type="hidden" name="ddcJoinNo">
	<input type="hidden" name="bizno" />
	<input type="hidden" name="pageNo" value="1" />
	<input type="hidden" name="numOfPage" value="10" />
	<input type="hidden" name="pagingType" value="ajax" />
	
	<div id="construction" class="layer">
		<h1>공사명 검색</h1>
		<button type="button" class="close">×</button>
		<div>
			<table>
				<colgroup>
					<col style="width:20%;">
					<col style="width:80%;">
				</colgroup>
				<tbody>
					<tr>
						<th scope="row">공사명</th>
						<td>
							<input type="text" name="cnstwkNm" title="공사명"/>
							<button type="button" class="btn normal black btnSearchNm" id="btnSearchNm">검색</button>
						</td>
					</tr>
				</tbody>
			</table>

			<!-- <h2>공사명</h2>
			<ul id="crtfIssuConsResult">
			</ul> -->
			
			<table class="cnstwk-info">
				<colgroup>
					<col style="width:15%">
					<col style="width:25%">
					<col style="width:60%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">연번</th>
						<th scope="col">구분</th>
						<th scope="col">공사명</th>
					</tr>
				</thead>
				<tbody id="crtfIssuConsResult">
					<tr>
						<td>1</td>
						<td>고용보험(일용)</td>
						<td>가나다라공사</td>
					</tr>
					<tr>
						<td colspan="3">조회내역이 없습니다.</td>
					</tr>
				</tbody>
			</table>
					
			<!-- paging -->
			<div class="paging" id="pageDiv" style="text-align:center">
			</div>
			<!-- //paging -->
		</div>
	</div>
	</form>
	<!------------ //modal2 공사 ------------>
	
	<div id="sendSMS" class="layer">
		<h1>SMS 발송</h1>
		<button type="button" class="close">×</button>
		<div>
			<form id="smsFrm" action="" method="post">
				<input type="hidden" name="ihidnum" value="${param.ihidnum}" />
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
					<button type="submit" href="../clmserEdu/sendSms.do" class="btn normal blue btnSms">발송</button>
					<button type="button" class="close btn normal black">닫기</button>
				</div>
			</form>
		</div>
	</div>
	
	<a href="#issueAgreement" class="openLayer btn normal blue mr10" id="btnIssuAgrePop" style="display: none;">발급동의 신청 팝업</a>
	<a href="#construction" class="openLayer btn normal blue mr10" id="btnSearchPop" style="display: none;">발급동의 신청 공사 팝업</a>
</body>
</html>
