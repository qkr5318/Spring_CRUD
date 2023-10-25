<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- JSP 페이지 지시자 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><!-- 변주지원, 제어문 페이지 관련처리 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %><!-- 다국어 문서처리 -->

<%@include file="../includes/header.jsp" %>
 <div class="row">
			<div class="col-lg-12">
		  	 <h1 class="page-header">Board Read</h1>
		</div>
    <!-- /.col-lg-12 -->
</div>
		  <!-- /.row -->
		 <div class="row">
		      <div class="col-lg-12">
		          <div class="panel panel-default">
		              <div class="panel-heading"> Board Read Page</div>		  
		                          
		              <!-- /.panel-heading -->
		              <div class="panel-body">
		                  
		                  <div class="form-group">
		                  	<label>Bno </label>
		                  	<input class="form-control" name="bno" value="<c:out value='${board.bno }'/>" readonly="readonly"> 
		                  </div>
		                  
		                  <div class="form-group">
		                  	<label>Title </label>
		                  	<input class="form-control" name="title" value="<c:out value='${board.title }'/>" readonly="readonly"> 
		                  </div>
		                  
		                  <div class="form-group">
		                  	<label>Text area </label>
		                  	<textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value='${board.title }'/></textarea> 
		                  </div>
		                  
		                  <div class="form-group">
		                  	<label>Writer </label>
		                  	<input class="form-control" name="writer" value="<c:out value='${board.writer }'/>" readonly="readonly"> 
		                  </div>
		                  
		                  <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno }"/>'">Modify</button>
		                  <button data-oper="list" class="btn btn-info" onclick="location.href='/board/list'">List</button>
		                  
		                  <form id="operForm" action="/board/modify" method="get">
		                  	<input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}'/>">
		           			<input type="hidden" name="pageNum" value="<c:out value='${cri.pageNum}'/>">
		                  	<input type="hidden" name="amount" value="<c:out value='${cri.amount}'/>">
		                  	<!-- p.345 조회 페이지에서 검색처리 -->
		                  	<input type="hidden" name="keyword" value="<c:out value='${cri.keyword}'/>">
		                  	<input type="hidden" name="type" value="<c:out value='${cri.type}'/>">
		                  </form>
		                    
		                </div>
		                <!-- /.table-responsive -->
		            </div>
		            <!-- /end panel-body -->
		        </div>
		        <!-- /end panel -->
		    </div>
		    <!-- /.col-lg-6 -->
	
  <!-- /.row -->
	 <div class="row">
      	<div class="col-lg-12">
		      <!-- /.panel -->
	          <div class="panel panel-default">
		          <!-- p.419
		            <div class="panel-heading"> 
			              <i class="fa fa-comments fa-fw"></i> Reply
			              </div>		
		           -->
			       <div class="panel-heading"> 
			              <i class="fa fa-comments fa-fw"></i> Reply
			              <button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">
			              New Reply</button>
		           </div>	                    
		              <!-- /.panel-heading -->
		              <div class="panel-body">
		                  
		                  <ul class="chat">
		                  	<!-- start reply -->
		                  	<li class="left clearfix" data-rno='12'>
		                  		<div>
		                  			<div class="header">
		                  				<strong class="primary-font">user00</strong>
		                  				<small class="pull-right text-muted">2018-01-01 13:13</small>
		                  			</div>	
		                  			<p>Good Job!</p>
		                  		</div>
		                  	</li>
		                  </ul>
		                
		           	 </div>
		            <!-- /end panel-body -->
		            <!-- .chat-panel 추가 -->
		            <div class="panel-footer">
		            
		            </div>
		        </div>
		        <!-- /end panel -->
	    </div>
		    <!-- /.col-lg-6 -->

	</div>
	
	 <!-- Modal -->
      <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
          <div class="modal-dialog">
              <div class="modal-content">
                  <div class="modal-header">
                      <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                      <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
                  </div>
                  <div class="modal-body">
                     <div class="form-group">
                     	<label>Reply</label>
                     	<input class="form-control" name="reply" value="NewReply!!!!">
                     </div>
                     <div class="form-group">
                     	<label>Replyer</label>
                     	<input class="form-control" name="replyer" value="replyer">
                     </div>
                     <div class="form-group">
                     	<label>Reply Date</label>
                     	<input class="form-control" name="replyDate" value="">
                     </div>
                  </div>
                  <div class="modal-footer">
                  	  <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
                  	  <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
                  	  <button id="modalRegisterBtn" type="button" class="btn btn-danger">Register</button>
                      <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                      <button id="modalClassBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                  </div>
              </div>
              <!-- /.modal-content -->
          </div>
          <!-- /.modal-dialog -->
      </div>
      <!-- /.modal -->
