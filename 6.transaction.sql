-- 트랜잭션 : 논리적인 작업 처리 단위(1개 이상의 SQL문의 집합)
-- 트랜잭션 -> 0) 임시저장  1) commit  2) rollback
-- 트랜잭션 테스트
alter table author add column post_count int default 0;

-- post에 글 쓴 후에, author 테이블의 post_count 컬럼에 +1을 시키는 트랜잭션 테스트 (분기처리X)
start transaction;
update author set post_count = post_count + 1 where id = 3;
insert into post(title, content, author_id) values ("hello", "hello....", 3);
commit; -- 또는 rollback;

-- 위 트랜잭션은 실패 시 자동으로 rollback 어려움
-- stored 프로시저를 활용하여 성공 시 commit, 실패 시 rollback 등 다이나믹한 프로그래밍 가능
-- update, insert 문에서 error 발생 시 rollback
DELIMITER //
create procedure transaction_test()
begin
    -- SQLEXCEPTION 발생 시 rollback
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update author set post_count = post_count + 1 where id = 3;
    insert into post(title, content, author_id) values ("hello", "hello....", 3);
    commit;
end //
DELIMITER ;

-- 프로시저 호출
call transaction_test();


-- 사용자에게 입력받는 프로시저 생성
DELIMITER //
create procedure transaction_test2(in titleInput varchar(255), in contentInput varchar(255), in idInput bigint)
begin
    -- SQLEXCEPTION 발생 시 rollback
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update author set post_count = post_count + 1 where id = idInput;
    insert into post(title, content, author_id) values (titleInput, contentInput, idInput);
    commit;
end //
DELIMITER ;

-- 프로시저 호출
call transaction_test2('abc', 'abc....', 3);