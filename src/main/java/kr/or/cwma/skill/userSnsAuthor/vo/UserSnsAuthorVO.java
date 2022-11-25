package kr.or.cwma.skill.userSnsAuthor.vo;

import org.springframework.stereotype.Component;

import lombok.Data;

@Component
@Data
public class UserSnsAuthorVO {

	private String userId;	// 사용자 아이디
	private String se;		// 구분(K: kakao, G: google, N: naver)
	private String snsId;	// SNS 고유 아이디
	private String rgstDt;	// 등록일시

	private String authYn;	// 인증여부
	
}
