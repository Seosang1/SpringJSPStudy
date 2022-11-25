<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

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
		
		//상세보기버튼 클릭이벤트
		$('#result').on('click', '.btnView', function(){
			$('#frm').attr('action', 'careerDeclareView.do');
			$('[name=careerNo]').val($(this).data('sn'));
			$('[name=se]').val($(this).data('ty'));
			$('#frm').submit();
		});
		
		//검색버튼 클릭이벤트
		$('#frm input').keyup(function(e){
			if(e.keyCode == 13){
				$('#btnSearch').click();
				e.preventDefault();
			}
			return false;
		});
		
		//엑셀다운로드
		$('.btnExcelForm').click(function(e){
			cwma.showExcelPop('/admin/careerDeclare/excelDown.do?'+$('#frm').serialize().replace(/%/g, '%25'));
			e.preventDefault();
			return false;
		});
		
		$('[name=jumin1]').keyup(function(){
			if($(this).val().length == 6){
				$('[name=jumin2]').focus();
			}
		});
		
		dateInput('1', 'Rqstdt');
		dateInput('1', 'Closedt');
		$('#btnSearch').click();
	});
	
	//날짜계산 입력
	function dateInput(type, input){
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
		dateInput2(date1, date2, input);
	}
	
	function dateInput2(date1, date2, input){
		if("Rqstdt" == input){
			$('[name=bgnRqstdt]').val(date1);
			$('[name=endRqstdt]').val(date2);
		}else if("Closedt" == input){
			$('[name=bgnClosedt]').val(date1);
			$('[name=endClosedt]').val(date2);
		}
	}
	
	//리스트조회 함수
	function ajaxList(pageNo){
		$('#frm').attr('action', 'careerDeclareList.do');
		$('[name="pageNo"]').val(pageNo);
		$('#frm').ajaxCwma({
			beforeSubmit:function(res){
				if($('[name="jumin1"]').val() || $('[name="jumin2"]').val()){
					if($('[name="jumin1"]').val().length < 3){
						alert('주민등록번호 앞자리를 입력해주세요')
						return false;
						
					}else if($('[name="jumin2"]').val().length < 5){
						alert('주민등록번호 뒷자리를 입력해주세요')
						return false;
					}
				}
				
			},
			success:function(res){
				var html = '';
				
				$(res.list).each(function(){
					html += '<tr>';
					html += '	<td>'+this.rownum+'</td>';
					html += '	<td>'+this.sptSeNm+'</td>';
					html += '	<td>'+this.seNm+'</td>';
					html += '	<td>'+this.rceptNo+'</td>';
					html += '	<td><a href="#" class="btnView" data-sn="'+this.careerNo+'" data-ty="'+this.se+'">'+this.nm+'</a></td>';
					html += '	<td>'+(this.rqstdt?this.rqstdt.formatDate():'')+'</td>';
					html += '	<td>'+(this.rceptDe?this.rceptDe.formatDate():'')+'</td>';
					html += '	<td>'+this.chrgBrffc+'</td>';
					html += '	<td>'+(this.rceptUser?this.rceptUser:'')+'</td>';
					html += '	<td>'+this.progrsSttusNm+'</td>';
// 					html += '	<td>'+this.trede+'</td>';
					html += '	<td>'+(this.progrsSttusDe?this.progrsSttusDe.formatDate():'')+'</td>';
					html += '	<td>'+this.processSttus+'</td>';
					html += '</tr>';
				});
				
				if(!res.vo.totalCnt)
					html = '<tr><td colspan="12">조회결과가 없습니다</td></tr>';
				
				$('#result').html(html);
				$('span.total').text(' 전체 '+res.vo.totalCnt.formatMoney()+' 건 | '+res.vo.pageNo+'/'+res.vo.totalPage+' 페이지 ');
				cwmaList.setPage(res.vo);
			}
		});
	};
