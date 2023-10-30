package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
// Criteria는 '검색의 기준'을 의미
public class Criteria {

	private int pageNum;
	private int amount;
	
	// p.334 검색을 위한 추가
	private String type;
	private String keyword;
	
	public Criteria() {
		this(1,10);
	}
	
	// Criteria 클래스의 용도는 pageNum과 amount 값을 같이 전달하는 용도지만 생성자를 통해서
	// 기본값을 1페이지, 10개로 지정해서 처리한다.
	public Criteria(int pageNum, int amount) {
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	// p.334 검색을 위한 추가
	public String[] getTypeArr() {
		
		return type == null ? new String[] {} : type.split("");
	}
	
	// p. 349 링크를 생성하는 기능을 추가
	public String getListLink() {
		
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
		
		return builder.toUriString();
	}
}
