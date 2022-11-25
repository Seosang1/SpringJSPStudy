<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
var cwmaFile, namoCrossUploader;
var today = new Date();
	$(function(){
		cwmaFile = new CrossDownloader({fileLayer:'fileLayer', parntsSe:'ATCH0011', parntsSn:$('[name="reqstNo"]').val()});
		
		$('#btnPrint').click(function(){
			window.open("", "crtfReport","status=no,scrollbars=yes,resizable=no,top=100,left=100,width=900,height=680");
			$('#frm').attr('action', 'crtfIssuReportPop.do');
			
			$('#frm').attr('target', 'crtfReport');
			$('#frm').submit();
			$('#frm').attr('target', '');
		});
		$('#btnEdit').click(function(){
			$('#frm').attr('action', 'crtfIssuReqForm.do');
			$('#frm').submit();
		});
		$('#btnTrash').click(function(){
			var txt = $(this).text().trim();
			if(confirm('삭제하시겠습니까?')){
				$('#frm').attr('action', 'crtfIssuReqDelete.do');
				$('#frm').ajaxCwma({
					success:function(res){
						alert(txt + ' 되었습니다');
						location.href="crtfIssuReqList.do";
					}
				});
				return false;
			}
		});
		
		/* 수수료감면 신청 처리상태 저장 */
		$("#feeSave").click(function(){
			if($('#btnPrint')[0]){
				alert("처리완료되어 수정할 수 없습니다.");
				return false;
			}
			if(confirm("처리상태를 저장하시겠습니까?")){
				$("#frm").attr("action", "feeUpdateStatus.do");
				$("#frm").ajaxCwma({
					beforeSubmit:function(){
						if(!$("[name=progrsSttus]:checked").val()){
							alert("처리상태를 선택하세요.");
							return false;
						}else{
							$("#frm").append($("[name=progrsSttus]"));
							$("#frm").append("<input type='hidden' name='progrsDe' value='"+$("#toDate").text()+"'/>");
							$("#frm").append("<input type='hidden' name='rplyTmlmt' value='"+$.datepicker.formatDate('yy-mm-dd', today)+"'/>");
							if($("[name=progrsSttus]:checked").val() == "FEEA0004" || $("[name=progrsSttus]:checked").val() == "FEEA0005"){
								$("#frm").append($("[name=progrsResn]"));
							}
						}
							
					},success:function(res){
						alert('처리되었습니다.');
						location.reload();
					}
				});
			}
		});
		
		$("#toDate").text($.datepicker.formatDate('yy-mm-dd', today));
		today.setDate(today.getDate()+10);	//회신기한 : 10일뒤
		/* 처리상태 변경시 */
		$("[name=progrsSttus]").change(function(){
			if($("[name=progrsSttus]:checked").val() == "FEEA0004"){	//보완
				$("#replyDeadline").text($.datepicker.formatDate('yy-mm-dd', today));
				$("[name=progrsResnSelect] option").remove();
				$("[name=progrsResnSelect]").append("<option value='1'>증빙서류 첨부오류</option>");
				$("[name=progrsResnSelect]").append("<option value='2'>직접입력</option>");
				$("[name=progrsResnSelect]").change();
				$(".feeRe").show();
			}else if($("[name=progrsSttus]:checked").val() == "FEEA0005"){	//반려
				$("[name=progrsResnSelect] option").remove();
				$("[name=progrsResnSelect]").append("<option value='3'>신청자 취소요청</option>");
				$("[name=progrsResnSelect]").append("<option value='4'>증빙서류 미제출</option>");
				$("[name=progrsResnSelect]").append("<option value='5'>직접입력</option>");
				$("[name=progrsResnSelect]").change();
				$(".feeRe").show();
			}else
				$(".feeRe").hide();
		});
		
		/* 처리상태  */
		$("[name=progrsResnSelect]").change(function(){
			if($("[name=progrsResnSelect] option:selected").val() == "1"){
				$("[name=progrsResn]").val("증명서발급 신청 시 제출하신 서류가 다른 파일로 잘못 첨부되었습니다.\n해당 내용을 확인 후, 응신기한 내 PC 등록 또는 우편(방문)하여 주시기 바랍니다.");
			}else if($("[name=progrsResnSelect] option:selected").val() == "3"){
				$("[name=progrsResn]").val("신청자 취소요청으로 인해 증명서발급 신청이 반려되었습니다.\n감사합니다.");
			}else if($("[name=progrsResnSelect] option:selected").val() == "4"){
				$("[name=progrsResn]").val("증명서발급 신청 시 제출하신 서류가 다른 파일로 잘못 첨부되어 보완요청을 드렸으나,회신기한 내 서류를 미제출하여 증명서발급 신청이 반려되었습니다.\n감사합니다.");
			}else{
				$("[name=progrsResn]").val("");
			}
		});
	});
	
	var openPop = function(str){
		var top = screen.height/2 - 620/2;
		var left = screen.width/2 - 700/2;
		var option = 'width = 700px , height = 620px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no'; 
		window.open('crtfIssuReqReceiptPop.do?ReqstNo='+str, 'reciept', option);
	}
