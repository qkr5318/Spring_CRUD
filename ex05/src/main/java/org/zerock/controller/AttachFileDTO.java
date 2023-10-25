package org.zerock.controller;

import lombok.Data;

@Data
public class AttachFileDTO {
	
	private String fileName;		// 파일 이름
	private String uploadPath;		// 파일 경로
	private String uuid;			// uuid값
	private boolean image; 			// 이미지 여부
}
