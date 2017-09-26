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
<!-- excel parsing -->
<script type="text/javascript" src="/js/shim.js"></script>
<script type="text/javascript" src="/js/jszip.js"></script>
<script type="text/javascript" src="/js/xlsx.js"></script>
<script type="text/javascript" src="/js/dist/ods.js"></script>

<script type="text/javascript">

	var SHEET_NAME = "1";

	function goPage(url) {
		location.href = url;
	}
	
	var X = XLSX;
	
	function fixdata(data) {
		var o = "", l = 0, w = 10240;
		for(; l<data.byteLength/w; ++l) o+=String.fromCharCode.apply(null,new Uint8Array(data.slice(l*w,l*w+w)));
		o+=String.fromCharCode.apply(null, new Uint8Array(data.slice(l*w)));
		return o;
	}
	
	function exceltojson(workbook) {
		var result = {};
		workbook.SheetNames.forEach(function(sheetName) {
			if(sheetName == SHEET_NAME){
				// 엑셀 첫번째 시트의 이름이 1 이라서 그것만 읽음
				var roa = X.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
				if(roa.length > 0){
					result[sheetName] = roa;
				}
			}
		});
		return result;
	}
	
	function printToTable(workbook){
		$("#tab").hide();
		var html = '';
		
		for(var i=0; i<workbook[SHEET_NAME].length; i++){
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
			var cate1 = workbook[SHEET_NAME][i]["카테고리"];
			var cpcate1 = workbook[SHEET_NAME][i]["cp카테고리"];
			var cate2 = workbook[SHEET_NAME][i]["카테고리"];
			var cpcate2 = workbook[SHEET_NAME][i]["cp카테고리"];
			var gener = workbook[SHEET_NAME][i]["세대"];
			var ktfmenu = workbook[SHEET_NAME][i]["KTF별 메뉴"];
			var innercp = workbook[SHEET_NAME][i]["내부 CP 선택"];
			var top = workbook[SHEET_NAME][i]["대표"];
			var detail = workbook[SHEET_NAME][i]["세부"];
			var reserve = workbook[SHEET_NAME][i]["예약일시"];
			var inputs = workbook[SHEET_NAME][i]["입력"];
			
			html += '<tr>';
			html += '<td>'+lid+'</td>';
			html += '<td>'+title+'</td>';
			html += '<td>'+singer+'</td>';
			html += '<td>'+album+'</td>';
			html += '<td>'+songcode+'</td>';
			html += '<td>'+lp+'</td>';
			html += '<td>'+filename+'</td>';
			html += '<td>'+makingdate+'</td>';
			html += '<td>'+path1+'</td>';
			html += '<td>'+path2+'</td>';
			html += '<td>'+lyrics1+'</td>';
			html += '<td>'+lyrics2+'</td>';
			html += '<td>'+lyrics3+'</td>';
			html += '<td>'+genre+'</td>';
			html += '<td>'+cate1+'</td>';
			html += '<td>'+cpcate1+'</td>';
			html += '<td>'+cate2+'</td>';
			html += '<td>'+cpcate2+'</td>';
			html += '<td>'+gener+'</td>';
			html += '<td>'+ktfmenu+'</td>';
			html += '<td>'+innercp+'</td>';
			html += '<td>'+top+'</td>';
			html += '<td>'+detail+'</td>';
			html += '<td>'+reserve+'</td>';
			html += '<td>'+inputs+'</td>';
			html += '</tr>';
		}
		
		$("#tbody").empty();
		$("#tbody").append(html);
		$("#tab").show();
	}
	
	$("document").ready(function(){
	    $("#xlf").change(function(e) {
	    	var files = e.target.files;
			var f = files[0];
			{
				var reader = new FileReader();
				var name = f.name;
				reader.onload = function(e) {
					var data = e.target.result;
					var arr = fixdata(data);
					wb = X.read(btoa(arr), {type: 'base64'});
					
					var workbook = exceltojson(wb);
					printToTable(workbook);
				};
				reader.readAsArrayBuffer(f);
			}
	    });
	});
	
</script>
</head>
<body>

<div class="container">
	
	<div class="page-header">
		<h1>${text }</h1>
	</div>
	
	<p>
		<label class="btn btn-default btn-file"><span class="glyphicon glyphicon-search"></span> 엑셀선택<input type="file" name="xlfile" id="xlf" style="display: none;" /></label>
		<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');"><span class="glyphicon glyphicon-home"></span> 홈</button>
	</p>
	
	<table id="tab" class="table table-bordered table-hover" style="display: none;">
		<thead>
			<tr>
				<th>LID</th>
				<th>곡명</th>
				<th>가수명</th>
				<th>앨범명</th>
				<th>곡코드</th>
				<th>LP</th>
				<th>파일명</th>
				<th>제작일</th>
				<th>경로1</th>
				<th>경로2</th>
				<th>후렴가사</th>
				<th>앞가사</th>
				<th>뒤가사</th>
				<th>장르</th>
				<th>카테고리</th>
				<th>cp카테고리</th>
				<th>카테고리</th>
				<th>cp카테고리</th>
				<th>세대</th>
				<th>KTF별 메뉴</th>
				<th>내부 CP 선택</th>
				<th>대표</th>
				<th>세부</th>
				<th>예약일시</th>
				<th>입력</th>
			</tr>
		</thead>
		<tbody id="tbody">
		</tbody>
	</table>

</div>

</body>
</html>