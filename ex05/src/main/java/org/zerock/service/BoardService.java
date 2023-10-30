package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {

	public void register(BoardVO board);
	
	public BoardVO get(Long bno);
	
	public boolean modify(BoardVO board);
	
	public boolean remove(Long bno);
	//p.299 예제 수정 주석처리
//	public List<BoardVO> getList();
	public List<BoardVO> getList(Criteria cri);
	
	// p.323 BoardMapper의 getTotalCount()를 호출
	public int getTotal(Criteria cri);
	
}
