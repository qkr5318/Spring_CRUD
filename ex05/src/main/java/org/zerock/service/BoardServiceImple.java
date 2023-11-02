package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Service
@Log4j
@AllArgsConstructor
public class BoardServiceImple implements BoardService{
	
	@Setter(onMethod_ = @Autowired)
	private BoardMapper mapper;
	
	@Autowired
	private BoardAttachMapper attachMapper;

	@Override
	public void register(BoardVO board) {
		
		log.info("register....... " + board);
		
		mapper.insertSelectKey(board);
		
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			return;
		}
		
		board.getAttachList().forEach(attach ->{
			
			attach.setBno(board.getBno());
			log.info("attach === >   " + attach);
			attachMapper.insert(attach);
		});
		
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get....... " + bno);
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("modify....... " + board);
		return mapper.update(board) == 1;
	}

	@Override
	public boolean remove(Long bno) {
		log.info("remove....... " + bno);
		
		return mapper.delete(bno) == 1;
	}

	// p.299 수정 주석처리
	/*
	 * 	@Override
	public List<BoardVO> getList() {
	
		log.info("getList..........................");
		return mapper.getList();
	}
	*/
	
	@Override
	public List<BoardVO> getList(Criteria cri) {
	
		log.info("get List with criteria 11111111111: " + cri);
	
		List<BoardVO> list = mapper.getListWithPaging(cri);
		
		return list;
	}
	
	// p.323 BoardMapper의 getTotalCount()를 호출
	public int getTotal(Criteria cri) {
		
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
	
}
