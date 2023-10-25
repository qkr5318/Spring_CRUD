package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor // BoardService 타입의 객체와 같이 연동해야 하므로 의존성에 대한 처리로 @Allconstructor를 이용해서 생상자를 만들고 자동으로 주입
// 생성자를 만들지 않을 경우에는 @Setter(onMethod_ = @AutoWierd)를 이용해서 처리
public class BoardController {
	
	private BoardService service;
	
	// list()는 나중에 게시물의 목록을 전달해야 하므로 Model을 파라미터로 지정하고, 이를 통해서 BoardServiceImpl 객체의 getList() 결과를 담아 전달(addAttribute)
	// p.300 수정 주석처리
//	@GetMapping("/list")
//	public void list(Model model) {
//		
//		log.info("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" + "list");
//		
//		model.addAttribute("list", service.getList());
//	}
	
	@GetMapping("/list")
	public void list(Criteria cri,Model model) {
		
		log.info("list : " + cri);
		
		model.addAttribute("list", service.getList(cri));
		//p.307 PageDTO를 사용할 수 있도록 Model에 담아서 화면에 전달할 코드 작성
		//model.addAttribute("pageMaker", new PageDTO(cri, 123));
		
		// p.324 BoardService 인터페이스를 통해서 getTotal()을 호출하도록 변경
		int total = service.getTotal(cri);
		
		log.info("total: " + total);
		
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		
		log.info("register : " + board);
		
		service.register(board);
		
		rttr.addFlashAttribute("result", board.getBno());
		
		return "redirect:/board/list";
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
	
	//@GetMapping이나 @PostMapping 등에는 URL을 배열로 처리할 수 있다.
	// 즉, 하나의 메소드로 여러개의 URL을 처리할 수 있다.
//	@GetMapping({"/get", "/modify"})
//	public void get(@RequestParam("bno") Long bno, Model model) {
//		
//		log.info("/get or modify");
//		model.addAttribute("board", service.get(bno));
//	}
	// p.316 수정 조회 페이지에서 다시 목록 페이지로 이동 - 페이지 번호 유지
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri , Model model) {
		
		log.info("/get or modify");
		log.info(cri);
		model.addAttribute("board", service.get(bno));
	}
	
//	@PostMapping("/modify")
//	public String modify(BoardVO board, RedirectAttributes rttr) {
//		
//		log.info("modify : " + board);
//		
//		if (service.modify(board)) {
//			rttr.addFlashAttribute("result", "success");
//			
//		}
//		return "redirect:/board/list";
//	}
	// p.319 modify 수정/삭제 처리 후 이동
	@PostMapping("/modify")
	public String modify(BoardVO board,@ModelAttribute("cri")Criteria cri ,RedirectAttributes rttr) {
		
		log.info("modify : " + board);
		
		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
			
		}
		
//		rttr.addAttribute("pageNum", cri.getPageNum());
//		rttr.addAttribute("pageNum", cri.getAmount());
//		// p.346 수정/삭제 처리는 BoardContorller에서 redirect 방식으로 동작하므로 type과 keyword 조건을 같이 리다이렉트 시에 포함시켜야만 한다.
//		rttr.addAttribute("keyword", cri.getKeyword());
//		rttr.addAttribute("type", cri.getType());
		
		return "redirect:/board/list" + cri.getListLink();
	}

//	@PostMapping("/remove")
//	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr) {
//		
//		log.info("remove : " + bno);
//		if (service.remove(bno)) {
//			rttr.addFlashAttribute("result", "success");
//		}
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno,@ModelAttribute("cri")Criteria cri ,RedirectAttributes rttr) {
		
		log.info("remove : " + bno);
		if (service.remove(bno)) {
			rttr.addFlashAttribute("result", "success");
		}
		
//		rttr.addAttribute("pageNum",cri.getPageNum());
//		rttr.addAttribute("pageNum",cri.getAmount());
//		// p.346 수정/삭제 처리는 BoardContorller에서 redirect 방식으로 동작하므로 type과 keyword 조건을 같이 리다이렉트 시에 포함시켜야만 한다.
//		rttr.addAttribute("keyword", cri.getKeyword());
//		rttr.addAttribute("type", cri.getType());
		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	
}
