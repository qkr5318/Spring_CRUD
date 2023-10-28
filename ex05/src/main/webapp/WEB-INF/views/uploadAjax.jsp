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
	
	<div class="bigPictureWrapper">
		<div class="bigPicture">
		</div>
	</div>
	
	

	<script src="https://code.jquery.com/jquery-3.3.1.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous"></script>
	 
	<script type="text/javascript">
		function showImage(fileCallPath){
		
				//alert(fileCallPath);
				
				$(".bigPictureWrapper").css("display", "flex").show();
				
				$(".bigPicture")
				.html("<img src='display?fileName="+ encodeURI(fileCallPath)+ "'>")
				.animate({width:'100%', height:'100%'}, 1000);
				
				
				
				
		}
		
		$(document).ready(function () {
			
			// 'x' 이미지/일반파일 x표시 클릭이벤트 처리
			$(".uploadResult").on("click","span", function(e) {
				
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				console.log(targetFile);
				
				$.ajax({
					url : '/deleteFile',
					data:{ fileName: targetFile, type: type},
					dataType : 'Text',
					type: "POST",
						sucecc: function(result) {
							alert(result);
							
						}
				}); // $.Ajax
			})
			
			// 화살표 함수는 ES6의 기능이다.
			// Chrome에서는 정상 작동하지만 IE에서는 제대로 동작이 안될수 있어 변경이 필요하다.
			$(".bigPictureWrapper").on("click", function(e) {
				$(".bigPicture").animate({width:'0%', height:'0%'}, 1000);
				setTimeout(() => {
				//	$(this).hide();
					$(".bigPictureWrapper").hide();
				}, 1000);
			});
			
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
						
						// repacle로 경로 \\ 를 /로 변경
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
						
						//str += "<li><a href='/download?fileName="+fileCallPath+"'>"
						//		+"<img src='/resources/img/attach1.png'>"+obj.fileName+"</li>";
					
						str += "<li><div><a href='/download?fileName="+fileCallPath+"'>"
						+"<img src='/resources/img/attach1.png'>"+obj.fileName+"</a>" + 
						"<span data-file=\'" + fileCallPath+"\' data-type='file'> x </span>"
						+"</div></li>";
						
						
						
					}else{
						//	str += "<li>" + obj.fileName + "</li>";
						// 파일이 이미지일때
						
						var fileCallPath = encodeURIComponent(obj.uploadPath + "/s_"+ obj.uuid+"_"+obj.fileName);
						
						var originPath = obj.uploadPath + "\\"+ obj.uuid + "_" + obj.fileName;
						
					 	originPath = originPath.replace(new RegExp(/\\/g), "/")
					 	
					 	//str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="+fileCallPath+"'></li>";
					 	str += "<li><a href=\"javascript:showImage(\'"+originPath+"\')\">"
						+"<img src='/display?fileName="+fileCallPath+"'></a>" + 
						"<span data-file=\'" + fileCallPath+"\' data-type='image'> x </span>"
						+"</li>";
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