-- read uncommited (가장 낮은 격리 수준) : 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 다른 트랜잭션이 커밋되지 않은 데이터를 내가 read
-- 실습 절차
-- 1) 워크 벤치에서 auto_commit 해제. update 후, commit하지 않음 (transaction1)
-- 2) 터미널을 열어 select 했을 떄 위 변경 사항이 읽히는 지 확인 (transaction2)
-- 결론 : mariadb 는 기본이 repeatable read 이므로 dirty read 발생X (워크 벤치에서 commit 하지 않으면 터미널에서 조회 시 읽히지 않음)


-- read committed : 커밋한 데이터만 read 가능 -> phantom read 발생 (또는 non-repeatable read)
-- 워크벤치에서 실행
start transaction;
select count(*) from author;
do sleep(15);
select count(*) from author;
commit;
-- 터미널에서 실행
insert into author(email, name) values ("xxxxx@naver.com", "jhjhjh");


-- repeatable read : phantom read 해결 (읽기의 일관성 보장) -> ** lost update 문제 발생 -> 배타적 잠금으로 해결 **
-- lost update 문제 발생
DELIMITER //
create procedure concurrent_test1()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values ('hello world', 1);
    select post_count into count from author where id = 1;
    do sleep(15);
    update author set post_count = count + 1 where id = 1;
    commit;
end //
DELIMITER ;
-- 터미널에서는 아래 코드 실행
select post_count from author where id = 1; -- => 0

-- lost update 문제 해결 : select for update 시에 트랜잭션이 종료 후에 특정 행에 대한 lock 풀림
DELIMITER //
create procedure concurrent_test2()
begin
    declare count int;
    start transaction;
    insert into post(title, author_id) values ('hello world', 1);
    select post_count into count from author where id = 1 for update;
    do sleep(15);
    update author set post_count = count + 1 where id = 1;
    commit;
end //
DELIMITER ;
-- 터미널에서는 아래 코드 실행
select post_count from author where id = 1 for update;

-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성 문제 없으나 저하