<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>FILE FORM</title>
<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css" />
<script src="/js/jquery-3.1.1.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script type="text/javascript">
	
	var totalCnt = 0;
	var sendCnt = 0;
	var successCnt = 0;
	var errorCnt = 0;
	
	function goPage(url) {
		location.href = url;
	}
	
	$("document").ready(function(){
	    $("#folders").change(function(e) {
	    	var files = e.target.files;
	    	drawFileList(files);
	    });
	});
	
	function drawFileList(files){
		$("#tab").hide();
		var html = '';
		totalCnt = 0;
		
		if(files.length > 0){
			for (var i = 0, len = files.length; i < len; i++) {
	    		var file = files[i];
	    		var filePath = file.webkitRelativePath;
	    		var fileName = file.name;
	    		var fileByteSize = file.size;
	    		
	    		if(isUploadFile(filePath)) {
	    			html += '<tr>';
	        		html += '<td>'+(totalCnt+1)+'</td>';
	        		html += '<td>'+filePath+'</td>';
	        		html += '<td>'+fileName+'</td>';
	        		html += '<td>'+fileByteSize+'</td>';
	        		html += '<td id="fileState'+i+'">대기중</td>';
	        		html += '</tr>';
	        		totalCnt++;
	    		}
	    	}
			
			$("#fileList").empty();
			$("#fileList").append(html);
			$("#tab").show();
		}
	}
	
	// 프로그래스바 초기화
	function cleanProgressBar() {
		$("#proAreaSuc").attr("href", 0);
		$("#proAreaSuc").css("width", "0%");
		$("#proAreaSuc").text("0%");
		$("#proAreaErr").attr("href", 0);
		$("#proAreaErr").css("width", "0%");
		$("#proAreaErr").text("0%");
	}
	
	function sendFiles(){
		cleanProgressBar();
		
		sendCnt = 0;
		successCnt = 0;
		errorCnt = 0;
		
		for(var i=0; i<$("#folders").get(0).files.length; i++){
			var filePath = $("input[name=folders]")[0].files[i].webkitRelativePath;
			
			if(isUploadFile(filePath)) {
				var formData = new FormData();
				formData.append("path", $("input[name=folders]")[0].files[i].webkitRelativePath);
				formData.append("file", $("input[name=folders]")[0].files[i]);
				
				$.ajax({
					url: '/file/fileUpload.do',
					data: formData,
					processData: false,
					contentType: false,
					type: 'POST',
					success: function(args){
						var stateStr = "대기중";
						if (args.data.result == "success") {
							successCnt++;
							stateStr = "성공";
						} else {
							errorCnt++;
							stateStr = "실패";
						}
						$("#fileState"+sendCnt).text(stateStr);
						
						var successPercentage = parseInt(successCnt/totalCnt*100);
						var errorPercentage = parseInt(errorCnt/totalCnt*100);
						
						$("#proAreaSuc").attr("href", successPercentage);
						$("#proAreaSuc").css("width", successPercentage+"%");
						$("#proAreaSuc").text(successPercentage+"%");
						$("#proAreaErr").attr("href", errorPercentage);
						$("#proAreaErr").css("width", errorPercentage+"%");
						$("#proAreaErr").text(errorPercentage+"%");
						
						sendCnt++;
					},
					error: function(args){
						alert("오류가 발생하였습니다.");
					}
				});
			} else {
				// no action
			}
		}
	}
	
	function isUploadFile(filePath){
		if( filePath.indexOf("VOLTE") > -1 || filePath.indexOf("롱mp3벨") > -1 || filePath.indexOf("롱투유") > -1 || filePath.indexOf("실음원") > -1 || filePath.indexOf("컷팅벨") > -1 ) {
			return true;
		}else{
			return false;
		}
	}
	
</script>
</head>
<body>

<div class="container">
	
	<div class="page-header">
		<h1>${text }</h1>
	</div>
	
	<p>
		<label class="btn btn-default btn-file"><span class="glyphicon glyphicon-search"></span> 폴더선택<input type="file" id="folders" name="folders" style="display: none;" webkitdirectory mozdirectory ></label>
		<button type="button" class="btn btn-default" onClick="javascript:sendFiles();"><span class="glyphicon glyphicon-upload"></span> 업로드시작</button>
		<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');"><span class="glyphicon glyphicon-home"></span> 홈</button>
	</p>
	
	<div class="progress">
		<div class="progress-bar progress-bar-success progress-bar-striped active"  id="proAreaSuc" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">0%</div>
		<div class="progress-bar progress-bar-danger progress-bar-striped active"  id="proAreaErr" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">0%</div>
	</div>
	
	<table id="tab" class="table table-bordered table-hover" style="display: none;">
		<thead>
			<tr>
				<th>순번</th>
				<th>경로</th>
				<th>파일명</th>
				<th>크기(byte)</th>
				<th>상태</th>
			</tr>
		</thead>
		<tbody id="fileList">
		</tbody>
	</table>

</div>

</body>
</html>