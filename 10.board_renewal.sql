-- 사용자 테이블 생성 (author)
create table author (
id bigint primary key auto_increment
, email varchar(50) not null
, name varchar(50)
, password varchar(255) not null
);

-- 주소 테이블 (address)
create table address (
id bigint primary key auto_increment
, author_id bigint not null
, country varchar(255) not null
, city varchar(255) not null
, street varchar(255) not null
, foreign key(author_id) references author(id)
);

-- 게시글 테이블 (post)
create table post(
id bigint primary key auto_increment
, title varchar(255) not null
, contents varchar(1000)
);

-- 게시글 작성자 테이블 (author_post)
create table author_post(
id bigint primary key auto_increment
, post_id bigint not null
, author_id bigint not null
, foreign key(post_id) references post(id)
, foreign key(author_id) references author(id)
);


-- 복합키를 이용한 연결 테이블 생성
create table author_post2(
post_id bigint not null
, author_id bigint not null
, primary key(author_id, post_id)
, foreign key(post_id) references post(id)
, foreign key(author_id) references author(id)
);

-- 회원가입 및 주소생성
DELIMITER //
create procedure insert_author(
    in emailInput varchar(255)
    , in nameInput varchar(255)
    , in passwordInput varchar(255)
    ,in countryInput varchar(255)
    , in cityInput varchar(255)
    , in streetInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into author(email, name, password) values (emailInput, nameInput, passwordInput);
    insert into address(author_id, country, city, street)
     values(
        (select id from author order by id desc limit 1)
        , countryInput, cityInput, streetInput);
    commit;
end //
DELIMITER ;

-- 글쓰기
DELIMITER //
create procedure insert_post(
    in titleInput varchar(255)
    , in contentsInput varchar(255)
    , in emailInput varchar(255))
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    insert into post(title, contents) values (titleInput, contentsInput);
    insert author_post(author_id, post_id)
     values (
        (select id from author where email=emailInput),
         (select id from post order by id desc limit 1)
         );
    commit;
end //
DELIMITER ;


-- 글편집하기
DELIMITER //
create procedure edit_post(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255), in idInput bigint)
begin
    declare exit handler for SQLEXCEPTION
    begin
        rollback;
    end;
    start transaction;
    update post set title=titleInput, contents=contentsInput where id=idInput;
    insert author_post(author_id, post_id) values((select id from author where email=emailInput), idInput);
    commit;
end //
DELIMITER ;