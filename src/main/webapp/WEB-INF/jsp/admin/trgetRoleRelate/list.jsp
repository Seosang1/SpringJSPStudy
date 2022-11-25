<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<script type="text/javascript">
$(function(){
	//사용자폼 검색버튼 클릭 이벤트
	$('#frm .btn_search').click(function(e){
		$('#frm').attr('action', $(this).attr('href'));
		$('#frm').ajaxCwma({
			beforeValid:false,
			success:function(res){
				$('#userList').html('');
				
				$(res.list).each(function(){
					$('#userList').append('<li class="mt15"><label><input type="checkbox" name="trgetList" data-rolesn="'+this.roleSn+'" title="사용자" value="'+($('[name="se"]').val() == 'TRSE0001'?this.userId:this.deptCd)+'" required><span></span>'+($('[name="se"]').val() == 'TRSE0001'?this.userName:this.deptName)+'</label></li>');
				});
				
				$('[name="roleSn"]').prop('checked', false);
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	//사용자폼 엔터이벤트
	$('#frm [name="searchWord"]').on('keyup, keypress', function(e){
		if(e.keyCode == 13){
			$('#frm .btn_search').click();
			e.preventDefault();
			return false;
		}
	});
	
	//권한그룹폼 검색버튼 클릭 이벤트
	$('#roleFrm .btn_search').click(function(e){
		$('#roleFrm').attr('action', $(this).attr('href'));
		$('#roleFrm').ajaxCwma({
			success:function(res){
				$('#roleList').html('');
				
				$(res.list).each(function(){
					$('#roleList').append('<li class="mt15"><label><input type="radio" name="roleSn" value="'+this.roleSn+'"><span></span>'+this.roleNm+'</label></li>');
				});
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	
	//권한그룹폼 엔터이벤트
	$('#roleFrm [name="roleNm"]').on('keyup, keypress', function(e){
		if(e.keyCode == 13){
			$('#roleFrm .btn_search').click();
			e.preventDefault();
			return false;
		}
	});
	
	//사용자 선택 이벤트
	$('#userList').on('change', '[name="trgetList"]', function(){
		$('#roleList [value="'+$(this).data('rolesn')+'"]').prop('checked', true);
	});
	
	//사용자그룹변경 이벤트
	$('[name="se"]').change(function(){
		$('#frm .btn_search').click();
	});
	
	//권한부여버튼 클릭 이벤트
	$('#btnSetup').click(function(e){
		if($('#roleList [name="roleSn"]:checked').length)
			$('#frm [name="roleSn"]').val($('#roleList [name="roleSn"]:checked').val());
		else
			$('#frm [name="roleSn"]').val('');
		
		$('#frm').attr('action', $(this).attr('href'));
		$('#frm').ajaxCwma({
			success:function(res){
				alert('권한이 설정되었습니다');
			}
		});
		
		e.preventDefault();
		return false;
	});
	
	//삭제버튼 이벤트
	$('.btnDel').click(function(e){
		if($('[name="trgetList"]:checked').length){
			if(confirm('권한해제 하시겠습니까?')){
				$('#frm').attr('action', $(this).attr('href'));
				$('#frm').ajaxCwma({
					success:function(res){
						alert('권한해제 되었습니다');
						$('.btn_search').click();
					}
				});
			}
		}else{
			alert('권한해제 대상을 선택해주세요');
		}
		e.preventDefault();
		return false;
	});
	
	$('#frm .btn_search').click();
	$('#roleFrm .btn_search').click();
});
</script>
</head>
<body>
<div class="data_wrap">
	<form action="" method="post" id="frm">
		<input type="hidden" name="roleSn" value="0" required title="권한그룹"/>
		<div class="data_wrap_half_left">
			<div class="ml20">부서 및 개인관리자별 권한설정의 매칭기능을 제공합니다..</div>
			<table class="tbl tbl_form2">
				<colgroup>
					<col width="20%">
					<col width="80%">
				</colgroup>
				<tbody>
					<tr>
						<th scope="col" colspan="2" class="">관리자목록</th>
					</tr>
					<tr>
						<th scope="row">
							<select name="se">
								<option value="TRSE0001">관리자명</option>
								<option value="TRSE0002">부서</option>
							</select>
						</th>
						<td>
							<input type="text" class="w70p" name="searchWord">
							<a href="list.do" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
						</td>
					</tr>
					<tr>
						<td colspan="2" style="vertical-align: top; height: 500px; overflow: auto;">
							<ul id="userList" style="vertical-align: top; height: 490px;"></ul>
						</td>
					</tr>
				</tbody>
			</table>
			<div class="btn_wrap mb20">
				<div class="fl txt_left"></div>
				<div class="fr txt_right">
					<a id="btnSetup" href="update.do" class="btn normal blue"><i class="far fa-save mr5"></i> 권한저장</a>
					<a href="delete.do" class="btn normal red mr10 btnDel"><i class="far fa-trash-alt mr5"></i> 권한해제</a>
				</div>
			</div>
		</div>
	</form>
	
	<form action="" method="post" id="roleFrm">
		<div class="data_wrap_half_right">
			<div class="ml20">&nbsp;</div>
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
						<th scope="row">권한명</th>
						<td>
							<input type="text" class="w70p" name="roleNm" title="권한명">
							<a href="../roleInfo/list.do" class="btn btn_search"><i class="fas fa-search mr5"></i> 조회</a>
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
				<div class="fl txt_left"></div>
				<div class="fr txt_right"></div>
			</div>
		</div>
	</form>
</div>
</body>
</html>
