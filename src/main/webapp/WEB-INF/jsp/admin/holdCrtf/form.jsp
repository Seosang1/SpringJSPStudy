<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
var uploader = null, uploader2 = null;
var cwmaList;

//초기화
$(function(){
	uploader = new CrossUploader({fileLayer:'fileDiv', parntsSe:'ATCH0014', parntsSn:$('[name="sn"]').val()});
	cwmaList = new cwma.list({pageLayer:$('.paging'), func:'cntrctAjax2'});
	$('[name="validDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date().add(30)));
	
	if($('[name="applcntBizno"]').val()){
		$($('[name="applcntBizno"]').val().split('-')).each(function(i){
			$('[name="applcntBizno'+(i+1)+'"]').val(this+'');
		});
	}
	
	if($('[name="bizno"]').val()){
		$($('[name="bizno"]').val().split('-')).each(function(i){
			$('[name="bizno'+(i+1)+'"]').val(this+'');
		});
	}
	
	$('.datepicker').datepicker('option', 'minDate', '+1D');
	$('.datepicker').datepicker('option', 'maxDate', '+3M');
});

//이벤트
$(function(){
	//수정버튼 이벤트
	$('#frm [type="submit"]').click(function(e){
		var txt = $(this).text();
		
		if($('[name="se"]:checked').val() == 'HCSE0002'){
			$('[name="jssfcAllAt"]:eq(0)').prop('checked', true);
			$('[name="gradAllAt"]:eq(0)').prop('checked', true);
			$('[name="labrrAllAt"]:eq(0)').prop('checked', true);
		}
		
		$('#frm').attr('action', $(this).attr('href'));
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				if($('[name="presentnOffic"]').val() == 'HCPO0004' && !$('[name="presentnOfficEtc"]').val()){
					alert('제출처를 입력해주세요');
					$('[name="presentnOfficEtc"]').focus();
					return false;
				}
				
				$('#frm [name^="fileVO["]').remove();
				if(!uploader.getTotalFileCount()){
					alert('첨부파일을 등록해주세요');
					return false;
					
				}else{
					isUploading = true;
					uploader.startUpload();
				}
				
				$('#frm [name^="cntrwkVO["]').remove();
				$('.constructionPlaceSelected [name="ddcJoinNo"]').each(function(i){
					$(this).attr('name', 'cntrwkVO['+i+'].ddcJoinNo');
					$(this).next().attr('name', 'cntrwkVO['+i+'].se');
				});
				
				$('#frm [name^="jssfcVO["]').remove();
				$('#frm [name="jssfcNo"]').not('.constructionWorkerSelected [name="jssfcNo"]').each(function(i){
					$(this).attr('name', 'jssfcVO['+i+'].jssfcNo');
				});
				
				$('#frm [name^="gradVO["]').remove();
				$('#frm [name="gradCd"]:checked').each(function(i){
					$('#frm').append('<input type="hidden" name="gradVO['+i+'].gradCd" value="'+$(this).val()+'" />"');
				});
				
				$('#frm [name^="labrrVO["]').remove();
				$('#frm [name="ihidnum"]').parent().each(function(i){
					$(this).find('input').each(function(){
						$(this).attr('name', 'labrrVO['+i+'].'+$(this).attr('name'));
					});
				});
				
				$('[name="tmprAt"]').val('N');
				
			}, success:function(res){
				alert(txt+'되었습니다');
				location.href='list.do';
				
			}, complete:function(){
				$('#frm [name^="cntrwkVO["], #frm [name^="jssfcVO["], #frm [name^="labrrVO["]').each(function(i){
					$(this).attr('name', $(this).attr('name').split('.')[1]);
				});
			}
		});
		e.preventDefault();
		return false;
	});
	
	//구분변경 이벤트
	$('[name="se"]:radio').on('change', function(){
		var str = '',  str1 = '';
		
		str += '<strong>※기본</strong>';
		str += '<ol class="mb10"><li>·보유증명서 발급신청서(날인본) 1부</li></ol>';
		str += '<strong>※기타 근로자 추가 시</strong>';
		str += '<ol><li>·건강보험 또는 국민연금 자격득실확인서 등 (발급 1개월 이내)</li></ol>';
		
		str1 += '<ol><li>1. 보유증명서 발급신청서</li>';
		str1 += '<li>2. 도급계약서 1부</li></ol>';
		
		$('[data-dstnrow]').hide();
		$('[data-dstnrow="'+$(this).val()+'"]').show();
		$('p.info').hide();
		$('#fileDiv').parent().prev().find('td').html(($(this).val() == 'HCSE0001'?str:str1));
		
		$('[name="bplcAllAt"]').prop('checked', false);
		
		if($(this).val() == 'HCSE0002'){
			$('[name="bplcAllAt"][value="N"]').prop('checked', true);
			$('[href="#constructionPlace"]').show();
		}else{
			$('[href="#constructionPlace"]').hide();
		}
		
		$('#frm [type="text"]').not('[name="feeSn"]').not('[name="fee"]').val('');
		$('#frm [type="checkbox"]').prop('checked', false);
		$('[name="bizno3"]').parent().parent().next().find('td').text('');
		$('[name="bizno3"]').parent().parent().next().next().find('td:eq(0)').text('');
		$('[name="bizno3"]').parent().parent().next().next().find('td:eq(1)').text('');
		$('[name="bizno"]').val('');
		$('[name="applcntBizno"]').val('');
		$('[name="applcntBizno1"]').val('');
		$('[name="applcntBizno2"]').val('');
		$('[name="applcntBizno3"]').val('');
	});

	//분류변경 이벤트
	$('[name="cl"]').on('change', function(){
		var str2 = '',  str1 = '';
		
		str1 += '<ol><li>1. 보유증명서 발급신청서</li>';
		str1 += '<li>2. 도급계약서 1부</li></ol>';
		str2 += '<ol><li>1. 보유증명서 발급신청서</li>';
		str2 += '<li>2. 입찰참가신청서 1부</li></ol>';
		
		if($(this).val() == 'HCCL0001')
			$('#fileDiv').parent().prev().find('td').html(str1);
		else
			$('#fileDiv').parent().prev().find('td').html(str2);
	});
	
	//사업자번호 엔터이벤트
	$('[name^="applcntBizno"]').on('keyup, keypress', function(e){
		if(e.keyCode == 13){
			$('.btnCorp:eq(0)').click();
			e.preventDefault();
			return false;
		}
	});
	
	//사업자번호 엔터이벤트
	$('[name^="bizno"]').on('keyup, keypress', function(e){
		if(e.keyCode == 13){
			$('.btnCorp:eq(1)').click();
			e.preventDefault();
			return false;
		}
	});
	
	//조회버튼클릭 이벤트
	$('.btnCorp').click(function(e){
		var obj = $(this);
		var chkNm = obj.prev().attr('name').replace(/[0-9]+/g, '');
		var eo;
		var chk = true;
		var data = {};
		
		$('[name^="'+chkNm+'"]').not('[name="'+chkNm+'"]').each(function(){
			if(!$(this).val()){
				alert($(this).attr('title')+'을(를) 입력해주세요');
				chk = false;
				return false;
			}
		});
		
		if(chk){
			$('[name="'+chkNm+'"]').val($('[name^="'+chkNm+'"]').not('[name="'+chkNm+'"]').get().map(function(o){return o.value;}).join('-'));
			data[chkNm] = $('[name="'+chkNm+'"]').val();
		}else
			return chk;
		
		$.ajax({
			url:'corpInfo.do',
			data:data,
			method:'post',
			success:function(res){
				if(chkNm == 'bizno' && !res.corpEo){
					alert('등록되지 않은 사업자번호 입니다');
					return false;
					
				}
				
				if(chkNm != 'bizno' && (($('[name="se"]:checked').val() == 'HCSE0002' && !res.dminsttEo) || ($('[name="se"]:checked').val() == 'HCSE0001' && !res.corpEo))){
					alert('등록되지 않은 사업자번호 입니다');
					return false;					
				}
				
				if(chkNm == 'bizno')
					eo = res.corpEo;
				else if($('[name="se"]:checked').val() == 'HCSE0001')
					eo = res.corpEo;
				else
					eo = res.dminsttEo;
				
				//신청정보
				obj.parent().parent().next().find('td').text(eo.corpNm?eo.corpNm:eo.dminsttNm);
				obj.parent().parent().next().next().find('td:eq(0)').text(eo.ceoNm?eo.ceoNm:'');
				obj.parent().parent().next().next().find('td:eq(1)').text(eo.telNo?eo.telNo:'');
				
				if(chkNm != 'bizno' && $('[name="se"]:checked').val() == 'HCSE0001'){
					$('[name="bizno1"]').val($('[name="applcntBizno1"]').val());
					$('[name="bizno2"]').val($('[name="applcntBizno2"]').val());
					$('[name="bizno3"]').val($('[name="applcntBizno3"]').val());
					$('[name="bizno"]').val($('[name="applcntBizno"]').val());
					$('[name="bizno3"]').parent().parent().next().find('td').text(eo.corpNm);
					$('[name="bizno3"]').parent().parent().next().next().find('td:eq(0)').text(eo.ceoNm?eo.ceoNm:'');
					$('[name="bizno3"]').parent().parent().next().next().find('td:eq(1)').text(eo.telNo?eo.telNo:'');
				}
				
				//발급동의팝업
				if(chkNm == 'bizno' || $('[name="se"]:checked').val() == 'HCSE0001'){
					$('#agreementAdd th:contains(사업자등록번호)').next().text($('[name="'+chkNm+'"]').val());
					$('#agreementAdd th:contains(기업명)').next().text(eo.corpNm);
					$('#agreementAdd th:contains(대표자)').next().text(eo.ceoNm?eo.ceoNm:'');
					$('#agreementAdd th:contains(전화번호)').next().text(eo.telNo?eo.telNo:'');
				}
				
				if($('[name="se"]:radio:checked').val() == 'HCSE0002' && $('[data-dstnrow="HCSE0001"]:visible')[0]){
					$('[data-dstnrow]').hide();
					$('[data-dstnrow="HCSE0002"]').show();
					$('#fileDiv').parent().prev().find('td').text(('도급계약서'));
				}
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	//직종라디오 변경
	$('[name="jssfcAllAt"]').click(function(){
		if($('[name="bizno"]').val()){
			if($(this).val() == 'N'){
				$('.jobList').show();
				$('[href="#constructionJob"]').show();
			}else{
				$('#constructionJob tbody th, td').attr('class', '')
				$('.jobList').val('');
				$('.jobList').hide();
				$('[href="#constructionJob"]').hide();
				$('#frm [name="jssfcNo"]').remove();
			}
			
			$('div.constructionWorkerSelected.cat01 table tbody').html('');
		}else{
			alert('사업자번호를 먼저 조회해주세요');
			return false;
		}
	});
	
	//직종선택팝업 직종클릭 이벤트
	$('#constructionJob tr > td:not(.disabled)').on('click', function(){
		$(this).prev().addBack().toggleClass('checked');
	});

	//직종선택팝업 추가버튼클릭 이벤트
	$('#constructionJob > div > div:last button:first').on('click', function(){
		var cCell = $('#constructionJob tr > td.checked');
		if(cCell.length){
			$('#frm [name="jssfcNo"]').remove();
			var list = new Array();
			cCell.each(function(){
				list.push($(this).text());
				$('#frm').append('<input type="hidden" name="jssfcNo" value="'+$(this).prev().text()+'" />');
			}).promise().done(function(){
				$(':text.jobList').val(list);
				$('#constructionJob .close').trigger('click');
				$('div.constructionWorkerSelected.cat01 table tbody').html('');
			});
		}else{
			alert('선택된 직종이 없습니다');
		}
	});

	//등급라디오 변경
	$('[name="gradAllAt"]').click(function(){
		if($('[name="bizno"]').val()){
			if($(this).val() == 'N'){
				$('[name="gradCd"]').parent().show();
				$(this).parent().find('a').show();
			}else{
				$('[name="gradCd"]').prop('checked', false);
				$('[name="gradCd"]').parent().hide();
				$(this).parent().find('a').hide();
			}
		}else{
			alert('사업자번호를 먼저 조회해주세요');
			return false;
		}
	});
	
	//등급라디오 클릭
	$('[name="gradCd"]').click(function(){
		if($('[name="gradCd"]:checked').size() == 4){
			alert('전체 등급을 선택하셨습니다.');
			$('[name="gradAllAt"]:eq(0)').click();
		}
	});
	
	//사업장라디오 변경
	$('[name="bplcAllAt"]').click(function(e){
		if($('[name="bizno"]').val()){
			var obj = $(this).parents('div:first').next();
			if($(this).val() == 'N'){
				obj.hide();
				$('[href="#constructionPlace"]').show();
			}else{
				if(!$('.constructionPlaceSelected tbody tr').size() || confirm($(this).data('alert'))){
					$('#constructionPlace form')[0].reset();
					$('.constructionPlaceSelected').hide();
					$('.constructionPlaceSelected tbody').html('');
					obj.show();
					$('[href="#constructionPlace"]').hide();
				}else{
					e.preventDefault();
					return false;
				}
			}
		}else{
			alert('사업자번호를 먼저 조회해주세요');
			return false;
		}
	});
	
	//사업장팝업 조회버튼클릭 이벤트
	$('.btnCntrct').click(function(e){
		cntrctAjax(1);
		e.preventDefault();
		return false;
	});
	
	//사업장 목록조회
	function cntrctAjax(pageNo){
		var frm = $('#cntrctFrm');
		frm.find('[name="pageNo"]').val(pageNo);
		frm.ajaxCwma({
			data:{bizno:$('[name="bizno"]').val()},
			success:function(res){
				var html = '';
				if(res && res.list && res.list.length){
					$(res.list).each(function(){
						html += '<tr>';
						html += '<td><input type="checkbox" name="ddcJoinNo" value="'+this.ddcJoinNo+'"><input type="hidden" name="se" value="'+(this.seNm == '퇴직공제'?'AGSE0001':this.seNm == '일용'?'AGSE0002':'AGSE0003')+'"></td>';
						html += '<td>'+(this.seNm.indexOf('퇴직')>=0?this.seNm:'고용보험('+this.seNm+')')+'</td>';
						html += '<td>'+this.cntrctNm+'</td>';
						html += '<td>'+(this.dminsttNm?this.dminsttNm:'')+'</td>';
						html += '<td>'+this.cnstwkLocplcAddr+'</td>';
						html += '</tr>';
					});
					
					if(res.list.length >= 10)
						$('.btnCntrct').parents('.layer').find('button:contains(보기)').show();
					else
						$('.btnCntrct').parents('.layer').find('button:contains(보기)').hide();
				}else{
					html += '<tr><td colspan="4">조회결과가 없습니다</td></tr>';
				}
				
				if(pageNo > 1){
					if(res && res.list && res.list.length)
						$('#cntrctResult').append(html);
				}else
					$('#cntrctResult').html(html);
				
				modalAlign();
			}
		});
	}
	
	//발급사업장 팝업 추가버튼 클릭 이벤트
	$('#constructionPlace > div > div:last button:first').on('click', function(){
		if($('#cntrctResult :checked').length){
			var tmp = $('#cntrctResult :checked').parents('tr').clone();
			tmp.find('td:first').hide().end().append('<td><button type="button" class="btn normal black">삭제</button></td>');
			
			tmp.each(function(){
				if($('div.constructionPlaceSelected tbody [name="ddcJoinNo"][value="'+$(this).find('[name="ddcJoinNo"]').val()+'"]').val())
					return true;
				else
					$('div.constructionPlaceSelected tbody').append(this);
			});
			
			$('div.constructionPlaceSelected').show();
			$('div.constructionWorkerSelected table tbody').html('');
		}else{
			alert('선택된 항목이 없습니다.');
		}
	});
	
	//근로자 선택시 validation
	function labrrValid(){
		if(!$('[name="bizno"]').val()){
			alert('사업자번호를 먼저 조회해주세요');
			return false;
		}else if(!$('[name="jssfcAllAt"]:checked').length || ($('[name="jssfcAllAt"]:checked').val() != 'Y' && !$('.jobList').val().length)){
			alert('직종을 선택해주세요');
			return false;
		}else if(!$('[name="gradAllAt"]:checked').length || ($('[name="gradAllAt"]:checked').val() != 'Y' && !$('[name="gradCd"]:checked').length)){
			alert('등급을 선택해주세요');
			return false;
		}else if(!$('[name="bplcAllAt"]:checked').length || ($('[name="bplcAllAt"]:checked').val() != 'Y' && !$('.constructionPlaceSelected tbody tr').length)){
			alert('사업장을 선택해주세요');
			return false;
		}else
			return true;
	}
	
	//근로자라디오 변경
	$('[name="labrrAllAt"]').click(function(e){
		if(!labrrValid()){
			return false;
		}else{
			if($(this).val() == 'Y')
				if(!$('.constructionWorkerSelected tbody tr').size() || confirm($(this).data('alert'))){
					$(this).parent().parent().find('a').hide();
					$('.constructionWorkerSelected').hide();
					$('.constructionWorkerSelected tbody').html('');
					$('[name="labrrAllAt"]').parents('div:first').siblings('p.info').show();
				}else{
					e.preventDefault();
					return false;
				}
			else{
				$(this).parent().parent().find('a').show();
					$('[name="labrrAllAt"]').parents('div:first').siblings('p.info').hide();
			}
			
		}
	});
	
	//근로자팝업 조회버튼클릭 이벤트
	$('.btnLabrr').click(function(e){
		labrrAjax(1);
		e.preventDefault();
		return false;
	});
	
	//근로자 목록조회
	function labrrAjax(pageNo){
		var frm = $('[action="labrrInfoList.do"]');
		frm.find('[name="pageNo"]').val(pageNo);
		frm.ajaxCwma({
			data:{bizno:$('[name="bizno"]').val()},
			beforeSubmit:function(){
				if(!labrrValid())
					return false;
				
				if(!$('[action="labrrInfoList.do"] :text').get().map(function(o){return o.value}).join('')){
					alert('검색어를 입력해주세요');
					return false;
				}
				
				if(frm.find('[name="ihidnum1"]').val() || frm.find('[name="ihidnum2"]').val()){
					if((frm.find('[name="ihidnum1"]').val()+frm.find('[name="ihidnum2"]').val()).length == 13)
						frm.find('[name="ihidnum"]').val(frm.find('[name="ihidnum1"]').val()+'-'+frm.find('[name="ihidnum2"]').val());
					
					else{
						frm.find('[name="ihidnum"]').val('');
						
						if(frm.find('[name="ihidnum1"]').val().length < 6){
							alert('주민번호를 앞자리를 입력해주세요');
							frm.find('[name="ihidnum1"]').focus();
							return false;
							
						}else if(frm.find('[name="ihidnum2"]').val().length < 7){
							alert('주민번호를 뒷자리를 입력해주세요');
							frm.find('[name="ihidnum2"]').focus();
							return false;
						}
					}
				}
				
				frm.find('[name^="gradVO["]').remove();
				$('[name="gradCd"]:checked').each(function(i){
					frm.append('<input type="hidden" name="gradVO['+i+'].gradCd" value="'+this.value+'">');
				});
				
				frm.find('[name^="cntrwkVO["]').remove();
				$('.constructionPlaceSelected [name="ddcJoinNo"]').each(function(i){
					frm.append('<input type="hidden" name="cntrwkVO['+i+'].ddcJoinNo" value="'+this.value+'">');
				});
				
				frm.find('[name^="jssfcVO["]').remove();
				$('#frm [name="jssfcNo"]').not('.constructionWorkerSelected [name="jssfcNo"]').each(function(i){
					frm.append('<input type="hidden" name="jssfcVO['+i+'].jssfcNo" value="'+this.value+'">');
				});
				
				return true;
			},
			success:function(res){
				var html = '';
				if(res && res.list && res.list.length){
					$(res.list).each(function(){
						html += '<tr>';
						html += '<td><input type="checkbox" name="ihidnum" value="'+this.ihidnum+'">';
						html += '<input type="hidden" name="jssfcNo" value="'+this.jssfcNo+'">';
						html += '<input type="hidden" name="se" value="HCLS0001">';
						html += '<input type="hidden" name="ddcJoinNo" value="'+this.ddcJoinNo+'">';
						html += '<input type="hidden" name="cl" value="'+(this.se == '상용'?'HCLC0002':'HCLC0001')+'">';
						html += '</td>';
						html += '<td>'+(this.se == '상용'?'고용보험(상용)':'발급동의')+'</td>';
						html += '<td>'+this.cntrctNm+'</td>';
						html += '<td>'+this.nm+'</td>';
						html += '<td>'+this.ihidnum+'</td>';
						html += '<td>'+this.jssfcNm+'</td>';
						html += '</tr>';
					});
					
					if(res.list.length >= 10)
						$('.btnLabrr').parents('.layer').find('button:contains(보기)').show();
					else
						$('.btnLabrr').parents('.layer').find('button:contains(보기)').hide();
				}else{
					html += '<tr><td colspan="6">조회결과가 없습니다</td></tr>';
				}
				
				if(pageNo > 1){
					if(res && res.list && res.list.length)
						$('#labrrResult').append(html);
				}else
					$('#labrrResult').html(html);
				
				modalAlign();
			}
		});
	}
	
	//근로자팝업 추가버튼클릭 이벤트
	$('#constructionWorker > div > div:last button:first').on('click', function(){
		if($('#labrrResult :checked').length){
			var tmp = $('#labrrResult :checked').parents('tr').clone();
			tmp.find('td:first').hide().end().append('<td><button type="button" class="btn normal black">삭제</button></td>');
			
			tmp.each(function(){
				if($('div.constructionWorkerSelected.cat01 table tbody [name="ihidnum"][value="'+$(this).find('[name="ihidnum"]').val()+'"]').val())
					return true;
				else
					$('div.constructionWorkerSelected.cat01 table tbody').append(this);
			});
			
			$('div.constructionWorkerSelected.cat01').show();
		}else{
			alert('선택된 항목이 없습니다.');
		}
	});
	
	//발급정보 라디오 변경 이벤트
	$('[name="jssfcAllAt"], [name="gradAllAt"], [name="gradCd"], [name="bplcAllAt"]').change(function(){
		$('div.constructionWorkerSelected.cat01 table tbody').html('');
	});
	
	//발급동의팝업 엔터이벤트
	$('#agreementAdd input').keyup(function(e){
		if(e.keyCode == 13)
			$('.btnAgre').click();	
			
		e.preventDefault();
	})
	
	//발급동의팝업 - 조회버튼클릭 이벤트
	$('.btnAgre').click(function(e){
		var frm = $(this).form();
		var gradChk = false;
		
		frm.attr('action', 'issuAgreInfo.do');
		frm.ajaxCwma({
			beforeValid:false,
			beforeSubmit:function(){
				if(!frm.find('[name="ihidnum1"]').val()){
					alert('주민번호 앞자리를 입력해주세요');
					frm.find('[name="ihidnum1"]').focus();
					return false;
				}else if(!frm.find('[name="ihidnum2"]').val()){
					alert('주민번호 뒷자리를 입력해주세요');
					frm.find('[name="ihidnum2"]').focus();
					return false;					
				}
				
				frm.find('[name="ihidnum"]').val(frm.find('[name="ihidnum1"]').val()+'-'+frm.find('[name="ihidnum2"]').val());
				
				frm.find('[name^="searchList"]').remove();
				$('#frm [name="jssfcNo"]').not('.constructionWorkerSelected [name="jssfcNo"]').each(function(i){
					frm.append('<input type="hidden" name="searchList['+i+'].jssfcNo" value="'+this.value+'" />');
				});
			},success:function(res){
				if(res && res.eo){
					if(res.eo.ddcJoinNo){
						alert('발급동의한 공사가 존재합니다.');
						$('[name="selectJssfcNo"]').html('');
						$('[data-node="name"]').text('');
					}else if(!res.jssfcList || !res.jssfcList.length){
						alert('발급직종의 발급동의할 근로내역이 없습니다.');
						$('[name="selectJssfcNo"]').html('');
						$('[data-node="name"]').text('');
					}else{
						$('[name="selectJssfcNo"]').html('');
						$(res.jssfcList).each(function(){
							$('[name="selectJssfcNo"]').append('<option value="'+this.jssfcNo+'">'+this.jssfcNm+'</option>');
						});
						
						$('#agreementAdd [data-node="name"]').text(res.eo.nm);
					}
				}else{
					alert('근로자 데이터가 존재하지 않습니다');
					$('[name="selectJssfcNo"]').html('');
					$('[data-node="name"]').text('');
				}
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	//증명서 발급동의팝업 -> 공사팝업 -> 엔터이벤트
	$('#cntrctFrm2 input').keyup(function(e){
		if(e.keyCode == 13)
			$('.btnCntrct2').click();
		
		e.preventDefault();
		return false;
	});
	
	//증명서 발급동의팝업 -> 공사팝업 -> 조회버튼클릭 이벤트
	$('.btnCntrct2').click(function(e){
		cntrctAjax2(1);
		e.preventDefault();
		return false;
	});
	
	//증명서 발급동의팝업 -> 공사명검색 팝업 -> 공사명버튼 클릭 이벤트
	$('#cntrctResult2').on('click', 'button', function(){
		$('a[href="#construction"]').next().val($(this).text());
		$('#agreFrm [name="ddcJoinNo"]').val($(this).data('id'));
		$('#agreFrm [name="cntrwkSe"]').val($(this).data('se'));
		$('#construction .close').trigger('click');
	});

	//증명서 발급동의팝업 - 계속등록, 등록버튼 클릭 이벤트
	$('#agreementAdd div.txt_center button:not(:last)').on('click', function(e){
		var obj = $('div.constructionWorkerSelected.cat02 tbody');
		var frm = $(this).form();
		var txt = $(this).text();
		var html = '';
		
		frm.attr('action', '../issuAgre/insertIssuAgre.do');
		frm.ajaxCwma({
			beforeSubmit:function(){
				if(!uploader2.getTotalFileCount()){
					alert('첨부파일을 등록해주세요');
					return false;
					
				}else{
					isUploading = true;
					uploader2.startUpload();
				}
			},success:function(){
				html += '<tr>';
				html += '<td style="display: none;">';
				html += '<input type="hidden" name="ihidnum" value="'+frm.find('[name="ihidnum"]').val()+'">';
				html += '<input type="hidden" name="jssfcNo" value="'+frm.find('[name="selectJssfcNo"]').val()+'">';
				html += '<input type="hidden" name="se" value="HCLS0002">';
				html += '<input type="hidden" name="ddcJoinNo" value="'+frm.find('[name="ddcJoinNo"]').val()+'">';
				html += '<input type="hidden" name="cl" value="HCLC0001">';
				html += '</td>';
				html += '<td>발급동의</td>';
				html += '<td>'+frm.find('td[data-node="cName"] input').val()+'</td>';
				html += '<td>'+frm.find('td[data-node="name"]').text()+'</td>';
				html += '<td>'+frm.find('[name="ihidnum"]').val()+'</td>';
				html += '<td>'+frm.find('[name="selectJssfcNo"] option:selected').text()+'</td>';
				html += '<td><button type="button" class="btn normal black">삭제</button></td>';
				html += '</tr>';
				obj.html(html);
				
				$('div.constructionWorkerSelected.cat02').show();

				frm[0].reset();
				frm.find('[name="selectJssfcNo"]').html('');
				frm.find('td[data-node="name"]').text('');
				$('[name="validDt"]').val($.datepicker.formatDate('yy-mm-dd', new Date().add(30)));
				uploader2.deleteAllFiles()
				
				if(txt == '등록')
					$('#agreementAdd .close:contains(취소)').trigger('click');
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	//기타근로자팝업 엔터이벤트
	$('#etcFrm input').keyup(function(e){
		if(e.keyCode == 13)
			$('.btnEtc').click();
		
		e.preventDefault();
		return false;
	});
	
	//기타근로자팝업 - 조회버튼클릭 이벤트
	$('.btnEtc').click(function(e){
		var frm = $(this).form();
		
		frm.attr('action', 'issuAgreInfo.do');
		frm.ajaxCwma({
			beforeSubmit:function(){
				frm.find('[name="ihidnum"]').val(frm.find('[name="ihidnum1"]').val()+'-'+frm.find('[name="ihidnum2"]').val());
			},success:function(res){
				if(res && res.eo){
					if(res.eo.ddcJoinNo){
						alert('발급동의한 공사가 존재합니다.');
						$('#etcFrm [data-node="name"]').text('');
						
					}else{
						$('#etcFrm [data-node="name"]').text(res.eo.nm);
					}
				}else{
					alert('근로자 데이터가 존재하지 않습니다');
					$('#etcFrm [data-node="name"]').text('');
				}
			}
		});
		
		e.preventDefault();
		return false;
	});

	//기타근로자팝업 - 계속등록, 등록버튼 클릭 이벤트
	$('#etcAdd div.txt_center button:not(:last)').on('click', function(e){
		var obj = $('div.constructionWorkerSelected.cat03 tbody');
		var frm = $(this).form();
		var txt = $(this).text();
		var chk = true;
		
		frm.find('[required]').each(function(){
		    if(!$(this).val()){
		        alert($(this).attr('title')+'을(를)입력해주세요');
		        $(this).focus();
		        chk = false;
		        return false;
		    }
		});
		
		if(chk){
			obj.append('<tr>');
			obj.append('<td style="display: none;">');
			obj.append('<input type="hidden" name="ihidnum" value="'+frm.find('[name="ihidnum"]').val()+'">');
			obj.append('<input type="hidden" name="jssfcNo" value="'+frm.find('[name="jssfcNo"]').val()+'">');
			obj.append('<input type="hidden" name="se" value="HCLS0003">');
			obj.append('<input type="hidden" name="cl" value="HCLC0003">');
			obj.append('</td>');
			obj.append('<td>기타</td>');
			obj.append('<td>'+frm.find('td[data-node="name"]').text()+'</td>');
			obj.append('<td>'+frm.find('[name="ihidnum"]').val()+'</td>');
			obj.append('<td>'+frm.find('[name="jssfcNo"] option:selected').text()+'</td>');
			obj.append('<td><button type="button" class="btn normal black">삭제</button></td>');
			obj.append('</tr>');
			$('div.constructionWorkerSelected.cat03').show();

			frm[0].reset();
			frm.find('[name="jssfcNo"]').val(1);
			frm.find('td[data-node="name"]').text('');
			
			if(txt == '등록')
				$('#etcAdd .close:contains(취소)').trigger('click');
		}
		
		e.preventDefault();
		return false;
	});

	//삭제버튼 이벤트
	$('div.tableWrap').on('click', 'td button', function(){
		if(0 == $(this).parents('tr:first').siblings().length)
			$(this).parents('div.tableWrap').hide();
		
		if($(this).parents('.constructionPlaceSelected')[0])
			$('[value="'+$(this).parents('tr:first').find('[name="ddcJoinNo"]').val()+'"]').parent().parent().remove();
		
		$(this).parents('tr:first').remove();
	});
	
	//팝업버튼 클릭 이벤트
	var back = $('div.pageDisabled');
	$('.openLayer').on('click', function(e){
		if($('[name="bizno"]').val()){
			var indexCnt = parseInt(back.css('z-index'));
			
			if(back.not(':visible'))
				back.show();
	
			$($(this).attr('href')).css({zIndex : indexCnt + 3}).find('.modal tbody').html('').end().find('button:contains(보기)').hide().end().show();
			
			if($('div.layer').is(':visible'))
				back.css('z-index', indexCnt + 2);
			
			if($(this).attr('href') == '#agreementAdd' && !uploader2)
				uploader2 = new CrossUploader({fileLayer:'agreFileDiv'});
			
			modalAlign();
		}else{
			alert('사업자번호를 먼저 조회해주세요')
		}
	});

	//팝업레이어 닫기
	$(document).on('click', 'div.layer .close', function(e){
		$(this).parents('div.layer:first').hide();
		if(!$('div.layer').is(':visible')){
			back.hide();
		}else{
			back.css('z-index', back.css('z-index') - 2);
		}
		e.preventDefault();
	});

	//팝업 조회버튼 클릭 이벤트
	$('.layer input').on('keyup, keypress', function(e){
		if(e.keyCode == 13){
			$(this).form().find('button:contains(조회)').click();
			e.preventDefault();
			return false;
		}
	});
	
	//팝업 더보기 버튼 클릭 이벤트
	$('.layer button:contains(보기)').click(function(e){
		var pageNo = $(this).parents('.layer').find('form').find('[name="pageNo"]');
		pageNo.val(Number(pageNo.val())+1);
		
		if($(this).parents('.layer').find('button:contains(조회)').hasClass('btnCntrct'))
			cntrctAjax(pageNo.val());
		else if($(this).parents('.layer').find('button:contains(조회)').hasClass('btnLabrr'))
			labrrAjax(pageNo.val());
		
		e.preventDefault();
		return false;
	});
	
	//제출처 변경 이벤트
	$('[name="presentnOffic"]').change(function(){
		$('[name="presentnOfficEtc"]').val('');
		
		if($(this).val() == 'HCPO0004')
			$('[name="presentnOfficEtc"]').show();
		else
			$('[name="presentnOfficEtc"]').hide();
	});
	
	//신청서출력버튼 클릭
	$('.btnRpt').click(function(e){
		if($('[name="se"]:checked').val() == 'HCSE0002'){
			$('[name="jssfcAllAt"]:eq(0)').prop('checked', true);
			$('[name="gradAllAt"]:eq(0)').prop('checked', true);
			$('[name="labrrAllAt"]:eq(0)').prop('checked', true);
		}
		
		$('#frm').attr('action', 'insert.do');
		$('#frm').ajaxCwma({
			beforeSubmit:function(){
				if($('[name="presentnOffic"]').val() == 'HCPO0004' && !$('[name="presentnOfficEtc"]').val()){
					alert('제출처를 입력해주세요');
					$('[name="presentnOfficEtc"]').focus();
					return false;
				}
				
				if(labrrValid()){
					if($('[name="se"]').val() == 'HCSE0001' && (!$('[name="labrrAllAt"]:checked').length || ($('[name="labrrAllAt"]:checked').val() != 'Y' && !$('.constructionWorkerSelected tbody tr').size()))){
						alert('근로자를 선택해주세요');
						return false;
					}
				}else
					return false;
				
				$('#frm [name^="cntrwkVO["]').remove();
				$('.constructionPlaceSelected [name="ddcJoinNo"]').each(function(i){
					$(this).attr('name', 'cntrwkVO['+i+'].ddcJoinNo');
					$(this).next().attr('name', 'cntrwkVO['+i+'].se');
				});
				
				$('#frm [name^="jssfcVO["]').remove();
				$('#frm [name="jssfcNo"]').not('.constructionWorkerSelected [name="jssfcNo"]').each(function(i){
					$(this).attr('name', 'jssfcVO['+i+'].jssfcNo');
				});
				
				$('#frm [name^="gradVO["]').remove();
				$('#frm [name="gradCd"]:checked').each(function(i){
					$('#frm').append('<input type="hidden" name="gradVO['+i+'].gradCd" value="'+$(this).val()+'" />"');
				});
				
				$('#frm [name^="labrrVO["]').remove();
				$('#frm [name="ihidnum"]').parent().each(function(i){
					$(this).find('input').each(function(){
						$(this).attr('name', 'labrrVO['+i+'].'+$(this).attr('name'));
					});
				});
				
				$('[name="tmprAt"]').val('Y');
			}, success:function(res){
				var top = screen.height/2 - 680/2;
				var left = screen.width/2 - 900/2;
				var option = 'width = 900px , height = 680px , top = ' + top + 'px , left = 0' + left + ', toolbar = no, menubar = no, location = no, directories = no, resizable = no, scrollbars = yes, status = no';
				
				window.name ="CWMA_SKILL_WINDOW";
				window.open('', 'holdCrtpRptPop', option);
				
				$('#rptFrm [name="sn"]').val(res.vo.sn);
				$('#frm [name="sn"]').val(res.vo.sn);
				$('#rptFrm').attr('action', 'rptPop.do');
				$('#rptFrm').attr('target', 'holdCrtpRptPop');
				$('#rptFrm').submit();
				
			}, complete:function(){
				$('#frm [name^="cntrwkVO["], #frm [name^="jssfcVO["], #frm [name^="labrrVO["]').each(function(i){
					$(this).attr('name', $(this).attr('name').split('.')[1]);
				});
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	if($('[name="applcntBizno"]').val())
		$('.btnCorp:eq(0)').click();
	
	if($('[name="bizno"]').val())
		$('.btnCorp:eq(1)').click();
	
	/* 태블릿 서명 */
	$("#btnPrint").click(function(e){
		e.preventDefault();
		$('#frm').attr('action', 'holdCrtfPreViewSave.do');
		$('#frm').ajaxCwma({
			beforeSubmit:function(){

			},success:function(res){
				alert("ok");
				return;
				$("[name=reqstNo]").val(res.reqstNo);
				window.open("", "preView","status=no,scrollbars=yes,resizable=no,top=100,left=100,width=900,height=680");
				$('#frm').attr('action', 'holdCrtfPreViewReportPop.do');
				$('#frm').attr('target', 'preView');
				$('#frm').submit();
				$('#frm').attr('target', '');
				$("[name=reqstNo]").val("");
			}
		});
		
	});
	
	$('[name="se"]:eq(0)').change();
});

function modalAlign(){
	$('div.layer').each(function(){
		$(this).css({
			marginTop : -($(this).outerHeight() / 2),
			marginLeft : -($(this).outerWidth() / 2)
		});
	});
}

//증명서 발급동의팝업 -> 공사명검색 팝업 -> 공사목록조회
function cntrctAjax2(pageNo){
	var frm = $('#cntrctFrm2');
	frm.find('[name="pageNo"]').val(pageNo);
	frm.ajaxCwma({
		data:{bizno:$('[name="bizno"]').val()},
		beforeSubmit:function(){
			frm.find('[name="ddcJoinNoList"]').remove();
			$('.constructionPlaceSelected [name="ddcJoinNo"]').each(function(){
				frm.append('<input type="hidden" name="ddcJoinNoList" value="'+this.value+'" />');
			});
		},
		success:function(res){
			var html = '';
			if(res && res.list && res.list.length){
				$(res.list).each(function(){
					html += '<tr>';
					html += '<td>'+this.rownum+'</td>';
					html += '<td>'+(this.seNm.indexOf('퇴직')>=0?this.seNm:'고용보험('+this.seNm+')')+'</td>';
					html += '<td><button type="button" data-id="'+this.ddcJoinNo+'" data-se='+(this.seNm == '퇴직공제'?'AGSE0001':this.seNm == '일용'?'AGSE0002':'AGSE0003')+'>'+this.cntrctNm+'</button></td>';
					html += '</tr>';
				});
				
			}else{
				html += '<tr><td colspan="3">조회결과가 없습니다</td></tr>';
			}
			
			$('#cntrctResult2').html(html);
			cwmaList.setPage(res.vo);
			modalAlign();
		}
	});
}

onCloseMonitorWindowCu = function(){
	if(uploader.getUploadStatus() == 'COMPLETION'){
		// 업로드된 전체 파일의 정보를 가져옵니다.
		var uploadedFilesInfo = uploader.getUploadedFilesInfo();
		var obj = jQuery.parseJSON(uploadedFilesInfo);
		
		if(obj){
			$(obj).each(function(i){
				for(var key in this){
					$('#frm').append('<input type="hidden" name="fileVO['+i+'].'+key+'" value="'+this[key]+'" />');
				}
			});
		}
		
		isUploading = false;
	}
	
	if(uploader2.getUploadStatus() == 'COMPLETION'){
		// 업로드된 전체 파일의 정보를 가져옵니다.
		var uploadedFilesInfo = uploader2.getUploadedFilesInfo();
		var obj = jQuery.parseJSON(uploadedFilesInfo);
		
		if(obj){
			$(obj).each(function(i){
				for(var key in this){
					$('#agreFrm').append('<input type="hidden" name="fileVO['+i+'].'+key+'" value="'+this[key]+'" />');
				}
			});
		}
		
		isUploading = false;
	}
}

// 예외 발생 시 호출됩니다.
var onExceptionCu = function(){
    var exceptionInfo = uploader.getLastExceptionInfo();
    var obj = jQuery.parseJSON(exceptionInfo);
    
    alert('[예외 정보]\n' + 'code : ' + obj.code + '\n' + 'message : ' + obj.message + '\n' + 'detailMessage : ' + obj.detailMessage);
}
</script>
</head>
<body>
	<form action="" method="post" id="rptFrm">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="title" value="건설근로자보유증명서발급신청서sign" />
	</form>
	
	<form action="" method="post" id="frm">
		<input type="hidden" name="sn" value="${empty eo?0:eo.sn}" />
		<input type="hidden" name="bizno" value="${eo.bizno}" />
		<input type="hidden" name="applcntBizno" value="${eo.applcntBizno}" />
		<input type="hidden" name="gradCdList" value="<c:forEach var="ceo" items="${eo.gradVO}" varStatus="sts">${ceo.gradCd}${!sts.last?',':''}</c:forEach>" />
		<input type="hidden" name="feeSn" value="${fee.sn }" />
		<input type="hidden" name="sptSe" value="SPTS0002" />
		<input type="hidden" name="recptSe" value="PRNT0002" />
		<input type="hidden" name="tmprAt" value="N" />

		<table class="tbl tbl_search mt20">
			<colgroup>
				<col style="width: 100%;">
			</colgroup>
			<thead>
				<tr>
					<th><i class="fas fa-th-large mr10"></i> 신청인정보</th>
				</tr>
			</thead>
		</table>
		
		<table class="tbl tbl_form mt5">
			<colgroup>
				<col style="width: 12%;">
				<col style="width: 38%;">
				<col style="width: 12%;">
				<col style="width: 38%;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">구분</th>
					<td colspan="3">
					<c:forEach var="ceo" items="${seList}" varStatus="sts">
						<label><input type="radio" name="se" value="${ceo.cdId}" ${ceo.cdId eq eo.se or sts.first?'checked':''}>${ceo.cdNm}</label>
					</c:forEach>
					<select name="cl" title="발주자" data-dstnrow="HCSE0002" style="display: none;">
					<c:forEach var="ceo" items="${clList}">
						<option value="${ceo.cdId}" ${ceo.cdId eq eo.cl?'selected':''}>${ceo.cdNm}</option>
					</c:forEach>
					</select>
					</td>
				</tr>
				<tr>
					<th scope="row">사업자등록번호(고유번호)</th>
					<td colspan="3">
						<input type="text" name="applcntBizno1" title="사업자등록번호 앞 자리" maxlength="3" hasnext number required value=""> -
						<input type="text" name="applcntBizno2" title="사업자등록번호 가운데 자리" maxlength="2" hasnext number required value=""> -
						<input type="text" name="applcntBizno3" title="사업자등록번호 뒷 자리" maxlength="5" required number value="">
						<button type="button" class="btn normal black btnCorp">조회</button>
					</td>
				</tr>
				<tr>
					<th scope="row">상호 또는 기관명</th>
					<td colspan="3"></td>
				</tr>
				<tr>
					<th scope="row">대표자</th>
					<td></td>
					<th scope="row">전화번호</th>
					<td></td>
				</tr>
			</tbody>
		</table>
		
		<table class="tbl tbl_search mt20">
			<colgroup>
				<col style="width: 100%;">
			</colgroup>
			<thead>
				<tr>
					<th><i class="fas fa-th-large mr10"></i> 신청사항</th>
				</tr>
			</thead>
		</table>
		
		<table class="tbl tbl_form mt5">
			<colgroup>
				<col style="width: 12%;">
				<col style="width: 38%;">
				<col style="width: 12%;">
				<col style="width: 38%;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">사업자등록번호(고유번호)</th>
					<td colspan="3">
						<input type="text" name="bizno1" title="사업자등록번호 앞 자리" maxlength="3" hasnext required number value=""> -
						<input type="text" name="bizno2" title="사업자등록번호 가운데 자리" maxlength="2" hasnext required number value=""> -
						<input type="text" name="bizno3" title="사업자등록번호 뒷 자리" maxlength="5" required number value="">
						<button type="button" class="btn normal black btnCorp">조회</button>
					</td>
				</tr>
				<tr>
					<th scope="row">상호 또는 기관명</th>
					<td colspan="3"></td>
				</tr>
				<tr>
					<th scope="row">대표자</th>
					<td></td>
					<th scope="row">전화번호</th>
					<td></td>
				</tr>
			</tbody>
		</table>

		<table class="tbl tbl_search mt10">
			<colgroup>
				<col style="width: 100%;">
			</colgroup>
			<thead>
				<tr>
					<th><i class="fas fa-th-large mr10"></i> 발급정보</th>
				</tr>
			</thead>
		</table>
		<table class="tbl tbl_form mt5">
			<colgroup>
				<col style="width: 12%;">
				<col style="width: 88%;">
			</colgroup>
			<tbody>
				<tr data-dstnrow="HCSE0001" style="">
					<th scope="row">직종</th>
					<td style="padding:10px;">
						<label style="width: 10%"><input type="radio" name="jssfcAllAt" ${eo.jssfcAllAt eq 'Y'?'checked':'' } value="Y" required title="직종"> 전체 직종</label>
						<label><input type="radio" name="jssfcAllAt" ${eo.jssfcAllAt eq 'N'?'checked':'' } value="N" required title="직종"> 특정 직종</label>
						<p style="margin-top:5px;">
							<a href="#constructionJob" class="openLayer confirm btn normal black ml10" ${eo.jssfcAllAt eq 'N'?'':'style="display:none"'}> 특정 직종 조회</a>
							<input type="text" name="" title="직종" readonly="readonly" placeholder="조회 버튼을 클릭하여 직종을 선택해주세요." class="jobList" ${eo.jssfcAllAt eq 'N'?'':'style="display:none"'}
							value="<c:forEach var="list" items="${eo.jssfcVO}" varStatus="sts">${!sts.first?',':''}${list.jssfcNm}</c:forEach>"
							/>
							<c:forEach var="list" items="${eo.jssfcVO}">
								<input type="hidden" name="jssfcNo" value="${list.jssfcNo}" / >
							</c:forEach>
						</p>
					</td>
				</tr>
				<tr data-dstnrow="HCSE0001" style="">
					<th scope="row">등급</th>
					<td class="checkGrade">
						<label style="width: 10%"><input type="radio" name="gradAllAt" ${eo.gradAllAt eq 'Y'?'checked':'' } value="Y" required title="등급"> 전체 등급</label>
						<label><input type="radio" name="gradAllAt" ${eo.gradAllAt eq 'N'?'checked':'' } value="N" required title="등급"> 특정 등급</label>
					<c:forEach var="ceo" items="${gradList}">
						<label ${eo.gradAllAt eq 'N'?'':'style="display:none"'}><input type="checkbox" name="gradCd" value="${ceo.cdId}" <c:forEach var="list" items="${eo.gradVO}">${list.gradCd eq ceo.cdId?'checked':''}</c:forEach>>${ceo.cdNm}</label>
					</c:forEach>
					</td>
				</tr>
				<tr>
					<th scope="row">사업장</th>
					<td class="p10">
						<div>
							<label data-dstnrow="HCSE0001" style="width: 10%"><input type="radio" name="bplcAllAt" ${eo.bplcAllAt eq 'Y'?'checked':'' } value="Y" required title="사업장" data-place="true" data-alert="선택하신 사업장 및 근로자 항목이 모두 초기화되며 모든 공사가 선택됩니다. 계속 진행하시겠습니까?"> 전체 사업장</label>
							<label data-dstnrow="HCSE0001"><input type="radio" name="bplcAllAt" ${eo.bplcAllAt eq 'N'?'checked':'' } value="N" required title="사업장" /> 특정 사업장</label>
							<a href="#constructionPlace" class="openLayer confirm btn normal black ml10" ${eo.bplcAllAt eq 'N'?'':'style="display:none"'}> 특정 사업장 조회</a>
						</div>

						<p class="info">모든 공사의 발급대상 근로자를 출력할 수 있습니다. 발급대상 근로자를 선택해주세요.</p>

						<div class="tableWrap constructionPlaceSelected mt10" ${eo.bplcAllAt eq 'N'?'style="display:block"':''}>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width:10%">
										<col style="width:35%">
										<col style="width:15%">
										<col style="width:33%">
										<col style="width:7%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">
												<span>고용형태</span>
											</th>
											<th scope="col">
												<span>공사명</span>
											</th>
											<th scope="col">
												<span>주소</span>
											</th>
											<th scope="col">
												<span>발주자</span>
											</th>
											<th scope="col">
												<span>삭제</span>
											</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.cntrwkVO}">
										<tr>
											<td style="display:none">
												<input type="hidden" name="ddcJoinNo" value="${list.ddcJoinNo}">
												<input type="hidden" name="se" value="${list.se}">
											</td>
											<td>${list.se eq 'AGSE0001'?list.seNm:'고용보험('.concat(list.seNm).concat(')')}</td>
											<td>${list.cntrctNm}</td>
											<td>${list.adrs}</td>
											<td><button type="button" class="btn normal black">삭제</button></td>
										</tr>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
					</td>
				</tr>
				<tr>
					<th scope="row">근로자</th>
					<td class="p10">
						<div data-dstnrow="HCSE0001" style="">
							<label style="width: 10%"><input type="radio" name="labrrAllAt" value="Y" ${eo.labrrAllAt eq 'Y'?'checked':'' } required title="근로자" data-worker="true" data-alert="선택하신 근로자 항목이 모두 초기화되며 선택하신 공사 기준 모든 근로자가 선택됩니다. 계속 진행하시겠습니까?"> 전체 근로자</label>
							<label><input type="radio" name="labrrAllAt" value="N" ${eo.labrrAllAt eq 'N'?'checked':'' } required title="근로자" /> 특정근로자</label>
							<a href="#constructionWorker" class="openLayer confirm btn normal black ml10" ${eo.labrrAllAt eq 'N'?'':'style="display:none"'}>특정 근로자 조회</a>
							<a href="#agreementAdd" class="openLayer confirm btn normal black ml10" ${eo.labrrAllAt eq 'N'?'':'style="display:none"'}>증명서 발급동의 추가</a>
							<a href="#etcAdd" class="openLayer confirm btn normal black ml10" ${eo.labrrAllAt eq 'N'?'':'style="display:none"'}>기타 근로자 추가 (재직 확인서류 제출)</a>
						</div>

						<p class="info">선택하신 공사 기준으로 보유증명서 발급에 동의한 모든 근로자가 출력됩니다.</p>

						<div class="tableWrap constructionWorkerSelected cat01 mt10" ${eo.labrrAllAt eq 'N'?'style="display:block"':''}>
							<strong>* 발급대상 근로자</strong>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width: 13%">
										<col style="width: 40%">
										<col style="width: 9%">
										<col style="width: 15%">
										<col style="width: 13%">
										<col style="width: 10%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">
												<span>구분</span>
											</th>
											<th scope="col">
												<span>공사명</span>
											</th>
											<th scope="col">
												<span>성명</span>
											</th>
											<th scope="col">
												<span>주민등록번호</span>
											</th>
											<th scope="col">
												<span>직종</span>
											</th>
											<th scope="col">
												<span>삭제</span>
											</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.labrrVO }">
										<c:if test="${list.se eq 'HCLS0001' }">
											<tr>
												<td style="display:none">
													<input type="hidden" name="ihidnum" value="${list.ihidnum }">
													<input type="hidden" name="jssfcNo" value="${list.jssfcNo}">
													<input type="hidden" name="se" value="${list.se}">
													<input type="hidden" name="ddcJoinNo" value="${list.ddcJoinNo}">
													<input type="hidden" name="cl" value="${list.cl}">
												</td>
												<td>${list.clNm }</td>
												<td>${list.cntrctNm }</td>
												<td>${list.nm }</td>
												<td>${list.ihidnum }</td>
												<td>${list.jssfcNm }</td>
												<td><button type="button" class="btn normal black">삭제</button></td>
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>

						<div class="tableWrap constructionWorkerSelected cat02 mt10" ${eo.labrrAllAt eq 'N'?'style="display:block"':''}>
							<strong>⁕ 증명서 발급동의 추가자</strong>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width: 13%">
										<col style="width: 40%">
										<col style="width: 9%">
										<col style="width: 15%">
										<col style="width: 13%">
										<col style="width: 10%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">
												<span>구분</span>
											</th>
											<th scope="col">
												<span>공사명</span>
											</th>
											<th scope="col">
												<span>성명</span>
											</th>
											<th scope="col">
												<span>주민등록번호</span>
											</th>
											<th scope="col">
												<span>직종</span>
											</th>
											<th scope="col">
												<span>삭제</span>
											</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.labrrVO }">
										<c:if test="${list.se eq 'HCLS0002' }">
											<tr>
												<td style="display:none">
													<input type="hidden" name="ihidnum" value="${list.ihidnum }">
													<input type="hidden" name="jssfcNo" value="${list.jssfcNo}">
													<input type="hidden" name="se" value="${list.se}">
													<input type="hidden" name="ddcJoinNo" value="${list.ddcJoinNo}">
													<input type="hidden" name="cl" value="${list.cl}">
												</td>
												<td>${list.clNm }</td>
												<td>${list.cntrctNm }</td>
												<td>${list.nm }</td>
												<td>${list.ihidnum }</td>
												<td>${list.jssfcNm }</td>
												<td><button type="button" class="btn normal black">삭제</button></td>
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>

						<div class="tableWrap constructionWorkerSelected cat03 mt10" ${eo.labrrAllAt eq 'N'?'style="display:block"':''}>
							<strong>⁕ 기타 근로자 추가</strong>
							<div>
								<span></span>
								<table class="tbl tbl_search">
									<colgroup>
										<col style="width: 14%">
										<col style="width: 45%">
										<col style="width: 16%">
										<col style="width: 14%">
										<col style="width: 11%">
									</colgroup>
									<thead>
										<tr>
											<th scope="col">
												<span>구분</span>
											</th>
											<th scope="col">
												<span>성명</span>
											</th>
											<th scope="col">
												<span>주민등록번호</span>
											</th>
											<th scope="col">
												<span>직종</span>
											</th>
											<th scope="col">
												<span>삭제</span>
											</th>
										</tr>
									</thead>
									<tbody>
									<c:forEach var="list" items="${eo.labrrVO }">
										<c:if test="${list.se eq 'HCLS0003' }">
											<tr>
												<td style="display:none">
													<input type="hidden" name="ihidnum" value="${list.ihidnum }">
													<input type="hidden" name="jssfcNo" value="${list.jssfcNo}">
													<input type="hidden" name="se" value="${list.se}">
												</td>
												<td>${list.seNm }</td>
												<td>${list.nm }</td>
												<td>${list.ihidnum }</td>
												<td>${list.jssfcNm }</td>
												<td><button type="button" class="btn normal black">삭제</button></td>
											</tr>
										</c:if>
									</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<p data-dstnrow="HCSE0002" style="display: none;">선택한 사업장의 모든 기능등급 보유자 현황이 발급됩니다.</p>
					</td>
				</tr>
				<tr>
					<th scope="row">제출처</th>
					<td>
						<select name="presentnOffic" title="제출처" class="chooseReception w30p">
						<c:forEach var="ceo" items="${officList}">
							<option value="${ceo.cdId}" ${ceo.cdId eq eo.presentnOffic?'selected':''}>${ceo.cdNm}</option>
						</c:forEach>
						</select>
						<input type="text" name="presentnOfficEtc" title="제출처 직접입력" value="${eo.presentnOfficEtc}" style="display: none; width: calc(100% - 30% - 10px)">
					</td>
				</tr>
				<tr>
					<th scope="row">발급매수</th>
					<td>
						<input type="number" name="issuCo" title="발급매수" value="${empty eo?1:eo.issuCo}" required> 매
					</td>
				</tr>
			</tbody>
		</table>

		<table class="tbl tbl_search mt10" style="display:none">
			<colgroup>
				<col style="width: 100%;">
			</colgroup>
			<thead>
				<tr><th><i class="fas fa-th-large mr10"></i> 결제정보</th></tr>
			</thead>
		</table>
		<table class="tbl tbl_form mt5" style="display:none">
			<colgroup>
				<col style="width: 12%;">
				<col style="width: 38%;">
				<col style="width: 12%;">
				<col style="width: 38%;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">결제구분</th>
					<td>
					<c:forEach var="ceo" items="${payList}" varStatus="sts">
						<c:if test="${ceo.cdId ne 'PAYM0004' }">
							<label><input type="radio" name="setleSe" value="${ceo.cdId}" ${ceo.cdId eq eo.setleSe or sts.first?'checked':''}>${ceo.cdNm}</label>
						</c:if>
					</c:forEach>
					</td>
					<th scope="row">수수료</th>
					<td>
						<input type="text" name="fee" title="수수료" readonly="readonly" value="${fee.hold }"> 원
					</td>
				</tr>
			</tbody>
		</table>

		<table class="tbl tbl_search mt10">
			<colgroup>
				<col style="width: 100%;">
			</colgroup>
			<thead>
				<tr><th><i class="fas fa-th-large mr10"></i> 제출서류</th></tr>
			</thead>
		</table>
		<table class="tbl tbl_form mt5">
			<colgroup>
				<col style="width: 12%;">
				<col style="width: 88%;">
			</colgroup>
			<tbody>
				<tr>
					<th scope="row">구비서류</th>
					<td>도급계약서</td>
				</tr>
				<tr>
					<td id="fileDiv" colspan="2"></td>
				</tr>
			</tbody>
		</table>

		<div class="btn_wrap">
			<div class="fl txt_left">
<!-- 				<a href="" class="btn normal sky mr10 btnRpt"><i class="fas fa-print mr5"></i> 신청서 출력</a> -->
			</div>
			<div class="fr txt_right">
				<button type="button" class="btn normal sky mr10 btnRpt"> <i class="fas fa- mr5"></i> 신청서 출력</button>
				<button type="submit" class="btn normal blue mr10" href="${empty eo?'insert.do':'update.do'}"><i class="far fa-save mr5"></i>${empty eo?'신청':'수정'}</button>
				<button type="reset" class="btn normal grey mr10"><i class="fas fa-eraser mr5"></i>초기화</button>
			</div>
		</div>
	</form>
	
	<div id="constructionJob" class="layer" style="margin-top: -440px; margin-left: -500px; z-index: 7788; display: none;">
		<h1>특정 직종 조회</h1>
		<button type="button" class="close">×</button>
		<div>
			<table>
				<colgroup>
					<col style="width:8%">
					<col style="width:17%">
					<col style="width:8%">
					<col style="width:17%">
					<col style="width:8%">
					<col style="width:17%">
					<col style="width:8%">
					<col style="width:17%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">연번</th>
						<th scope="col">직종명</th>
						<th scope="col">연번</th>
						<th scope="col">직종명</th>
						<th scope="col">연번</th>
						<th scope="col">직종명</th>
						<th scope="col">연번</th>
						<th scope="col">직종명</th>
					</tr>
				</thead>
				<tbody>
				<c:forEach var="list" items="${jssfcList}" varStatus="sts">
					<c:if test="${sts.first or sts.index % 4 eq 0}">
						<tr>
					</c:if>
							<th scope="row">${list.jssfcNo }</th>
							<td>${list.jssfcNm }</td>
					<c:if test="${sts.last or sts.count % 4 eq 0}">
						</tr>
					</c:if>
				</c:forEach>
				</tbody>
			</table>
			<p>※ 기능등급 미시행 직종은 노출되지 않습니다.</p>
	
			<div class="mt30 txt_center">
				<button type="button " class="btn normal green"><i class="fas fa-folder-plus mr5"></i>추가</button>
				<button type="button " class="close btn normal black"><i class="fas fa-times mr5"></i>닫기</button>
			</div>
		</div>
	</div>
	
	<div id="constructionPlace" class="layer">
		<h1>특정 사업장 조회</h1>
		<button type="button" class="close">×</button>
		<div>
			<form id="cntrctFrm" action="cntrctInfoList.do" method="post">
				<input type="hidden" name="pageNo" value="1" />
				<table>
					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">공사명</th>
							<td>
								<input type="text" name="cntrctNm" title="공사명" class="w100p">
							</td>
						</tr>
						<tr>
							<th scope="row">발주자</th>
							<td>
								<input type="text" name="dminsttNm" title="발주자" class="w100p">
							</td>
						</tr>
					</tbody>
				</table>
				<div class="mt10 txt_center">
					<button type="button" class="btn normal blue btnCntrct">조회</button>
				</div>
			</form>
	
			<div class="tableWrap modal constructionPlace mt30" style="display:block">
				<div>
					<span></span>
					<table>
						<colgroup>
							<col style="width:7%">
							<col style="width:10%">
							<col style="width:35%">
							<col style="width:15%">
							<col style="width:33%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><span>선택</span></th>
								<th scope="col"><span>구분</span></th>
								<th scope="col"><span>공사명</span></th>
								<th scope="col"><span>발주자</span></th>
								<th scope="col"><span>주소</span></th>
							</tr>
						</thead>
						<tbody id="cntrctResult">
						</tbody>
					</table>
				</div>
			</div>
	
			<div class="mt10 txt_center">
				<button type="button "class="btn normal blue" style="display:none">더 보기</button>
			</div>
			<div class="mt30 txt_center">
				<button type="button "class="btn normal green"><i class="fas fa-folder-plus mr5"></i>추가</button>
				<button type="button "class="close btn normal black"><i class="fas fa-times mr5"></i>닫기</button>
			</div>
		</div>
	</div>
	
	<div id="constructionWorker" class="layer" style="margin-top: -440.5px; margin-left: -500px; z-index: 7780; display: none;">
		<h1>발급대상 근로자 조회</h1>
		<button type="button" class="close">×</button>
		<div>
			<form action="labrrInfoList.do" method="post">
				<input type="hidden" name="pageNo" value="1" />
				<input type="hidden" name="ihidnum" /> 
				<table>
					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">공사명</th>
							<td>
								<input type="text" name="cntrctNm" title="공사명" class="w100p">
							</td>
						</tr>
						<tr>
							<th scope="row">근로자 성명</th>
							<td>
								<input type="text" name="nm" title="근로자 성명" class="w100p">
							</td>
						</tr>
						<tr>
							<th scope="row">주민등록번호</th>
							<td>
								<input type="text" name="ihidnum1" title="주민번호 앞자리" class="w30p" maxlength="6" number hasnext> - 
								<input type="text" name="ihidnum2" title="주민번호 뒷자리" class="w30p" maxlength="7" number> 
							</td>
						</tr>
					</tbody>
				</table>
				<div class="mt10 txt_center">
					<button type="submit " class="btn normal blue btnLabrr">조회</button>
				</div>
			</form>
	
			<div class="tableWrap modal constructionWorker mt30" style="display:block">
				<div>
					<span></span>
					<table>
						<colgroup>
							<col style="width:7%">
							<col style="width:12%">
							<col style="width:42%">
							<col style="width:10%">
							<col style="width:15%">
							<col style="width:14%">
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><span>선택</span></th>
								<th scope="col"><span>고용형태</span></th>
								<th scope="col"><span>공사명</span></th>
								<th scope="col"><span>성명</span></th>
								<th scope="col"><span>주민등록번호</span></th>
								<th scope="col"><span>직종</span></th>
							</tr>
						</thead>
						<tbody id="labrrResult">
						</tbody>
					</table>
				</div>
			</div>
	
			<div class="mt10 txt_center">
				<button type="button " class="btn normal blue" style="display:none">더 보기</button>
			</div>
			<div class="mt30 txt_center">
				<button type="button " class="btn normal green"><i class="fas fa-folder-plus mr5"></i>추가</button>
				<button type="button " class="close btn normal black"><i class="fas fa-times mr5"></i>닫기</button>
			</div>
		</div>
	</div>
	
	<div id="agreementAdd" class="layer" style="margin-top: -386px; margin-left: -400px; z-index: 7790; display: none;">
		<h1>증명서 발급동의 추가</h1>
		<button type="button" class="close">×</button>
		<div>
			<form id="agreFrm" action="../issuAgre/insertIssuAgre.do" method="post">
				<input type="hidden" name="ihidnum" value="" />
				<input type="hidden" name="ddcJoinNo" value="" required title="공사"/>
				<input type="hidden" name="cntrwkSe" value="" />
				<input type="hidden" name="SptSe" value="SPTS0002" /><!-- 방문 -->
				<input type="hidden" name="deleteAt" value="N" />
				
				<h2>발급동의자</h2>
				<table class="mt10 mb20">
					<colgroup>
						<col style="width:20%;">
						<col style="width:30%;">
						<col style="width:20%;">
						<col style="width:30%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">주민등록번호</th>
							<td data-node="ssn" colspan="3">
								<input type="text" name="ihidnum1" title="주민등록번호 앞자리" required number maxlength="6" hasnext> -&nbsp;
								<input type="text" name="ihidnum2" title="주민등록번호 뒷자리" required number maxlength="7">
								<button type="button" class="close btn normal black btnAgre">조회</button>
							</td>
						</tr>
						<tr>
							<th scope="row">성명</th>
							<td data-node="name" colspan="3"></td>
						</tr>
						<tr>
							<th scope="row">발급직종</th>
							<td data-node="job" colspan="3">
								<select name="selectJssfcNo" title="발급직종" required>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">동의만료일</th>
							<td colspan="3">
								<div class="input_date">
									<input type="text" name="validDt" class="datepicker" required>
									<a href="#"><img src="../../static/admin/images/icon/ico_date.jpg" alt="" /></a>
								</div>
							</td>
						</tr>
						<tr>
							<th scope="row">사업자등록번호</th>
							<td></td>
							<th scope="row">기업명</th>
							<td></td>
						</tr>
						<tr>
							<th scope="row">대표자</th>
							<td></td>
							<th scope="row">전화번호</th>
							<td></td>
						</tr>
						<tr>
							<th scope="row">공사명</th>
							<td data-node="cName" colspan="3">
								<a href="#construction" class="openLayer btn normal black">조회</a>
								<input type="text" name="" title="공사명" readonly="readonly" style="width:70%;">
							</td>
						</tr>
					</tbody>
				</table>
	
				<h2>제출서류</h2>
				<table class="mt10">
					<colgroup>
						<col style="width:20%;">
						<col style="width:80%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">구비서류</th>
							<td class="p10">
								1. 신분증<br>
								2. 근로자의 동의를 받은 ‘발급 동의서’<br>
	 							- 동의일자 1개월 이내
							</td>
						</tr>
						<tr>
							<th scope="row">첨부파일</th>
							<td id="agreFileDiv"></td>
						</tr>
					</tbody>
				</table>
	
				<div class="mt30 txt_center">
					<button type="submit " class="btn normal indigo mr5"><i class="fas fa-folder-plus mr5"></i>계속등록</button>
					<button type="submit " class="btn normal blue mr5"><i class="far fa-save mr5"></i>등록</button>
					<button type="button" class="close btn normal black"><i class="fas fa-times mr5"></i>취소</button>
				</div>
			</form>
		</div>
	</div>
	
	<div id="etcAdd" class="layer" style="margin-top: -386px; margin-left: -400px; z-index: 7790; display: none;">
		<h1>기타 근로자 추가(재직 확인서류 제출)</h1>
		<button type="button" class="close">×</button>
		<div>
			<form id="etcFrm" action="" method="post">
				<input type="hidden" name="ihidnum" value="" />
				
				<h2>기타 근로자</h2>
				<table class="mt10 mb20">
					<colgroup>
						<col style="width:20%;">
						<col style="width:80%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">주민등록번호</th>
							<td data-node="ssn">
								<input type="text" name="ihidnum1" title="주민등록번호 앞자리" required number maxlength="6" hasnext> -&nbsp;
								<input type="text" name="ihidnum2" title="주민등록번호 뒷자리" required number maxlength="7">
								<button type="button" class="btn normal black btnEtc">조회</button>
							</td>
						</tr>
						<tr>
							<th scope="row">성명</th>
							<td data-node="name"></td>
						</tr>
						<tr>
							<th scope="row">발급직종</th>
							<td data-node="job">
								<select name="jssfcNo" title="발급직종" required>
								<c:forEach var="list" items="${jssfcList}" varStatus="sts">
									<option value="${list.jssfcNo }">${list.jssfcNm }</option>
								</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
	
				<div class="mt30 txt_center">
					<button type="submit " class="btn normal indigo mr5"><i class="fas fa-folder-plus mr5"></i>계속등록</button>
					<button type="submit " class="btn normal blue mr5"><i class="far fa-save mr5"></i>등록</button>
					<button type="button" class="close btn normal black"><i class="fas fa-times mr5"></i>취소</button>
				</div>
			</form>
		</div>
	</div>
	
	<div id="construction" class="layer">
		<h1>공사명 검색</h1>
		<button type="button" class="close">×</button>
		<div>
			<form id="cntrctFrm2" action="cntrctInfoList.do" method="post">
				<input type="hidden" name="pageNo" value="1" />
				<table>
					<colgroup>
						<col style="width:20%;">
						<col style="width:80%;">
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">공사명</th>
							<td>
								<input type="text" name="cntrctNm" title="공사명">
								<button type="submit" class="btn normal black btnCntrct2">검색</button>
							</td>
						</tr>
					</tbody>
				</table>
			</form>
	
			<table class="list construction">
				<colgroup>
					<col style="width:15%">
					<col style="width:15%">
					<col style="width:70%">
				</colgroup>
				<thead>
					<tr>
						<th scope="col">연번</th>
						<th scope="col">구분</th>
						<th scope="col">공사명</th>
					</tr>
				</thead>
				<tbody id="cntrctResult2">
				</tbody>
			</table>
	
			<div class="paging">
			</div>
		</div>
	</div>
	
	<div class="pageDisabled" style="display: none; z-index: 7795;"></div>
</body>
</html>