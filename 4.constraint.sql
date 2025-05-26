-- not nulll 제약 조건 추가
alter table author modify column name varchar(255) not null;
alter table post modify column title varchar(255) not null;

-- not null 제약 조건 제거 (덮어쓰기)
alter table author modify column name varchar(255);
alter table author modify column title varchar(255);

-- not null, unique 제약 조건 동시 추가
alter table author modify column email varchar(255) not null unique;

-- table 차원의 제약 조건(PK, FK) 추가/제거
-- 제약 조건의 이름을 먼저 알아야함 => information_schema.key_column_usage
-- 제약 조건 삭제 (FK); FK는 여러 개 있을 수 있기 때문에 제약조건명을 알아야 함
alter table post drop foreign key 제약조건명; -- 주로 사용
alter table post drop constraint 제약조건명;

-- 제약 조건 삭제 (PK); PK는 테이블 당 하나씩 밖에 없기 때문에 제약조건명을 명시해주지 않아도 됨
alter table post drop primary key;

-- 제약 조건 추가
alter table post add constraint 제약조건명 primary key(id);
alter table post add constraint post_fk foreign key(author_id) references author(id);

-- one delete/update 제약 조건 테스트
-- 부모 테이블 데이터 delete 시에 자식 fk 컬럼 set nulll, update 시에 자식 fk 컬럼 cascade
alter table post add constraint post_fk_new foreign key(author_id)
 references author(id) on delete set null on update cascade;

-- default 옵션
-- enum 타입 및 현재 시간(current_timestamp) 에서 많이 사용
alter table author modify name varchar(255) default 'anonymous';

-- auto_increment : 입력을 안했을 때 마지막에 입력된 가장 큰 값에서 +1 만큼 자동으로 증가된 숫자값을 적용
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;

-- uuid 타입 (uuid() 함수 사용)
alter table post add column user_id char(36) default (uuid());