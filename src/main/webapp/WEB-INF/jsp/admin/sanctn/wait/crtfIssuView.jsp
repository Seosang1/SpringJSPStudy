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
		
	});
	
	var openPop = function(str){
		var top = screen.height/2 - 620/2;
		var left = screen.width/2 - 700/2;
		var option = 'width = 700px , height = 620px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no'; 
		window.open('crtfIssuReqReceiptPop.do?ReqstNo='+str, 'reciept', option);
	}
	
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
	<div class="data_wrap">
		<div>
			<form id="frm" action="" method="post">
				<input type="hidden" name="reqstNo" value="${eo.reqstNo }" >
				<input type="hidden" name="detailHistInclsAt" value="${eo.detailHistInclsAt}" />
				<input type="hidden" name="docNo" value="${eo.reqstNo }" >
				<input type="hidden" name="careerNo" value="${eo.reqstNo }" >		  
				<input type="hidden" name="sanctnSttus" >				  
				<input type="hidden" name="sanctnKnd" value="ARCS0002" >
			</form>
			
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
		
			<table class="tbl tbl_form mt5" style="display:none">
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
				<button type="button" id="goForm1" onclick="goFrm('5', this)" class="btn normal blue mr10"> <i class="far fa-edit mr5"></i> 승인</button>
				<button type="button" id="goForm2" onclick="goFrm('6', this)" class="btn normal red mr10"> <i class="far fa-edit mr5"></i> 반려</button>
				<a href="list.do" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
	</div>
</body>
</html>
