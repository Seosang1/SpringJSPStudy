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

	//삭제버튼 이벤트
	$('#btnDel').click(function(e){
		if(confirm('삭제하시겠습니까?')){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					alert('삭제되었습니다');
					$('#btnList').click();
				}
			});
		}
		e.preventDefault();
		return false;
	});

	//수정버튼 이벤트
	$('#btnUpd').click(function(e){
		$('#frm').attr('action', $(this).attr('href'));
		$('#frm').submit();
		e.preventDefault();
		return false;
	});

	$('.constructionWorkerSelected').each(function(){
		if(!$(this).find('tbody tr') || !$(this).find('tbody tr').length){
			$(this).hide();
		}
	});
	
	//사유변경
	$('[name="resn"]').change(function(){
		$(this).next().val($(this).find('option:selected').data('val'));
	});
	
	//사유변경
	$('[name="progrsSttus"]').change(function(){
		$('[data-sttus]').hide();
		$('[data-sttus="'+$(this).val()+'"]').show();
		$('[name="resn"]:visible').change();
	});
	
	//처리일자 변경
	$('[name="progrsDe"]').change(function(){
		if($('[name="rplyTmlmt"]:visible')[0]){
			var str = $(this).val().split('-');
			var date = new Date();
			
			date.setFullYear(str[0]);
			date.setMonth(str[1]);
			date.setDate(str[2]);
			
			$('[name="rplyTmlmt"]').val($.datepicker.formatDate('yy-mm-dd', date.add(10)));
		}
	});
	
	//처리상태 저장버튼 클릭
	$('.btnProg').click(function(){
		$('#progFrm').ajaxCwma({
			beforeSubmit:function(){
				if($('[name="resn"]:visible')[0]){
					if(!$('[name="resnEtc"]:visible').val()){
						alert('사유를 입력해주세요');
						return false;
					}
					
					$('[name="progrsResn"]').val($('[name="resnEtc"]:visible').val());
				}else{
					$('[name="rplyTmlmt"]').val('');
				}
			},success:function(res){
				alert('처리되었습니다.');
				location.reload();
			}
		});
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

	<form id="progFrm" action="insertProgrs.do" method="post" ${eo.sptSe eq 'SPTS0002'?'style="display:none"':'' }>
		<input type="hidden" name="holdCrtfSn" value="${eo.sn }" />
		<input type="hidden" name="progrsResn" value="" />
		<table class="tbl tbl_form mt5">
			<colgroup>
				<col style="width: 10%;" />
				<col style="width: 40%;" />
				<col style="width: 10%;" />
				<col style="width: 40%;" />
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">처리상태</th>
					<td colspan="3">
						<label><input name="progrsSttus" value="CAPG0002" type="radio" required title="처리상태"> 접수</label>
						<label><input name="progrsSttus" value="CAPG0003" type="radio" required title="처리상태"> 처리중</label>
						<label><input name="progrsSttus" value="CAPG0004" type="radio" required title="처리상태"> 보완</label>
						<label><input name="progrsSttus" value="CAPG0006" type="radio" required title="처리상태"> 반려</label>
						<label><input name="progrsSttus" value="CAPG0007" type="radio" required title="처리상태"> 제출완료</label>
						<label><input name="progrsSttus" value="CAPG0009" type="radio" required title="처리상태"> 처리완료</label>
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
				<tr data-sttus="CAPG0004" style="display:none">
					<th scope="row">사유</th>
					<td colspan="3">
						<select name="resn">
							<option value="증빙서류 첨부오류" data-val="건설근로자 보유증명서 발급신청 시 제출하신 서류가 다른파일로 잘못 첨부되었습니다.해당 내용을 확인 후, 회신기한 내 PC 등록 또는 우편(방문)하여 주시기 바랍니다.">증빙서류 첨부오류</option>
							<option value="">직접입력</option>
						</select>
						<textarea name="resnEtc" class="w100p"></textarea>
					</td>
				</tr>
				<tr data-sttus="CAPG0004" style="display:none">
					<th scope="row">회신기한</th>
					<td colspan="3">
						<div class="input_date">
							<input type="text" style="width: 105px;" class="datepicker" name="rplyTmlmt">
							<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
						</div>
					</td>
				</tr>
				<tr data-sttus="CAPG0006" style="display:none">
					<th scope="row">사유</th>
					<td colspan="3">
						<select name="resn">
							<option value="신청자 취소요청" data-val="신청자 취소요청으로 인해 건설근로자 보유증명서 발급신청이 반려되었습니다.감사합니다.">신청자 취소요청</option>
							<option value="증빙서류 미제출" data-val="건설근로자 보유증명서 발급신청 시 제출하신 서류가 다른 파일로 잘못 첨부되어 보완요청을 드렸으나, 회신기한 내 서류를 미제출하여 건설근로자 보유증명서 보유증명서 발급신청이 반려되었습니다.감사합니다.">증빙서류 미제출</option>
							<option value="">직접입력</option>
						</select>
						<textarea name="resnEtc" class="w100p"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
		<div class="btn_wrap txt_center">
			<button type="button" class="btn normal blue mr10 btnProg"> <i class="far fa-save mr5"></i> 저장</button>
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
			<tbody>
			<c:forEach var="list" items="${progList}">
				<tr>
					<td>${list.progrsSttus }</td>
					<td>${empty list.rgstNm?list.rgstId:list.rgstNm }</td>
					<td>${list.rgstBrffc }</td>
					<td date>${list.rgstDt}</td>
					<td date>${list.progrsDe }</td>
					<td date>${list.rplyTmlmt }</td>
					<td>${list.progrsResn }</td>
				</tr>
			</c:forEach>
			<c:if test="${empty progList}">
				<tr>
					<td colspan="7">처리내역이 없습니다</td>
				</tr>
			</c:if>
			</tbody>
		</table>   
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
					${eo.jssfcAllAt eq 'Y'?'전체':'<strong>특정 직종</strong> : ' }
					<c:forEach var="list" items="${eo.jssfcVO }" varStatus="sts">
						${!sts.first?',':''} ${list.jssfcNm}
					</c:forEach>
				</td>
				<th scope="row">등급</th>
				<td>
					${eo.gradAllAt eq 'Y'?'전체':'<strong>특정 등급</strong> : ' }
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
					<strong>※특정 사업장</strong> 
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
						<strong>※특정 근로자</strong>
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
			<tr style="display:none">
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
				<th scope="row">구비서류</th>
				<td>
				<c:if test="${eo.se eq 'HCSE0001'}">
					<strong>※증명서 발급동의 추가 시</strong>
					<ol class="mb10 ml10">
						<li>1.보유증명서 발급 동의서(근로자 서명본) 1부</li>
						<li class="ml10"> - 동의일자 1개월 이내</li>
						<li>2. 신분증</li>
						<li style="list-style: disc;">서울시 독성물질 중독관리센터를 통해 사전에 건설근로자의 동의를 받은 경우에는 별도 첨부서류 없음</li>
					</ol>
					<strong>※기타 근로자 추가 시</strong>
					<ol class="ml10">
						<li style="list-style: disc;">건강보험 또는 국민연금 자격득실확인서 등 (발급 1개월 이내)</li>
					</ol>
				</c:if>
				<c:if test="${eo.se eq 'HCSE0002'}">
					<ol class="ml10">
						<li>1. 보유증명서 발급신청서(날인본) 1부</li>
					<c:if test="${eo.cl eq 'HCCL0001'}">
						<li>2. 도급계약서 1부</li>
					</c:if>
					<c:if test="${eo.cl eq 'HCCL0002'}">
						<li>2. 입찰참가신청서 1부</li>
					</c:if>
					</ol>
				</c:if>
				</td>
			</tr>
			<tr>
				<th scope="row">첨부파일</th>
				<td class="p10" id="fileLayer"></td>
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
				<td>${eo.sptSeNm }</td>
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
		<c:if test="${(!empty eo and !empty eo.progrsVO and eo.progrsVO.progrsSttus eq 'CAPG0009') or eo.sptSe eq 'SPTS0002'}">
			<button type="submit" class="btn normal blue mr10 btnRpt" data-title="건설근로자보유증명서"><i class="fas fa-check"></i> 발급</button>
		</c:if>
		<c:if test="${!empty eo and !empty eo.progrsVO and eo.progrsVO.progrsSttus ne 'CAPG0009'}">
			<a href="form.do" class="btn normal green mr10" id="btnUpd"><i class="far fa-edit mr5"></i> 수정</a>
		</c:if>
			<a href="list.do" class="btn normal black mr10" id="btnList"><i class="fas fa-list mr5"></i> 목록</a>
		</div>
	</div>
</body>
</html>
