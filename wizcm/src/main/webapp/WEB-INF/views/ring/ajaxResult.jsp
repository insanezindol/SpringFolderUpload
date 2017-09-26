<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RING AJAX RESULT</title>
<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css" />
<script src="/js/jquery-3.1.1.min.js"></script>
<script type="text/javascript" src="/js/common.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	function goPage(url) {
		location.href = url;
	}

	var searchRing = function() {
		var lid = $("#lid").val();

		var param = {
			"lid" : lid
		};
		var opts = {
			url : "/data/getRingData.do",
			data : param,
			type : "post",
			sendDataType : "form",
			success : function(resJSON, resCode) {
				if (resCode == "success") {
					drawTable(resJSON.data);
				} else {
					alert("오류가 발생하였습니다.");
				}
			}
		};
		common.http.ajax(opts);
	}

	var drawTable = function(infos) {
		$("#tab").hide();

		var html = '';

		if (infos.length == 0) {
			html += '<td colspan="6">해당 데이터가 없습니다.</td>';
		} else {
			for (var i = 0; i < infos.length; i++) {
				html += '<tr>';
				html += '<td>' + infos[i].singer + '</td>';
				html += '<td>' + infos[i].title + '</td>';
				html += '<td>' + infos[i].ktf_lid + '</td>';
				html += '<td>' + infos[i].lring1 + '</td>';
				html += '<td>' + infos[i].lring2 + '</td>';
				html += '<td>' + infos[i].lring3 + '</td>';
				html += '</tr>';
			}
		}

		$("#resultArea").empty();
		$("#resultArea").append(html);
		$("#tab").show();
	}
</script>
</head>
<body>

<div class="container">

	<div class="page-header">
		<h1>${text }</h1>
	</div>
	
	<p>
		<input type="text" name="lid" id="lid" value="82158820" />
		<button type="button" class="btn btn-default" onClick="javascript:searchRing();"><span class="glyphicon glyphicon-search"></span> 조회</button>
		<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');"><span class="glyphicon glyphicon-home"></span> 홈</button>
	</p>
	
	<table id="tab" class="table table-bordered table-hover" style="display: none;">
		<thead>
			<tr>
				<th>가수</th>
				<th>곡명</th>
				<th>LID</th>
				<th>링코드(후렴)</th>
				<th>링코드(앞)</th>
				<th>링코드(뒤)</th>
			</tr>
		</thead>
		<tbody id="resultArea"></tbody>
	</table>
	
</div>
</body>
</html>