<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	var cwmaList;

	$(function(){
		cwmaList = new cwma.list({pageLayer:$('.paging')});
		//검색버튼 클릭이벤트
		$('#btnSearch').click(function(e){
			ajaxList(1);
			return false;
		});

		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/crtfIssu/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'), true);
			e.preventDefault();
			return false;
		});
		
		dateInput(1, "Rqstdt");
		dateInput(1, "IssuOn");
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(e){
			e.preventDefault();
			$('#frm').attr('action', 'crtfIssuReqView.do');
			$('#frm').append('<input type="hidden" name="reqstNo" value="'+$(this).data('sn')+'" />');
			$('#frm').submit();
		});
		
		$('[name=jumin1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin2]').focus();
			}
		});
		
		//메뉴목록 엔터이벤트
		$('#frm input').on('keyup, keypress', function(e){
			if(e.keyCode == 13){
				$('#btnSearch').click();
				return false;
			}
		});
		
		$('#btnSearch').click();
	});
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'crtfIssuReqList.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			beforeSubmit:function(res){
				if($('[name="jumin1"]').val() || $('[name="jumin2"]').val()){
					if($('[name="jumin1"]').val().length < 6){
						alert('주민등록번호 앞자리를 입력해주세요')
						return false;
					}else if($('[name="jumin2"]').val().length < 7){
						alert('주민등록번호 뒷자리를 입력해주세요')
						return false;
					}
				}
				
			},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(i){
					var sanctnText = "";
					//수수료감면신청
					if(this.feeRdcxptReqst != "Y"){
						sanctnText = "해당없음";
					}else{
						if(this.sanctnSttus == "FEEA0001")	//결재대기
							sanctnText = "신청";
						else if(this.sanctnSttus == "FEEA0002")	//진행중
							sanctnText = "접수";
						else if(this.sanctnSttus == "FEEA0003")	//반려기안
							sanctnText = "처리중";
						else if(this.sanctnSttus == "FEEA0004")	//결재회수
							sanctnText = "보완";
						else if(this.sanctnSttus == "FEEA0005")	//결재승인
							sanctnText = "반려";
						else if(this.sanctnSttus == "FEEA0006")	//결재반려
							sanctnText = "제출완료";
						else if(this.sanctnSttus == "FEEA0007")	//처리완료
							sanctnText = "처리완료";
						else
							sanctnText = "신청";
					}
					
					html += '<tr>';
					html += '	<td>'+(res.vo.totalCnt-this.rownum+1)+'</td>';
					html += '	<td>'+this.sptSeNm+'</td>';
					html += '	<td>'+this.recptMthNm+'</td>';
					html += '	<td><a href="javascript:fnDetailView(\''+this.reqstNo+'\');">'+this.applcntNm+'</a></td>';
					html += '	<td><a href="javascript:fnDetailView(\''+this.reqstNo+'\');">'+this.issuTrgterNm+'</a></td>';
					html += '	<td>'+this.jumin3+'</td>';
					html += '	<td>'+this.rqstdt+'</td>';
					html += '	<td>'+this.issuDe+'</td>';
					html += '	<td>'+this.issuCo+'</td>';
					html += '	<td>'+this.chrgBrffc+'</td>';
					html += '	<td>'+sanctnText+'</td>';
					html += '	<td style="display:none">'+(!this.sanctnSttus?this.setleMthNm:'')+'</td>';
					html += '	<td style="display:none">'+(!this.sanctnSttus?'<button type="button" onclick="openPop('+this.reqstNo+')" class="btn btn_form mr10">영수증</button>':'')+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="13">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo+'/'+res.vo.totalPage+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	};

	/* 상세보기 */
	function fnDetailView(sn){
		$('#frm').attr('action', 'crtfIssuReqView.do');
		$('#frm').append('<input type="hidden" name="reqstNo" value="'+sn+'" />');
		$('#frm').submit();
	} 
	
	var openPop = function(str){
		var top = screen.height/2 - 620/2;
		var left = screen.width/2 - 700/2;
		var option = 'width = 700px , height = 620px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no'; 
		window.open('crtfIssuReqReceiptPop.do?ReqstNo='+str, 'reciept', option);
	}
	
	//날짜계산 입력
	var dateInput = function(type, input){
		var date1 = '', date2 = '';
		
		var cDate = new Date();
		var cDate2 = new Date();
		
		if(type == '1'){
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate);
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2);
		}else if(type == '2'){
			cDate.setTime(new Date().getTime() - (1 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '3'){
			cDate.setTime(new Date().getTime() - (7 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '4'){
			cDate.setTime(new Date().getTime() - (30 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '5'){
			cDate.setTime(new Date().getTime() - (60 * 24 * 60 * 60 * 1000)); //1일전
	
			date1 = $.datepicker.formatDate('yy-mm-dd', cDate );
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '6'){
			date1 = cDate.getFullYear() + "-01-01";
			date2 = $.datepicker.formatDate('yy-mm-dd', cDate2 );
		}else if(type == '7'){
			date1 = '';
			date2 = '';
		}
		
		if("Rqstdt" == input){
			$('[name=bgnRqstdt]').val(date1);				
			$('[name=endRqstdt]').val(date2);
		}else{
			$('[name=bgnIssuOn]').val(date1);				
			$('[name=endIssuOn]').val(date2);
		}
	}
</script>
</head>
<body>
	<div class="search_wrap">
		<form id="frm" action="#" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="10" />
			<input type="hidden" name="printSe" value="CASE0001" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
				<tr>
					<th scope="row">주민등록번호</th>
					<td>
						<input type="text" class="w30p" name="jumin1" maxlength="6" number/>
						-
						<input type="text" class="w30p" name="jumin2" maxlength="7" number />
					</td>
<!-- 					<th scope="row">결제구분</th> -->
<!-- 					<td> -->
<!-- 						<select class="w30p" name="setleMth"> -->
<!-- 							<option value="">전체</option> -->
<%-- 							<c:forEach var="list" items="${payList }" varStatus="sts"> --%>
<%-- 							<option value="${list.cdId }">${list.cdNm }</option> --%>
<%-- 							</c:forEach> --%>
<!-- 						</select> -->
<!-- 					</td> -->
				<c:if test='${adminLoginInfo.ddcAstcCd eq "01100" }'>
					<th scope="row">지사/센터</th>
					<td>
						<select name="chrgBrffc">
							<option value="">전체</option>
							<c:forEach var="ddcAsctList" items="${ddcAsctList }" varStatus="sts">
							<option value="${ddcAsctList.ddcAsctCd }">${ddcAsctList.brffcNm }</option>
							</c:forEach>
						</select>
					</td>
				</c:if>
				</tr>
				<tr>
					<th scope="row">대상자 성명</th>
					<td colspan="3">
						<input type="text" class="w100p" name="issuTrgterNm" />
					</td>
				</tr>
				<tr>
					<th scope="row">수수료감면 신청</th>
					<td colspan="3">
						<label><input name="feeRdcxptStat" value="" type="radio" checked>전체</label>
						<input type="radio" id="fee1" name="feeRdcxptStat" value="FEEA0000" /><label for="fee1">해당없음</label>
						<input type="radio" id="fee2" name="feeRdcxptStat" value="FEEA0002"><label for="fee2">접수</label>
						<input type="radio" id="fee3" name="feeRdcxptStat" value="FEEA0003"><label for="fee3">처리중</label>
						<input type="radio" id="fee4" name="feeRdcxptStat" value="FEEA0004"><label for="fee4">보완</label>
						<input type="radio" id="fee5" name="feeRdcxptStat" value="FEEA0005"><label for="fee5">반려</label>
						<input type="radio" id="fee6" name="feeRdcxptStat" value="FEEA0006"><label for="fee6">제출완료</label>
						<input type="radio" id="fee7" name="feeRdcxptStat" value="FEEA0007"><label for="fee7">처리완료</label>
					</td>
				</tr>
				<tr>
					<th scope="row">신청일</th>
					<td colspan="3">
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="bgnRqstdt">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<span class="fuhao">~</span>
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="endRqstdt">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<button type="button" onClick="dateInput('1', 'Rqstdt');" class="btn btn_form ml10">오늘</button>
						<button type="button" onClick="dateInput('2', 'Rqstdt');" class="btn btn_form ml10">어제</button> 
						<button type="button" onClick="dateInput('3', 'Rqstdt');" class="btn btn_form ml10">1주</button>
						<button type="button" onClick="dateInput('4', 'Rqstdt');" class="btn btn_form ml10">1개월</button>
						<button type="button" onClick="dateInput('5', 'Rqstdt');" class="btn btn_form ml10">2개월</button>
						<button type="button" onClick="dateInput('6', 'Rqstdt');" class="btn btn_form ml10">당해년도</button>
						<button type="button" onClick="dateInput('7', 'Rqstdt');" class="btn btn_form ml10">전체</button>
					</td>
				</tr>
				<tr>
					<th scope="row">발급일</th>
					<td colspan="3">
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="bgnIssuOn">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<span class="fuhao">~</span>
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="endIssuOn">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
						<button type="button" onClick="dateInput('1', 'IssuOn');" class="btn btn_form ml10">오늘</button>
						<button type="button" onClick="dateInput('2', 'IssuOn');" class="btn btn_form ml10">어제</button> 
						<button type="button" onClick="dateInput('3', 'IssuOn');" class="btn btn_form ml10">1주</button>
						<button type="button" onClick="dateInput('4', 'IssuOn');" class="btn btn_form ml10">1개월</button>
						<button type="button" onClick="dateInput('5', 'IssuOn');" class="btn btn_form ml10">2개월</button>
						<button type="button" onClick="dateInput('6', 'IssuOn');" class="btn btn_form ml10">당해년도</button>
						<button type="button" onClick="dateInput('7', 'IssuOn');" class="btn btn_form ml10">전체</button>
					</td>
				</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<button type="button" id="btnSearch" class="btn btn_search mr10"> <i class="fas fa-search mr5"></i> 조회</button>
				<button type="reset" class="btn normal grey"> <i class="far fa-sticky-note mr5"></i>  초기화</button>
			</div>
		</form>
	</div>
	
	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total">
				전체 8,999 건  |	5/400 페이지
			</span>
			<div class="fr txt_right">
				<button type="button" class="btn normal green mr10 btnExcelForm"> <i class="far fa-file-excel mr5"></i> 엑셀다운로드</button>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="8%" />
				<col width="10%" />
				<col width="10%" />
				<col />
				<col width="10%" />
				<col width="10%" />
<%-- 				<col width="8%" /> --%>
<%-- 				<col width="10%" /> --%>
				<col width="10%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">일련번호</th>
					<th scope="col"><span>접수방법</span></th>
					<th scope="col"><span>발급형태</span></th>
					<th scope="col"><span>신청자성명</span></th>
					<th scope="col"><span>대상자성명</span></th>
					<th scope="col"><span>생년월일</span></th>
					<th scope="col"><span>신청일</span></th>
					<th scope="col"><span>발급일</span></th>
					<th scope="col"><span>발급부수</span></th>
					<th scope="col"><span>부서명</span></th>
					<th scope="col"><span>수수료감면신청</span></th>
<!-- 					<th scope="col"><span>결재구분</span></th> -->
<!-- 					<th scope="col"><span>영수증</span></th> -->
				</tr>
			</thead>
			<tbody id="result">
			</tbody>
		</table>
		<div class="paging">
		</div>
	</div>
</body>
</html>
