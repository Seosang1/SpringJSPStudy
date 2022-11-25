<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
var cwmaFile, namoCrossUploader;

$(function(){
	cwmaFile = new CrossDownloader({fileLayer:'fileLayer', parntsSe:'ATCH0014', parntsSn:$('[name="sn"]').val()});
	namoCrossUploader = cwmaFile.crossUploader;
	
	$('[name="progrsDe"]').val($.datepicker.formatDate('yy-mm-dd', new Date()));
	$('[name="rplyTmlmt"]').val($.datepicker.formatDate('yy-mm-dd', new Date().add(10)));
	
	//목록버튼 이벤트
	$('#btnList').click(function(e){
		location.href = $(this).attr('href');
		e.preventDefault();
		return false;
	});

	$('.constructionWorkerSelected').each(function(){
		if(!$(this).find('tbody tr') || !$(this).find('tbody tr').length){
			$(this).hide();
		}
	});
	
	//영수증버튼 클릭
	$('.btnRpt').click(function(){
		var top = screen.height/2 - 620/2;
		var left = screen.width/2 - 700/2;
		var option = 'width = 700px , height = 620px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no';
		
		window.name ="CWMA_SKILL_WINDOW";
		window.open('', 'holdCrtpRptPop', option);
		
		$('#frm [name="title"]').val($(this).data('title'));
		$('#frm').attr('action', 'rptPop.do');
		$('#frm').attr('target', 'holdCrtpRptPop');
		$('#frm').submit();
		$('#frm').attr('target', '_self');
	});
	
	//결재/반려 클릭 이벤트 - 팝업오픈
	$('.btnPop').click(function(e){
		$('#frm [name="sanctnSttus"]').val($(this).text().trim() == '결재기안'?'APRV0002':'APRV0003');
		$('#frmPop [name="agncyNm"]').val('');
		$('#sanctnLayer .tbl_data').parent().hide();
		$('#sanctnLayer .btn_wrap').hide();
		
		cwma.showMask();
		$('#sanctnLayer').css('height', '170px');
        $('#sanctnLayer').css("top",(($(window).height() - $('#sanctnLayer').outerHeight()) / 2) + $(window).scrollTop());
        $('#sanctnLayer').css("left",(($(window).width() - $('#sanctnLayer').outerWidth()) / 2) + $(window).scrollLeft());
        
		if($('.right_cont .layerpop')[0]){
			$('#sanctnLayer').draggable();
			$('body').append($('.data_wrap .layerpop'));
		}

		$('#sanctnLayer').show();
        
		e.preventDefault();
		return false;
	});
	
	//팝업닫기 버튼 클릭이벤트
	$('.layerpop_close, .btnClose').click(function(e){
		cwma.hideMask();
		$('#sanctnLayer').hide();
		
		e.preventDefault();
		return false;			
	});
	
	//팝업 - 검색버튼 클릭
	$('.btnAgncyMember').click(function(){
		$('#frmPop').ajaxCwma({
			success:function(res){
				var html = '';
				var height = 100;
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td><input type="radio" name="sanctnId" value="'+this.userId+'" /></td>';
					html += '<td>'+this.brffcNm+'</td>';
					html += '<td>'+this.userName+'</td>';
					html += '<td>'+this.email+'</td>'
					html += '</tr>';
				});
				
				height = Math.min(res.list.length+1, 5) * 45 + 20;
				$('#sanctnLayer .tbl_data').parent().css('height', height+'px');
				$('#sanctnLayer').css('height', (height + 220)+'px');
		        $('#sanctnLayer').css("top",(($(window).height() - $('#sanctnLayer').outerHeight()) / 2) + $(window).scrollTop());
		        $('#sanctnLayer').css("left",(($(window).width() - $('#sanctnLayer').outerWidth()) / 2) + $(window).scrollLeft());
				
				$('#sanctnLayer .tbl_data').parent().show();
				$('#sanctnLayer .btn_wrap').show();
				$('#memberResult').html(html);
			}
		});
	});
	
	//팝업 - 엔터이벤트
	$('#frmPop').submit(function(e){
		$('.btnAgncyMember').click();
		e.preventDefault();
		return false;
	});
	
	//결재기안버튼 클릭
	$('.btnSubmit').click(function(e){
		if(!$('[name="sanctnId"]:checked').size()){
			alert('결재자를 선택해주세요');
			return false;
		}
		
		if(confirm(($('#frm [name="sanctnSttus"]').val() == 'APRV0002'?'결재기안':'반려') + '하시겠습니까?')){
			$('#frm [name="sanctnId"]').val($('#sanctnLayer [name="sanctnId"]:checked').val());
			$('#frm').attr('action', 'progrs.do');
			$('#frm').ajaxCwma({
				success:function(res){
					alert('처리 되었습니다');
					$('.fa-list').click();
				}
			});
		}
		
		e.preventDefault();
		return false;
	});
});

