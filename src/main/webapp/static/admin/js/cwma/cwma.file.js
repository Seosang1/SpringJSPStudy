cwma.file = function(param){
	//변수선언
	var maxSize = 0, parntsSe, parntsSn, frm, fileName, allowExt;
	
	//변수값 초기화
	this.param = {
		parntsSe:'',
		parntsSn:0,
		frm:$('#frm'),
		fileLayer:$('#fileDiv'),
		fileName:'file',
		maxSize:5,
		allowExt:['JPEG','BMP','PNG','JPG','GIF','XLS','XLSX','HWP','DOC','DOCX','PDF']
	};
	
	if(param) $.extend(this.param, param);
	
	if(this.param.fileLayer){
		if($(this.param.fileLayer)[0])
			this.param.fileLayer = $(this.param.fileLayer);
		else if(this.param.fileLayer[0])
			this.param.fileLayer = this.param.fileLayer;
		else
			throw '파일 레이어를 찾을 수 없음 : ' + this.param.fileLayer;
	}
	
	parntsSe = this.param.parntsSe;
	parntsSn = this.param.parntsSn;
	frm = this.param.frm;
	fileName = this.param.fileName;
	maxSize = this.param.maxSize;
	allowExt = this.param.allowExt;
	
	//첨부파일삭제버튼 이벤트
	this.param.fileLayer.on('click', '.btnFileDel', function(){
		if($(this).data('filesn')){
			frm.append('<input type="hidden" name="delFileVO['+$('[name$=".fileSn"]').length+'].parntsSe" value="'+parntsSe+'" />');
			frm.append('<input type="hidden" name="delFileVO['+$('[name$=".fileSn"]').length+'].parntsSn" value="'+parntsSn+'" />');
			frm.append('<input type="hidden" name="delFileVO['+$('[name$=".fileSn"]').length+'].fileSn" value="'+$(this).data('filesn')+'" />');
		}
		
		$(this).parent().remove();
		event.preventDefault();
		return false;
	});
	
	//첨부파일 추가이벤트
	this.param.fileLayer.on('change', '[type="file"]', function(){
		var str = '', size = 0, cnt = 0, idx = 1;
		var ext, arr = $(this).val().split('.');
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var isAllowExt = false;
		
		if($(this).parent().parent().find('.btnFileDel').length >= maxSize){
			alert('최대 '+maxSize+'개까지 등록 가능합니다');
			$(this).val(null);
			event.preventDefault();
			return false;
		}
			
		if(arr.length > 1){
			ext = arr[arr.length-1];
			
			$(allowExt).each(function(){
				if(ext.toUpperCase() == this){
					isAllowExt = true;					
					return false;
				}
			});
		}
		
		if(isAllowExt){
			size = this.files[0].size;
			
			for(cnt = 0;size>1024;cnt++)
			    size = size/1024;
			
			//기본형
			if($(this).attr('id')){
				if(!$(this).next()[0]){
					idx = Number($('[id^='+fileName+'_]').attr('id').replace(/[^\d]/g,''))+1;
					
					str +='<img src="../../static/admin/images/file_icon/'+(ext.toLowerCase())+'.gif" />';
					str += this.files[0].name;
					str += '('+(size.formatMoney())+unit[cnt]+')';
					str += '<a href="#" class="btn small ml10 red btnFileDel" data-filesn="'+(this.fileSn?this.fileSn:'')+'"><i class="fas fa-eraser"></i></a>';
					
					$(this).parent().attr('class', 'mt5 mb5');
					$(this).parent().find('input, label').hide();
					$(this).parent().append(str);
					
					str = '<div class="input-file mt10">';
					str += '<input type="text" readonly="readonly" class="file-name" />';
					str += '<label for="'+fileName+'_'+(idx<10?'0':'')+idx+'" class="file-label">찾아보기</label>';
					str += '<input type="file" name="'+fileName+'" id="'+fileName+'_'+(idx<10?'0':'')+idx+'" class="file-upload" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" />';
					str += '</div>';
					$(this).parent().before(str);
				}
			
			//설문조사용
			}else{
				str = '<div class="input-file mt10">';
				str +='<img src="../../static/admin/images/file_icon/'+(ext.toLowerCase())+'.gif" />';
				str += this.files[0].name;
				str += '('+(size.formatMoney())+unit[cnt]+')';
				str += '<a href="#" class="btn small ml10 red btnFileDel" data-filesn="'+this.fileSn+'"><i class="fas fa-eraser"></i></a>';
				str += '</div>';
				$(this).parent().parent().append(str);
				
			}
			
		}else{
			alert('업로드 불가능한 확장자입니다');
			$(this).val(null);
		}
		
		event.preventDefault();
		return false;
	});
	
	this.setFileList = function(isEdit){
		//초기화
		var str = '', size = 0, cnt = 0;
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var fileLayer = this.param.fileLayer;
		
		if(isEdit){
			str += '<div class="input-file mt10">';
			str += '<input type="text" readonly="readonly" class="file-name" />';
			str += '<label for="'+fileName+'_01" class="file-label">찾아보기</label>';
			str += '<input type="file" name="'+fileName+'" id="'+fileName+'_01" class="file-upload" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" />';
			str += '</div>';
		}
		
		if(parseInt(param.parntsSn) && param.parntsSe){
			$.ajax({
				url:contextPath + '/common/attchFileInfo/list.do',
				async:false,
				method:'post',
				data:{parntsSe:param.parntsSe, parntsSn:param.parntsSn},
				success:function(res){
					str += '<div>';
					
					$(res.list).each(function(){
						size = this.size;
						
						for(cnt = 0;size>1024;cnt++)
						    size = size/1024;
						
						str += '<div class="mt5 mb5">';
						str +='<img src="../../static/admin/images/file_icon/'+(this.extsn.toLowerCase())+'.gif" />';
						str += '<a href="'+contextPath+'/common/download.do?fileSn='+this.fileSn+'&parntsSn='+this.parntsSn+'&parntsSe='+this.parntsSe+'">'+this.orginlFileNm+'</a>';
						str += '('+(size.formatMoney())+unit[cnt]+')';
						
						if(isEdit)
							str += '<a href="#" class="btn small ml10 red btnFileDel" data-filesn="'+this.fileSn+'"><i class="fas fa-eraser"></i></a>';
						
						str += '</div>';
					});
					str += '</div>';
					
					if(isEdit){
						str += '<div class="mt5 mb5">※ 첨부파일별 업로드 가능용량은 10Mb이며 최대 '+maxSize+'개까지 등록할 수 있습니다.</div>';
						str += '<div class="mt5 mb5">※ 파일 형식은 '+allowExt.join(',').toLocaleLowerCase()+'가 적합합니다.</div>';
					}
					
					fileLayer.html(str);
				}
			});
		}else{
			if(isEdit){
				str += '<div class="mt5 mb5">※ 첨부파일별 업로드 가능용량은 10Mb이며 최대 '+maxSize+'개까지 등록할 수 있습니다.</div>';
				str += '<div class="mt5 mb5">※ 파일 형식은 '+allowExt.join(',').toLocaleLowerCase()+'가 적합합니다.</div>';
			}
			
			fileLayer.html(str);
		}
		
	}
	
	this.setFileCnList = function(){
		//초기화
		var str = '', size = 0, cnt = 0;
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var fileLayer = this.param.fileLayer;
		
		if(parseInt(param.parntsSn) && param.parntsSe){
			$.ajax({
				url:contextPath + '/common/attchFileInfo/list.do',
				async:false,
				method:'post',
				data:{parntsSe:param.parntsSe, parntsSn:param.parntsSn},
				success:function(res){
					str += '<div>';
					
					$(res.list).each(function(){
						size = this.size;
						for(cnt = 0;size>1024;cnt++)
						    size = size/1024;
						str += '<div class="mt5 mb5">';
						str += '<p>파일이름 : '+ this.orginlFileNm + '</p>';
						str += '<p>파일 확장자 : '+ this.extsn.toLowerCase() + '</p>';
						str += '<p>파일 크기 : '+ '('+(size.formatMoney())+unit[cnt]+')' + '</p>';
						str += '<p>파일 링크 : <a href="'+ contextPath+'/common/download.do?fileSn='+this.fileSn+'&parntsSn='+this.parntsSn+'&parntsSe='+this.parntsSe + '"> '+ location.host+'/common/download.do?fileSn='+this.fileSn+'&parntsSn='+this.parntsSn+'&parntsSe='+this.parntsSe +' <a/></p>';
						str += '</div>';
						str += '<br>';
					});
					str += '</div>';
					
					fileLayer.html(str);
				}
			});
		}else{
		
		}
		
	}
	
	this.setSurveyFileList = function(isEdit){
		//초기화
		var str = '', size = 0, cnt = 0;
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var fileLayer = this.param.fileLayer;
		
		if(isEdit){
			str += '<label class="btn small ml10 purple">';
			str += '<input type="file" name="'+fileName+'" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" style="display:none" />';
			str += '<i class="far fa-images"></i></label>'
		}
		
		if(parseInt(param.parntsSn) && param.parntsSe){
			$.ajax({
				url:contextPath + '/common/attchFileInfo/list.do',
				async:false,
				method:'post',
				data:{parntsSe:param.parntsSe, parntsSn:param.parntsSn},
				success:function(res){
					str += '<div>';
					
					$(res.list).each(function(){
						size = this.size;
						
						for(cnt = 0;size>1024;cnt++)
						    size = size/1024;
						
						str += '<div class="mt5 mb5">';
						str +='<img src="../../static/admin/images/file_icon/'+(this.extsn.toLowerCase())+'.gif" />';
						str += '<a href="'+contextPath+'/common/download.do?fileSn='+this.fileSn+'&parntsSn='+this.parntsSn+'&parntsSe='+this.parntsSe+'">'+this.orginlFileNm+'</a>';
						str += '('+(size.formatMoney())+unit[cnt]+')';
						
						if(isEdit)
							str += '<a href="#" class="btn small ml10 red btnFileDel" data-filesn="'+this.fileSn+'"><i class="fas fa-eraser"></i></a>';
						
						str += '</div>';
					});
					str += '</div>';
					
					fileLayer.append(str);
				}
			});
			
		}else{
			fileLayer.append(str);
			
		}
		
	}
	
	return this;

};
