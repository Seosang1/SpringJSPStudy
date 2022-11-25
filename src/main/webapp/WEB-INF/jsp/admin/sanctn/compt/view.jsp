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
						경력인정신청
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
			<ul class="tab200 mt10">
				<li class="on" id="tab1" name="tab1" onClick="tabDisplay('P');">
					자격
				</li>
				<li id="tab2" name="tab2" onClick="tabDisplay('R');">
					교육훈련
				</li>
				<li id="tab3" name="tab3" onClick="tabDisplay('E');">
					포상
				</li>
			</ul>	
											
			<div id="catab_1" name="catab_1" style="display: block;">
				<!-- 자격 -->
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="" />
						<col width="10%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><span>자격종목명</span></th>
							<th scope="col"><span>취득일자</span></th>
							<th scope="col"><span>관리번호</span></th>
							<th scope="col"><span>발급기관</span></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${licenseList }" varStatus="sts">
						<tr>
							<td>${list.lcnsJssfc }</td>
							<td date>${list.lcnsAcqdt }</td>
							<td>${list.lcnsNo }</td>
							<td>${list.cntcNm }</td>
						</tr>
						</c:forEach>
					 </tbody>
				 </table>									
			</div>
			<div id="catab_2" name="catab_2" style="display: none;">
				<!-- 교육훈련 -->
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="" />
						<col width="20%" />
						<col width="20%" />
						<col width="20%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><span>과정명</span></th>
							<th scope="col"><span>훈련유형</span></th>
							<th scope="col"><span>실제출석일수(시간)</span></th>
							<th scope="col"><span>교육훈련기관</span></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${eduList }" varStatus="sts">
						<tr>
							<td>${list.crseNm }</td>
							<td>&nbsp;</td>
							<td>${list.traingDe }</td>
							<td>${list.cntcNm }</td>
						</tr>
						</c:forEach>
					 </tbody>
				 </table> 
			</div>
			<div id="catab_3" name="catab_3" style="display: none;">
				<!-- 포상 -->
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="18%" />
						<col width="" />
						<col width="18%" />
						<col width="18%" />
						<col width="18%" />
					</colgroup>
					<thead>
						<tr>
							<th scope="col"><span>경기종목</span></th>
							<th scope="col"><span>대회명</span></th>
							<th scope="col"><span>수상내역</span></th>
							<th scope="col"><span>수여일자</span></th>
							<th scope="col"><span>수여기관</span></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="list" items="${rewardList }" varStatus="sts">
						<tr>
							<td>${list.item }</td>
							<td>${list.cnfrncNm }</td>
							<td>${list.grad }</td>
							<td>${list.rwardDe }</td>
							<td>${list.cntcNm }</td>
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
