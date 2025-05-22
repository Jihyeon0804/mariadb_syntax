-- insert : 테이블에 데이터 삽입
insert into 테이블명(컬럼1, 컬럼2, 컬럼3) values (데이터1, 데이터2, 데이터3);
insert into author(id, name, email) values (3, 'hong', 'hong3@naver.com'); -- 문자열은 일반적으로 작은 따옴표 사용

-- update : 테이블에 데이터 변경
update author set name="홍길동", email="hong100@naver.com" where id=3;

-- select : 조회
select 컬럼1, 컬럼1 from 테이블명;
select name, email from author;
select * from author; -- * : 전체 컬럼

-- delete : 삭제
delete from 테이블명 where 조건절
delete from author where id=3;

-- select 조건절 활용 조회
-- 테스트 데이터 삽입
-- insert문을 활용해서 author 데이터 3개, post 데이터 5개
insert into author(id, name, email) values (4, 'kim', 'kim22@naver.com');
insert into author(id, name, email) values (5, 'lee', 'lee444@google.com');
insert into author(id, name, email) values (6, 'park', 'park777@naver.com');

insert into post(id, title, content, author_id) values (1, '안녕하세요', '안녕하세요', 2);
insert into post(id, title, content, author_id) values (2, 'hello', 'hello world', 6);
insert into post(id, title, content, author_id) values (3, 'zzzz', 'zzzz', 6);
insert into post(id, title, content, author_id) values (4, 'aaaaa', 'bbbbb', 4);
insert into post(id, title, content, author_id) values (5, 'qqqqq', 'ccccc', 1);

select * from author; -- 어떤 조회 조건없이 모든 컬럼 조회회
select * from author where id=1; -- where 뒤 조회 조건을 통해 filtering
select * from author where name='hongildong';
select * from author where id > 3;
select * from author where id > 2 and name='park';

-- 중복 제거 조회 : distinct
select name from author;
select distinct name from author;

-- 정렬 : order by + 컬럼명
-- asc : 오름차순, desc : 내림차순, 생략 시 오름차순(default)
-- 아무런 정렬 조건 없이 조회할 경우에는 pk 기준으로 오름차순
select * from author order by name;
select * from author order by name desc;

-- *** 멀티컬럼 order by *** : 여러컬럼으로 정렬 시에, 먼저 쓴 컬럼 우선 정렬. 중복 시, 그 다음 정렬 옵션 적용
select * from author order by name desc, email asc; -- name 으로 먼저 정렬 후, name 이 중복되면 email로 정렬.

-- 결과값 개수 제한
select * from author order by id desc limit 1; -- 가장 숫자 값이 큰 id 조회 (가장 최신 데이터)

-- 별칭(alias)을 이용한 select
select name as '이름', email as '이메일' from author; -- 컬럼명 별칭
select name, email from author as a; -- 테이블명 별칭 (join 시 주로 사용 select 시 별칭.컬럼명 형태로 사용 ex) a.name)

-- null을 조회 조건으로 활용
select * from author where password=null; -- 안됨
select * from author where password is null; -- null 인 경우
select * from author where password is not null; -- not null 인 경우