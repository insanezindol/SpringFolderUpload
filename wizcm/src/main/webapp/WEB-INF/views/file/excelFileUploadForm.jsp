<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>FILE FORM</title>
<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css" />
<script src="/js/jquery-3.1.1.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<!-- excel parsing -->
<script type="text/javascript" src="/js/shim.js"></script>
<script type="text/javascript" src="/js/jszip.js"></script>
<script type="text/javascript" src="/js/xlsx.js"></script>
<script type="text/javascript" src="/js/dist/ods.js"></script>

<script type="text/javascript">
	var SHEET_NAME = "1"; // 파싱할 엑셀파일 내 시트 이름
	var FOLDER_ROOT_PATH = ""; // 폴더 루트 경로명
	var EXCEL_DATA = new Array(); // 엑셀을 파싱하여 나온 데이터
	var EXCEL_FILE_LIST = new Array(); // 엑셀을 파싱하여 나온 파일 경로+이름 배열
	var FOLDER_DATA = new Array(); // 폴더를 파싱하여 나온 데이터
	var FOLDER_FILE_LIST = new Array(); // 폴더를 파싱하여 나온 파일 경로+이름 배열
	var X = XLSX; // 엑셀 파싱에서 사용되는 변수

	$("document").ready(function() {
		// 엑셀선택 버튼 이벤트 리스너
		$("#xlfile").change(function(e) {
			try {
				var files = e.target.files;
				var f = files[0];
				var reader = new FileReader();
				var name = f.name;
				reader.onload = function(e) {
					var data = e.target.result;
					var arr = fixdata(data);
					wb = X.read(btoa(arr), {
						type : 'base64'
					});

					var workbook = exceltojson(wb);
					
					parseExcelFile(workbook);
					makeFileList();
					drawFileList();
				};
				reader.readAsArrayBuffer(f);
			} catch(err) {
				console.log(err.message);
			}
		});

		// 폴더선택 버튼 이벤트 리스너
		$("#folders").change(function(e) {
			var files = e.target.files;
			parseFolderFile(files);
			makeFolderList();
			drawFolderList();
		});
	});

	// 홈으로 이동하는 함수
	function goPage(url) {
		location.href = url;
	}

	// 엑셀 파싱에 사용되는 함수
	function fixdata(data) {
		var o = "", l = 0, w = 10240;
		for (; l < data.byteLength / w; ++l)
			o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
		o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
		return o;
	}

	// 엑셀을 파싱하여 json형태로 변환하는 함수
	function exceltojson(workbook) {
		var result = {};
		workbook.SheetNames.forEach(function(sheetName) {
			if (sheetName == SHEET_NAME) {
				// 엑셀 첫번째 시트의 이름이 1 이라서 그것만 읽음
				var roa = X.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
				if (roa.length > 0) {
					result[sheetName] = roa;
				}
			}
		});
		return result;
	}
	
	// 해당 폴더가 파싱해야 할 대상인지 구분하는 함수 (VOLTE, 롱mp3벨, 롱투유, 실음원, 컷팅벨)
	function isUploadFile(filePath) {
		if (filePath.indexOf("VOLTE") > -1 || filePath.indexOf("롱mp3벨") > -1 || filePath.indexOf("롱투유") > -1 || filePath.indexOf("실음원") > -1 || filePath.indexOf("컷팅벨") > -1) {
			return true;
		} else {
			return false;
		}
	}

	// 엑셀파일 파싱
	function parseExcelFile(workbook) {
		EXCEL_DATA = new Array();
		for (var i = 0; i < workbook[SHEET_NAME].length; i++) {
			var lid = workbook[SHEET_NAME][i]["LID"];
			var title = workbook[SHEET_NAME][i]["곡명"];
			var singer = workbook[SHEET_NAME][i]["가수명"];
			var album = workbook[SHEET_NAME][i]["앨범명"];
			var songcode = workbook[SHEET_NAME][i]["곡코드"];
			var lp = workbook[SHEET_NAME][i]["LP"];
			var filename = workbook[SHEET_NAME][i]["파일명"];
			var makingdate = workbook[SHEET_NAME][i]["제작일"];
			var path1 = workbook[SHEET_NAME][i]["경로1"];
			var path2 = workbook[SHEET_NAME][i]["경로2"];
			var lyrics1 = workbook[SHEET_NAME][i]["후렴가사"];
			var lyrics2 = workbook[SHEET_NAME][i]["앞가사"];
			var lyrics3 = workbook[SHEET_NAME][i]["뒤가사"];
			var genre = workbook[SHEET_NAME][i]["장르"];
			var cate = workbook[SHEET_NAME][i]["카테고리"];
			var cpcate = workbook[SHEET_NAME][i]["cp카테고리"];
			var gener = workbook[SHEET_NAME][i]["세대"];
			var ktfmenu = workbook[SHEET_NAME][i]["KTF별 메뉴"];
			var innercp = workbook[SHEET_NAME][i]["내부 CP 선택"];
			var top = workbook[SHEET_NAME][i]["대표"];
			var detail = workbook[SHEET_NAME][i]["세부"];
			var reserve = workbook[SHEET_NAME][i]["예약일시"];
			var inputs = workbook[SHEET_NAME][i]["입력"];
			
			var obj = {
					lid : lid,
					title : title,
					singer : singer,
					album : album,
					songcode : songcode,
					lp : lp,
					filename : filename,
					makingdate : makingdate,
					path1 : path1,
					path2 : path2,
					lyrics1 : lyrics1,
					lyrics2 : lyrics2,
					lyrics3 : lyrics3,
					genre : genre,
					cate : cate,
					cpcate : cpcate,
					gener : gener,
					ktfmenu : ktfmenu,
					innercp : innercp,
					top : top,
					detail : detail,
					reserve : reserve,
					inputs : inputs,
			}
			EXCEL_DATA[i] = obj;
		}
	}
	
	// 존재해야하는 파일 경로+이름 리스트를 만듬
	function makeFileList() {
		EXCEL_FILE_LIST = new Array();
		
		// 파일 리스트 만들기
		var fileIdx = 0;
		for (var i = 0; i < EXCEL_DATA.length; i++) {
			var lid = EXCEL_DATA[i].lid;
			var filename = EXCEL_DATA[i].filename;
			
			// VOLTE
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_후렴.awb2";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_후렴.awb";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_후렴.amr";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_앞.awb2";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_앞.awb";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_앞.amr";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_뒤.awb2";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_뒤.awb";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/VOLTE/" + filename + "_뒤.amr";

			// 롱mp3벨
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_후렴_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_후렴.wma";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_후렴.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_앞_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_앞.wma";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_앞.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_뒤_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_뒤.wma";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱mp3벨/" + filename + "_뒤.mp3";

			// 롱투유
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_후렴_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_후렴_60.wav";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_후렴_60.asf";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_후렴.ma3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_앞_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_앞_60.wav";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_앞_60.asf";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_앞.ma3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_뒤_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_뒤_60.wav";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_뒤_60.asf";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/롱투유/" + filename + "_뒤.ma3";

			// 실음원
			EXCEL_FILE_LIST[fileIdx++] = lid + "/실음원/" + filename + "_후렴_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/실음원/" + filename + "_후렴.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/실음원/" + filename + "_앞_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/실음원/" + filename + "_앞.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/실음원/" + filename + "_뒤_RE1.mp3";
			EXCEL_FILE_LIST[fileIdx++] = lid + "/실음원/" + filename + "_뒤.mp3";

			// 컷팅벨
			EXCEL_FILE_LIST[fileIdx++] = lid + "/컷팅벨/" + filename + ".mp3";
		}
	}
	
	// 파싱한 데이터를 출력함
	function drawFileList() {
		$("#accordion1").hide();
		
		// 첫번째 테이블 
		$("#tab1").hide();
		var html = '';
		for (var i = 0; i < EXCEL_DATA.length; i++) {
			html += '<tr>';
			html += '<td>' + (i + 1) + '</td>';
			html += '<td>' + EXCEL_DATA[i].lid + '</td>';
			html += '<td>' + EXCEL_DATA[i].filename + '</td>';
			html += '</tr>';
		}
		$("#tbody1").empty();
		$("#tbody1").append(html);
		$("#tab1").show();
		
		// 두번째 테이블 
		$("#tab2").hide();
		html = '';
		for (var i = 0; i < EXCEL_FILE_LIST.length; i++) {
			html += '<tr>';
			html += '<td>' + (i + 1) + '</td>';
			html += '<td>' + EXCEL_FILE_LIST[i] + '</td>';
			html += '</tr>';
		}
		$("#tbody2").empty();
		$("#tbody2").append(html);
		$("#tab2").show();
		
		$("#accordion1").text("[" + EXCEL_DATA.length + "개 음원] ["+EXCEL_FILE_LIST.length+"개 파일] [결과확인]");
		$("#accordion1").show();
	}

	// 폴더 하위 파싱
	function parseFolderFile(files){
		FOLDER_DATA = new Array();
		var totalCnt = 0;
		if (files.length > 0) {
			for (var i = 0; i < files.length; i++) {
				var file = files[i];
				var filePath = file.webkitRelativePath;
				var fileName = file.name;
				var fileByteSize = file.size;

				if (isUploadFile(filePath)) {
					var obj = {
							file : file,
							filePath : filePath,
							fileName : fileName,
							fileByteSize : fileByteSize,
					}
					FOLDER_DATA[totalCnt++] = obj;
				}
			}
		}
	}
	
	// 엑셀에서 만들어진 Path와 형태를 맞춰주기 위해 폴더의 Path를 변환하는 함수 
	function makeFolderList(){
		FOLDER_FILE_LIST = new Array();
		for ( var i = 0 ; i < FOLDER_DATA.length ; i++ ){
			var filePath = FOLDER_DATA[i].filePath;
			// 최상위 디렉토리명을 제외한 하위 경로명 추출
			FOLDER_FILE_LIST[i] = filePath.substring(filePath.indexOf("/") + 1);
			// 최상위 디렉토리 경로 추출
			FOLDER_ROOT_PATH = filePath.substring(0, filePath.indexOf("/"));
		}
	}
	
	// 파싱한 폴더내용을 출력함 
	function drawFolderList() {
		$("#accordion2").hide();
		
		// 세번째 테이블 
		$("#tab3").hide();
		var html = '';
		for (var i = 0; i < FOLDER_DATA.length; i++) {
			html += '<tr>';
			html += '<td>' + (i + 1) + '</td>';
			html += '<td>' + FOLDER_DATA[i].filePath + '</td>';
			html += '<td>' + FOLDER_DATA[i].fileName + '</td>';
			html += '<td>' + FOLDER_DATA[i].fileByteSize + '</td>';
			html += '</tr>';
		}
		$("#tbody3").empty();
		$("#tbody3").append(html);
		$("#tab3").show();
		
		$("#accordion2").text("[" + FOLDER_DATA.length + "개 파일] [결과확인]");
		$("#accordion2").show();
	}

	// 엑셀에서 파싱한 리스트를 기준으로 파일이 실제 존재하는지 확인하는 함수
	function compareFileList() {
		$("#accordion3").hide();
		$("#tab4").hide();
		var html = '';

		var totalCnt = 0;
		var successCnt = 0;
		var errorCnt = 0;
		
		// 화면 테이블 출력
		for (var i = 0; i < EXCEL_FILE_LIST.length; i++) {
			var existFlag = false;
			for (var j = 0; j < FOLDER_FILE_LIST.length; j++) {
				if (EXCEL_FILE_LIST[i] == FOLDER_FILE_LIST[j]) {
					existFlag = true;
					break;
				}
			}

			html += '<tr>';
			html += '<td>' + (i + 1) + '</td>';
			html += '<td>' + EXCEL_FILE_LIST[i] + '</td>';
			html += '<td>' + FOLDER_FILE_LIST[j] + '</td>';
			if (existFlag) {
				html += '<td class="bg-success">SUCCESS</td>';
				successCnt++;
			} else {
				html += '<td class="bg-danger">NOT EXIST</td>';
				errorCnt++;
			}
			html += '</tr>';
			totalCnt++;
		}

		$("#tbody4").empty();
		$("#tbody4").append(html);
		$("#tab4").show();
		$("#accordion3").text("[확인 : " + successCnt + "개] [미확인 : " + errorCnt + "개] [결과확인]");
		$("#accordion3").show();
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
	
	// 파일과 파일경로를 전송하는 함수
	function sendFiles(){
		cleanProgressBar();
		
		$("#accordion4").hide();
		$("#tab5").hide();
		$("#tbody5").empty();
		
		var totalCnt = EXCEL_FILE_LIST.length;
		var sendCnt = 0;
		var successCnt = 0;
		var errorCnt = 0;
		
		// 화면 테이블 출력
		for(var i=0; i<$("#folders").get(0).files.length; i++){
			var filePath = $("input[name=folders]")[0].files[i].webkitRelativePath;
			
			if(isUploadFile(filePath)) {
				var subFilePath = filePath.substring(filePath.indexOf("/") + 1);
				
				for (var j = 0; j < EXCEL_FILE_LIST.length; j++) {
					if (subFilePath == EXCEL_FILE_LIST[j]) {
						var path = $("input[name=folders]")[0].files[i].webkitRelativePath;
						var file = $("input[name=folders]")[0].files[i];
						var formData = new FormData();
						formData.append("path", path);
						formData.append("file", file);
						
						$.ajax({
							url: '/file/fileUpload.do',
							data: formData,
							processData: false,
							contentType: false,
							type: 'POST',
							async : true, // 한건씩 확인하기 위해 비동기 옵션 추가
							success: function(args){
								var html = '';
								html += '<tr>';
								html += '<td>' + (sendCnt + 1) + '</td>';
								html += '<td>' + args.data.path + '</td>';
								if (args.data.result == "success") {
									successCnt++;
									html += '<td class="bg-success">SUCCESS</td>';
								} else {
									errorCnt++;
									html += '<td class="bg-danger">FAIL</td>';
								}
								html += '</tr>';
								$("#tbody5").append(html);
								
								var successPercentage = parseInt(successCnt/totalCnt*100);
								var errorPercentage = parseInt(errorCnt/totalCnt*100);
								
								$("#proAreaSuc").attr("aria-valuenow", successPercentage);
								$("#proAreaSuc").css("width", successPercentage+"%");
								$("#proAreaSuc").text(successPercentage+"%");
								$("#proAreaErr").attr("aria-valuenow", errorPercentage);
								$("#proAreaErr").css("width", errorPercentage+"%");
								$("#proAreaErr").text(errorPercentage+"%");
								
								$("#accordion4").text("[완료 : " + successCnt + "개] [실패 : " + errorCnt + "개] [결과확인]");
								sendCnt++;
							},
							error: function(request,status,error){
								console.log("error : "+error);
							}
						});
					}
				}
			}
		}
		
		$("#tab5").show();
		$("#accordion4").show();
	}
	
	// 엑셀에서 파싱한 데이터를 전송하는 함수
	function sendData(){
		$("#accordion5").hide();
		$("#tab6").hide();
		$("#tbody6").empty();
		
		var sendCnt = 0;
		var successCnt = 0;
		var errorCnt = 0;
		
		for (var i = 0; i < EXCEL_DATA.length; i++) {
			var param = EXCEL_DATA[i];
			param.rootPath = FOLDER_ROOT_PATH; // 최상위 경로 추가
						
			var opts = {
				url : "/data/dataUpload.do",
				data : param,
				type : "POST",
				sendDataType : "form",
				async : false, // 한건씩 확인하기 위해 비동기 옵션 추가
				success : function(resJSON, resCode) {
					var html = '';
					html += '<tr>';
					html += '<td>' + (sendCnt + 1) + '</td>';
					html += '<td>' + param.singer + '</td>';
					html += '<td>' + param.title + '</td>';
					html += '<td>' + param.album + '</td>';
					html += '<td>' + param.filename + '</td>';
					if (resCode == "success") {
						if(resJSON.data.dbResult == "success"){
							html += '<td class="bg-success">SUCCESS</td>';
							if(resJSON.data.fileResult == "success"){
								html += '<td class="bg-success">SUCCESS</td>';
								successCnt++;
							} else {
								html += '<td class="bg-danger">FAIL</td>';
								errorCnt++;
							}
							
						} else {
							html += '<td class="bg-danger">FAIL</td>';
							if(resJSON.data.fileResult == "success"){
								html += '<td class="bg-success">SUCCESS</td>';
							} else {
								html += '<td class="bg-danger">FAIL</td>';
							}
							errorCnt++;
						}
					} else {
						errorCnt++;
						html += '<td class="bg-danger">FAIL</td>';
						html += '<td class="bg-danger">FAIL</td>';
					}
					html += '</tr>';
					$("#tbody6").append(html);
					$("#accordion5").text("[완료 : " + successCnt + "개] [실패 : " + errorCnt + "개] ");
					sendCnt++;
				},
				error: function(request,status,error){
					console.log("error:"+error);
				}
			};
			common.http.ajax(opts);
		}
		
		// 전체 복사를 성공했을때 임시폴더를 삭제
		var deleteResultText = "";
		if(successCnt == sendCnt){
			var opts = {
					url : "/data/dataDelete.do",
					type : "POST",
					sendDataType : "form",
					async : false, // 한건씩 확인하기 위해 비동기 옵션 추가
					success : function(resJSON, resCode) {
						if (resCode == "success") {
							if (resJSON.data.result == "success") {
								deleteResultText = "[임시폴더 삭제 성공]";
							} else {
								deleteResultText = "[임시폴더 삭제 실패-1]";
							}
						} else {
							deleteResultText = "[임시폴더 삭제 실패-2]";
						}
					},
					error: function(request,status,error){
						console.log("error:"+error);
					}
				};
				common.http.ajax(opts);
		}
		var accordion5Text = $("#accordion5").text() + deleteResultText + " [결과확인]";
		$("#accordion5").text(accordion5Text);
		
		$("#tab6").show();
		$("#accordion5").show();
	}
	
</script>
</head>
<body>

	<div class="container">

		<div class="page-header">
			<h1>${text }</h1>
		</div>

		<div class="panel-group" id="accordion">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4 class="panel-title">
						<label for="xlfile">1. </label> <label class="btn btn-default btn-file"><span class="glyphicon glyphicon-file"></span> 엑셀선택<input type="file" name="xlfile" id="xlfile" style="display: none;" /></label> <a id="accordion1" data-toggle="collapse" data-parent="#accordion" href="#collapse1" style="display:none;"></a>
					</h4>
				</div>
				<div id="collapse1" class="panel-collapse collapse">
					<div class="panel-body">
						<table id="tab1" class="table table-bordered table-hover" style="display: none;">
							<caption>1-1. 엑셀 파일 파싱 결과</caption>
							<thead>
								<tr>
									<th>순번</th>
									<th>LID</th>
									<th>파일명</th>
								</tr>
							</thead>
							<tbody id="tbody1">
							</tbody>
						</table>
						<table id="tab2" class="table table-bordered table-hover" style="display: none;">
							<caption>1-2. 존재해야하는 파일 리스트</caption>
							<thead>
								<tr>
									<th>순번</th>
									<th>경로</th>
								</tr>
							</thead>
							<tbody id="tbody2">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4 class="panel-title">
						<label for="folders">2. </label> <label class="btn btn-default btn-file"><span class="glyphicon glyphicon-folder-open"></span> 폴더선택<input type="file" id="folders" name="folders" style="display: none;" webkitdirectory mozdirectory></label> <a id="accordion2" data-toggle="collapse" data-parent="#accordion" href="#collapse2" style="display:none;"></a>
					</h4>
				</div>
				<div id="collapse2" class="panel-collapse collapse">
					<div class="panel-body">
						<table id="tab3" class="table table-bordered table-hover" style="display: none;">
							<caption>2-1. 폴더 파싱 결과</caption>
							<thead>
								<tr>
									<th>순번</th>
									<th>경로</th>
									<th>파일명</th>
									<th>크기(byte)</th>
								</tr>
							</thead>
							<tbody id="tbody3">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4 class="panel-title">
						<label for="btn3">3. </label> <button type="button" id="btn3" class="btn btn-default" onClick="javascript:compareFileList();"><span class="glyphicon glyphicon-duplicate"></span> 파일비교</button> <a id="accordion3" data-toggle="collapse" data-parent="#accordion" href="#collapse3" style="display:none;"></a>
					</h4>
				</div>
				<div id="collapse3" class="panel-collapse collapse">
					<div class="panel-body">
						<table id="tab4" class="table table-bordered table-hover" style="display: none;">
							<caption>3-1. 파일 비교 결과</caption>
							<thead>
								<tr>
									<th>순번</th>
									<th>엑셀 파싱 파일</th>
									<th>실제 폴더 파일</th>
									<th>상태</th>
								</tr>
							</thead>
							<tbody id="tbody4">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4 class="panel-title">
						<label for="btn4">4. </label> <button type="button" id="btn4" class="btn btn-default" onClick="javascript:sendFiles();"><span class="glyphicon glyphicon-upload"></span> 파일 업로드</button> <a id="accordion4" data-toggle="collapse" data-parent="#accordion" href="#collapse4" style="display:none;"></a>
					</h4>
				</div>
				<div id="collapse4" class="panel-collapse collapse">
					<div class="panel-body">
						<table id="tab5" class="table table-bordered table-hover" style="display: none;">
							<caption>4-1. 업로드 결과</caption>
							<thead>
								<tr>
									<th>순번</th>
									<th>파일</th>
									<th>상태</th>
								</tr>
							</thead>
							<tbody id="tbody5">
							</tbody>
						</table>
					</div>
				</div>
			</div>
			
			<div class="panel panel-default">
				<div class="panel-heading">
					<h4 class="panel-title">
						<label for="btn5">5. </label> <button type="button" id="btn5" class="btn btn-default" onClick="javascript:sendData();"><span class="glyphicon glyphicon-upload"></span> 곡정보 업로드</button> <a id="accordion5" data-toggle="collapse" data-parent="#accordion" href="#collapse5" style="display:none;"></a>
					</h4>
				</div>
				<div id="collapse5" class="panel-collapse collapse">
					<div class="panel-body">
						<table id="tab6" class="table table-bordered table-hover" style="display: none;">
							<caption>5-1. 업로드 결과</caption>
							<thead>
								<tr>
									<th>순번</th>
									<th>가수</th>
									<th>제목</th>
									<th>앨범</th>
									<th>파일이름</th>
									<th>DB INSERT</th>
									<th>FILE COPY</th>
								</tr>
							</thead>
							<tbody id="tbody6">
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</div>
		
		<div class="progress">
			<div class="progress-bar progress-bar-success progress-bar-striped active"  id="proAreaSuc" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">0%</div>
			<div class="progress-bar progress-bar-danger progress-bar-striped active"  id="proAreaErr" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width:0%">0%</div>
		</div>
		
		<div class="form-group">
			<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');">
				<span class="glyphicon glyphicon-home"></span> 홈
			</button>
		</div>
		
	</div>
		
</body>
</html>
