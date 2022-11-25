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
		cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0011', parntsSn:$('[name="reqstNo"]').val()});
		cwmaFile.setFileList();
	});
</script>
</head>
<body>
	<div class="data_wrap">
		<div>
			<form id="frm" action="" method="post">
				<input type="hidden" name="reqstNo" value="${eo.reqstNo }" >
			</form>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 90%;" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">구분</th>
					<td>
						기능등급증명서발급신청
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
					<td>
						${eo.applcntNm }
					</td>
					<th scope="row">주민등록번호</th>
					<td>
						${fn:substring(eo.applcntIhidnum, 0, 6) } - ${fn:substring(eo.applcntIhidnum, 7, 8) }******
					</td>
				</tr>
				<tr>
					<th scope="row">휴대폰</th>
					<td>
						${eo.applcntMoblphon }
					</td>
					<th scope="row">발급대상자와 관계</th>
					<td>
						<c:choose>
							<c:when test="${eo.relate eq 'RELA0001'}">
								${eo.relateNm }
							</c:when>
							<c:otherwise>
								${eo.relateNm } / ${eo.relateDetail }
							</c:otherwise>
						</c:choose> 
					</td>
				</tr>
				<tr>
					<th scope="row">신청일</th>
					<td>
						${eo.rqstdt }
					</td>
					<th scope="row">발급일</th>
					<td>		 
						${eo.issuOn }
					</td>
				</tr>
				</tbody>
			</table>				
						
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
						${fn:substring(eo.issuTrgterIhidnum, 0, 6) } - ${fn:substring(eo.issuTrgterIhidnum, 7, 8) }******
					</td>
				</tr>
				<tr>
					<th scope="row">성명</th>
					<td>
						${eo.issuTrgterNm }
					</td>
					<th scope="row">휴대폰</th>
					<td>
						${eo.issuTrgterMoblphon }
					</td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td colspan="3">
						${eo.issuTrgterZip } ${eo.issuTrgterAdres }
					</td>
				</tr>
				</tbody>
			</table>	
			
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 발급정보
						</th>
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
					<th scope="row">기능등급</th>
					<td colspan="3">	   
						<em class="red">${eo.gradNm }</em>
					</td>
				</tr>
				<tr>
					<th scope="row">주된 직종</th>
					<td>
						${eo.jssfcNm }
					</td>
					<th scope="row">활용 직종</th>
					<td>
						${eo.jssfcNm }
					</td>
				</tr>
				<tr>
					<th scope="row">환산근로일수</th>
					<td>
						<fmt:formatNumber pattern="#,###.#">${eo.cnvrsnDaycnt }</fmt:formatNumber>일
					</td>
					<th scope="row">발급매수</th>
					<td>
						${eo.issuCo }부
					</td>
				</tr>
				<tr>
					<th scope="row">결제구분</th>
					<td>
						${eo.setleMthNm }
					</td>
					<th scope="row">수수료</th>
					<td>
						<fmt:formatNumber pattern="#,###">${eo.issuAmount }</fmt:formatNumber>원 
						<a href="#" onclick="openPop(${eo.reqstNo})" class="btn btn_form mr10">영수증</a>
					</td>
				</tr>
				</tbody>
			</table>	
		
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 수수료감면 대상
						</th>
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
					<th scope="row">수수료감면 신청</th>
						<td colspan="3">${eo.feeRdcxptReqst eq 'Y' ? '수수료감면 신청':'해당없음' }</td>
					</tr>
					<tr ${eo.feeRdcxptReqst ne 'Y' ? 'style="display:none;"':''}>
						<th scope="row">감면유형</th>
						<td colspan="3">${eo.feeRdcxptTyNm }</td>
					</tr>
					<tr ${eo.feeRdcxptReqst ne 'Y' ? 'style="display:none;"':''}>
						<th scope="row">첨부서류</th>
						<td colspan="3" class="p10" id="fileLayer"></td>
					</tr>
				</tbody>
			</table>
			
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 접수정보
						</th>
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
					<th scope="row">서비스명</th>
					<td>
						건설기능증명서 발급
					</td>
					<th scope="row">접수방법</th>
					<td>
						${eo.sptSeNm }
					</td>
				</tr>
				<tr>
					<th scope="row">담당부서</th>
					<td>
						${adminLoginInfo.brffcNm }
					</td>
					<th scope="row">담당자</th>
					<td>
						${adminLoginInfo.userName }
					</td>
				</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="list.do" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</div>
</body>
</html>
