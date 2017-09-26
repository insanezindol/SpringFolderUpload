<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>RING RESULT</title>
<link rel="stylesheet" href="/bootstrap/css/bootstrap.min.css" />
<script src="/js/jquery-3.1.1.min.js"></script>
<script src="/bootstrap/js/bootstrap.min.js"></script>
<script type="text/javascript">
	function goPage(url) {
		location.href = url;
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
				<th>가수</th>
				<th>곡명</th>
				<th>LID</th>
				<th>링코드(후렴)</th>
				<th>링코드(앞)</th>
				<th>링코드(뒤)</th>
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
					<td>${result.singer }</td>
					<td>${result.title }</td>
					<td>${result.ktf_lid }</td>
					<td>${result.lring1 }</td>
					<td>${result.lring2 }</td>
					<td>${result.lring3 }</td>
				</tr>
			</c:forEach>
		</c:otherwise>
	</c:choose>
		</tbody>
	</table>

	<P>
		<button type="button" class="btn btn-default" onClick="javascript:goPage('/index.do');"><span class="glyphicon glyphicon-home"></span> 홈</button>
	</P>

</div>
</body>
</html>