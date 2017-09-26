<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	var successCnt = 0;
	var errorCnt = 0;
	
	var SPLIT_LID_NUM = 2;
	var SPLIT_PATH_NUM = 4;
	
	var UPLOAD_POSSIBLE_LID = new Array(); // 업로드 가능한 LID 배열
	
	function goPage(url) {
		location.href = url;
	}
	
	$("document").ready(function(){
		// 파일 객체 이벤트
	    $("#folders").change(function(e) {
	    	var files = e.target.files;
	    	drawFileList(files);
	    });
	});
	
	// 폴더를 선택하면 실행되는 함수
	function drawFileList(files){
		$("#tab1").hide();
		$("#tab2").hide();
		$("#fileList1").empty();
		$("#fileList2").empty();
		
		// 파일 디렉토리 구조화
		console.log("[BEG] 파일 디렉토리 구조화");
		var FOLDER_LID_DATA = new Array(); // 폴더내 존재하는 LID별 폴더 구조 배열
		var FOLDER_LID_DATA_IDX = 0; // 폴더내 존재하는 LID별 폴더 구조 배열 인덱스
		
		if(files.length > 0){
			for (var i = 0, len = files.length; i < len; i++) {
	    		var file = files[i];
	    		var filePath = file.webkitRelativePath;
    			var filePathLid = filePath.split("/")[SPLIT_LID_NUM];
    			if (filePathLid.length == 8) {
    				if ( filePath.indexOf("Thumbs.db") > -1 ) {
    					// Thumbs.db 있으면 PASS
    				} else {
    					var filePathName = filePath.split("/")[SPLIT_PATH_NUM].substring(0,16);
    					var directoryPath = filePath.split("/")[0] + " > " + filePath.split("/")[1];
    		    		FOLDER_LID_DATA[FOLDER_LID_DATA_IDX++] = filePathLid + "," + filePathName + "," + directoryPath;
    				}
	    		}
	    	}
		}
		console.log("[END] 파일 디렉토리 구조화");
		
		
		// array 중복 제거
		console.log("[BEG] array 중복 제거");
		var FOLDER_LID_UNIQ_DATA = new Array(); // 중복 제거한 폴더내 존재하는 LID별 폴더 구조 배열
		
		FOLDER_LID_UNIQ_DATA = FOLDER_LID_DATA.reduce(function(a,b){
			if (a.indexOf(b) < 0 ) a.push(b);
			return a;
		},[]);
		console.log("[END] array 중복 제거");
		
		
		// 아이폰벨 파일 리스트 만들기
		console.log("[BEG] 아이폰벨 파일 리스트 만들기");
		var UPLOAD_POSSIBLE_FILE_LIST= new Array(); // 아이폰 벨소리 파일 리스트
		var UPLOAD_POSSIBLE_FILE_LIST_IDX = 0; // 아이폰 벨소리 파일 리스트 인덱스
		
		if(files.length > 0){
			for (var i = 0, len = files.length; i < len; i++) {
	    		var file = files[i];
	    		var filePath = file.webkitRelativePath;
	    		var fileName = file.name;
	    		if(isUploadFile(filePath)) {
	    			UPLOAD_POSSIBLE_FILE_LIST[UPLOAD_POSSIBLE_FILE_LIST_IDX++] = filePath;
	    		}
	    	}
		}
		console.log("[END] 아이폰벨 파일 리스트 만들기");
		
		
		// 아이폰 벨 확인
		console.log("[BEG] 아이폰 벨 확인");
		UPLOAD_POSSIBLE_LID = new Array(); // 업로드 가능한 LID 배열
		var lidExistCnt = 0; // 아이폰벨이 모두 존재하는 카운트
		var lidNotExistCnt = 0; // 아이폰벨이 하나라도 존재하지 않는 카운트
		
		for(var i = 0; i<FOLDER_LID_UNIQ_DATA.length; i++){
			var filePathLid = FOLDER_LID_UNIQ_DATA[i].split(",")[0];
    		var filePathName = FOLDER_LID_UNIQ_DATA[i].split(",")[1];
    		var directoryPath = FOLDER_LID_UNIQ_DATA[i].split(",")[2];
    		
    		var iph_bell_exist_cnt = 0;
    		for(var j = 0; j<UPLOAD_POSSIBLE_FILE_LIST.length; j++){
    			if( UPLOAD_POSSIBLE_FILE_LIST[j].indexOf(filePathLid + "/아이폰벨/" + filePathName + "_뒤.m4r") > -1 || UPLOAD_POSSIBLE_FILE_LIST[j].indexOf(filePathLid + "/아이폰벨/" + filePathName + "_앞.m4r") > -1 || UPLOAD_POSSIBLE_FILE_LIST[j].indexOf(filePathLid + "/아이폰벨/" + filePathName + "_후렴.m4r") > -1 ) {
    				iph_bell_exist_cnt++;
    			}
    		}
    		
    		var html = '';
    		if (iph_bell_exist_cnt == 3) {
    			UPLOAD_POSSIBLE_LID[lidExistCnt] = filePathLid;
    			
    			html += '<tr>';
    			html += '<td>'+(++lidExistCnt)+'</td>';
    			html += '<td>'+filePathLid+'</td>';
        		html += '<td>'+filePathName+'</td>';
        		html += '<td>'+directoryPath+'</td>';
        		html += '<td id="fileState'+filePathLid+'">등록 가능합니다.</td>';
        		html += '</tr>';
        		
    			$("#fileList1").append(html);
    		} else {
    			html += '<tr>';
    			html += '<td>'+(++lidNotExistCnt)+'</td>';
    			html += '<td>'+filePathLid+'</td>';
        		html += '<td>'+filePathName+'</td>';
        		html += '<td>'+directoryPath+'</td>';
        		html += '<td id="fileState'+filePathLid+'">'+(3-iph_bell_exist_cnt)+'개의 파일이 존재하지 않습니다.</td>';
        		html += '</tr>';
        		
    			$("#fileList2").append(html);
    		}
		}
		console.log("[END] 아이폰 벨 확인");
		
		// 해당 테이블의 데이터가 없을때
		if(lidExistCnt == 0){
			$("#fileList1").append('<tr><td colspan="5" class="text-center">해당 데이터 없음</td></tr>');
		}
		if(lidNotExistCnt == 0){
			$("#fileList2").append('<tr><td colspan="5" class="text-center">해당 데이터 없음</td></tr>');
		}
		
		$("#tab1").show();
		$("#tab2").show();
	}
	
	// 업로드할 전체 파일 건수 확인
	function getTotalUploadFileCount() {
		totalCnt = 0;
		var files = $("#folders").get(0).files;
		if(files.length > 0){
			for (var i = 0, len = files.length; i < len; i++) {
	    		var file = files[i];
	    		var filePath = file.webkitRelativePath;
	    		if(isUploadFile(filePath)) {
	    			if(isPossibleLid(filePath)) {
	    				totalCnt++;
	    			}
				}
	    	}
		}
	}
	
	// 파일 전송
	function sendFiles(){
		getTotalUploadFileCount();
		var timeStamp = getTimeStamp();
		
		$("#fileList3").empty();
		$("#fileList4").empty();
		
		successCnt = 0;
		errorCnt = 0;
		
		for(var i=0; i<$("#folders").get(0).files.length; i++){
			var filePath = $("input[name=folders]")[0].files[i].webkitRelativePath;
			if(isUploadFile(filePath)) {
				if(isPossibleLid(filePath)) {
					var formData = new FormData();
					formData.append("timeStamp", timeStamp);
					formData.append("path", $("input[name=folders]")[0].files[i].webkitRelativePath);
					formData.append("file", $("input[name=folders]")[0].files[i]);
					
					$.ajax({
						url: '/file/fileUpload.do',
						data: formData,
						processData: false,
						contentType: false,
						type: 'POST',
						async: false, // 동기로해야만 ajax error에서 파일명을 잡을수 있음
						success: function(args){
							var resultViewHtml = '';
							var filePathLid = filePath.split("/")[SPLIT_LID_NUM];
							var filePathName = filePath.split("/")[SPLIT_PATH_NUM].substring(0,16);
							
							if (args.data.result == "success") {
								resultViewHtml += '<tr>';
								resultViewHtml += '<td>' + (successCnt+1) + '</td>';
								resultViewHtml += '<td>' + filePathLid + '</td>';
								resultViewHtml += '<td>' + filePathName + '</td>';
								resultViewHtml += '<td>' + filePath + '</td>';
								resultViewHtml += '<td>성공</td>';
								resultViewHtml += '</tr>';
								
								$("#fileList3").append(resultViewHtml);
								successCnt++;
							} else {
								resultViewHtml += '<tr>';
								resultViewHtml += '<td>' + (errorCnt+1) + '</td>';
								resultViewHtml += '<td>' + filePathLid + '</td>';
								resultViewHtml += '<td>' + filePathName + '</td>';
								resultViewHtml += '<td>' + filePath + '</td>';
								resultViewHtml += '<td>실패</td>';
								resultViewHtml += '</tr>';
								
								$("#fileList4").append(resultViewHtml);
								errorCnt++;
							}
						},
						error: function(args){
							var resultViewHtml = '';
							var filePathLid = filePath.split("/")[SPLIT_LID_NUM];
							var filePathName = filePath.split("/")[SPLIT_PATH_NUM].substring(0,16);
							
							resultViewHtml += '<tr>';
							resultViewHtml += '<td>' + (errorCnt+1) + '</td>';
							resultViewHtml += '<td>' + filePathLid + '</td>';
							resultViewHtml += '<td>' + filePathName + '</td>';
							resultViewHtml += '<td>' + filePath + '</td>';
							resultViewHtml += '<td>실패</td>';
							resultViewHtml += '</tr>';
							
							$("#fileList4").append(resultViewHtml);
							errorCnt++;
						}
					});
				}
			} else {
				// no action
			}
		}
		
		// 해당 테이블의 데이터가 없을때
		if($("#fileList3").html() == ""){
			$("#fileList3").append('<tr><td colspan="5" class="text-center">해당 데이터 없음</td></tr>');
		}
		if($("#fileList4").html() == ""){
			$("#fileList4").append('<tr><td colspan="5" class="text-center">해당 데이터 없음</td></tr>');
		}
		
		$("#resultWells").empty();
		var resultWellsHtml = '';
		resultWellsHtml += '전체 ' + totalCnt + ' 건<br>';
		resultWellsHtml += '성공 ' + successCnt + '건 <button type="button" class="btn btn-success" onClick="javascript:viewSuccessList();">성공 목록</button><br>';
		resultWellsHtml += '실패 ' + errorCnt + '건 <button type="button" class="btn btn-danger" onClick="javascript:viewFailList();">실패 목록</button>';
		$("#resultWells").html(resultWellsHtml);
		
		$("#preparePageDiv").hide();
		$("#resultPageDiv").show();
	}
	
	// 업로드 해야하는 폴더 구별
	function isUploadFile(filePath){
		if( filePath.indexOf("Thumbs.db") > -1 ) {
			return false;
		} else {
			if( filePath.indexOf("아이폰벨") > -1 ) {
				return true;
			}else{
				return false;
			}
		}
	}
	
	// 업로드 가능한 LID 구별
	function isPossibleLid(filePath){
		var isPossible = false;
		for(var i = 0; i<UPLOAD_POSSIBLE_LID.length; i++){
			if( filePath.indexOf(UPLOAD_POSSIBLE_LID[i]) > -1 ) {
				isPossible = true;
			}
		}
		return isPossible;
	}
	
	// 전송 성공 리스트 보기
	function viewSuccessList() {
		$("#tab4").hide();
		$("#tab3").show();
	}
	
	// 전송 실패 리스트 보기
	function viewFailList() {
		$("#tab3").hide();
		$("#tab4").show();
	}
	
	// 현재 시각 구하기 yyyymmddhh24miss
	function getTimeStamp() {
		now = new Date();
		year = "" + now.getFullYear();
		month = "" + (now.getMonth() + 1); if (month.length == 1) { month = "0" + month; }
		day = "" + now.getDate(); if (day.length == 1) { day = "0" + day; }
		hour = "" + now.getHours(); if (hour.length == 1) { hour = "0" + hour; }
		minute = "" + now.getMinutes(); if (minute.length == 1) { minute = "0" + minute; }
		second = "" + now.getSeconds(); if (second.length == 1) { second = "0" + second; }
		return year + month + day + hour + minute + second;
	}
	
