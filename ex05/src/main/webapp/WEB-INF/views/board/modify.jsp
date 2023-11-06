<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- JSP 페이지 지시자 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><!-- 변주지원, 제어문 페이지 관련처리 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %><!-- 다국어 문서처리 -->
<style>
	.uploadResult{
		width: 100%;
		background-color: gray; 
	}
	.uploadResult ul{
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center;
	}
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	
	.uploadResult ul li img{
		width: 100px;
	}
	.uploadResult ul li span{
		color: white;
	}
	.bigPictureWrapper{
		position: absolute;
		display: none;
		justify-content: center;
		align-items: center;
		top: 0%;
		width: 100%;
		height: 100%;
		background-color: gray;
		z-index: 100;
		background: rgba(255,255,255,0.5);
	}
	
	.bigPicture{
		position: relative;
		display: flex;
		justify-content: center;
		align-items: center;
	}
	.bigPicture img {
		width: 600px;
	}
</style>
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

	<!-- 첨부파일이 보여질 태그 -->
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>	
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Files</div>
				<!-- /.panel-heading -->
					
				<div class="panel-body">
					<div class="form-group uploadDiv">
						<input type="file" name="uploadFile" multiple> 
					</div>
							
					<div class="uploadResult">
						<ul>
						</ul>
					</div>
				</div>
				<!--  end panel-body -->
			</div>
			<!--  end panel-heading -->
		</div>
		<!-- end panel -->
	</div>    
	<!-- /.row -->
	
<%@include file="../includes/footer.jsp" %>    
<!-- 첨부파일 관련 js -->
<script>
$(document).ready(function () {
	
	
	(function () {
		
		var bno = '<c:out value="${board.bno}"/>';
		
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr) {
			
			console.log(arr);
			
			var str = "";
			
			
			$(arr).each(function (i, attach) {
				
				// image type
				if (attach.fileType) {
					var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
					
					str += "<li data-path ='"+attach.uploadPath+"'data-uuid='"+attach.uuid+"'data-filename='"+attach.fileName+"'data-type='"+attach.fileType+"'><div>";
					str += "<span> "+ attach.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='image' "
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='/display?fileName="+fileCallPath+"'>";
					str += "</div>";
					str += "</li>";
				}else{
					
					str += "<li data-path='"+attach.uploadPath+"'data-uuid='"+attach.uuid+"'data-filename='"+attach.fileName+"'data-type='"+attach.fileType+"'><div>";
					str += "<span>"+attach.fileName+"</span><br/>"
					str += "<button type='button' data-file=\'"+fileCallPath+"\'data-type='file' "
					str += "class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<a><img src='/resources/img/attach1.png'></a>";
					str += "</div>";
					str += "</li>";
				}
			});
			
			$(".uploadResult").on("click", "button", function(e) {
				
				console.log("delete file");
				
				if (confirm("Remove this file? ")) {
					
					var targetLi = $(this).closest("li");
					targetLi.remove();
				}
			});
			
			$(".uploadResult ul").html(str);
			
		});// end getjson
	})();// end function
	
	var regex = new RegExp("(.*?)\.(exe|sh|zip|akz)$");
	var maxSize = 5242880; //5MB
	
	function checkExtension(fileName, fileSize) {
		
		
		if ( regex.test(fileName)) {
			alert("해당 종류의 파일은 업로드할 수 없습니다.");
			return false;
		}
		
		if (fileSize >= maxSize) {
			alert("파일 사이즈 초과");
			return false;
		}
		
		return true;
		
	}
	
	$("input[type='file']").change(function(e) {
		
		var formData = new FormData();
		
		var inputFile = $("input[name = 'uploadFile']");
		
		var files = inputFile[0].files;
		
		for (var i = 0; i < files.length; i++) {
			
			if (!checkExtension(files[i].name, files[i].size)) {
				return false;
			}
			formData.append("uploadFile", files[i]);
		}
		
		$.ajax({
			url : '/uploadAjaxAction',
			processData : false,
			contentType : false, 
			data: formData, 
			type: 'POST',
			dataType:'json',
				success: function(result){
					console.log(result);
				
					showUploadResult(result); // 업로드 결과 처리 함수
				}
			
			
		});	//$.ajax
	});
	
	function showUploadResult(uploadresultArr) {
		
		if (!uploadresultArr || uploadresultArr.length == 0) {
			return;
		}
		
		var uploadUL = $(".uploadResult ul");
		
		var str ="";
		
		$(uploadresultArr).each(function(i, obj) {
			
			// image type
			if (obj.image) {
				var fileCallPath = encodeURIComponent(obj.uploadPath +"/s_"+ obj.uuid+"_"+obj.fileName);
				
				str += "<li data-path='"+ obj.uploadPath+"'";
				str += "data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"'data-type='"+obj.image+"'";
				str +" ><div>";
				str += "<span> " + obj.fileName + "</span>";
				str += "<button type= 'button' data-file=\'"+fileCallPath+"\' "
				str += "data-type='image' class = 'btn btn-warning btn-circle'><i class= 'fa fa-times'></i></button><br>";
				str += "<img src='/display?fileName="+fileCallPath+"'>";
				str += "</div>";
				str += "</li>";
				
				console.log("str 확인 ===  " + str);
			
			}else {
				var fileCallPath = encodeURIComponent(obj.uploadPath +"/"+ obj.uuid+"_"+obj.fileName);
				
				// repacle로 경로 \\ 를 /로 변경
				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li ";
				str += "data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename = '"+obj.fileName+"' data-type='"+obj.image+"'><div>";
				str += "<span> " + obj.fileName + "</span>";
				str += "<button type= 'button' data-file=\'"+fileCallPath+"\' data-type='file' class = 'btn btn-warning btn-circle'><i class= 'fa fa-times'></i></button><br>";
				str += "<a><img src='/resources/img/attach1.png'></a>";
				str += "</div>";
				str += "</li>";
			}
		});
		
		uploadUL.append(str);
	}
	
});
</script>        
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
			}else if (operation === 'modify') {
				
				console.log("submit clicked");
				
				var str = "";
				
				$(".uploadResult ul li").each(function (i, obj) {
					
					var jobj = $(obj);
					
					console.dir("ddddadsfasdf========  " + jobj);
					
					
					str +="<input type='hidden' name='attachList["+i+"].fileName'value='"+jobj.data("filename")+"'>";
					str +="<input type='hidden' name='attachList["+i+"].uuid'value='"+jobj.data("uuid")+"'>";
					str +="<input type='hidden' name='attachList["+i+"].uploadPath'value='"+jobj.data("path")+"'>";
					str +="<input type='hidden' name='attachList["+i+"].fileType'value='"+jobj.data("type")+"'>";
					
					console.log("확인 == " + str);
				
				});
				formObj.append(str).submit();
			}
			
			formObj.submit();
		});
		

		
	});
	
	

</script>

 
