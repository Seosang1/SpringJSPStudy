<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
	$(function(){
		//초기화
		var tree, node;
		
		//트리옵션 초기화
		var treeOpt = {
			check: {
				enable: true
			},
			callback:{
				onClick:function(){
					event.preventDefault();
					return false;
				},beforeCheck:function(treeId, treeNode){
					treeNode.checked = treeNode.checked-1;
					tree.refresh();
					event.preventDefault();
					return false;					
				}
			},
			data : {
				simpleData : {
					enable : true
				}
			}
		};
		
		//트리데이터 생성함수
		function getTree(list){
			var rootNodes = [];
			
			function addChild(prt, obj){
				$(prt).each(function(i){
					if(this.menuSn == obj.upperMenuSn){
						obj.name = obj.menuNm.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<') + ' - (' +obj.menuDc + ')';
						this.check_Child_State = 0;
						this.children = this.children || [];
						this.children.push(obj);
					}else{
						addChild(this.children, obj);
					}
				});
			}
			
			$(list).each(function(i){
				if(this.upperMenuSn == 0){
					this.name = this.menuNm.replace(/[&#40;]/g,'(').replace(/[&#41;]/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<')  + ' - (' +this.menuDc + ')';
					this.check_Child_State = 0;
					rootNodes.push(this);
				}else{
					addChild(rootNodes, this);
				}
			});
			
			return rootNodes;
		}
		
		//권한별 메뉴목록 조회
		$('#frm').on('change', '[name="authorCd"]', function(){
			$('#frm').attr('action', 'menuList.do');
			$('#frm').ajaxCwma({
				success:function(res){
					tree.checkAllNodes(false);
					tree.expandAll(false);
					
					$(res.list).each(function(){
						if(tree.getNodesByParam('menuSn', this.menuSn)[0]){
							tree.getNodesByParam('menuSn', this.menuSn)[0].checked = true;
							tree.expandNode(tree.getNodesByParam('menuSn', this.menuSn)[0], true, true, true);
						}
					});
					
					tree.refresh();
				}
			});
		});
		
		//조회버튼 클릭이벤트
		$('#updFrm .btn_search').on('click', function(e){
			var node = tree.getNodesByParamFuzzy('name', $(this).prev().val(), null);
			tree.selectNode(node[0]);
			$('a.curSelectedNode').trigger('click');
			e.preventDefault();
			return false;
		});
		
		
		//메뉴목록 엔터이벤트
		$('#updFrm input').on('keyup, keypress', function(e){
			if(e.keyCode == 13){
				$('#updFrm .btn_search').click();
				e.preventDefault();
				return false;
			}
		});
		
		//검색버튼 이벤트
		$('#frm .btn_search').click(function(e){
			$('#frm').attr('action', 'list.do');
			$('#frm').ajaxCwma({
				success:function(res){
					$('#authList').html('');
					$(res.list).each(function(){
						$('#authList').append('<div class="mt15"><label><input type="radio" name="authorCd" value="'+this.authorCd+'" data-dc="'+this.authorDc+'">'+this.authorNm+'</label></div>');
					});
				}
			});
			
			$('#updFrm').attr('action', '../menuInfo/list.do');
			$('#updFrm').ajaxCwma({
				success:function(res){
					tree = $.fn.zTree.init($('#menuTree'), treeOpt, getTree(res.list));
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//권한목록 엔터이벤트
		$('#frm [name="authorNm"]').on('keyup, keypress', function(e){
			if(e.keyCode == 13){
				$('#frm .btn_search').click();
				e.preventDefault();
				return false;
			}
		});
		
		//삭제버튼 이벤트
		$('.btnDel').click(function(e){
			if($('[name="authorCd"]:checked')[0]){
				if(confirm('삭제하시겠습니까?')){
					$('#frm').attr('action', $(this).attr('href'));
					$('#frm').ajaxCwma({
						success:function(res){
							alert('삭제되었습니다');
							$('#frm')[0].reset();
							$('.btn_search').click();
						}
					});
				}
			}else{
				alert('권한을 선택해주세요');
			}
			e.preventDefault();
			return false;
		});
		
		//전체펼침버튼 클릭이벤트
		$('.expandAll').on('click', function(){
			tree.expandAll(true);
			return false;
		});
	
		//전체접기버튼 클릭이벤트
		$('.collapseAll').on('click', function(){
			tree.expandAll(false);
			return false;
		});
		
		//권한설정버튼 이벤트
		$('#btnSetup').click(function(e){
			if($('[name="authorCd"]').val()){
				$('[name^="relateVO"]').remove();
				
				$(tree.getCheckedNodes()).each(function(i){
					$('#frm').append('<input type="hidden" name="relateVO['+i+'].menuSn" value="'+this.menuSn+'" />');
				});
				
				$('#frm').attr('action', $(this).attr('href'));
				$('#frm').ajaxCwma({
					success:function(res){
						$('[name^="relateVO"]').remove();
						$('[name="authorCd"]').val('');
						alert('적용되었습니다');
						$('.btn_search').click();
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
			$('#frmPop [name="authorCd"]').prop('readonly', false);
		    $('#authorLayer .blue').show();
		    $('#authorLayer .green').hide();				
			
			cwma.showMask();
	        $('#authorLayer').css("top",(($(window).height() - $('#authorLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#authorLayer').css("left",(($(window).width() - $('#authorLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
	        if($('.data_wrap .layerpop')[0]){
		        $('#authorLayer').draggable();
		        $('body').append($('.data_wrap .layerpop'));
	        }
	        
	        $('#authorLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//수정 버튼 클릭 이벤트 - 팝업오픈
		$('.btnUpd').click(function(e){
			if($('#frm [name="authorCd"]:checked').length){
			    var obj = $('#frm [name="authorCd"]:checked');
			    $('#frmPop [name="authorCd"]').val(obj.val());
			    $('#frmPop [name="authorNm"]').val(obj.parent().text().trim());
			    $('#frmPop [name="authorDc"]').val(obj.data('dc'));
			    $('#frmPop [name="authorCd"]').prop('readonly', true);
			    
			    $('#authorLayer .blue').hide();
			    $('#authorLayer .green').show();
			    
			}else{
			    alert('수정할 권한을 선택해주세요');
				e.preventDefault();
				return false;			    
			}
			
			cwma.showMask();
	        $('#authorLayer').css("top",(($(window).height() - $('#authorLayer').outerHeight()) / 2) + $(window).scrollTop());
	        $('#authorLayer').css("left",(($(window).width() - $('#authorLayer').outerWidth()) / 2) + $(window).scrollLeft());
	        
	        if($('.data_wrap .layerpop')[0]){
		        $('#authorLayer').draggable();
		        $('body').append($('.data_wrap .layerpop'));
	        }
	        
	        $('#authorLayer').show();
	        
			e.preventDefault();
			return false;
		});
		
		//팝업닫기 버튼 클릭이벤트
		$('.layerpop_close, .btnClose').click(function(e){
			cwma.hideMask();
			$('#authorLayer').hide();
			
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
					$('#frm [name="authorCd"]').prop('checked', false);
					$('#frm .btn_search').click();
					$('.btnClose').click();
				}
			});
			
			e.preventDefault();
			return false;
		});

		$('#frm .btn_search').click();
	});
</script>
</head>
<body>
	<div class="data_wrap">
		<form action="list.do" method="post" id="frm">
			<div class="data_wrap_half_left">
				<div class="ml20">세부권한정보에 대한 메뉴속성의 매칭과 설정이 가능합니다.</div>
				<table class="tbl tbl_form2">
					<colgroup>
						<col width="20%">
						<col width="80%">
					</colgroup>
					<tbody>
						<tr>
							<th scope="col" colspan="2" class="">상세권한관리</th>
						</tr>
						<tr>
							<th scope="row">조회대상</th>
							<td>
								<input type="text" name="authorNm" title="조회대상" class="w70p">
								<a href="#" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="vertical-align: top; height: 500px; overflow: auto;">
								<ul id="authList" style="width:100%;height:490px;"></ul>
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
						<a href="updateMenu.do" id="btnSetup" class="btn normal blue"><i class="far fa-save mr5"></i> 권한저장</a>
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
							<th scope="col" colspan="2" class="">Menu Tree</th>
						</tr>
						<tr>
							<th scope="row">조회대상</th>
							<td>
								<input type="text" title="조회대상" class="w70p">
								<a href="#" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="vertical-align: top; height: 500px; overflow: auto;">
								<ul id="menuTree" class="ztree list" style="width:100%;height:490px;"></ul>
							</td>
						</tr>
					</tbody>
				</table>
				<div class="btn_wrap mb20">
					<div class="fl txt_left"></div>
					<div class="fr txt_right">
						<a href="#" class="btn normal purple mr10 expandAll"><i class="far fa-folder-open mr5"></i> 전체펼침</a>
						<a href="#" class="btn normal purple mr10 collapseAll"><i class="far fa-folder mr5"></i> 전체닫기</a>
					</div>
				</div>
			</div>
		</form>
	
		<div id="authorLayer" class="layerpop ui-draggable ui-draggable-handle" style="width: 700px; height: 220px; display: none; position:absolute; z-index:99999">
			<div class="layerpop_area">
				<div class="title">업무권한 등록 / 수정</div>
				<a href="#" class="layerpop_close" id="layerbox_close">
					<i class="far fa-window-close"></i>
				</a>
				<div class="pop_content">
					<form id="frmPop" action="insert.do" method="post">
						<table class="tbl tbl_form">
							<colgroup>
								<col width="20%">
								<col width="30%">
								<col width="20%">
								<col width="30%">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">상세권한코드</th>
									<td><input type="text" name="authorCd" value="" title="상세권한코드" class="w100p"></td>
									<th scope="row">상세권한명</th>
									<td><input type="text" name="authorNm" value="" title="상세권한명" class="w100p"></td>
								</tr>
								<tr>
									<th scope="row">상세권한설명</th>
									<td colspan="3"><input type="text" name="authorDc" value="" title="상세권한설명" class="w100p"></td>
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
