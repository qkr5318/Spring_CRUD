package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
// @AllArgsConstructor 모든 속성을 사용하는 생성자를 위한 
@NoArgsConstructor
// @NoArgsConstructor 비어 있는 생성자를 만들기 위한 
public class SampleVO {

	private Integer mno;
	private String firstName;
	private String lastName;
}
