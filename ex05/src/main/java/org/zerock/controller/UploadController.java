package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		
		log.info("upload form");
	}
	
	// p.499 수정이 필요하여 주석 처리함
//	@PostMapping("/uploadFormAction")
//	public void uploadFormPost(MultipartFile[] uploadFile, Model model) throws IOException {
//		
//		
//		for (MultipartFile multipartFile : uploadFile) {
//			
//			 MultipartFile 인터페이스의 메서드들
//			log.info("-------------------------------------------------------");
//			log.info("Upload File Name: " + multipartFile.getOriginalFilename()); // 업로드되는 파일의 이름
//			log.info("Upload File Size: " + multipartFile.getSize());	// 업로드되는 파일의 크기
//			log.info("Upload File getName: " + multipartFile.getName());//String getName() 파라미터 이름<input> 태그의 이름
//			log.info("Upload File isEmpty: " + multipaMultipartFilertFile.isEmpty());// 파일이 존재하지 않는 경우 true
//			log.info("Upload File getBytes: " + multipartFile.getBytes());// byte[]로 파일 데이터 반환
//			log.info("Upload File getInputStream: " + multipartFile.getInputStream()); // 파일데이터와 연결된 inputStream을 반환
//		}
//	}
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) throws IOException {

		String uploadFolder = "C:\\upload";
		
		// 향상된 for문 아래는 형식
	//	for(타입 변수 : 배열)
		for (MultipartFile multipartFile : uploadFile) {
			
			log.info("-------------------------------------------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename()); // 업로드되는 파일의 이름
			log.info("Upload File Size: " + multipartFile.getSize());	// 업로드되는 파일의 크기
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile); // 파일의 저장 MultipartFile 인터페이스의 메소드
			} catch (Exception e) {
				log.error(e.getMessage());
			}//end catch
		}// end for
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		
		log.info("upload ajax");
	}

	@PostMapping(value = "/uploadAjaxAction",
				produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
		@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		
		
		log.info("update ajax post.....");
		
		List<AttachFileDTO> list = new ArrayList<AttachFileDTO>();
		String uploadFolder = "C:\\upload";
		
		String uploadFolderPath = getFolder();
		// make folder --------
		File uploadPath = new File(uploadFolder,uploadFolderPath);
		log.info("upload path: " + uploadPath);
		log.info("upload path: " + uploadPath.exists());
		
		
		if (uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		// make yyyy/MM/dd folder
		
		for(MultipartFile multipartFile : uploadFile) {
			
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			log.info("----------------------");
			log.info("Upload File Name: " + multipartFile.getOriginalFilename()); // 업로드되는 파일의 이름
			log.info("Upload File Size: " + multipartFile.getSize());	// 업로드되는 파일의 크기
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// IE has file path
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			
			log.info("only file name : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);
			
			// 중복 방지를 위한 UUID 적용
			UUID uuid = UUID.randomUUID();
			
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			//p.509 폴더생성으로 경로 변경 주석처리
			//File saveFile = new File(uploadFolder, uploadFileName);
			
			
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				if (checkImageType(saveFile)) {
					
					attachDTO.setImage(true);
					
					FileOutputStream thumnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumnail, 100, 100);
					
					thumnail.close();
				}
				
				// add to List
				list.add(attachDTO);
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
			} // end catch
			
		}// end for
		
		return new ResponseEntity<List<AttachFileDTO>>(list, HttpStatus.OK);
	}
	
	// 날짜 포맷
	private String getFolder() {
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Date date = new Date();
		
		String str = sdf.format(date);
		
		return str.replace("-", File.separator);
	}
	
	
	// 특정한 파일이 이미지 타입인지 검사하는 checkImageType() 메소드
	private boolean checkImageType(File file) {
		
		try {
			String contentType = Files.probeContentType(file.toPath());
			
			return contentType.startsWith("image");
		} catch (IOException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return false;
	}
	
	// UploadController에서 섬네일 데이터 전송하기
	
	@GetMapping("/display")
		@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		
		log.info("fileName : " + fileName);
		
		File file = new File("C:\\upload\\" + fileName);
		
		log.info("file : " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<byte[]>(FileCopyUtils.copyToByteArray(file),header,HttpStatus.OK);
		} catch (IOException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		
		log.info("download file: " + fileName);
		
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);
		
		log.info("resoruce: " + resource);
		
		if (resource.exists() == false) {
			log.info("존재하지 않는다.");
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		
		// remove UUID
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_")+1);
		
		log.info("다운받을 file 이름 === " + resourceName);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			String downloadName = null;
			
			if (userAgent.contains("Trident")) {
				
				log.info("IE browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replace("\\", " ");
			}else if (userAgent.contains("Edge")) {
				
				log.info("Edge browser");
				
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				
				log.info("Edge name: " + downloadName);
			}else {
				
				log.info("Chrome browser");
				
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
				log.info("Chrome browser ====  " + downloadName);
			}
			
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
		} catch (UnsupportedEncodingException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	// js에서 위임한 파일을 서버에서 위임받아 첨부파일의 삭제
	
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		
		log.info("deleteFile: " + fileName);
		
		File file;
		
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			
			file.delete();
			
			if (type.equals("image")) {
				
				// File클래스에 getAbsolutePath()는 업로드시 파일의 디렉토리 경로와 객체 생성시 만들어졌던 파일경로를 다가지고 온다.
				// 절대경로를 반환하는 getAbsolutePath()
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				
				log.info("largeFileName: " + largeFileName);
				
				file = new File(largeFileName);
				
				file.delete();
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		
		return new ResponseEntity<String>("delete", HttpStatus.OK);
	}
}
