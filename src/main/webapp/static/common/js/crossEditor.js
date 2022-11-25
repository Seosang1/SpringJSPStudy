CrossEditor = function(param){
	//변수값 초기화
	this.param = {
		name:'editor',
		layer:$('#editor')
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
	
	var editor = new NamoSE(this.param.name);
	editor.params.AllowContentIframe = false;
	editor.params.AllowContentScript = false;
	editor.params.SetFocus = false;
	editor.params.ParentEditor = this.param.layer.get()[0];
	editor.params.Width = '100%';
	editor.params.ImageSavePath = '/upload';
	editor.editorStart();
	this.param.layer.show();
	
	return editor;
}
