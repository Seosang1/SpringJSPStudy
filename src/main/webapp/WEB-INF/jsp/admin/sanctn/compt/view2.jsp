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
			cwmaFile = new cwma.file({fileLayer:'#fileLayer', parntsSe:'ATCH0009', parntsSn:$('[name="careerNo"]').val()});
			cwmaFile.setFileList();
	</script>
</head>
<body>
	<!--container-->
	<div class="data_wrap">
		<div>	
			<form id="frm" action="" method="post">
			<input type="hidden" name="docNo" value="${eo.careerNo }" >				  
			<input type="hidden" name="careerNo" value="${eo.careerNo }" >				  
			<input type="hidden" name="sanctnSttus" >				  
			<input type="hidden" name="sanctnKnd" value="ARCS0001" >
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 90%;" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">구분</th>
					<td>
						근로직종확인신청
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
						<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 신청자정보</th>
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
					   ${eo.jumin1 }-${fn:substring(eo.jumin2, 0, 1) }******
					</td>
				</tr>
				<tr>
					<th scope="row">성명</th>
					<td>
						${eo.nm }
					</td>
					<th scope="row">신청자와 관계</th>
					<td>
						${eo.relateNm} ${eo.relateDetail }
					</td>
				</tr>
				<tr>
					<th scope="row">휴대폰</th>
					<td>
					   ${eo.mbtlnum}
					</td>
					<th scope="row">이메일</th>
					<td>					  
						${eo.email}
					</td>
				</tr>
				<tr>
					<th scope="row">주소</th>
					<td colspan="3">
						${eo.zip}
						${eo.adres}
					</td>
				</tr>
				<tr>
					<th scope="row">신청일</th>
					<td colspan="3">
						${eo.rqstdt }
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
							<th scope="row" class=""><i class="fas fa-th-large mr10"></i> 확인자정보</th>
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
							<th scope="row">상호명</th>
							<td>
								${eo.cmpnmNm }
							</td>
							<th scope="row">대표자명</th>
							<td>
								${eo.rprsntvNm }
							</td>
						</tr>
						<tr>
							<th scope="row">사업자등록번호</th>
							<td>
								${eo.bizno }
							</td>
							<th scope="row">법인등록번호</th>
							<td>
								${eo.jurirno }
							</td>
						</tr>
						<tr>
							<th scope="row">휴대폰</th>
							<td colspan="3">
							   ${eo.mbtlnum2 }
							</td>
						</tr>
						<tr>
							<th scope="row">주소</th>
							<td colspan="3">
								${eo.zip2 }
								${eo.adres2 }
							</td>
						</tr>
						<tr>
							<th scope="row">신청일</th>
							<td colspan="3">
								${eo.rqstdt }
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
							<th scope="row" class="">
								<i class="fas fa-th-large mr10"></i> 확인사항
							</th>
						</tr>
					</thead>
				</table>		 
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="" />
						<col width="15%" />
						<col width="8%" />
						<col width="8%" />
						<col width="10%" />
						<col width="15%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><span>공사명</span></th>
							<th scope="col"><span>고용보험관리번호</span></th>
							<th scope="col"><span>근로년월</span></th>
							<th scope="col"><span>근로일수</span></th>
							<th scope="col"><span>기존직종</span></th>
							<th scope="col"><span>근로직종</span></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${workList }" varStatus="sts">
						<tr>
							<td>${list.bplcNm }</td>
							<td>${list.bplcCno }</td>
							<td>${list.laborYm }</td>
							<td>${list.laborDaycnt }</td>
							<td>${list.jssfcNm }</td>
							<td>
								<c:forEach var="ceo" items="${jssfcList}">
									${ceo.jssfcNo eq list.jssfcNo? ceo.jssfcNm:''}
								</c:forEach>
							</td>
						</tr>
						</c:forEach>
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
						<col style="width: 10%;" />
						<col style="width: 40%;" />
						<col style="width: 10%;" />
						<col style="width: 40%;" />
					</colgroup>
					<tbody>
					<tr>
						<th scope="row">접수번호</th>
						<td>	   
							${eo.rceptNo }
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
			</div>			
		<div class="btn_wrap">
			<div class="fr txt_right">
				<a href="list.do" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>   
	</div>
	<!--container end-->
</body>
</html>
