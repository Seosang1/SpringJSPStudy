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
		cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0013', parntsSn:$('[name="docNo"]').val()});
		cwmaFile.setFileList();
	});
</script>
</head>
<body>
	<div class="data_wrap">
		<div>
			<!-- 첨부파일 -->
			<form id="frm" action="" method="post">
				<input type="hidden" name="docNo" value="${eo.docNo }" >
			</form>
			<!-- //첨부파일 -->
			<!------------ 구분 ------------>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 15%;" />
					<col style="width: 35%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
						발급동의신청
					</td>
				</tr>
				</tbody>
			</table>
			<!------------ //구분 ------------>
			<!------------ 대상자 ------------>
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 동의대상자</th>
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
					<td>
						${fn:substring(eo.ihidnum, 0, 6) } - ${fn:substring(eo.ihidnum, 7, 8) }******
					</td>
					<th scope="row">발급 직종</th>
					<td>
						${eo.jssfcNm }
					</td>
				</tr>
				</tr>
				<tr>
					<th scope="row">성명</th>
					<td>
						${eo.nm }
					</td>
					<th scope="row">휴대폰 번호</th>
					<td>
						${eo.moblphonNo }
					</td>
				</tr>
				<tr>
					<th scope="row">이메일 주소</th>
					<td colspan="3">
						${eo.email }
					</td>
				</tr>
				</tbody>
			</table>
			<!------------ //대상자 ------------>
			<!------------ 신청자 ------------>
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 동의신청자</th>
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
						${eo.nm }
					</td>
					<th scope="row">주민등록번호</th>
					<td>
						${fn:substring(eo.ihidnum, 0, 6) } - ${fn:substring(eo.ihidnum, 7, 8) }******
					</td>
				</tr>
				<tr>
					<th scope="row">휴대폰 번호</th>
					<td>
						${eo.moblphonNo }
					</td>
					<th scope="row">발급대상자와 관계</th>
					<td>					  
						본인
					</td>
				</tr>
				<tr>
					<th scope="row">신청일</th>
					<td>
						${eo.rgstDt }
					</td>
					<th scope="row">발급일</th>
					<td>		 
						${eo.issuOn }
					</td>
				</tr>
				</tbody>
			</table>
			<!------------ //신청자 ------------>
			<!------------ 동의대상 ------------>
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 동의대상</th>
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
					<th scope="row">사업자등록번호</th>
					<td colspan="3">
						${eo.bizno }
					</td>
				</tr>
				<tr>
					<th scope="row">공사명</th>
					<td colspan="3">
						${eo.cnstwkNm }
					</td>
				</tr>
				<tr>
					<th scope="row">기업명</th>
					<td>
						${eo.corpNm }
					</td>
					<th scope="row">대표자</th>
					<td>
						${eo.ceoNm }
					</td>
				</tr>
				<tr>
					<th scope="row">전화번호</th>
					<td colspan="3">
						${eo.telNo }
					</td>
				</tr>
				</tbody>
			</table>
			
			<!------------ //동의대상 ------------>
			<!------------ 제출서류 ------------>
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 제출서류
						</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">첨부파일</th>
					<td class="" id="fileLayer">	   
					</td>
				</tr>
				</tbody>
			</table>
			<!------------ //제출서류 ------------>
			<!------------ 접수정보 ------------>
			<table class="tbl tbl_search mt10">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
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
						${eo.rceptDept }
					</td>
					<th scope="row">담당자</th>
					<td>
						${eo.rceptUser }
					</td>
				</tr>
				</tbody>
			</table>
			<!------------ //접수정보 ------------>
			
		<div>
		<!-- 목록 -->
		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<a href="list.do" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
		<!-- //목록 -->
	</div>
</body>
</html>
<!------------  ------------>