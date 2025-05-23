-- tinyint : -128 ~ 127까지 표현 (unsigned시에 0~255까지; 표현 범위 넘을 시 에러 발생)
-- author 테이블에 age컬럼 변경
alter table author modify column age tinyint unsigned;
insert into author(id, email, age) values (7, 'lee7878@naver.com', 300);

-- int : 4바이트 (대략, 40억 숫자범위)

-- bigint : 8바이트
-- author, post테이블의 id값 bigint로 변경 => author.id 데이터 타입 변경 불가
-- 참조 관계이기 때문에 바꿀 수 없음. 관계를 먼저 끊고 바꾸어 주어야 함.
-- foreign key (FK) 삭제
alter table post drop constraint post_ibfk_1;
-- 데이터 타입 변경경
alter table author modify column id bigint;
alter table post modify column id bigint;
alter table post modify column author_id bigint;
-- 다시 제약 조건 추가
alter table post add constraint post_ibfk_1;

-- decimal (총 자릿수, 소수부 자릿수)
alter table post add column price decimal(10, 3);
-- decimal 소수점 자릿수 초과 시 짤림 현상 발생
insert into post(id, title, price, author_id) values (8, 'hello python', 10.33412, 2);

-- 문자 타입 : 고정 길이 (char), 가변 길이 (varchar, text)
alter table author add column gender char(1); -- M or W
alter table author add column self_introduction text;

-- blob(바이너리 데이터) 타입 실습
-- 일반적으로 blob으로 저장하기 보다, varchar로 설계하고 이미지 경로만을 저장
alter table author add column profile_image longblob;
insert into author(id, email, profile_image) values(9, 'aaa@naver.com', LOAD_FILE('C:\\cat.jpg'));

-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼 추가
alter table author add column role enum('admin', 'user') not null default 'user';
-- enum에 지정된 값이 아닌 경우
insert into author(id, email, role) values (10, 'sss@naver.com', 'admin2');
-- role을 지정 안 한 경우
insert into author(id, email) values (11, 'sss@naver.com');
-- enum에 지정된 값인 경우
insert into author(id, email, role) values (12, 'sss@naver.com', 'admin');

-- date와 datetime
-- 날짜 타입의 입력, 수정, 조회 시에 문자열 형식을 사용(형식만 문자열)
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, author_id, created_time) values (7, 'hello', 3, '2025-05-23 14:36:30');
alter table post modify column created_time datetime default current_timestamp(); -- 입력 안 할 시 현재 시간 입력
insert into post(id, title, author_id) values (7, 'hello', 3);

-- 비교 연산자
select * from author where id >= 2 and id <= 4; -- id 2,3,4 조회
select * from author where id between 2 and 4; -- 위 구문과 동일
select * from author where id in (2, 3, 4); -- 위 구문과 동일

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%'; -- h로 시작
select * from post where title like '%h'; -- h로 끝
select * from post where title like '%h%'; -- h 포함
select * from post where title not like 'h%'; -- h로 시작 제외

-- regexp : 정규 표현식을 활요한 조회
select * from post where title regexp '[a-z]' -- 하나라도 알파벳 소문자가 들어있으면
select * from post where title regexp '[가-힣]' -- 하나라도 한글이 있으면

-- 날짜 -> 숫자
-- 20250523 -> 2025-05-23
select cast(20250523 as date); -- 테이블 대상으로 cast 하는 것이 아니기 때문에 반드시 from 절이 필요한 것은 아님
select cast(num as date) from author;

-- 문자 -> 날짜
select cast('20250523' as date); -- '20250523' -> 2025-05-23

-- 문자 -> 숫자
select cast('12' as unsigned); -- '12' -> 12

-- 날짜 조회 방법
-- like 패턴, 부등호 활용, date_format
select * from post where created_time like '2025-05%'; -- 문자열처럼 조회
-- 2025-05-01 부터 2025-05-20 까지
-- select * from post where created_time >= '2025-05-01' and created_time <= '2025-05-20';
-- 위에처럼 조회하는 경우 created_time <= '2025-05-20'는 '2025-05-20 00:00:00' 까지만 포함임
-- 날짜만 입력하여 조회시 시간 부분은 00:00:00이 자동으로 붙음
select * from post where created_time >= '2025-05-01' and created_time < '2025-05-21';

select date_format(created_time, '%Y-%m-%d') from post; -- 일자만 조회
select date_format(created_time, '%H:%i:%s') from post; -- 시간만 조회

select * from post where date_format(created_time, '%m') = '05'; -- 날짜가 5월인 데이터만 조회

select * from post where cast(date_format(created_time, '%m') as unsigned) = 5;