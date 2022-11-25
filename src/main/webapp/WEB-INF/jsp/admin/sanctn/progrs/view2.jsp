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
			
			//결재/반려 클릭 이벤트 - 팝업오픈
			$('.btnPop').click(function(e){
				$('#frm [name="sanctnSttus"]').val($(this).text().trim() == '결재기안'?'APRV0002':'APRV0003');
				$('#frmPop [name="agncyNm"]').val('');
				$('#sanctnLayer .tbl_data').parent().hide();
				$('#sanctnLayer .btn_wrap').hide();
				
				cwma.showMask();
				$('#sanctnLayer').css('height', '170px');
		        $('#sanctnLayer').css("top",(($(window).height() - $('#sanctnLayer').outerHeight()) / 2) + $(window).scrollTop());
		        $('#sanctnLayer').css("left",(($(window).width() - $('#sanctnLayer').outerWidth()) / 2) + $(window).scrollLeft());
		        
				if($('.data_wrap .layerpop')[0]){
					$('#sanctnLayer').draggable();
					$('body').append($('.data_wrap .layerpop'));
				}

				$('#sanctnLayer').show();
		        
				e.preventDefault();
				return false;
			});
			
			//팝업닫기 버튼 클릭이벤트
			$('.layerpop_close, .btnClose').click(function(e){
				cwma.hideMask();
				$('#sanctnLayer').hide();
				
				e.preventDefault();
				return false;			
			});
			
			//팝업 - 검색버튼 클릭
			$('.btnAgncyMember').click(function(){
				$('#frmPop').ajaxCwma({
					success:function(res){
						var html = '';
						var height = 100;
						
						$(res.list).each(function(){
							html += '<tr>';
							html += '<td><input type="radio" name="sanctnId" value="'+this.userId+'" /></td>';
							html += '<td>'+this.brffcNm+'</td>';
							html += '<td>'+this.userName+'</td>';
							html += '<td>'+this.email+'</td>'
							html += '</tr>';
						});
						
						height = Math.min(res.list.length+1, 5) * 45 + 20;
						$('#sanctnLayer .tbl_data').parent().css('height', height+'px');
						$('#sanctnLayer').css('height', (height + 220)+'px');
				        $('#sanctnLayer').css("top",(($(window).height() - $('#sanctnLayer').outerHeight()) / 2) + $(window).scrollTop());
				        $('#sanctnLayer').css("left",(($(window).width() - $('#sanctnLayer').outerWidth()) / 2) + $(window).scrollLeft());
						
						$('#sanctnLayer .tbl_data').parent().show();
						$('#sanctnLayer .btn_wrap').show();
						$('#memberResult').html(html);
					}
				});
			});
			
			//팝업 - 엔터이벤트
			$('#frmPop').submit(function(e){
				$('.btnAgncyMember').click();
				e.preventDefault();
				return false;
			});
			
			//결재기안버튼 클릭
			$('.btnSubmit').click(function(e){
				if(!$('[name="sanctnId"]:checked').size()){
					alert('결재자를 선택해주세요');
					return false;
				}
				
				if(confirm(($('#frm [name="sanctnSttus"]').val() == 'APRV0002'?'결재기안':'반려') + '하시겠습니까?')){
					$('#frm [name="sanctnId"]').val($('#sanctnLayer [name="sanctnId"]:checked').val());
					$('#frm').attr('action', 'progrs.do');
					$('#frm').ajaxCwma({
						success:function(res){
							alert('처리 되었습니다');
							$('.fa-list').click();
						}
					});
				}
				
				e.preventDefault();
				return false;
			});
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
			<input type="hidden" name="sanctnId" value="">
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
						근로직종확인신청
					</td>
				</tr>
				</tbody>
			</table>				
						
			<table class="tbl tbl_search mt10">
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
				<c:if test='${empty sanctnStatus.sanctnSttus or "APRV0004" eq sanctnStatus.sanctnSttus or "APRV0001" eq sanctnStatus.sanctnSttus}'>
				<button type="button" class="btn normal blue mr10 btnPop"> <i class="far fa-edit mr5"></i> 결재기안</button>
				<button type="button" class="btn normal red mr10 btnPop"> <i class="far fa-edit mr5"></i> 반려</button>
				</c:if>
				<c:if test='${"APRV0002" eq sanctnStatus.sanctnSttus or "APRV0003" eq sanctnStatus.sanctnSttus }'>
				<button type="button" id="goForm3" onclick="goFrm('4', this)" class="btn normal wood mr10"> <i class="far fa-edit mr5"></i> 결제회수</button>
				</c:if>
				<c:if test='${"APRV0004" eq sanctnStatus.sanctnSttus }'>
				<button type="button" id="goForm4" onclick="goFrm('0', this)" class="btn normal red mr10"> <i class="far fa-edit mr5"></i> 회수취소</button>
				</c:if>
				<a href="list.do" class="btn normal black mr10"> <i class="fas fa-list mr5"></i> 목록</a>
			</div>
		</div>
		
		<div id="sanctnLayer" class="layerpop" style="width: 500px; height: 350px; display: none; position:absolute; z-index:99999">
			<div class="layerpop_area">
				<div class="title">결재자 선택</div>
				<a href="#" class="layerpop_close">
					<i class="far fa-window-close"></i>
				</a>
	
				<div class="pop_content">
					<form id="frmPop" action="../sanctnWait/selectAgncyMember.do" method="post">
						<input type="hidden" name="se" value="search" />
						<table class="tbl tbl_form">
							<colgroup>
								<col width="25%">
								<col>
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">결재자 성명</th>
									<td><input type="text" class="w100p" maxlength="30" title="결재자 성명" name="agncyNm" required></td>
								</tr>
							</tbody>
						</table>
						<div class="mt10 txt_center">
							<button type="button" class="btn normal blue btnAgncyMember">조회</button>
						</div>
					</form>
					
					<div style="height:100px;overflow-y: auto;">
						<table class="tbl tbl_data">
							<colgroup>
								<col style="width:10%">
								<col style="width:30%">
								<col>
								<col style="width:30%">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"><span>선택</span></th>
									<th scope="col"><span>지사/센터</span></th>
									<th scope="col"><span>결재자 성명</span></th>
									<th scope="col"><span>이메일</span></th>
								</tr>
							</thead>
							<tbody id="memberResult"></tbody>
						</table>
					</div>
					
					<div class="btn_wrap mb20" style="display:none">
						<div class="txt_center mt20">
							<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 결재기안</a>
							<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
						</div>
					</div>
	
				</div>
			</div>
		</div>
	</div>
	<!--container end-->
</body>
</html>
