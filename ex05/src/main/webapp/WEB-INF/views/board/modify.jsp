<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- JSP 페이지 지시자 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><!-- 변주지원, 제어문 페이지 관련처리 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %><!-- 다국어 문서처리 -->

<%@include file="../includes/header.jsp" %>
 <div class="row">
		<div class="col-lg-12">
		  	 <h1 class="page-header">Board Modify Page</h1>
		</div>
    <!-- /.col-lg-12 -->
	</div>
		  <!-- /.row -->
		  <div class="row">
		      <div class="col-lg-12">
		          <div class="panel panel-default">
		              <div class="panel-heading"> Board Modify Page</div>		              
		              <!-- /.panel-heading -->
		              <div class="panel-body">
		                  <form role="form" action="/board/modify" method="post">
		                  
		                  <!-- p.319 추가 -->
	                  	<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
	                  	<input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
	                  	<!-- p.346 추가 -->
	                  	<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>">
	                  	<input type="hidden" name="type" value="<c:out value='${cri.type}'/>">
		                  	<div class="form-group">
		                  	<label>Bno </label>
		                  	<input class="form-control" name="bno" value="<c:out value='${board.bno }'/>" readonly="readonly"> 
		                  </div>
		                  
		              		<div class="form-group">
		              			<label>Title</label>
		              			<input class="form-control" name="title" value="<c:out value='${board.title }'/>">		           
		              		</div>
		              		
		              		<div class="form-group">
		              			<label>Text area</label>
		              			<textarea rows="3" class="form-control" name="content"><c:out value='${board.content }'/></textarea>
		              			
		              		</div>
		              		
		              		<div class="form-group">
		              			<label>Writer</label>
		              			<input class="form-control" name="writer" value="<c:out value='${board.writer}'/>" readonly="readonly" >
		              		</div>
		              		
		              	
		              		<button type="submit" data-oper="modify" class="btn btn-default" >Modify</button>
		              		<button type="submit" data-oper="remove" class="btn btn-danger" >Remove</button>
		              		<button type="submit" data-oper="list" class="btn btn-info" >List</button>
		              	</form>
		                  
		                  
		                  
		                  
		                  
		                  
		                    
		                </div>
		                <!-- /.table-responsive -->
		            </div>
		            <!-- /end panel-body -->
		        </div>
		        <!-- /end panel -->
		    </div>
		    <!-- /.col-lg-6 -->
	</div>
<!-- /.row -->

<%@include file="../includes/footer.jsp" %>            
<script type="text/javascript">

	$(document).ready(function () {
		var formObj = $("form");
		
		$('button').on("click", function (e) {
			
			e.preventDefault();
			
			var operation = $(this).data("oper");
			
			console.log(operation);
			
			if (operation === 'remove') {
				formObj.attr("action", "/board/remove");
			}
			else if (operation === "list") {
				// move to list 
				//self.location = "/board/list"; p266 페이지에서 수정하기 전 list버튼 클릭시 로직
				formObj.attr("action", "/board/list").attr("method", "get");
				
				// p.321 수정/삭제 페이지에서 목록 페이지 이동
				var pageNumTag = $("input[name='pageNum']").clone();
				var amountTag = $("input[name='amount']").clone();
				// p.347 리다이렉트는 GET방식으로 이루어지기 때문에 추가적인 파라미터를 처리해야한다. 
				// 다시 목록으로 이동하는 경우에 필요한 파라미터만 전송하기 위해서 <form> 태그의 모든 내용을 지우고 다시 추가하는 방식을 이용했다.
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
				formObj.empty();
				formObj.append(pageNumTag);
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			}
			formObj.submit();
		});
		
	});

</script>

 
