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
		var newCount = 1;
		
		//트리옵션 초기화
		var treeOpt = {
			view : {
				addHoverDom : addHoverDom,
				removeHoverDom : function(treeId, treeNode){
					$('#addBtn_' + treeNode.tId).unbind().remove();
				},
				selectedMulti : false,
				nameIsHTML: true
			},
			edit : {
				enable : true,
				showRemoveBtn : true,
				showRenameBtn : false,
				removeTitle : '메뉴 삭제',
				drag:{
					isCopy:false
				}
			},
			callback : {
				beforeRemove : 	function(treeId, treeNode){
					if(treeNode.children && treeNode.children.length > 0){
						alert('하위메뉴가 있는 경우 삭제할 수 없습니다.');
						return false;
					}
					
					if(confirm(treeNode.name + ' 메뉴를 삭제 하시겠습니까?') && treeNode.menuSn){
						$('#updFrm')[0].reset();
						$('#updFrm').find('[name="menuSn"]').val(treeNode.menuSn);
						$('#updFrm').attr('action', 'delete.do');
						$('#updFrm').ajaxCwma({
							beforeValid:false,
							success:function(res){
								alert('삭제되었습니다');
							}
						});
					}
				},
				onClick : function(event, treeId, treeNode){
					$('[name="menuNm"]').val(treeNode.menuNm);
					$('[name="url"]').val(treeNode.url);
					$('[name="menuDc"]').val(treeNode.menuDc);
					$('[name="displayAt"]').each(function(){
						this.value == treeNode.displayAt?$(this).prop('checked', true):$(this).prop('checked', false)	
					});
					$('[name="useAt"]').each(function(){
						this.value == treeNode.useAt?$(this).prop('checked', true):$(this).prop('checked', false)	
					});
					$('[name="bassAuthorAt"]').each(function(){
						this.value == treeNode.bassAuthorAt?$(this).prop('checked', true):$(this).prop('checked', false)	
					});
					$('[name="upperMenuSn"]').val(treeNode.upperMenuSn);
					$('[name="menuSn"]').val(treeNode.menuSn);
					$('[name="css"]').val(treeNode.css);
				}
			},
			data : {
				simpleData : {
					enable : true
				}
			}
		};

		//트리데이터생성 함수
		function getTree(list){
			var rootNodes = [];
			
			function addChild(prt, obj){
				$(prt).each(function(i){
					if(this.menuSn == obj.upperMenuSn){
						obj.name = obj.menuNm.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<')  + ' - ('+obj.menuDc+')';
						obj.menuNm = obj.menuNm.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<');
						obj.menuDc = obj.menuDc.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<');
						this.children = this.children || [];
						this.children.push(obj);
					}else{
						addChild(this.children, obj);
					}
				});
			}
			
			$(list).each(function(i){
				if(this.upperMenuSn == 0){
					this.name = this.menuNm.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<') + ' - ('+this.menuDc+')';
					this.menuNm = this.menuNm.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<');
					this.menuDc = this.menuDc.replace(/(&#40;)/g,'(').replace(/(&#41;)/g, ')').replace(/(&gt;)/g, '>').replace(/(&lt;)/g, '<');
					rootNodes.push(this);
				}else{
					addChild(rootNodes, this);
				}
			});
			
			return rootNodes;
		}
		
		//트리메뉴추가 이벤트
		function addHoverDom(treeId, treeNode){
			var sObj = $('#' + treeNode.tId + '_span');
			if(treeNode.editNameFlag || $('#addBtn_' + treeNode.tId).length>0){
				return;
			}
			var addStr = '<span class="button add" id="addBtn_' + treeNode.tId + '" title="하위메뉴 추가" onfocus="this.blur();"></span>';
			sObj.after(addStr);
			var btn = $('#addBtn_' + treeNode.tId);
			if(btn){
				btn.bind('click', function(){
					var zTree = $.fn.zTree.getZTreeObj('menuTree');
					var ret = zTree.addNodes(treeNode, {id:(100 + newCount), pId : treeNode.id, name : '새 메뉴 ' + (newCount++), upperMenuSn:treeNode.menuSn});
					$('#'+ret[0].tId+'_span').click();
					$('#updFrm [name="menuSn"]').val(0);
					$('[name="menuNm"]').focus();
					return false;
				});
			}
		};

		//검색버튼 이벤트
		$('#btnSearch').click(function(e){
			$('#frm').attr('action', $(this).attr('href'));
			$('#frm').ajaxCwma({
				success:function(res){
					tree = $.fn.zTree.init($('#menuTree'), treeOpt, getTree(res.list));
				}
			});
			
			e.preventDefault();
			return false;
		});
		
		//전체펼침버튼 클릭이벤트
		$('.expandAll').on('click', function(){
			tree.expandAll(true);
		});
	
		//전체접기버튼 클릭이벤트
		$('.collapseAll').on('click', function(){
			tree.expandAll(false);
		});
		
		//트리화면 빈곳 선택시 선택해제 
		$('#menuTree').click(function(){
			tree.cancelSelectedNode();
			$('[name="menuSn"]').val(0);
			$('[name="upperMenuSn"]').val(0);
			$('#updFrm')[0].reset();
		});
		
		//구조저장버튼 클릭이벤트
		$('.btnSave').click(function(){
			var list = [];
			cwma.showLoader();
			
			function setMenuOrdr(nodes){
				$(nodes).each(function(i){
					list.push({
						menuSn:this.menuSn, 
						menuOrdr:(i+1), 
						depth:(this.level+1), 
						upperMenuSn:(this.level?this.getParentNode().menuSn:0)
					});
					
					if(this.children && this.children.length)
						setMenuOrdr(this.children);
				});
			}
			
			setMenuOrdr(tree.getNodes());
			
			$.ajax({
				url:'updateOrdr.do',
				method:'POST',
				data:JSON.stringify({list:list}),
				dataType:'json',
				contentType : "application/json; charset=UTF-8",
				success:function(res){
					alert('저장되었습니다');
					
				},complete:function(){
					cwma.hideLoader();
				}
			});
		});

		//저장버튼 이벤트
		$('.btnUpd').click(function(e){
			var txt = '등록', act = 'insert.do';
			
			if($('#updFrm [name="menuSn"]').val() && Number($('#updFrm [name="menuSn"]').val())){
				txt = '수정';
				act = 'update.do';
			}else{
				$('#updFrm [name="menuSn"]').val(0);
			}
			
			if(!$('#updFrm [name="upperMenuSn"]').val())
				$('#updFrm [name="upperMenuSn"]').val(0);
			
			$('#updFrm').attr('action', act);
			$('#updFrm').ajaxCwma({
				success:function(res){
					alert(txt+'되었습니다');
					
					if(tree.getSelectedNodes()[0]){
						tree.getSelectedNodes()[0].name = $('#updFrm [name="menuNm"]').val() + ' - ('+$('#updFrm [name="menuDc"]').val()+')';
						tree.getSelectedNodes()[0].url = $('#updFrm [name="url"]').val();
						tree.getSelectedNodes()[0].menuNm = $('#updFrm [name="menuNm"]').val();
						tree.getSelectedNodes()[0].menuDc = $('#updFrm [name="menuDc"]').val();
						tree.getSelectedNodes()[0].css = $('#updFrm [name="css"]').val();
						tree.getSelectedNodes()[0].displayAt = $('#updFrm [name="displayAt"]:checked').val();
						tree.getSelectedNodes()[0].useAt = $('#updFrm [name="useAt"]:checked').val();
						tree.getSelectedNodes()[0].bassAuthorAt = $('#updFrm [name="bassAuthorAt"]:checked').val();
						
						if(act == 'insert.do')
							tree.getSelectedNodes()[0].menuSn = res.eo.menuSn;
						
						$('#updFrm')[0].reset();
						tree.refresh();
					}else{
						$('#btnSearch').click();
					}
				}
			});
			e.preventDefault();
			return false;
		});
	
		//조회버튼 클릭이벤트
		$('.btn_search').click(function(e){
			var node = tree.getNodesByParamFuzzy('name', $(this).prev().val(), null);
			tree.selectNode(node[0]);
			$('a.curSelectedNode').trigger('click');
			e.preventDefault();
			return false;
		});
		
		
		//엔터이벤트
		$('#frm input').on('keyup, keypress', function(e){
			if(e.keyCode == 13){
				$('.btn_search').click();
				
				e.preventDefault();
				return false;
			}
		});
		
		$('#btnSearch').click();
	});
