package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	// 댓글 등록
	public int  insert(ReplyVO vo);
	
	// 댓글 조회
	public ReplyVO read(Long rno); // 특정 댓글 읽기
	
	// 댓글 삭제
	public int delete (Long rno);
	
	// 댓글 수정
	public int update(ReplyVO reply);
	
	// 게시물 댓글 목록 
	// @Param의 속성값은 MyBatis에서 SQL을 이용할 때 '#{}'의 이름으로 사용이 가능하다.
	// 페이징 처리는 기존과 동일하게 Criteria를 이용
	// 여기서 추가적으로 번호는 파라미터를 전달하도록 ReplyMapper를 구성한다.
	public List<ReplyVO> getListWithPaging(
			@Param("cri") Criteria cri,
			@Param("bno") Long bno);
	
	// 댓글의 숫자 파악 
	// 댓글들을 페이징 처리하기 위해서는 해당 게시물의 전체 댓글의 숫자를 파악해서 화면에 보여줄 필요가 있다.
	// ReplyMapper 인터페이스에 getCountByBno()를 추가
	public int getCountByBno(Long bno);
	
	// 모든 댓글 삭제 처리
	public int deleteAll(Long bno);
}
