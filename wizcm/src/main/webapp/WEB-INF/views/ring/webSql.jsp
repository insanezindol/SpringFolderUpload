<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>WEB SQL</title>
<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css" />
<script src="/js/jquery-3.1.1.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	
	// scroll position
	var scrollXPosition = 0;
	
	function goPage(url) {
		location.href = url;
	}
	
	// page onload action
	$(function() {
		createDB();
		createTable();
		selectData();
		listChecked();
	});
	
	// db create
	var db;
	function createDB() {
		// 1 : name (ringDB)
		// 2 : version (1.0)
		// 3 : expression (ringDB)
		// 4 : size (10mb)
		db = window.openDatabase( "ringDB", "1.0", "ringDB", 1024 * 1024 * 10 );
	}
	
	// table create
	function createTable() {
		db.transaction(function(tx) {
			tx.executeSql("CREATE TABLE IF NOT EXISTS LID_LIST(LID, TITLE, SINGER, ALBUM)");
		});
	}
	
	// insert data
	function insertData(lid, title, singer, album) {
		db.transaction(function(tx) {
			tx.executeSql("INSERT INTO LID_LIST VALUES (?, ?, ?, ?)", [ lid, title, singer, album ]);
		});
	}
	
	// delete data
	function deleteData(lid) {
		db.transaction(function(tx) {
			tx.executeSql("DELETE FROM LID_LIST WHERE LID = ?", [ lid ]);
		});
	}
	
	// delete all data
	function deleteAllData() {
		db.transaction(function(tx) {
			tx.executeSql("DELETE FROM LID_LIST", []);
		});
	}
	
	// select data
	function selectData() {
		$("#chkedTbl").empty();
		db.transaction(function(tx) {
			tx.executeSql("SELECT * FROM LID_LIST", [], function(tx, result) {
				if (result.rows.length > 0) {
					for (var i = 0; i < result.rows.length; i++) {
						var row = result.rows.item(i);
						
						var html = '';
						html += '<tr>';
						html += '<td>';
						html += (i+1);
						html += '</td>';
						html += '<td>';
						html += row['LID'];
						html += '</td>';
						html += '<td>';
						html += row['TITLE'];
						html += '</td>';
						html += '<td>';
						html += row['SINGER'];
						html += '</td>';
						html += '<td>';
						html += row['ALBUM'];
						html += '</td>';
						html += '<td>';
						html += '<button type="button" class="btn btn-default btn-sm" onClick="javascript:removeViewElement(\''+row['LID']+'\');"><span class="glyphicon glyphicon-remove-sign"></span></button>';
						html += '</td>';
						html += '</tr>';
						
						$("#chkedTbl").append(html);
					}
				} else {
					var html = '<tr><td colspan="6" class="text-center">no data</td></tr>';
					$("#chkedTbl").append(html);
				}
				$( "body" ).scrollTop(scrollXPosition);
			});
		});
	}
	
	// main table list checkbox checked
	function listChecked() {
		db.transaction(function(tx) {
			tx.executeSql("SELECT * FROM LID_LIST", [], function(tx, result) {
				for (var i = 0; i < result.rows.length; i++) {
					var row = result.rows.item(i);
					$("input:checkbox[id='ch_"+row['LID']+"']").prop("checked", true);
				}
			});
		});
	}
	
	// main table list checkbox action
	function chkEvt(lid, title, singer, album) {
		if ($("#ch_" + lid).is(':checked')) {
			insertData(lid, title, singer, album);
		} else {
			deleteData(lid);
		}
		selectData();
	}
	
	// bottom table remove one data action 
	function removeViewElement(lid) {
		if ( confirm("Are you going to delete "+lid+" data?") ){
			scrollXPosition = $( "body" ).scrollTop();
			deleteData(lid);
			selectData();
			$("input:checkbox[id='ch_"+lid+"']").prop("checked", false);
		}
	}
	
	// bottom table remove all data action 
	function removeAllViewElement() {
		if ( confirm("Are you going to delete the entire data?") ){
			scrollXPosition = $( "body" ).scrollTop();
			deleteAllData();
			selectData();
			$("input:checkbox").prop('checked', false);
		}
	}
	
</script>
</head>
<body>

<div class="container">

	<div class="page-header">
		<h1>${text }</h1>
	</div>

	<table class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="text-center">추가</th>
				<th class="text-center">순번</th>
				<th class="text-center">가수</th>
				<th class="text-center">곡명</th>
				<th class="text-center">LID</th>
				<th class="text-center">앨범</th>
				<th class="text-center">링코드(후렴)</th>
				<th class="text-center">링코드(앞)</th>
				<th class="text-center">링코드(뒤)</th>
			</tr>
		</thead>
		<tbody>
	<c:choose>
		<c:when test="${fn:length(infos) == 0 }">
				<tr>
					<td colspan="6">해당 데이터가 없습니다.</td>
				</tr>
		</c:when>
		<c:otherwise>
			<c:forEach var="result" items="${infos}" varStatus="status">
				<tr>
					<td><input type="checkbox" name="ch_${result.ktf_lid }" id="ch_${result.ktf_lid }" value="${result.ktf_lid }" onChange="javascript:chkEvt('${result.ktf_lid }','${result.title }','${result.singer }','${result.realalbum }');"></td>
					<td>${result.rn }</td>
					<td>${result.singer }</td>
					<td>${result.title }</td>
					<td>${result.ktf_lid }</td>
					<td>${result.realalbum }</td>
					<td>${result.lring1 }</td>
					<td>${result.lring2 }</td>
					<td>${result.lring3 }</td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
		</tbody>
	</table>

	<ul class="pagination">
		<li class="previous"><a href="/ring/webSql.do?pageNo=${pageNavigator.firstPageNo }">First</a></li>
		<li class="previous"><a href="/ring/webSql.do?pageNo=${pageNavigator.prevPageNo }">Previous</a></li>
		<c:forEach var="i" varStatus="status" begin="${pageNavigator.startPageNo }" end="${pageNavigator.endPageNo }">
			<li <c:if test="${pageNavigator.pageNo == i }"> class="active"</c:if> ><a href="/ring/webSql.do?pageNo=${i }">${i }</a></li>
		</c:forEach>
		<li class="next"><a href="/ring/webSql.do?pageNo=${pageNavigator.nextPageNo }">Next</a></li>
		<li class="next"><a href="/ring/webSql.do?pageNo=${pageNavigator.finalPageNo }">Last</a></li>
	</ul>
	
	<P>
		<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');"><span class="glyphicon glyphicon-home"></span> 홈</button>
	</P>
	
	<div style="height: 300px !important; overflow: scroll;">
		<table class="table table-bordered table-hover" >
			<thead>
				<tr>
					<th class="text-center">순번</th>
					<th class="text-center">LID</th>
					<th class="text-center">곡명</th>
					<th class="text-center">가수</th>
					<th class="text-center">앨범</th>
					<th class="text-center"><button type="button" class="btn btn-default btn-sm" onClick="javascript:removeAllViewElement();"><span class="glyphicon glyphicon-remove-sign"></span></button></th>
				</tr>
			</thead>
			<tbody id="chkedTbl">
			</tbody>
		</table>
	</div>

</div>
</body>
</html>