</script>
</head>
<body>
	<div class="search_wrap">
		<form action="" id="frm" method="post">
			<input type="hidden" name="pageNo" value="1" />
			<input type="hidden" name="numOfPage" value="10" />
			<input type="hidden" name="careerNo" />
			<table class="tbl tbl_search">
				<colgroup>
					<col style="width: 10%;" />
					<col style="width: 40%;" />
					<col style="width: 10%;" />
					<col style="width: 40%;" />
				</colgroup>
				<tbody>
					<tr>
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
						<th scope="row">서비스구분</th>
						<td>
							<input type="radio" id="rad203" name="se" value="" title="구분" checked><label for="rad203">전체</label>
							<input type="radio" id="rad201" name="se" value="CASE0001" title="구분"><label for="rad201">경력인정신청</label>
							<input type="radio" id="rad202" name="se" value="CASE0002" title="구분"><label for="rad202">근로직종확인신청</label>
						</td>
					</tr>
					<tr>
						<th scope="row">주민등록번호</th>
						<td>
							<input type="text" class="w150" maxlength="6" name="jumin1" title="주민등록번호 앞자리" number>
							- <input type="text" class="w150" maxlength="7" name="jumin2" title="주민등록번호 뒷자리" number>
						</td>
						<th scope="row">신청자 성명</th>
						<td><input type="text" name="nm" class="w100p" /></td>
					</tr>
					<tr>
						<th scope="row">접수방법</th>
						<td>
							<select class="w30p" name="sptSe">
								<option value="">전체</option>
								<c:forEach var="list" items="${sptsList }" varStatus="sts">
									<option value="${list.cdId }">${list.cdNm }</option>
								</c:forEach>
							</select>
						</td>
						<th scope="row">처리상태</th>
						<td>
							<select class="w30p" name="progrsSttus">
								<option value="">전체</option>
								<c:forEach var="list" items="${capgList }" varStatus="sts">
									<option value="${list.cdId }">${list.cdNm }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<th scope="row">신청일</th>
						<td colspan="3">
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="bgnRqstdt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="신청일 시작" /></a>
							</div> <span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endRqstdt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="신청일 종료" /></a>
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
								<input type="text" style="width: 105px;" class="datepicker"  name="bgnClosedt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div> <span class="fuhao">~</span>
							<div class="input_date">
								<input type="text" style="width: 105px;" class="datepicker" name="endClosedt">
								<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
							</div> 
							<button type="button" onClick="dateInput('1', 'Closedt');" class="btn btn_form ml10">오늘</button>
							<button type="button" onClick="dateInput('2', 'Closedt');" class="btn btn_form ml10">어제</button>
							<button type="button" onClick="dateInput('3', 'Closedt');" class="btn btn_form ml10">1주</button>
							<button type="button" onClick="dateInput('4', 'Closedt');" class="btn btn_form ml10">1개월</button>
							<button type="button" onClick="dateInput('5', 'Closedt');" class="btn btn_form ml10">2개월</button>
							<button type="button" onClick="dateInput('6', 'Closedt');" class="btn btn_form ml10">당해년도</button>
							<button type="button" onClick="dateInput('7', 'Closedt');" class="btn btn_form ml10">전체</button>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap">
				<button type="button" class="btn btn_search mr10" id="btnSearch"><i  class="fas fa-search mr5"></i> 조회</button>
				<button type="reset" class="btn normal grey"><i class="far fa-sticky-note mr5"></i> 초기화</button>
			</div>
		</form>
	</div>

	<div class="data_wrap">
		<div class="top_wrap">
			<span class="total"> 전체 ${vo.totalCnt} 건 | ${vo.pageNo}/${vo.totalPage} 페이지 </span>
			<div class="fr txt_right">
				<a href="javascript:void();" class="btn normal green mr10 btnExcelForm"> <i
					class="far fa-file-excel mr5"></i> 엑셀다운로드
				</a>
			</div>
		</div>
		<table class="tbl tbl_data">
			<colgroup>
				<col width="5%" />
				<col width="7%" />
				<col width="7%" />
				<col width="" />
				<col width="9%" />
				<col width="9%" />
				<col width="9%" />
				<col width="9%" />
				<col width="9%" />
				<col width="9%" />
				<col width="9%" />
				<col width="9%" />
			</colgroup>
			<thead>
				<tr>
					<th scope="col">일련번호</th>
					<th scope="col"><span>접수방법</span></th>
					<th scope="col"><span>서비스구분</span></th>
					<th scope="col"><span>접수번호</span></th>
					<th scope="col"><span>성명</span></th>
					<th scope="col"><span>신청일</span></th>
					<th scope="col"><span>접수일</span></th>
					<th scope="col"><span>부서명</span></th>
					<th scope="col"><span>접수자</span></th>
					<th scope="col"><span>처리상태</span></th>
					<th scope="col"><span>처리일</span></th>
					<th scope="col"><span>결재상태</span></th>
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
