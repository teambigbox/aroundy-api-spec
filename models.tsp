import "./utils.tsp";
import "./types.tsp";

/** 상속용 Post 클래스 */
model BasePost extends Identifiable {
	/** 제목 */
	title: string;

	/** 카테고리 */
	category: Category.Base;

	/** 피드 배너 이미지 목록 */
	@maxItems(10)
	feeds: url[];

	/** Post 상세 내용 */
	@maxLength(2200)
	caption: string;

	/** 이벤트 유형 */
	type: EventType;

	/** 상세주소 */
	location: string | null;

	/** 연락처 */
	contact: string | null;

	/** 가격 */
	pricing: uint64 | null;

	/** 할인률 */
	discountRate: uint64 | null;

	/** 오픈일 */
	startsAt: utcDateTime;

	/** 종료일 */
	endsAt: utcDateTime | null;

	/** 출처 링크 */
	link: url | null;
}

/** Post 생성 시 입력할 정보 */
model CreatePost extends OmitProperties<BasePost, "id"> {
	/** Post를 생성할 기업의 ID */
	companyId: id;

	/** 태그 id 목록 */
	tagIds: id[];
}

/** Post 수정 시 입력할 정보 */
alias UpdatePost = OptionalProperties<OmitProperties<
	CreatePost,
	"companyId"
>>;

/** Post 정보 */
model Post extends BasePost {
	/** 게시일 */
	createAt: utcDateTime;

	/** Post를 등록한 기업 */
	company: Company;

	/** 태그 목록 */
	tags: Tag[];

	/** 좋아요 수 */
	likes: uint64;

	/** 조회수 */
	views: uint64;

	/** 현재 로그인된 사용자가 이미 좋아요한 Post인지 여부 */
	isLiked: boolean;

	/** 현재 로그인된 사용자가 이미 마이페이지에 저장한 Post인지 여부 */
	isSaved: boolean;
}

/** 상속용 Company 클래스 */
model BaseCompany {
	/** 기업명 */
	name: string;

	/** 기업 로고 */
	logo: url;

	/** 상태 */
	active: boolean;
}

/** 기업정보 수정 시 입력할 정보 */
alias UpdateCompany = OptionalProperties<BaseCompany>;

/** 기업 정보 */
model Company extends BaseCompany {
	...Identifiable;
}

/** 이미지 업로드 정보 */
model Image {
	filename: string;
	image: bytes;
}

/** 카테고리 관련 타입 */
namespace Category {
	/** 카테고리 정보 */
	model Base extends Identifiable {
		...Create;
	}

	model Create {
		/** 카테고리명 */
		name: string;
	}
}

/** 태그 관련 타입 */
namespace Tag {
	/** 태그 정보 */
	model Base extends Identifiable {
		...Create;
	}

	model Create {
		/** 태그명 */
		name: string;
	}
}

/** 상속용 UserProfile 클래스 */
model BaseUserProfile extends Identifiable {
	/** 사용자 실명 */
	name: string;
}

/**
 * 상속용 User 클래스
 *
 * 주로 사용자가 회원가입 후 추가적으로 입력하는 개인정보들이 포함된다.
 */
model BaseUser extends BaseUserProfile {
	/** 회원 성별 */
	gender: Gender | null;

	/** 이메일 */
	@format("email")
	email: string;

	/** 전화번호 */
	telephone: string | null;

	/**
	 * 생년월일
	 *
	 * 형식은 [RFC 3339문서의 5.6 문단](https://datatracker.ietf.org/doc/html/rfc3339#section-5.6)을 따른다.
	 *
	 * @example "2005-12-12"
	 */
	birth: plainDate | null;
}

/** 회원 정보 */
model User extends BaseUser {
	/** 사용한 소셜 로그인 서비스 */
	oAuthProvider: string;

	/** 회원 가입일 */
	createAt: utcDateTime;

	/** 마지막 로그인 시점 */
	lastLogin: utcDateTime;
}

/** User 수정 시 입력할 정보 */
alias UpdateUser = OptionalProperties<OmitProperties<
	BaseUser,
	"id"
>>;

/**
 * 회원 프로필 정보
 *
 * 프로필 페이지에 보여줄 정보들이 포함된다.
 */
model UserProfile extends BaseUserProfile {
	/** 사용자가 팔로우 중인 기업 목록 */
	follows: Paginate<Company[]>;

	/** 사용자가 저장한 포스트 목록 */
	saved: Paginate<Post[]>;
}
