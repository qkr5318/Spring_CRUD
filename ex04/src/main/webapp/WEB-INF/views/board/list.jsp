<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- JSP 페이지 지시자 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><!-- 변주지원, 제어문 페이지 관련처리 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %><!-- 다국어 문서처리 -->

<%@include file="../includes/header.jsp" %>
 <div class="row">
		<div class="col-lg-12">
		  	 <h1 class="page-header">Tables</h1>
		</div>
    <!-- /.col-lg-12 -->
	</div>
		  <!-- /.row -->
		  <div class="row">
		      <div class="col-lg-12">
		          <div class="panel panel-default">
		              <div class="panel-heading"> Board List Page
		              <button id="regBtn" type="button" class="btn btn-xs pull-right">Register New Board</button>
		              </div>
		              <!-- /.panel-heading -->
		              <div class="panel-body">
		                  <table  class="table table-striped table-bordered table-hover" >
		                      <thead>
		                          <tr>
		                              <th>#번호</th>
		                              <th>제목</th>
		                              <th>작성자</th>
		                              <th>작성일</th>
		                              <th>수정일</th>
		                          </tr>
		                      </thead>
		                      
		                      <c:forEach items="${list}" var="board">
		                      <tr>
		                      	<td><c:out value="${board.bno }"/></td>
		                      	<td>
		                      	<a class="move" href="<c:out value='${board.bno }'/>">
		                      	<c:out value="${board.title }"/> </a> <b> [ <c:out 
		                      	value="${board.replyCnt }"/> ] </b>
		                      	</td>
		                      	<td><c:out value="${board.writer }"/></td>
		                      	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate }"/></td>
		                      	<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updateDate }"/></td>
   		                      </tr>		                      
		                      </c:forEach>		       
		                    </table>
		                    <!-- p.340 list.jsp에 검색조건 처리 
		                    <div class="row">
		                    	<div class="col-lg-12">
		                    		<form id="searchForm" action="/board/list" method="get">
		                    			<select name="type">
		                    				<option value="">--</option>
		                    				<option value="T">제목</option>
		                    				<option value="C">내용</option>
		                    				<option value="W">작성자</option>
		                    				<option value="TC">제목 or 내용</option>
		                    				<option value="TW">제목 or 작성자</option>
		                    				<option value="TWC">제목 or 내용 or 작성자</option>	
		                    			</select>	
		                    		 	<input type="text" name="keyword">
		                    		 	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		                    		 	<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		                    		 	<button class="btn btn-default">Search</button>
		                    		</form>
		                    	</div>
		                    </div>
		                    -->
		                    
		                     <!-- p.343 list.jsp에서 검색 조건과 키워드 보여주는 부분 수정 --> 
		                    <div class="row">
		                    	<div class="col-lg-12">
		                    		<form id="searchForm" action="/board/list" method="get">
		                    			<select name="type">
		                    				<option value=""
		                    					<c:out value="${pageMaker.cri.type == null?'selected':'' }"/>>--</option>	              
		                    				<option value="T"
		                    					<c:out value="${pageMaker.cri.type eq 'T'?'selected':''}"/>>제목</option>
		                    				<option value="C"
		                    					<c:out value="${pageMaker.cri.type eq 'C'?'selected':''}"/>>내용</option>
		                    				<option value="W"
		                    					<c:out value="${pageMaker.cri.type eq 'W'?'selected':''}"/>>작성자</option>
		                    				<option value="TC"
		                    					<c:out value="${pageMaker.cri.type eq 'TC'?'selected':''}"/>>제목 or 내용</option>
		                    				<option value="TW"
		                    					<c:out value="${pageMaker.cri.type eq 'TW'?'selected':''}"/>>제목 or 작성자</option>
		                    				<option value="TWC"
		                    					<c:out value="${pageMaker.cri.type eq 'TWC'?'selected':''}"/>>제목 or 내용 or 작성자</option>	
		                    			</select>	
		                    		 	<input type="text" name="keyword"
		                    		 		value="<c:out value='${pageMaker.cri.keyword}'/>" />
		                    		 	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		                    		 	<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
		                    		 	<button class="btn btn-default">Search</button>
		                    		</form>
		                    	</div>
		                    </div>
		                    
		                    
		                    <div class="pull-right">
		                    	<ul class="pagination">
		                    		
		                    		<c:if test="${pageMaker.prev }">
		                    			<li class="paginate_button previous">
		                    				<a href="${pageMaker.startPage -1 }">Previous</a>
		                    			</li>
		                    		</c:if>
		                    		
		                    		<c:forEach var="num" begin="${pageMaker.startPage }"
		                    			end="${pageMaker.endPage }">
		                    			<li class="paginate_button ${pageMaker.cri.pageNum == num ? "active":"" }">
		                    				<a href="${num }">${num }</a>
		                    			</li>
		                    		</c:forEach>
		                    		
		                    		<c:if test="${pageMaker.next }">
		                    			<li class="paginate_button next">
		                    				<a  href="${pageMaker.endPage +1 }" >Next</a>
		                    			</li>
		                    		</c:if>
		                    	</ul>
		                    </div>
		                  
		                    <!-- 	end Pagination -->
		                      <!-- Modal 추가-->
                            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                                <div class="modal-dialog">
                                    <div class="modal-content">
                                        <div class="modal-header">
                                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                                            <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                                        </div>
                                        <div class="modal-body">
                                            처리가 완료되었습니다.
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                                         <!--    <button type="button" class="btn btn-primary">Save changes</button> -->
                                        </div>
                                    </div>
                                    <!-- /.modal-content -->
                                </div>
                                <!-- /.modal-dialog -->
                            </div>
                            <!-- /.modal -->
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
  
 <form id="actionForm" action="/board/list" method="get">
  	<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
  	<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
  	<!-- p.344 페이지 번호를 클릭해서 이동할 때에도 검색 조건과 키워드는 같이 전달되어야 함 -->
  	<input type="hidden" name="type" value="${pageMaker.cri.type }">
  	<input type="hidden" name="keyword" value="${pageMaker.cri.keyword }">
 </form>
 
