-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만을 반환. (on 조건을 통해 교집합 찾기)
-- 즉, post 테이블에 글쓴 적이 있는 author와 글쓴이가 author에 있는 post 데이터를 결합하여 출력
select * from author inner join post on author.id = post.author_id;
select * from author a inner join post p on a.id = p.author_id; -- alias 사용
-- 출력 순서만 달라질 뿐 위 쿼리와 아래 쿼리는 동일
select * from post p inner join author a on a.id = p.author_id;
-- 만약 위 두 쿼리와와 같게 하고 싶다면면
select a.*, p.* from post p inner join author a on a.id = p.author_id;


-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오.
-- post의 글쓴이가 없는 데이터는 제외. 글쓴이 중 글 쓴 적 없는 사람도 제외.
select p.*,a.email from author a inner join post p on a.id = p.author_id;

-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오.
select p.title, p.content, a.name from post p inner join author a on a.id = p.author_id;

-- A left join B : A 테이블의 데이터는 모두 조회하고, 관련 있는 B 데이터도 출력.
-- 글쓴이는 모두 출력하되, 글을 쓴 적이 있다면 관련 글도 같이 출력
select * from author a left join post p on a.id = p.author_id;

-- 모든 글 목록을 출력하고, 만약 저자가 있다면 이메일 정보를 출력.
select p.*, a.email from post p left join author a on a.id = p.author_id;

-- 모든 글 목록을 출력하고, 관련된 저자 정보 출력 (author_id가 not null 이라면)
-- 아래 두 쿼리는 동일
select * from post p left join author a on a.id = p.author_id;
select * from post p inner join author a on a.id = p.author_id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 email을 출력하되,
--       저자의 나이가 30세 이상인 글만 출력
select p.title, a.email from post p
 inner join author a on a.id = p.author_id
 where a.age >= 30;

-- 전체 글 목록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글 목록만을 출력.
select p.* from post p left join author a on a.id = p.author_id
 where a.name is not null;
select p.* from post p inner join author a on a.id = p.author_id;

-- 조건에 맞는 도서와 저자 리스트 출력
select b.BOOK_ID, a.AUTHOR_NAME, date_format(b.PUBLISHED_DATE, '%Y-%m-%d') as PUBLISHED_DATE
from BOOK b
inner join AUTHOR a
on b.AUTHOR_ID = a.AUTHOR_ID
where b.CATEGORY = '경제'
order by PUBLISHED_DATE;

-- 없어진 기록 찾기
SELECT o.animal_id, o.name from animal_outs o where o.animal_id not in (select animal_id from animal_ins);


-- union : 두 테이블의 select 결과를 횡으로 결합 (기본적으로 distinct 적용)
-- union 시킬 때 컬럼읙 개수와 컬럼의 타입이 같아야 함
select name, email from author union select title, content from post;

-- union all : 중복까지 모두 포함
select name, email from author union all select title, content from post;

-- 서브쿼리 : select문 안에 또 다른 select 문을 서브쿼리라 한다.
-- where 절 안에 서브쿼리
-- 한 번이라도 글을 쓴 author 목록 조회
select distinct a.* from author a inner join post p on a.id = p.author_id;
-- null 값은 in 조건절에서 자동으로 제외
select * from author where id in (select author_id from post);

-- 컬럼 위치에 서브쿼리
-- author의 email과 author 별로 본인의 쓴 글의 개수를 출력
select email, (select count(*) from post p where p.author_id = a.id) from author a;

-- from 절 위치에 서브쿼리
select a.* from (select * from author where id > 5) as a;

-- group by 컬럼명 : 특정 컬러믕로 데이터를 그룹화하여, 하나의 행(row)처럼 취급 (보통 기준이 되는 컬럼밖에 조회할 수 없음)
select author_id from post group by author_id;
-- 보통 아래와 같이 집계 합수(그룹화한 행 끼리)와 같이 많이 사용
select author_id, count(*) from post group by author_id;

-- 집계 함수
-- null은 count에서 제외
select count(*) from author; -- 행의 개수
select sum(price) from post; -- 합계
select avg(price) from post; -- 평균
select round(avg(price), 3) from post; -- 소수점 3번째 자리에서 반올림


-- group by와 집계 함수
select author_id, count(*), sum(price) from post group by author_id;

-- where와 group by (전체 데이터에 대한 조건이면 where 절은 group by 앞에, 그룹화한 데이터에 대한 조건이면 group by 뒤에 위치)
-- 날짜별 post 글의 개수 출력 (null은 제외)
select date_format(created_time, '%Y-%m-%d') as day, count(*) from post where created_time is not null group by day;

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
-- 입양 시각 구하기(1)
select date_format(DATETIME, '%H')/1 as HOUR, count(1) as COUNT
from ANIMAL_OUTS 
group by HOUR
having HOUR between 9 and 19
order by HOUR;

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 2번 이상 쓴 사람의 ID 찾기
select author_id, count(*) from post group by author_id having count(*) >= 2;

-- 동명 동물 수 찾기
select NAME, count(NAME) as COUNT
from ANIMAL_INS
group by NAME
having COUNT >= 2
order by NAME;

-- 카테고리 별 도서 판매량 집계하기
select b.CATEGORY, sum(s.SALES) as TOTAL_SALES 
from BOOK b
inner join BOOK_SALES s
on b.BOOK_ID = s.BOOK_ID
where date_format(s.SALES_DATE, '%Y-%m') = '2022-01'
group by b.CATEGORY
order by b.CATEGORY;

-- 조건에 맞는 사용자와 총 거래금액 조회하기
select u.USER_ID, u.NICKNAME, sum(b.PRICE) as TOTAL_SALES
from USED_GOODS_BOARD b
inner join USED_GOODS_USER u
on b.WRITER_ID = u.USER_ID
where b.STATUS = 'DONE'
group by u.USER_ID
having TOTAL_SALES >= 700000
order by TOTAL_SALES;

-- 다중열 group by
-- group by 첫번째 컬럼, 두번째 컬럼 : 첫번째 컬럼으로 먼저  grouping 한 이후에 두번째 컬럼으로 grouping
-- post 테이블에서 작성자 별로 만든 제목의 개수를 출력하시오
select author_id, title, count(*) from post group by author_id, title;

-- 재구매가 일어난 상품과 회원 리스트 구하기
select USER_ID, PRODUCT_ID
from ONLINE_SALE
group by USER_ID, PRODUCT_ID
having count(*) >= 2
order by USER_ID, PRODUCT_ID desc;