<%@include file="../includes/footer.jsp" %>  

<script type="text/javascript" src="/resources/js/reply.js"></script>  
<!-- showReplyPage() script -->
<script type="text/javascript">

	var pageNum = 1;
	var replyPageFooter = $(".panel-footer");
	var replyPageUl = $(".pagination");
	
	function showReplyPage(replyCnt) {
		
		var endNum = Math.ceil(pageNum / 10.0) * 10;
		var startNum = endNum - 9;
		
		var prev = startNum != 1;
		var next = false;
		
		if (endNum * 10 >= replyCnt) {
			endNum = Math.ceil(replyCnt/10.0);
		}
		
		if (endNum * 10 < replyCnt) {
			next = true;
		}
		
		var str = "<ul class='pagination pull-right'>";
		
		if (prev) {
			str+= "<li class='page-item'><a class='page-link' href='"+(startNum -1)+"'>Previous</a></li>";
		}
		
		
		for (var i = startNum; i <= endNum; i++) {
			
			var active = pageNum == i? "active":"";
			
			str += "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
		}
		if (next) {
			str += "<li class='page-item'><a class='page-link' href='"+(endNum + 1)+"'>Next</a></li>";
		}
		
		str += "</ul>";
		
		console.log(str);
		
		replyPageFooter.html(str);
		
		
		
	}
</script>

