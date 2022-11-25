package kr.or.cwma.admin.sanctn.vo;

import java.io.Serializable;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("Agncy")
public class Agncy implements Serializable{

	private static final long serialVersionUID = 1L;
	
	/**
	 * 순번
	 */
	private Integer agncyNo;
	
	/**
	 * 구분
	 */
	private String se;
	
	/**
	 * 이름검색
	 */
	private String agncyNm;
	
	/**
	 * 시작일
	 */
	private String bgnde;
	
	/**
	 * 종료일
	 */
	private String endde;
	
	/**
	 * 대리결재자 id
	 */
	private String agncyId;
	
	/**
	 * 대리결재자 id
	 */
	private String userId;
	
	/**
	 * 대리결재자 id
	 */
	private String userName;
	
	/**
	 * 대리결재자 id
	 */
	private String brffcNm;
	
	/**
	 * 대리결재자 id
	 */
	private String email;
	
	/**
	 * 삭제여부
	 */
	private String deleteAt;

	/**
	 * 등록자
	 */
	private String rgstId;
	
}