</script>
</head>
<body>
	<div class="data_wrap">
		<div>
			<form id="frm" action="" method="post">
				<input type="hidden" name="reqstNo" value="${eo.reqstNo }" >
				<input type="hidden" name="detailHistInclsAt" value="${eo.detailHistInclsAt}" />
				<input type="hidden" name="sanctnSttus" value="${eo.sanctnSttus }" >
			</form>
			
			<div class="feeDiv" ${eo.feeRdcxptReqst eq 'Y' or eo.stateMatterAditAt eq 'Y'?'':'style="display: none;"'}>
				<table class="tbl tbl_form mt5">
					<colgroup>
						<col style="width: 15%;" />
						<col style="width: 35%;" />
						<col style="width: 10%;" />
						<col style="width: 40%;" />
					</colgroup>
					<tbody>
					<tr>
						<th scope="row">처리상태</th>
						<td colspan="3">
							<input type="radio" id="fee2" name="progrsSttus" value="FEEA0002"><label for="fee2">접수</label>
							<input type="radio" id="fee3" name="progrsSttus" value="FEEA0003"><label for="fee3">처리중</label>
							<input type="radio" id="fee4" name="progrsSttus" value="FEEA0004"><label for="fee4">보완</label>
							<input type="radio" id="fee5" name="progrsSttus" value="FEEA0005"><label for="fee5">반려</label>
							<input type="radio" id="fee6" name="progrsSttus" value="FEEA0006"><label for="fee6">제출완료</label>
							<input type="radio" id="fee7" name="progrsSttus" value="FEEA0007"><label for="fee7">처리완료</label>
						</td>
					</tr>
					<tr>
						<th scope="row">담당자</th>
						<td>${uvo.userName }</td>
						<th scope="row">처리일자</th>
						<td id="toDate"></td>
					</tr>
					<tr class="feeRe" style="display: none;">
						<th scope="row">사유</th>
						<td colspan="3">
							<select name="progrsResnSelect">
								<option value="1">증빙서류 첨부오류</option>
								<option value="2">직접입력</option>
							</select>
							<br>
							<textarea name="progrsResn" class="w100p">증명서발급 신청 시 제출하신 서류가 다른 파일로 잘못 첨부되었습니다. 해당 내용을 확인 후, 응신기한 내 PC 등록 또는 우편(방문)하여 주시기 바랍니다.
							</textarea>
						</td>
					</tr>
					<tr class="feeRe" style="display: none;">
						<th scope="row">회신기한</th>
						<td id="replyDeadline"></td>
					</tr>
					</tbody>
				</table>
				<div class="btn_wrap txt_center">
					<button type="button" class="btn normal blue mr10" id="feeSave"> <i class="far fa-save mr5"></i> 저장</button>
				</div>
				
				<table class="tbl tbl_data">
					<colgroup>
						<col width="10%" />
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
							<th scope="col"><span>접수일자</span></th>
							<th scope="col"><span>처리일자</span></th>
							<th scope="col"><span>회신기한</span></th>
							<th scope="col"><span>사유</span></th>
						</tr>
					</thead>
					<tbody id="feeList">
						<c:forEach var="list" items="${feeList }">
							<tr>
								<td>${empty list.progrsSttusNm?'신청':list.progrsSttusNm }</td>
								<td>${list.userName }</td>
								<td>${list.brffcNm }</td>
								<td date>${list.rgstDt }</td>
								<td date>${list.rgstDt }</td>
								<td date>${list.rplyTmlmt }</td>
								<td>${list.progrsResn }</td>
							</tr>
						</c:forEach>
						<c:if test="${empty feeList }">
							<tr><td colspan="7">처리내역이 없습니다.</td></tr>
						</c:if>
					</tbody>
				</table>
			</div>
			
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
						${eo.relateNm } / ${eo.relateDetail }
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
					<th scope="row">환산근로년수</th>
					<td>
						<fmt:formatNumber pattern="#,###.##">${eo.gradCnt }</fmt:formatNumber>년
					</td>
					<th scope="row">발급매수</th>
					<td>
						${eo.issuCo }부
					</td>
				</tr>
				<tr>
					<th>세부이력 포함여부</th>
					<td>${eo.detailHistInclsAt eq 'Y'? '포함':'미포함' }</td>
					<th>주민등록번호(뒷부분6자리)공개여부</th>
					<td>${eo.ihidnumOthbcAt eq 'Y'? '공개':'비공개' }</td>
				</tr>
				<tr>
					<th>기재사항 추가여부</th>
					<td colspan="3">
						${eo.stateMatterAditAt eq 'Y'? '예':'아니오' }
					<c:if test="${eo.stateMatterAditAt eq 'Y'}">
						<input type="text" class="w50p" title="기재사항" value="${eo.stateMatter}" disabled="disabled" readonly/>
					</c:if>
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
				</tbody>
			</table>
			
			<table class="tbl tbl_search mt10" ${eo.feeRdcxptReqst eq 'Y' or eo.stateMatterAditAt eq 'Y'?'':'style="display: none;"'}>
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 첨부서류
						</th>
					</tr>
				</thead>
			</table>
			<table class="tbl tbl_form mt5" ${eo.feeRdcxptReqst eq 'Y' or eo.stateMatterAditAt eq 'Y'?'':'style="display: none;"'}>
				<colgroup>
					<col style="width: 10%;" />
					<col style="" />
				</colgroup>
				<tbody>
				<tr>
					<td class="p5" id="fileLayer">	   
					</td>
				</tr>
				</tbody>
			</table>
			
			<table class="tbl tbl_search mt10">
				<thead>
					<tr>
						<th scope="row" class="">
							<i class="fas fa-th-large mr10"></i> 결재정보
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
						${eo.chrgDept }
					</td>
					<th scope="row">담당자</th>
					<td>
						${eo.chrgNm }
					</td>
				</tr>
				</tbody>
			</table>
		</div>
		<div class="btn_wrap">
			<div class="fl txt_left"></div>
			<div class="fr txt_right">
				<c:if test="${eo.sanctnSttus eq 'APRV0005'}">
					<button type="button" id="btnPrint" class="btn normal blue mr10"> <i class="far fa-save mr5"></i> 발급</button>
				</c:if>
			<c:if test="${eo.sanctnSttus ne 'APRV0005'}">
				<button type="button" id="btnEdit" class="btn normal green mr10"> <i class="far fa-edit mr5"></i> 수정</button>
<!-- 				<button type="button" id="btnTrash" class="btn normal red mr10"> <i class="far fa-trash-alt mr5"></i> 삭제</button> -->
			</c:if>
				<button type="button" onclick="location.href='crtfIssuReqList.do'" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</button>
				<button type="button" onclick="location.href='crtfIssuForm.do'" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 새로운 신청</button>
			</div>
		</div>
	</div>
</body>
</html>
