<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%> <!-- JSP 페이지 지시자 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><!-- 변주지원, 제어문 페이지 관련처리 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %><!-- 다국어 문서처리 -->

<%@include file="../includes/header.jsp" %>
<style>
	.uploadResult{
		
		width:100%;
		background-color: gray;
	}
	
	.uploadResult ul{
		
		display: flex;
		flex-flow: row;
		justify-content: center;
		align-items: center
	}
	
	.uploadResult ul li{
		list-style: none;
		padding: 10px;
		align-content: center;
		text-align: center;
	}
	
	.uploadResult ul li img {
		width: 20px;
	}
	.bigPictureWrapper{
		position: absolute;;
		display: none;
		justify-content: center;
		align-items: center;
		top : 0%;
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

 <div class="row">
		<div class="col-lg-12">
		  	 <h1 class="page-header">Board Register</h1>
		</div>
    <!-- /.col-lg-12 -->
	</div>
		  <!-- /.row -->
		  <div class="row">
		      <div class="col-lg-12">
		          <div class="panel panel-default">
		              <div class="panel-heading"> Board Register</div>
		              <!-- /.panel-heading -->
		              <div class="panel-body">
		              
		              	<form role="form" action="/board/register" method="post">
		              		<div class="form-group">
		              			<label>Title</label><input class="form-control" name="title">		           
		              		</div>
		              		
		              		<div class="form-group">
		              			<label>Text area</label>
		              			<textarea rows="3" class="form-control" name="content"></textarea>
		              		</div>
		              		
		              		<div class="form-group">
		              			<label>Writer</label><input class="form-control" name="writer">
		              		</div>
		              		
		              		<button type="submit" class="btn btn-default">Submit Button</button>
		              		<button type="reset" class="btn btn-default">Reset Button</button>
		              		
		              	</form>
		              
			            </div>
			            <!-- /end panel-body -->
			        </div>
			        <!-- /end panel -->
			    </div>
			    <!-- /.col-lg-12 -->
			</div>
		<!-- /.row -->
		
		<!-- 새로 추가하는 부분 -->
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default">
					
					<div class="panel-heading">File Attach</div>
					<!-- /. panel-heading-->
						<div class="panel-body">
							<div class="form-group uploadDiv">
								<input type="file" name="uploadFile" multiple> 
							</div>
							
							<div class="uploadResult">
								<ul>
								</ul>
							</div>
						</div>
					<!-- end panel-body -->
				</div>
				<!-- end panel-default-body -->
			</div>
			<!-- end col-lg-12 -->
		</div>
		<!-- end row -->
		
		

<%@include file="../includes/footer.jsp" %>
<script>
	$(document).ready(function (e) {
		
		var formObj = $("form[role='form']");
		
		$("button[type='submit']").on("click", function (e) {
			
			e.preventDefault();
			
			console.log("submit clicked");
			
			var str= "";
			
			$(".uploadResult ul li").each(function (i, obj) {
				
				var jobj = $(obj);
				
				
				
				
				str +="<input type='hodden' name='attachList["+i+"].fileName'value='"+jobj.data("filename")+"'>";
				str +="<input type='hodden' name='attachList["+i+"].uuid'value='"+jobj.data("uuid")+"'>";
				str +="<input type='hodden' name='attachList["+i+"].uploadPath'value='"+jobj.data("path")+"'>";
				str +="<input type='hodden' name='attachList["+i+"].fileType'value='"+jobj.data("type")+"'>";
				console.dir("ddddadsfasdf========  " + jobj);
				
				formObj.append(str).submit();
			});
		});
	});
	
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
	
	
$(".uploadResult").on("click", "button", function(e) {
		
		console.log("delete file");
		
		var targetFile = $(this).data("file");
		var type = $(this).data("type");
		
		var targetLi = $(this).closest("li");
		
		$.ajax({
			url: '/deleteFile',
			data: {fileName : targetFile, type:type},
			dataType:'text',
			type: 'POST',
				success: function(result) {
					alert(result);
					targetLi.remove();
				}
		}); // $.ajax
		
	});
	
</script>            
  

 