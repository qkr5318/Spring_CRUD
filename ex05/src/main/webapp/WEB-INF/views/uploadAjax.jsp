<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
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
	}
	
	.uploadResult ul li img {
		width: 20px;
	}
	
	

	
	</style>
</head>
<body>
	<h1>Upload with Ajax</h1>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	
	<div class="uploadResult">
		<ul>
		
		</ul>
	</div>
	
	<button id="uploadBtn">Upload</button>


	<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
	  
	<script type="text/javascript">
	
		// jQuery의 $(document).ready(function 바깥쪽에 작성한다.)
		// 이렇게 하는 이유는 나중에<a> 태그에서 직접 showImage()를 호출할 수 있는 방식으로 작성하기 위해서다.
		function showImage(fileCallPath){
		
				alert(fileCallPath);
				
		}
		
		$(document).ready(function () {
			
			
			
			
			var regex = new RegExp("(.*?)\.(exe|sh|zip|akz)$");
			var maxSize = 5242880; //5MB
			
			function checkExtension(fileName, fileSize) {
				
				if (regex.test(fileName)) {
					alert("해당 종류의 파일은 업로드할 수 없습니다.");
					return false;
				}
				
				if (fileSize >= maxSize) {
					alert("파일 사이즈 초과");
					return false;
				}
				
			
				return true;
			}
			
			
			var uploadResult = $(".uploadResult ul");
			
			function showUploadedFile(uploadResultArr) {
				
				var str = "";
				
				$(uploadResultArr).each(function (i, obj) {
					
					if (!obj.image) {
						// 파일이 이미지가아닐때
						var fileCallPath = encodeURIComponent(obj.uploadPath +"/"+ obj.uuid+"_"+obj.fileName);
						
						str += "<li><a href='/download?fileName="+fileCallPath+"'>"
								+"<img src='/resources/img/attach1.png'>"+obj.fileName+"</li>";
					
					}else{
						ㅔ//	str += "<li>" + obj.fileName + "</li>";
						// 파일이 이미지일때
						
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+ obj.uuid+"_"+obj.fileName);
						
						var originPath = obj.uploadPath + "\\"+ obj.uuid + "_" + obj.fileName;
						
					 	originPath = originPath.replace(new RegExp(/\\/g), "/")
						str += "<li><img src='/display?fileName="+fileCallPath+"'></li>";
					}
					
				});
				
				uploadResult.append(str);
			}
			
			var cloneObj = $(".uploadDiv").clone();
			
			$("#uploadBtn").on("click", function(e) {
				
				var formData = new FormData();
				
				var inputFile = $("input[name='uploadFile']");
				
				var files = inputFile[0].files;
				
				console.log(inputFile);
				console.log(files);
				
				// add File Data to formData
				for (var i = 0; i < files.length; i++) {
					
					if (!checkExtension(files[i].name, files[i].size)) {
						return false;
					}
					
					formData.append("uploadFile", files[i]);
				}
				
				$.ajax({
					url: '/uploadAjaxAction',
					processData: false,
					contentType: false,
					data: formData,
					type: 'POST',
					dataType :'json',
					success: function(result){

						console.log(result);
						
						showUploadedFile(result);
						
						// 업로드가 완료되면 초기화
						$(".uploadDiv").html(cloneObj.html());
					}
				}); // $.ajax
			});
		});
	</script>
	

</body>
</html>