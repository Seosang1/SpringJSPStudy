cwma.file = function(param){
	//변수선언
	var parntsSe, parntsSn, frm, fileName, maxSize, maxMegaByte, allowExt, isFullSize;
	
	//변수값 초기화
	this.param = {
		parntsSe:'',
		parntsSn:0,
		frm:$('#frm'),
		fileLayer:$('#fileDiv'),
		fileName:'file',
		maxSize:5,
		maxMegaByte:10,
		isFullSize:false,
		allowExt:['HWP', 'XLS', 'PPT', 'DOC', 'XLSX', 'PPTX', 'DOCX', 'PDF', 'JPG', 'JPEG', 'GIF', 'BMP', 'PNG']
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
	maxMegaByte = this.param.maxMegaByte;
	allowExt = this.param.allowExt;
	isFullSize = this.param.isFullSize;
	
	//첨부파일삭제버튼 이벤트
	this.param.fileLayer.on('click', '.btnFileDel', function(e){
		if($(this).data('filesn')){
			frm.append('<input type="hidden" name="delFileVO['+$('[name$=".fileSn"]').length+'].parntsSe" value="'+parntsSe+'" />');
			frm.append('<input type="hidden" name="delFileVO['+$('[name$=".fileSn"]').length+'].parntsSn" value="'+parntsSn+'" />');
			frm.append('<input type="hidden" name="delFileVO['+$('[name$=".fileSn"]').length+'].fileSn" value="'+$(this).data('filesn')+'" />');
		}
		
		$(this).parent().remove();
		e.preventDefault();
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
			
			if(!$(this).next()[0]){
				idx = Number($('[id^='+fileName+'_]').attr('id').replace(/[^\d]/g,''))+1;
				
				str +='<img src="../../static/skill/img/icon-'+(ext.toLowerCase())+'.png" alt="'+ext.toLowerCase()+' 파일" />';
				str += this.files[0].name;
				str += '('+(size.formatMoney())+unit[cnt]+')';
				str += '<a href="#" class="btn small ml10 red btnFileDel" data-filesn="'+(this.fileSn?this.fileSn:'')+'"><i class="fas fa-eraser"></i></a>';
				
				$(this).parent().attr('class', 'mt5 mb5');
				$(this).parent().find('input, label').hide();
				$(this).parent().append(str);
				
				str = '<div class="input-group '+(isFullSize?'w-100':'w-50')+' mobile-w100">';
				str += '<input type="text" readonly="readonly" class="form-control" />';
				str += '<label for="'+fileName+'_'+(idx<10?'0':'')+idx+'" class="btn btn-main-ligt-gray2 ml-2">찾아보기</label>';
				str += '<input type="file" name="'+fileName+'" id="'+fileName+'_'+(idx<10?'0':'')+idx+'" style="display:none" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" title="첨부파일"/>';
				str += '</div>';
				$(this).parent().before(str);
			}
			
			
		}else{
			alert('업로드 불가능한 확장자입니다');
			$(this).val(null);
		}
		
		event.preventDefault();
		return false;
	});
	
	//파일목록조회
	this.setFileList = function(isEdit){
		//초기화
		var str = '', size = 0, cnt = 0;
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var fileLayer = this.param.fileLayer;
		
		if(parseInt(param.parntsSn) && param.parntsSe){
			$.ajax({
				url:contextPath+'/common/attchFileInfo/list.do',
				async:false,
				method:'post',
				data:{parntsSe:param.parntsSe, parntsSn:param.parntsSn},
				success:function(res){
					str += '';
					
					if(isEdit){
						str = '<div class="input-group '+(isFullSize?'w-100':'w-50')+' mobile-w100">';
						str += '<input type="text" readonly="readonly" class="form-control" />';
						str += '<label for="'+fileName+'_1" class="btn btn-main-ligt-gray2 ml-2">찾아보기</label>';
						str += '<input type="file" name="'+fileName+'" id="'+fileName+'_1" style="display:none" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" title="첨부파일" />';
						str += '</div>';
					}
					
					$(res.list).each(function(){
						size = this.size;
						
						for(cnt = 0;size>1024;cnt++)
						    size = size/1024;
						
						if(isEdit)
							str += '<div class="mt5 mb5">';
						else
							str += '<a href="'+contextPath+'/common/download.do?fileSn='+this.fileSn+'&parntsSn='+this.parntsSn+'&parntsSe='+this.parntsSe+'">';
						
						str +='<img src="../../static/skill/img/icon-'+(this.extsn.toLowerCase())+'.png" alt="'+this.extsn.toLowerCase()+' 파일" />';
						str += this.orginlFileNm;
						str += ' ('+(size.formatMoney())+unit[cnt]+')';
						
						if(isEdit)
							str += '<a href="#" class="btn small ml10 red btnFileDel" data-filesn="'+this.fileSn+'"><i class="fas fa-eraser"></i></a></div>';
						else
							str += '</a>';
					});
					
					
					
					
					if(isEdit){
						str += '<p class="w-100 mt-2 m-0">※ 첨부파일은 총 '+maxMegaByte+'MB까지 가능합니다.<br>';
						str += '※ 파일 형식은 '+allowExt.join(', ').toLocaleLowerCase()+'가 적합합니다.</p>';
					}
					
					fileLayer.html(str);
				}
			});
		}else{
			if(isEdit){
				str = '<div class="input-group '+(isFullSize?'w-100':'w-50')+' mobile-w100">';
				str += '<input type="text" readonly="readonly" class="form-control" />';
				str += '<label for="'+fileName+'_1" class="btn btn-main-ligt-gray2 ml-2">찾아보기</label>';
				str += '<input type="file" name="'+fileName+'" id="'+fileName+'_1" style="display:none" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" />';
				str += '</div>';
				
				str += '<p class="w-100 mt-2 m-0">※ 첨부파일은 총 '+maxMegaByte+'MB까지 가능합니다.<br>';
				str += '※ 파일 형식은 '+allowExt.join(', ').toLocaleLowerCase()+'가 적합합니다.</p>';
			}

			fileLayer.html(str);
		}
		
		if(!this.param.fileLayer.html().trim())
			this.param.fileLayer.parents('.board-read-file').hide();
		
	}
	
	//파일목록조회
	this.setFileList2 = function(){
		//초기화
		var str = '', size = 0, cnt = 0;
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var fileLayer = this.param.fileLayer;
		
		str = '<div class="input-group '+(isFullSize?'w-100':'w-50')+' mobile-w100">';
		str += '<input type="text" readonly="readonly" class="form-control" />';
		str += '<label for="'+fileName+'_1" class="btn btn-main-ligt-gray2 ml-2">찾아보기</label>';
		str += '<input type="file" name="file" id="'+fileName+'_1" style="display:none" accept="'+'.'+allowExt.join(',').toLocaleLowerCase().replace(/,/g, ',.')+'" />';
		str += '</div>';

		fileLayer.html(str);
		
		if(!this.param.fileLayer.html().trim())
			this.param.fileLayer.parents('.board-read-file').hide();
		
	}
	
	//설문조사용 파일목록조회
	this.setSurveyFileList = function(){
		//초기화
		var str = '', size = 0, cnt = 0;
		var unit = ['BYTE', 'KB', 'MB', 'GB'];
		var fileLayer = this.param.fileLayer;
		
		if(parseInt(param.parntsSn) && param.parntsSe){
			$.ajax({
				url:contextPath+'/common/attchFileInfo/list.do',
				async:false,
				method:'post',
				data:{parntsSe:param.parntsSe, parntsSn:param.parntsSn},
				success:function(res){
					str += '';
					
					$(res.list).each(function(){
						str += '<img src="'+contextPath+'/common/download.do?fileSn='+this.fileSn+'&parntsSn='+this.parntsSn+'&parntsSe='+this.parntsSe+'" class="survey-q-img">';
					});
					
					fileLayer.html(str);
				}
			});
		}
		
		if(!this.param.fileLayer.html().trim())
			this.param.fileLayer.parent().hide();
		
	}
	
	return this;
};