</script>
</head>
<body>
<div class="data_wrap">
	<form action="list.do" id="frm" method="post">
		<input type="hidden" name="menuSn" value="0" />
		<button type="button" id="btnSearch" href="list.do" style="display:none">검색</button>
		
		<div class="data_wrap_half_left">
			<div class="ml20">시스템의 전체서비스 메뉴를 관리할 수 있습니다.</div>
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
							<input type="text" class="w70p" maxlength="30">
							<a href="#" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="vertical-align: top; height: 500px; overflow: auto;">
							<ul id="menuTree" class="ztree list" style="width:100%;height:500px;"></ul>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap mb20">
				<div class="fl txt_left">
					<a href="#" class="btn normal purple mr10 expandAll"><i class="far fa-folder-open mr5"></i> 전체펼침</a>
					<a href="#" class="btn normal purple mr10 collapseAll"><i class="far fa-folder mr5"></i> 전체닫기</a>
				</div>
				<div class="fr txt_right">
					<a href="#" class="btn normal blue btnSave"><i class="far fa-save mr5"></i> 구조저장</a>
				</div>
			</div>
		</div>
	</form>

	<form action="" id="updFrm" method="post">
		<input type="hidden" name="menuSn" value="" />
		<input type="hidden" name="upperMenuSn" value="" />
		<div class="data_wrap_half_right">
			<div class="ml20">&nbsp;</div>
			<table class="tbl tbl_form2">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" colspan="2" class="">Menu 상세정보</th>
					</tr>
					<tr>
						<th scope="row">메뉴명</th>
						<td><input type="text" name="menuNm" title="메뉴명" class="w100p" required></td>
					</tr>
					<tr>
						<th scope="row">URL</th>
						<td><input type="text" name="url" title="URL" class="w100p" required></td>
					</tr>
					<tr>
						<th scope="row">메뉴설명</th>
						<td><input type="text" name="menuDc" title="메뉴설명" class="w100p" required></td>
					</tr>
					<tr>
						<th scope="row">CSS 클래스명</th>
						<td><input type="text" name="css" title="CSS 클래스명" class="w100p"></td>
					</tr>
					<tr>
						<th scope="row">노출여부</th>
						<td>
							<label><input type="radio" name="displayAt" value="Y" checked="checked" title="노출여부" required><span></span>YES</label>
							<label><input type="radio" name="displayAt" value="N" title="노출여부"><span></span>NO</label>
						</td>
					</tr>
					<tr>
						<th scope="row">사용여부</th>
						<td>
							<label><input type="radio" name="useAt" value="Y" checked="checked" title="사용여부" required><span></span>YES</label>
							<label><input type="radio" name="useAt" value="N" title="사용여부"><span></span>NO</label>
						</td>
					</tr>
					<tr>
						<th scope="row">기본권한</th>
						<td>
							<label><input type="radio" name="bassAuthorAt" value="Y" checked="checked" title="기본권한" required><span></span>YES</label>
							<label><input type="radio" name="bassAuthorAt" value="N" title="기본권한"><span></span>NO</label>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap mb20">
				<div class="fl txt_left"></div>
				<div class="fr txt_right">
					<a href="#" class="btn normal blue btnUpd"><i class="far fa-save mr5"></i> 저장</a>
				</div>
			</div>
		</div>
	</form>
</div>
</body>
</html>
