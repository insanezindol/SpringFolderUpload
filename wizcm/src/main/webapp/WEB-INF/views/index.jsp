<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>INDEX</title>
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
		<h1>WIZCM PROJECT</h1>
	</div>
	
	<P> ${serverTime}. </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/ring/ringResult.do?lid=82158820');"> 링 DB 조회</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/bell/bellResult.do?lid=82147537');"> 벨 DB 조회</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/ring/ajaxResult.do');"> AJAX DB 조회</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/file/fileForm.do');"> 폴더 업로드</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/file/excelForm.do');"> 엑셀 파싱</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/file/excelFileUploadForm.do');"> 엑셀 파싱 + 폴더 업로드</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/file/iphoneBellForm.do');"> 아이폰벨 업로드</button> </P>
	<P> <button type="button" class="btn btn-default" onClick="javascript:goPage('/ring/webSql.do');"> Web SQL Sample</button> </P>
		
</div>

</body>
</html>