<script type="text/javascript">
	$(document).ready(function(){
		
		var result = '<c:out value="${result}"/>';
		var reply =  '<c:out value="${board.replyCnt }"/>';
		var title = '	<c:out value="${board.title }"/>';
		
		checkModal(result);
		
		history.replaceState({}, null, null);
		
		function checkModal(result) {
			
			if (result === '' || history.state) {
				return;
			}
			
			if (parseInt(result) > 0) {
				$(".modal-body").html("게시글 " + parseInt(result) + " 번이 등록되었습니다.");
			}
			
			$("#myModal").modal("show");
		}
		
		// 리스트 header에 Register New Button클릭시 발생하는 이벤트 처리
		$("#regBtn").on("click", function () {
			
			self.location = "/board/register"
			
		});
		
		var actionForm = $("#actionForm");
		
		$(".paginate_button a").on("click", function (e) {
			
			e.preventDefault();
			
			console.log("click");
			
			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
			actionForm.submit();
			//jQuery에 있는
			//.find()는 어떤 요소의 하위 요소 중 특정 요소를 찾을 때 사용합니다.
			//.val()은 양식(form)의 값을 가져오거나 값을 설정하는 메소드입니다.
			//.attr()은 요소(element)의 속성(attribute)의 값을 가져오거나 속성을 추가한다.
		});
		
		//list.jsp 게시물 조회를 위한 이벤트 처리 추가
		$(".move").on("click", function (e) {
			
			e.preventDefault();
			actionForm.append("<input type='hidden' name='bno' value='"+$(this).attr("href")+"'>");
			actionForm.attr("action", "/board/get");
			actionForm.submit();
		});
		
		// p.342 list.jsp의 검색 버튼의 이벤트 처리
		var searchForm = $("#searchForm");
		
		$("#searchForm button").on("click", function (e) {
			
			if (!searchForm.find("option:selected").val()) {
				alert("검색종류를 선택하세요");
				return false;
			}
			
			if (!searchForm.find("input[name='keyword']").val()) {
				alert("키워드를 입력하세요");
				return false;
			}
			
			searchForm.find("input[name='pageNum']").val("1");
			e.preventDefault();
		    
			searchForm.submit();
			
		});
		
	});
</script>