var goFrm = function(str, obj){
	if(confirm($(obj).text() + '을 진행하시겠습니까?')){
		$('[name=sanctnSttus]').val('APRV000' + str);
		$('#frm').attr('action', 'progrs.do');
		var txt = $(this).text().trim();
		$('#frm').ajaxCwma({
			success:function(res){
				alert('처리 되었습니다');
				$('#frm').attr('action', 'list.do');
				$('#frm').attr('method', 'GET');
				$('#frm').submit();
			}
		});
		return false;
	}	
}
</script>
</head>
<body>
	<form action="" id="frm" method="post">
		<input type="hidden" name="sn" value="${eo.sn}" />
		<input type="hidden" name="title" value="" />
		<input type="hidden" name="docNo" value="${eo.sn }" >				  
		<input type="hidden" name="careerNo" value="${eo.sn }" >				  
		<input type="hidden" name="sanctnSttus" >				  
		<input type="hidden" name="sanctnKnd" value="ARCS0005" >
		<input type="hidden" name="sanctnId" value="">
	</form>
	
	<table class="tbl tbl_search mt20">
		<colgroup>
			<col style="width:100%;">
		</colgroup>
		<thead>
			<tr><th><i class="fas fa-th-large mr10"></i> 신청자정보</th></tr>
		</thead>
	</table>
	<table class="tbl tbl_form mt5">
		<colgroup>
			<col style="width:12%;">
			<col style="width:38%;">
			<col style="width:12%;">
			<col style="width:38%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">구분</th>
				<td>${eo.seNm} ${eo.se eq 'HCSE0001'?'':'('.concat(eo.clNm).concat(')')}</td>
				<th scope="row">상호 또는 기관명</th>
				<td>${eo.se eq 'HCSE0001'?applEo.corpNm:applEo.dminsttNm}</td>
			</tr>
			<tr>
				<th scope="row">사업자등록번호(고유번호)</th>
				<td colspan="3">${applEo.bizno }</td>
			</tr>
			<tr>
				<th scope="row">대표자</th>
				<td>${applEo.ceoNm }</td>
				<th scope="row">전화번호</th>
				<td>${applEo.telNo }</td>
			</tr>
		</tbody>
	</table>
	
	<table class="tbl tbl_search mt20">
		<colgroup>
			<col style="width:100%;">
		</colgroup>
		<thead>
			<tr><th><i class="fas fa-th-large mr10"></i> 발급대상자</th></tr>
		</thead>
	</table>
	<table class="tbl tbl_form mt5">
		<colgroup>
			<col style="width:12%;">
			<col style="width:38%;">
			<col style="width:12%;">
			<col style="width:38%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">상호 또는 기관명</th>
				<td>${corpEo.corpNm}</td>
				<th scope="row">사업자등록번호(고유번호)</th>
				<td>${corpEo.bizno }</td>
			</tr>
			<tr>
				<th scope="row">대표자</th>
				<td>${corpEo.ceoNm }</td>
				<th scope="row">전화번호</th>
				<td>${corpEo.telNo }</td>
			</tr>
		</tbody>
	</table>

	<table class="tbl tbl_search mt10">
		<colgroup>
			<col style="width:100%;">
		</colgroup>
		<thead>
			<tr>
				<th><i class="fas fa-th-large mr10"></i> 신청사항</th>
			</tr>
		</thead>
	</table>
	<table class="tbl tbl_form mt5">
		<colgroup>
			<col style="width:12%;">
			<col style="width:38%;">
			<col style="width:12%;">
			<col style="width:38%;">
		</colgroup>
		<tbody>
		<c:if test="${eo.se eq 'HCSE0001'}">
			<tr>
				<th scope="row">직종</th>
				<td>
					${eo.jssfcAllAt eq 'Y'?'전체':'' }
					<c:forEach var="list" items="${eo.jssfcVO }" varStatus="sts">
						${!sts.first?',':''} ${list.jssfcNm}
					</c:forEach>
				</td>
				<th scope="row">등급</th>
				<td>
					${eo.gradAllAt eq 'Y'?'전체':'' }
					<c:forEach var="list" items="${eo.gradVO }" varStatus="sts">
						${!sts.first?',':''} ${list.gradNm}
					</c:forEach>
				</td>
			</tr>
		</c:if>
			<tr>
				<th scope="row">사업장</th>
				<td colspan="3" class="p10">
				<c:if test="${eo.bplcAllAt eq 'Y' }">
					전체
				</c:if>
				<c:if test="${eo.bplcAllAt eq 'N' }">
					<div class="tableWrap constructionPlaceSelected list">
						<div>
							<span></span>
							<table class="tbl tbl_search">
								<colgroup>
									<col style="width:13%">
									<col style="width:46%">
									<col style="width:41%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col"><span>고용형태</span></th>
										<th scope="col"><span>공사명</span></th>
										<th scope="col"><span>주소</span></th>
									</tr>
								</thead>
								<tbody>
								<c:forEach var="list" items="${eo.cntrwkVO }">
									<tr>
										<td>${list.seNm }</td>
										<td>${list.cntrctNm }</td>
										<td>${list.adrs }</td>
									</tr>
								</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</c:if>
				</td>
			</tr>
			<tr>
				<th scope="row">근로자</th>
				<td colspan="3" class="p10">
				<c:if test="${eo.se eq 'HCSE0001'}">
					<c:if test="${eo.labrrAllAt eq 'Y' }">
						전체
					</c:if>
					<c:if test="${eo.labrrAllAt eq 'N' }">
						<div class="tableWrap constructionWorkerSelected list">
							<strong>* 발급대상 근로자</strong>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width:13%">
										<col style="width:45%">
										<col style="width:10%">
										<col style="width:17%">
										<col style="width:15%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><span>고용형태</span></th>
											<th scope="col"><span>공사명</span></th>
											<th scope="col"><span>성명</span></th>
											<th scope="col"><span>주민등록번호</span></th>
											<th scope="col"><span>직종</span></th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.labrrVO }">
										<c:if test="${list.se eq 'HCLS0001' }">
											<tr>
												<td>${list.clNm }</td>
												<td>${list.cntrctNm }</td>
												<td>${list.nm }</td>
												<td>${list.ihidnum }</td>
												<td>${list.jssfcNm }</td>
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
	
						<div class="tableWrap constructionWorkerSelected list mt10">
							<strong>* 증명서 발급동의 추가자</strong>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width:13%">
										<col style="width:45%">
										<col style="width:10%">
										<col style="width:17%">
										<col style="width:15%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><span>고용형태</span></th>
											<th scope="col"><span>공사명</span></th>
											<th scope="col"><span>성명</span></th>
											<th scope="col"><span>주민등록번호</span></th>
											<th scope="col"><span>직종</span></th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.labrrVO }">
										<c:if test="${list.se eq 'HCLS0002' }">
											<tr>
												<td>${list.clNm }</td>
												<td>${list.cntrctNm }</td>
												<td>${list.nm }</td>
												<td>${list.ihidnum }</td>
												<td>${list.jssfcNm }</td>
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
	
						<div class="tableWrap constructionWorkerSelected list mt10">
							<strong>* 기타 근로자</strong>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width:15%">
										<col>
										<col style="width:18%">
										<col style="width:17%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col"><span>고용형태</span></th>
											<th scope="col"><span>성명</span></th>
											<th scope="col"><span>주민등록번호</span></th>
											<th scope="col"><span>직종</span></th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.labrrVO }">
										<c:if test="${list.se eq 'HCLS0003' }">
											<tr>
												<td>${list.clNm }</td>
												<td>${list.nm }</td>
												<td>${list.ihidnum }</td>
												<td>${list.jssfcNm }</td>
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
					</c:if>
				</c:if>
				<c:if test="${eo.se eq 'HCSE0002'}">
					사업주가 보유한 모든 사업장의 기능등급 보유자
				</c:if>
				</td>
			</tr>
			<tr>
				<th scope="row">제출처</th>
				<td>${eo.presentnOfficNm } ${!empty eo.presentnOfficEtc?'- '.concat(eo.presentnOfficEtc):'' }</td>
				<th scope="row">발급매수</th>
				<td money="부">${eo.issuCo }</td>
			</tr>
			<tr>
				<th scope="row">결제구분</th>
				<td>${eo.setleSeNm }</td>
				<th scope="row">수수료</th>
				<td>${eo.sptSe eq 'SPTS0002'?eo.feeVO.hold:eo.feeVO.holdOnline }원
					<a href="#" class="btn btn_form ml10 btnRpt" data-title="건설기능인보유증명서영수증" style="color:#b33a00;">영수증</a>
				</td>
			</tr>
		</tbody>
	</table>

	<table class="tbl tbl_search mt10">
		<colgroup>
			<col style="width:100%;">
		</colgroup>
		<thead>
			<tr>
				<th><i class="fas fa-th-large mr10"></i> 제출서류</th>
			</tr>
		</thead>
	</table>
	<table class="tbl tbl_form mt5">
		<colgroup>
			<col style="width:12%;">
			<col style="width:88%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">첨부파일</th>
				<td class="p10" id="fileLayer">
				</td>
			</tr>
		</tbody>
	</table>

	<table class="tbl tbl_search mt10">
		<colgroup>
			<col style="width:100%;">
		</colgroup>
		<thead>
			<tr>
				<th><i class="fas fa-th-large mr10"></i> 접수정보</th>
			</tr>
		</thead>
	</table>
	<table class="tbl tbl_form mt5">
		<colgroup>
			<col style="width:12%;">
			<col style="width:38%;">
			<col style="width:12%;">
			<col style="width:38%;">
		</colgroup>
		<tbody>
			<tr>
				<th scope="row">서비스명</th>
				<td>보유증명서 발급</td>
				<th scope="row">접수방법</th>
				<td>${eo.recptSeNm }</td>
			</tr>
			<tr>
				<th scope="row">담당부서</th>
				<td>${eo.userVO.brffcNm }</td>
				<th scope="row">담당자</th>
				<td>${eo.userVO.userName }</td>
			</tr>
		</tbody>
	</table>

	<div class="btn_wrap">
		<div class="fr txt_right">
			<c:if test='${empty sanctnStatus.sanctnSttus or "APRV0004" eq sanctnStatus.sanctnSttus or "APRV0001" eq sanctnStatus.sanctnSttus}'>
			<button type="button" class="btn normal blue mr10 btnPop"> <i class="far fa-edit mr5"></i> 결재기안</button>
			<button type="button" class="btn normal red mr10 btnPop"> <i class="far fa-edit mr5"></i> 반려</button>
			</c:if>
			<c:if test='${"APRV0002" eq sanctnStatus.sanctnSttus or "APRV0003" eq sanctnStatus.sanctnSttus }'>
			<button type="button" id="goForm3" onclick="goFrm('4', this)" class="btn normal wood mr10"> <i class="far fa-edit mr5"></i> 결제회수</button>
			</c:if>
			<c:if test='${"APRV0004" eq sanctnStatus.sanctnSttus }'>
			<button type="button" id="goForm4" onclick="goFrm('0', this)" class="btn normal red mr10"> <i class="far fa-edit mr5"></i> 회수취소</button>
			</c:if>
			<a href="list.do" class="btn normal black mr10" id="btnList"><i class="fas fa-list mr5"></i> 목록</a>
		</div>
	</div>
	
	<div id="sanctnLayer" class="layerpop" style="width: 500px; height: 350px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">결재자 선택</div>
			<a href="#" class="layerpop_close">
				<i class="far fa-window-close"></i>
			</a>

			<div class="pop_content">
				<form id="frmPop" action="../sanctnWait/selectAgncyMember.do" method="post">
					<input type="hidden" name="se" value="search" />
					<table class="tbl tbl_form">
						<colgroup>
							<col width="25%">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">결재자 성명</th>
								<td><input type="text" class="w100p" maxlength="30" title="결재자 성명" name="agncyNm" required></td>
							</tr>
						</tbody>
					</table>
					<div class="mt10 txt_center">
						<button type="button" class="btn normal blue btnAgncyMember">조회</button>
					</div>
				</form>
				
				<div style="height:100px;overflow-y: auto;">
					<table class="tbl tbl_data">
						<colgroup>
							<col style="width:10%">
							<col style="width:30%">
							<col>
							<col style="width:30%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><span>선택</span></th>
								<th scope="col"><span>지사/센터</span></th>
								<th scope="col"><span>결재자 성명</span></th>
								<th scope="col"><span>이메일</span></th>
							</tr>
						</thead>
						<tbody id="memberResult"></tbody>
					</table>
				</div>
				
				<div class="btn_wrap mb20" style="display:none">
					<div class="txt_center mt20">
						<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 결재기안</a>
						<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
					</div>
				</div>

			</div>
		</div>
	</div>
</body>
</html>
