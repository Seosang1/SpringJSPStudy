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
});
</script>
</head>
<body>
	<form action="" id="frm" method="post">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="title" value="" />
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
			<a href="list.do" class="btn normal black mr10" id="btnList"><i class="fas fa-list mr5"></i> 목록</a>
		</div>
	</div>
</body>
</html>
