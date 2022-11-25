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
			
			$('[name=progrsDe]').val($.datepicker.formatDate('yy-mm-dd', new Date()));

			//처리완료일때 처리상태 변경불가
			if('${eo.progrsSttus}' == "CAPG0009"){
				$("[name=progrsSttus]").prop("disabled", true);
				$("#saveProgs").prop("disabled", true);
				
			}
			
			$('[name=progrsDe]').change(function(){
				if($('[name=rplyTmlmt]').length > 0){
					var date = new Date($('[name=progrsDe]').val());
					date.setTime(date.getTime() + (10 * 24 * 60 * 60 * 1000));
					$('[name=rplyTmlmt]').val($.datepicker.formatDate('yy-mm-dd', date));
				}
			});
			
			$('#saveProgs').click(function(e){
				$('#frm').attr('action', 'careerDeclareProgsIns.do');
				$('#frm').ajaxCwma({
					success:function(res){
						ajaxProgList();
					}
				});
				
				e.preventDefault();
				return false;
			});
			
			$('#btnPrint').click(function(){
				window.open("", "careerDeclareReport","status=no,scrollbars=yes,resizable=no,top=100,left=100,width=790,height=550");
				$('#frm').attr('action', 'careerDeclareReportPop.do');
				$('#frm').attr('target', 'careerDeclareReport');
				$('#frm').submit();
				$('#frm').attr('target', '');
			});
			
			$('#goForm').click(function(){
				$('#frm').attr('action', 'careerDeclareForm.do');
				$('#frm').submit();
			});
			
			$('[name=progrsSttus]').click(function(e){
				
				var html;
				
				removeProgrsTr();
				
				if("CAPG0004" == $(this).val()){
					
					html = '<tr id="CAPG00041">';
					html += '	<th scope="row">사유</th>';
					html += '		<td colspan="3">';
					html += '		<textarea class="w100p h100" id="progrsResn" name="progrsResn"></textarea>';
					html += '	</td>';
					html += '</tr>';
					html += '<tr id="CAPG00042">';
					html += '	<th scope="row">회신기한</th>';
					html += '	<td colspan="3" >';
					html += '		<div class="input_date">';
					html += '			<input type="text" style="width: 105px;" class="datepicker" name="rplyTmlmt">';
					html += '			<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>';
					html += '		</div>';
					html += '	</td>';
					html += '</tr>';
					var date = new Date($('[name=progrsDe]').val());
					date.setTime(date.getTime() + (10 * 24 * 60 * 60 * 1000));
					$('#appendTable').append(html);
					$('[name=rplyTmlmt]').val($.datepicker.formatDate('yy-mm-dd', date));			
					
				}else if("CAPG0006" == $(this).val()){
					
					
					html = '<tr id="CAPG0006">';
					html += '	<th scope="row">사유</th>';
					html += '	<td colspan="3">';
					html += '		<select onchange="progrsResnSelect(this.value);" style="margin-right:5px;float:left">';
					html += '			<option value="증빙서류 미제출">증빙서류 미제출</option>';
					html += '			<option value="신청자 취소요청">신청자 취소요청</option>';
					html += '			<option value="">직접입력</option>';
					html += '		</select><input type="text" class="w30p" name="progrsResn" value="증빙서류 미제출" style="display:none">';
					html += '	</td>';
					html += '</tr>';
					
					$('#appendTable').append(html);
					
				}
			});
			
			ajaxProgList();
		});
		
		var ajaxProgList = function(){
			$('#frm').attr('action', 'careerDeclareProgsList.do');
			$('#frm').ajaxCwma({
				success:function(res){
					var html = '';
					
					$(res.progsList).each(function(){
						html += '<tr>';
						html += '	<td>'+this.progrsSttusNm.replace('undefined', '')+'</td>';
						html += '	<td>'+this.rgstNm+'</td>';
						html += '	<td>'+this.rgstDept+'</td>';
						html += '	<td>'+this.progrsDe+'</td>';
						html += '	<td>'+this.rplyTmlmt+'</td>';
						html += '	<td class="txt_left pl20">'+this.progrsResn+'</td>';
						html += '</tr>';
					});
					
					$('#progsList').html(html);
				}
			});
		}
		
		var removeProgrsTr = function(){
			$('#CAPG00041').each(function(){
				$(this).remove();
			});
			$('#CAPG00042').each(function(){
				$(this).remove();
			});
			$('#CAPG0006').remove();
		}
		
		var progrsResnSelect = function(str){
			if("" != str){
				$('[name="progrsResn"]').val(str);
				$('[name="progrsResn"]').css('display', 'none');
			}else{
				$('[name="progrsResn"]').val('');
				$('[name="progrsResn"]').css('display', 'block');
			}
		}
	</script>