<script type="text/javascript">
	$(document).ready(function() {
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
			showList(1);
			
			function showList(page) {
				replyService.getList({bno:bnoValue, page:page}, 
				function(replyCnt,list){
					
					console.log("replyCnt: " + replyCnt);
					console.log("list: " + list);
					console.log("page: " + page);
					console.log(list);
					
					if (page == -1) {
						pageNum = Math.ceil(replyCnt/10.0);
						showList(pageNum);
						return;
					}
					
					var str = "";
					if (list == null || list.length == 0) {
						replyUL.html("");
						
						return;
					}
					for (var i = 0, len = list.length||0; i < len; i++) {
						
						str +="<li class='left clearfix' data-rno='"+ list[i].rno+"'>";
						str +="	<div> <div class='header'><strong class='primary-font'>"
						+list[i].replyer+"</strong>";
						str +="	<small class='pull-right text-muted'>" + replyService.displayTime(list[i].
						replyDate)+"</small></div>";
						str +="	<p>" +list[i].reply+"</p></div></li>";
						
					}
					
					replyUL.html(str);
					//p.441 추가
					showReplyPage(replyCnt);
				}); //end function
			}// end showList
			// 'New Reply'클릭시 새댓글 모달 창 나오는 이벤트 처리
			var modal = $(".modal");
			var modalInputReply = modal.find("input[name='reply']");
			var modalInputReplyer = modal.find("input[name='replyer']");
			var modalInputReplyDate = modal.find("input[name='replyDate']");
			
			var modalModBtn = $("#modalModBtn");
			var modalRemoveBtn = $("#modalRemoveBtn");
			var modalRegisterBtn = $("#modalRegisterBtn");
			
			$("#addReplyBtn").on("click", function (e) {
				
				modal.find("input").val("");
				modalInputReplyDate.closest("div").hide();
				modal.find("button[id != 'modalCloseBtn']").hide();
				
				modalRegisterBtn.show();
				
				$(".modal").modal("show");
			});
			// 댓글 등록 및 목록 갱신
			modalRegisterBtn.on("click", function (e) {
				
				var reply = {
						reply : modalInputReply.val(),
						replyer : modalInputReplyer.val(),
						bno : bnoValue
				};
				
				replyService.add(reply, function (result) {
					
					alert(result);
					
					modal.find("input").val("");
					modal.modal("hide");
					
					showList(1);
				});
			});
			// 특정 댓글의 클릭 이벤트 처리
			$(".chat").on("click","li", function (e) {
				
				var rno = $(this).data("rno");
				
				replyService.get(rno, function (reply) {
					
					modalInputReply.val(reply.reply);
					modalInputReplyer.val(reply.replyer);
					modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readOnly", "readOnly");
					modal.data("rno", reply.rno);
					
					modal.find("button[id != 'modalCloseBtn']").hide();
					modalModBtn.show();
					modalRemoveBtn.show();
					
					$(".modal").modal("show");
				});
				
				console.log(rno);
			});
			
		/* p.425
			$(".chat").on("click","li", function (e) {
				
				var rno = $(this).data("rno");
				
				console.log(rno);
			});
		*/	
		
		// 댓글의 수정/ 삭제 이벤트 처리
		
		modalModBtn.on("click", function (e) {
		
			var reply = {rno:modal.data("rno"), reply: modalInputReply.val()};
			
			replyService.update(reply, function (result) {
				
				
				alert(result);
				modal.modal("hide");
				//showList(1); // p.422 수정으로 주석처리함
				showList(pageNum);
			});
		});
		
		modalRemoveBtn.on("click", function (e) {
		
			var rno = modal.data("rno");
			
			replyService.remove(rno, function (result) {
				
				
				alert(result);
				modal.modal("hide");
				//showList(1); // p.422 수정으로 주석처리함
				showList(pageNum);
			});
		});
		replyPageFooter.on("click","li a", function (e) {
			e.preventDefault();
			console.log("page click");
		
			var targetPageNum = $(this).attr("href");
		
			console.log("targetPageNum : " + targetPageNum);
			
			pageNum = targetPageNum;
			
			showList(pageNum);
		});
		
		/*
		$(document).on("click",".page-link", function (e) {
			e.preventDefault();
			console.log("page click");
		
			var targetPageNum = $(this).attr("href");
		
			console.log("targetPageNum : " + targetPageNum);
			
			pageNum = targetPageNum;
			
			showList(pageNum);
		});
		*/
		
			
	});

</script>
<!-- 

<script type="text/javascript">
	$(document).ready(function () {
		
		//p.401
		console.log(replyService);
		
		console.log("=====================");
		console.log("JS TEST");
		
		var bnoValue = '<c:out value="${board.bno}"/>';
		
		
		/*
		p.402 reply.js 등록처리
	    결과를 확인해 보면 
		브라우저에는 json 형태로 데이터가 전송되고 
		서버에는 JSON 데이터가 ReplyVO 타입으로 제대로 변환되는 것을 확인할 수 있다.
		*/
		// for replyService add test
		replyService.add(
			{reply:"JS Test GETLIST", replyer:"tester", bno:bnoValue}
			,
			function(result){
				alert("RESULT: " + result);
			}
		);
		
		// reply List test
		replyService.getList({bno:bnoValue, page:1}, function(list){
			console.log("getJson으로 부터 받은 Data === " + list + " list.length === " + list.length);
			for (var i = 0, len = list.length||0; i < len; i++) {
				console.log(list[i]);
			}
		}
		);
		
		// 22번 댓글 삭제 테스트
		replyService.remove(22, function(count){
			
			console.log(count);
			
			if (count === "success") {
				alert("REMOVED");
			}
		}, function (err) {
				alert("ERROR...");
		});
		
		// 21번 댓글 수정
		replyService.update({
			rno : 21,
			bno : bnoValue,
			reply : "Modified 맞냐?......."
		}, function(result){
			
			alert("수정 완료....");
		
		});
		
		// get 댓글 조회 처리
		replyService.get(10, function(data){
			console.log(data);
		});
		
		
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function (e) {
			
			operForm.attr("action", "/board/modify").submit();
			
		});
		
		$("button[data-oper='list']").on("click", function (e) {
			
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
			
		});
	});	
</script>  
 -->
 
