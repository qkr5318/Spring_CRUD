package org.zerock.domain;

import lombok.Data;

@Data
public class Ticket {

	// 번호(tno), 소유주(owner), 등급(grade)를 지정
	private int tno;
	private String owner;
	private String grade;
}
