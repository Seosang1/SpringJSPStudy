<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
		//업무역할설정 검색버튼 이벤트
		$('#frm .btn_search').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					$('#roleList').html('');
					
					$(res.list).each(function(){
						$('#roleList').append('<li class="mt15"><label><input type="radio" name="roleSn" value="'+this.roleSn+'" data-dc="'+this.roleDc+'"><span></span>'+this.roleNm+'</label></li>');
					});
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//업무역할설정 엔터이벤트
		$('#frm [name="roleNm"]').on('keyup, keypress', function(e){
			if(e.keyCode == 13){
				$('#frm .btn_search').click();
				e.preventDefault();
				return false;
			}
		});
		
		//상세권한설정 검색버튼 이벤트
		$('#updFrm .btn_search').click(function(e){
			$('button.uncheckAll').click();
			$('#updFrm').attr('action', '../authorInfo/list.do');
			$('#updFrm').ajaxCwma({
				success:function(res){
					$('#authList').html('');
					
					$(res.list).each(function(){
						$('#authList').append('<li class="mt15"><label><input type="checkbox" name="authorCd" value="'+this.authorCd+'"><span></span>'+this.authorNm+'</label></li>');
					});
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//상세권한설정 엔터이벤트
		$('#updFrm [name="authorNm"]').on('keyup, keypress', function(e){
			if(e.keyCode == 13){
				$('#updFrm .btn_search').click();
				e.preventDefault();
				return false;
			}
		});
		
		//권한그룹 선택 이벤트
		$('#roleList').on('change', '[name="roleSn"]', function(){
			$('#frm').attr('action', 'authorList.do');
			$('#frm').ajaxCwma({
				success:function(res){
					$('[name="authorCd"]').prop('checked', false);
					$(res.list).each(function(){
						$('#authList').find('[value="'+this.authorCd+'"]').prop('checked', true);
					});
				}
			});
		});
		
		//수정버튼 이벤트
		$('#btnUpd').click(function(e){
			if($('[name="roleSn"]:checked').length){
				window.open($(this).attr('href')+'?roleSn='+$('[name="roleSn"]:checked').val(), $(this).attr('target'), 'width='+$(this).data('pw')+',height='+$(this).data('ph')+',location=no,status=no,resizable=no,fullscreen=no,scrollbars=yes');
			}else{
				alert('권한을 선택해주세요');
			}
			e.preventDefault();
			return false;
		});
		
		//삭제버튼 이벤트
		$('.btnDel').click(function(e){
			if($('#frm [name="roleSn"]:checked').length){
				if(confirm('삭제하시겠습니까?')){
					$('#frm').attr('action', $(this).attr('href'));
					$('#frm').ajaxCwma({
						success:function(res){
							alert('삭제되었습니다');
							$('#frm')[0].reset();
							$('#frm .btn_search').click();
						}
					});
				}
			}else{
				alert('권한을 선택해주세요');
			}
			e.preventDefault();
			return false;
		});
		
		//전체선택버튼 클릭이벤트
		$('.checkAll').on('click', function(e){
			$('[name="authorCd"]').prop('checked', true);
			e.preventDefault();
			return false;
		});
	
		//전체해제버튼 클릭이벤트
		$('.uncheckAll').on('click', function(e){
			$('[name="authorCd"]').prop('checked', false);
			e.preventDefault();
			return false;
		});
		
		//권한설정버튼 이벤트
		$('#btnSetup').click(function(e){
			if($('[name="roleSn"]:checked').length){
				$('[name^="relateVO"]').remove();
				
				$('[name="authorCd"]:checked').each(function(i){
					$('#frm').append('<input type="hidden" name="relateVO['+i+'].authorCd" value="'+this.value+'" />');
				});
				
				$('#frm').attr('action', $(this).attr('href'));
				$('#frm').ajaxCwma({
					success:function(res){
						$('[name^="relateVO"]').remove();
						$('[name="roleSn"]').prop('checekd', false);
						alert('적용되었습니다');
					}
				});
			}else{
				alert('권한을 선택해주세요');
			}
			
			e.preventDefault();
			return false;
		});
		
		//등록버튼 클릭 이벤트 - 팝업오픈
		$('.btnReg').click(function(e){
			$('#frmPop input').val('');
			$('#frmPop [name="roleSn"]').val(0);
		    $('#roleLayer .blue').show();
		    $('#roleLayer .green').hide();				
			
			cwma.showMask();
	        $('#roleLayer').css("top",(($(window).height() - $('#roleLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#roleLayer').css("left",(($(window).width() - $('#roleLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
	        if($('.data_wrap .layerpop')[0]){
		        $('#roleLayer').draggable();
		        $('body').append($('.data_wrap .layerpop'));
	        }
	        
	        $('#roleLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//수정 버튼 클릭 이벤트 - 팝업오픈
		$('.btnUpd').click(function(e){
			if($('#frm [name="roleSn"]:checked').length){
			    var obj = $('#frm [name="roleSn"]:checked');
			    $('#frmPop [name="roleSn"]').val(obj.val());
			    $('#frmPop [name="roleNm"]').val(obj.parent().text().trim());
			    $('#frmPop [name="roleDc"]').val(obj.data('dc'));
			    
			    $('#roleLayer .blue').hide();
			    $('#roleLayer .green').show();
			    
			}else{
			    alert('수정할 업무권한를 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			cwma.showMask();
	        $('#roleLayer').css("top",(($(window).height() - $('#roleLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#roleLayer').css("left",(($(window).width() - $('#roleLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
	        if($('.data_wrap .layerpop')[0]){
		        $('#roleLayer').draggable();
		        $('body').append($('.data_wrap .layerpop'));
	        }
	        
	        $('#roleLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#roleLayer').hide();
			
			e.preventDefault();
			return false;			
		});
		
		//등록/수정버튼 이벤트 - submit
		$('.btnSubmit').click(function(e){
			var txt = $(this).text().trim();
			$('#frmPop').attr('action', $(this).attr('href'));
			$('#frmPop').ajaxCwma({
				success:function(res){
					alert(txt+'되었습니다');
					$('#frm [name="roleSn"]').prop('checked', false);
					$('#frm .btn_search').click();
					$('.btnClose').click();
				}
			});
			
			e.preventDefault();
			return false;
		});

		$('#frm .btn_search').click();
		$('#updFrm .btn_search').click();
	});
</script>
</head>
<body>
<div class="data_wrap">
	<form action="" method="post" id="frm">
		<div class="data_wrap_half_left">
			<div class="ml20">시스템기능 및 메뉴별 상세권한에 대한 업무역할별 설정 기능을 제공합니다.</div>
			<table class="tbl tbl_form2">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" colspan="2" class="">업무역할설정</th>
					</tr>
					<tr>
						<th scope="row">조회대상</th>
						<td>
							<input type="text" name="roleNm" title="조회대상" class="w70p">
							<a href="list.do" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="vertical-align: top; height: 500px; overflow: auto;">
							<ul id="roleList" style="vertical-align: top; height: 490px;"></ul>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap mb20">
				<div class="fl txt_left">
					<a href="#" class="btn normal blue mr10 btnReg"><i class="far fa-save mr5"></i> 등록</a>
					<a href="#" class="btn normal green mr10 btnUpd"><i class="far fa-edit mr5"></i> 수정</a>
					<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i> 삭제</a>
				</div>
				<div class="fr txt_right">
					<a href="updateAuthor.do" id="btnSetup" class="btn normal blue"><i class="far fa-save mr5"></i> 권한저장</a>
				</div>
			</div>
		</div>
	</form>
	
	<form action="" method="post" id="updFrm">
		<div class="data_wrap_half_right">
			<div class="ml20">&nbsp;</div>
			<table class="tbl tbl_form2">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" colspan="2" class="">상세권한설정</th>
					</tr>
					<tr>
						<th scope="row">조회대상</th>
						<td>
							<input type="text" name="authorNm" title="조회대상" class="w70p">
							<a href="list.do" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="vertical-align: top; height: 500px; overflow: auto;">
							<ul id="authList" style="vertical-align: top; height: 490px;"></ul>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap mb20">
				<div class="fl txt_left"></div>
				<div class="fr txt_right">
					<a href="" class="btn normal purple mr10 checkAll"><i class="fas fa-check-square mr5"></i> 전체선택</a>
					<a href="" class="btn normal purple uncheckAll"><i class="far fa-check-square mr5"></i> 전체해제</a>
				</div>
			</div>
		</div>
	</form>
	
	<div id="roleLayer" class="layerpop ui-draggable ui-draggable-handle" style="width: 700px; height: 220px; display: none; position:absolute; z-index:99999">
		<div class="layerpop_area">
			<div class="title">업무권한 등록 / 수정</div>
			<a href="#" class="layerpop_close" id="layerbox_close">
				<i class="far fa-window-close"></i>
			</a>
			<div class="pop_content">
				<form id="frmPop" action="insert.do" method="post">
					<input type="hidden" name="roleSn" value="" />
					<table class="tbl tbl_form">
						<colgroup>
							<col width="20%">
							<col width="80%">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">업무권한명</th>
								<td><input type="text" name="roleNm" value="" title="업무권한명" class="w100p"></td>
							</tr>
							<tr>
								<th scope="row">업무권한설명</th>
								<td><input type="text" name="roleDc" value="" title="업무권한설명" class="w100p"></td>
							</tr>
						</tbody>
					</table>
				</form>
				
				<div class="btn_wrap mb20">
					<div class="txt_center mt20">
						<a href="insert.do" class="btn normal blue mr10 btnSubmit"><i class="far fa-save mr5"></i> 등록</a>
						<a href="update.do" class="btn normal green mr10 btnSubmit"><i class="far fa-edit mr5"></i> 수정</a>
						<a href="#" class="btn normal black mr10 btnClose"><i class="fas fa-power-off mr5"></i> 취소</a>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
