package org.zerock.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.service.ReplyService;


import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

/*
 * @Setter 주입을 이용하거나 위의 코드와 같이 @AllArgsContstructor를 이용해서
 * ReplyService 타입의 객체를 필요로 하는 생성자를 만들어서 사용한다.
 * (스프링 4.3이상)*/

@RequestMapping("/replies/")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	
	private ReplyService service;
	// insert
	@PostMapping(value = "new",
			consumes = "application/json", //--> Client가 Server에게 보내는 데이터 타입명시
			produces = {MediaType.TEXT_PLAIN_VALUE}) // --> Server가 Client에게 반환하는 데이터 타입 명시
	public ResponseEntity<String> create(@RequestBody ReplyVO vo){
		
		log.info("ReplyVO: " + vo);
		
		int insertCount = service.register(vo);
		
		log.info("Reply INSERT COUNT : " + insertCount);
		
		return insertCount == 1
				? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
				// 삼항 연산자 처리
	}
	// 특정게시물 댓글목록 확인 
	// p.435 수정으로 인한 getList() 주석처리
//	@GetMapping(value = "pages/{bno}/{page}",
//			produces = {
//					MediaType.APPLICATION_XML_VALUE,
//					MediaType.APPLICATION_JSON_UTF8_VALUE})
//	public ResponseEntity<List<ReplyVO>> getList(
//			@PathVariable("page") int page,
//			@PathVariable("bno") Long bno){
//		
//		log.info("getList........ ");
//		Criteria cri = new Criteria(page,10);
//		
//		log.info(cri);
//		
//		return new ResponseEntity<List<ReplyVO>>(service.getList(cri, bno), HttpStatus.OK);
//	}
	
	@GetMapping(value = "pages/{bno}/{page}",
			produces = {
					MediaType.APPLICATION_XML_VALUE,
					MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyPageDTO> getList(
			@PathVariable("page") int page,
			@PathVariable("bno") Long bno){
		
		log.info("getList........ ");
		Criteria cri = new Criteria(page,10);
		
		log.info("get Reply List bno: " + bno);
		log.info("cri: " + cri);
		
		return new ResponseEntity<ReplyPageDTO>(service.getListPage(cri, bno), HttpStatus.OK);
	}
	// 조회
	@GetMapping(value = "/{rno}",
			produces = {MediaType.APPLICATION_XML_VALUE,
						MediaType.APPLICATION_JSON_UTF8_VALUE})
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno){
		
		log.info("get : " + rno);
		
		return new ResponseEntity<ReplyVO>(service.get(rno), HttpStatus.OK);
	}
	// 삭제
	@DeleteMapping(value = "/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno){
		
		log.info("remove: "+ rno);
		
		return service.remove(rno) == 1
			? new ResponseEntity<String>("success", HttpStatus.OK)
			: new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	// 수정
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(
			@RequestBody ReplyVO vo,
			@PathVariable("rno") Long rno){
		
		vo.setRno(rno);
		
		log.info("rno : " + rno);
		log.info("modify : " + vo);
		
		return service.modify(vo) == 1
			?	new ResponseEntity<String>	("success", HttpStatus.OK)
			:   new	ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
