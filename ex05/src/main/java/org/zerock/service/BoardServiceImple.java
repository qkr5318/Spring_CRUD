package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

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

	@Autowired
	private ReplyMapper replyMapper;
	@Transactional
	@Override
	public void register(BoardVO board) {
		
		log.info("register....... " + board);
		
		mapper.insertSelectKey(board);
		
		if (board.getAttachList() == null || board.getAttachList().size() <= 0) {
			log.info("확인 서비스");
			return;
		}
		
		board.getAttachList().forEach(attach ->{

			log.info("attach ===>   " + attach);
			attach.setBno(board.getBno());
			
				String type = "true";
				String check = attach.getFileType();
				System.out.println(check);
				System.out.println(" attach.getFileType().equals(type) ===  " + check.equals(type));
				
				// fileType 값이 true일 때 1으로 설정	
			    if (attach.getFileType().equals(type)) {
			        attach.setFileType("1");
			    }
			    // fileType 값이 fasle일 때 0로 설정
			    else {
			        attach.setFileType("0");
			    }


			attachMapper.insert(attach);
		});
		
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get....... " + bno);
		return mapper.read(bno);
	}

	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		
		log.info("modify....... " + board);
		
		attachMapper.deleteAll(board.getBno());
		
		boolean modifyResult = mapper.update(board) == 1;
		
		if (modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			
			board.getAttachList().forEach(attach ->{
				
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return modifyResult;
	}

	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove....... " + bno);
		
		replyMapper.deleteAll(bno);
		
		attachMapper.deleteAll(bno);
		
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

	// getAatachList()메소드를 추가해서 게시물의 첨부파일들의 목록을 가져온다.
	@Override
	public List<BoardAttachVO> getAttachList(Long bno) {
		
		log.info("get Attach list by bno" + bno);
		
		return attachMapper.findByBno(bno);
	}
	
	
}
