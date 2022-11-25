//업로드 시작 시 호출됩니다.
var onStartUploadCu = function(){
}

//개별 파일에 대한 업로드 시작 시 호출됩니다.
var onStartUploadItemCu = function(rowIndex){
}

//개별 파일에 대한 업로드 완료 시 호출됩니다.
var onEndUploadItemCu = function(rowIndex){
}

//업로드 완료 시 호출됩니다.
var onEndUploadCu = function(){
}

//개별 파일에 대한 업로드 취소 시 호출됩니다.
var onCancelUploadItemCu = function(rowIndex){
}

CrossUploader = function(param){
	var fileLayer = '';
	//변수선언
	var namoCrossUploader = new __NamoCrossUploader();
	var managerProperties = new Object();
	var monitorProperties = new Object();
	
	//변수값 초기화
	this.param = {
		parntsSe:'',
		parntsSn:0,
		fileLayer:'fileDiv',
		maxSize:0,
		allowExt:['HWP', 'XLS', 'PPT', 'DOC', 'XLSX', 'PPTX', 'DOCX', 'PDF', 'JPG', 'JPEG', 'GIF', 'BMP', 'PNG'],
		uploader:null
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
	
	fileLayer = this.param.fileLayer;
	
	//파일UI 초기화
	managerProperties.width = '100%';
	managerProperties.height = '280';
	managerProperties.containerId = this.param.fileLayer;
	managerProperties.uploadButtonDisplayStyle = 'none';
	managerProperties.uploadUrl = contextPath + '/common/upload.do';
	//managerProperties.uploadUrl = contextPath + '/static/lib/crossUploader/Upload/LimitFileUpload/UploadProcess.jsp';

	monitorProperties.monitorLayerClass = 'monitorLayer';      // FileUploadMonitor 창의 스타일입니다. (namocrossuploader.css 파일에 정의, 변경 가능)
	monitorProperties.monitorBgLayerClass = 'monitorBgLayer';  // FileUploadMonitor 창의 백그라운드 스타일입니다. (namocrossuploader.css 파일에 정의, 변경 가능)
	monitorProperties.closeMonitorCheckBoxChecked = true;      // 전송 완료 후 FileUploadMonitor 창 닫기 설정

	var uploader = namoCrossUploader.createUploader(
		JSON.stringify(managerProperties),                          // FileUploadManager 프로퍼티를 JSON 문자열로 전달
		JSON.stringify(monitorProperties),                          // FileUploadMonitor 프로퍼티를 JSON 문자열로 전달
		JSON.stringify(window.namoCrossUploaderConfig.eventNames)
	); // 이벤트 이름을 JSON 문자열로 전달

	uploader.setFileFilter(this.param.allowExt.map(function(o){return '.'+o.toLowerCase()}).join(','));
	uploader.setAllowedFileExtension(this.param.allowExt.map(function(o){return o.toLowerCase()}).join(';'), 'FORWARD');
	
	if(this.param.maxSize)
		uploader.setMaxFileCount(this.param.maxSize);
	
	if(parseInt(this.param.parntsSn) && this.param.parntsSe){
		$.ajax({
			url:contextPath + '/common/attchFileInfo/list.do',
			async:false,
			method:'post',
			data:{parntsSe:this.param.parntsSe, parntsSn:this.param.parntsSn},
			success:function(res){
				$(res.list).each(function(){
	                var fileInfo = new Object();
	                fileInfo.fileId = this.fileSn;
	                fileInfo.fileSn = this.fileSn;
	                fileInfo.fileName = this.orginlFileNm;
	                fileInfo.fileSize = this.size;
	                fileInfo.parntsSn = this.parntsSn;
	                fileInfo.parntsSe = this.parntsSe;
	                uploader.addUploadedFile(JSON.stringify(fileInfo));
				});
			}
		});
	}
	
	uploader.addFile = function(){
		$('#'+fileLayer).find('[value="파일선택"]:eq(0)').click();
	}
	
	return uploader;
}

CrossDownloader = function(param){
	//변수선언
	var namoCrossUploader = new __NamoCrossUploader();
	var managerProperties = new Object();
	
	//변수값 초기화
	this.param = {
		parntsSe:'',
		parntsSn:0,
		fileLayer:'fileDiv'
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
	
	//파일UI 초기화
	managerProperties.width = '100%';
	managerProperties.height = '280';
	managerProperties.containerId = this.param.fileLayer;
	managerProperties.uiMode = 'SINGLE';                  // FileDownloadManager UI 모드 설정
	managerProperties.downloadUrl = contextPath + '/common/download.do';
	
	var downloader = namoCrossUploader.createDownloader(JSON.stringify(managerProperties));
	
	if(parseInt(this.param.parntsSn) && this.param.parntsSe){
		$.ajax({
			url:contextPath + '/common/attchFileInfo/list.do',
			async:false,
			method:'post',
			data:{parntsSe:this.param.parntsSe, parntsSn:this.param.parntsSn},
			success:function(res){
				$(res.list).each(function(){
	                var fileInfo = new Object();
	                fileInfo.fileId = this.fileSn;
	                fileInfo.fileSn = this.fileSn;
	                fileInfo.fileName = this.orginlFileNm;
	                fileInfo.fileSize = this.size;
	                fileInfo.parntsSn = this.parntsSn;
	                fileInfo.parntsSe = this.parntsSe;
	                fileInfo.fileUrl = managerProperties.downloadUrl;
	                downloader.addFile(JSON.stringify(fileInfo));
				});
				
				downloader.scrollRow(0); // 첫번째 파일 위치로 스크롤 이동
			}
		});
	}
	
	this.crossUploader = namoCrossUploader;
	this.downloader = downloader;
	
	return this;
}
