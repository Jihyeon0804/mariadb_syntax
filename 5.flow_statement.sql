-- 흐름 제어 : case when, if, ifnull
-- if (a, b, c) : a조건이 참이면 b 반환, 그렇지 않으면 c 반환
select id, if (name is null, '익명사용자', name) from author;

-- ifnull (a, b) : a가 null이면 b를 반환, null이 아니면 a를 그대로 반환
select id, ifnull(name, '익명사용자') from author;

-- case when : case when 구문 끝에 end 써주어야 함
select id,
    case
        when name is null then '익명사용자'
        when name = 'hong1' then '홍길동'
        else name
    end
from author;