</script>
</head>
<body>

<div class="container">
	
	<div class="page-header">
		<h1>${text }</h1>
	</div>
	
	<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');"><span class="glyphicon glyphicon-home"></span> 홈</button>
	
	<div id="preparePageDiv">
		<p>
			<label class="btn btn-default btn-file"><span class="glyphicon glyphicon-search"></span> 폴더선택<input type="file" id="folders" name="folders" style="display: none;" webkitdirectory mozdirectory ></label>
			<button type="button" class="btn btn-default" onClick="javascript:sendFiles();"><span class="glyphicon glyphicon-upload"></span> 업로드시작</button>
		</p>
	    
		<table id="tab1" class="table table-bordered table-hover" style="display: none;">
			<caption>등록 가능 음원</caption>
			<thead>
				<tr>
					<th>순번</th>
					<th>LID</th>
					<th>파일명</th>
					<th>파일 경로</th>
					<th>등록 가능 확인</th>
				</tr>
			</thead>
			<tbody id="fileList1">
			</tbody>
		</table>
		
		<table id="tab2" class="table table-bordered table-hover" style="display: none;">
			<caption>등록 불가 음원</caption>
			<thead>
				<tr>
					<th>순번</th>
					<th>LID</th>
					<th>파일명</th>
					<th>파일 경로</th>
					<th>등록 가능 확인</th>
				</tr>
			</thead>
			<tbody id="fileList2">
			</tbody>
		</table>
	</div>

	<div id="resultPageDiv" style="display: none;">
		<div class="well" id="resultWells"></div>
	
		<table id="tab3" class="table table-bordered table-hover" style="display: none;">
			<caption>전송 성공 리스트</caption>
			<thead>
				<tr>
					<th>순번</th>
					<th>LID</th>
					<th>파일명</th>
					<th>파일 경로</th>
					<th>성공/실패</th>
				</tr>
			</thead>
			<tbody id="fileList3">
			</tbody>
		</table>
	
		<table id="tab4" class="table table-bordered table-hover" style="display: none;">
			<caption>전송 실패 리스트</caption>
			<thead>
				<tr>
					<th>순번</th>
					<th>LID</th>
					<th>파일명</th>
					<th>파일 경로</th>
					<th>성공/실패</th>
				</tr>
			</thead>
			<tbody id="fileList4">
			</tbody>
		</table>
	</div>
	
</div>

</body>
</html>