</head>
<body>
	<!--container-->
	<div class="data_wrap">
		<div>	
			<form id="frm" action="" method="post">
			<input type="hidden" name="careerNo" value="${eo.careerNo }" >				  
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody id="appendTable">
				<tr>
					<th scope="row">처리상태</th>
					<td colspan="3">
						<input name="progrsSttus" value="CAPG0002" type="radio" id="rad301" ${empty eo.progrsSttus or eo.progrsSttus eq "CAPG0002" ? "checked" : "" }> <label for="rad301"> 접수</label>
						<input name="progrsSttus" value="CAPG0003" type="radio" id="rad302" ${eo.progrsSttus eq "CAPG0003" ? "checked" : "" }> <label for="rad302"> 처리중</label>
						<input name="progrsSttus" value="CAPG0004" type="radio" id="rad303" ${eo.progrsSttus eq "CAPG0004" ? "checked" : "" }> <label for="rad303"> 보완</label>
						<input name="progrsSttus" value="CAPG0006" type="radio" id="rad304" ${eo.progrsSttus eq "CAPG0006" ? "checked" : "" }> <label for="rad304"> 반려</label>
						<input name="progrsSttus" value="CAPG0007" type="radio" id="rad305" ${eo.progrsSttus eq "CAPG0007" ? "checked" : "" }> <label for="rad305"> 제출완료</label>
						<input name="progrsSttus" value="CAPG0009" type="radio" id="rad306" ${eo.progrsSttus eq "CAPG0009" ? "checked" : "" }> <label for="rad306"> 처리완료</label>
					</td>
				</tr>
				<tr>
					<th scope="row">담당자</th>
					<td>
						${adminLoginInfo.userName }
					</td>
					<th scope="row">처리일자</th>
					<td>
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="progrsDe">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div> 
					</td>
				</tr>
				</tbody>
			</table>	
			<div class="btn_wrap txt_center">
				<button type="button" id="saveProgs" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 저장</button>
			</div>
			</form>
			<table class="tbl tbl_data">
				<colgroup>
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="10%" />
					<col width="" />
				</colgroup>
				<thead>
					<tr>
						<th scope="col"><span>처리상태</span></th>
						<th scope="col"><span>담당자</span></th>
						<th scope="col"><span>담당부서</span></th>
						<th scope="col"><span>처리일자</span></th>
						<th scope="col"><span>응신기한</span></th>
						<th scope="col"><span>사유</span></th>
					</tr>
				</thead>
				<tbody id="progsList">
				</tbody>
			 </table>   									
			
			<table class="tbl tbl_form mt5">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 90%;" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">구분</th>
					<td>
						근로직종확인
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
					   ${eo.mbtlnum }
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
					<thead>
						<tr>
							<th scope="row" class=""><i class="fas fa-th-large mr10"></i>퇴직공제</th>
						</tr>
					</thead>
				</table>
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<thead>
						<th>공사명</th>
						<th>업체명</th>
						<th>근로년월</th>
						<th>근로일수</th>
						<th>신고직종</th>
						<th>통합직종</th>
					</thead>
					<tbody>
						<c:forEach var="list" items="${workList }" varStatus="sts">
						<tr>
							<td>${list.bplcNm }</td>
							<td>${list.corpNm }</td>
							<td date="yy-mm">${list.laborYm }</td>
							<td money>${list.laborDaycnt }</td>
							<td>${list.jssfcNm }</td>
							<td>
								<select name="jssfcNoList" disabled>
									<c:forEach var="ceo" items="${jssfcList}">
										<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq list.jssfcCd?'selected':''}>${ceo.jssfcNm}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
				
				<table class="tbl tbl_search mt10">
					<thead>
						<tr>
							<th scope="row" class=""><i class="fas fa-th-large mr10"></i>고용보험(상용)</th>
						</tr>
					</thead>
				</table>
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<thead>
						<th>공사명</th>
						<th>업체명</th>
						<th>근로년월</th>
						<th>근로일수</th>
						<th>신고직종</th>
						<th>통합직종</th>
					</thead>
					<tbody>
						<c:forEach var="list" items="${workCmclList }" varStatus="sts">
						<tr>
							<td>${list.bplcNm }</td>
							<td>${list.corpNm }</td>
							<td dateToDate>${list.laborAcqdt} ~ ${list.laborFrfdt}</td>
							<td money>${list.laborDaycnt }</td>
							<td>${list.jssfcNm }</td>
							<td>
								<select name="jssfcNoList" disabled>
									<c:forEach var="ceo" items="${jssfcList}">
										<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq list.jssfcCd?'selected':''}>${ceo.jssfcNm}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						</c:forEach>
					</tbody>
				</table>
				
				<table class="tbl tbl_search mt10">
					<thead>
						<tr>
							<th scope="row" class=""><i class="fas fa-th-large mr10"></i>고용보험(일용)</th>
						</tr>
					</thead>
				</table>
				<table class="tbl tbl_data mt5">
					<colgroup>
						<col width="20%" />
						<col width="20%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<thead>
						<th>공사명</th>
						<th>업체명</th>
						<th>근로년월</th>
						<th>근로일수</th>
						<th>신고직종</th>
						<th>통합직종</th>
					</thead>
					<tbody>
						<c:forEach var="list" items="${workDlyList }" varStatus="sts">
						<tr>
							<td>${list.bplcNm }</td>
							<td>${list.corpNm }</td>
							<td date="yy-mm">${list.laborYm}</td>
							<td money>${list.laborDaycnt }</td>
							<td>${list.jssfcNm }</td>
							<td>
								<select name="jssfcNoList" disabled>
									<c:forEach var="ceo" items="${jssfcList}">
										<option value="${ceo.jssfcNo}" ${ceo.jssfcNo eq list.jssfcCd?'selected':''}>${ceo.jssfcNm}</option>
									</c:forEach>
								</select>
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
			<div class="fl txt_left">
				<button type="button" id="btnPrint" class="btn normal purple mr10"> <i class="far fa-file-alt mr5"></i> 신청서출력</button>
			</div>
			<div class="fr txt_right">
				<button type="button" id="goForm" class="btn normal green mr10"> <i class="far fa-edit mr5"></i> 수정</button>
				<a href="careerDeclareList.do" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>   
	</div>
	<!--container end-->
</body>
</html>
