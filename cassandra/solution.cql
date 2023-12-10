-- TODO: Implementation
describe cluster;

create keyspace my_ks with replication = {'class':'SimpleStrategy', 'replication_factor':1};

use my_ks;

create table posts
(
    user_id int,
    username text,
    email text,
    post_id int,
    topic_id int,
    content text,
    created_at timestamp,
    PRIMARY KEY (user_id, created_at, topic_id)
) with clustering order by (created_at desc, topic_id asc);

insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (1, 'Mary', 'mary@mail.ru', 1, 1, 'Topic 1', '2011-02-03 04:05+0000');
insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (1, 'Mary', 'mary@mail.ru', 2, 1, 'Topic 1', '2011-02-05 16:18+0000');
insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (2, 'Alex', 'alex@mail.ru', 7, 1, 'Topic 1', '2011-02-05 16:21+0000');
insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (1, 'Mary', 'mary@mail.ru', 3, 1, 'Topic 1', '2011-02-06 12:59+0000');
insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (1, 'Mary', 'mary@mail.ru', 4, 1, 'Topic 1', '2011-02-07 11:18+0000');
insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (2, 'Alex', 'alex@mail.ru', 5, 2, 'Topic 2', '2011-03-01 07:28+0000');
insert into posts (user_id, username, email, post_id, topic_id, content, created_at) values (2, 'Alex', 'alex@mail.ru', 6, 2, 'Topic 2', '2011-03-11 13:28+0000');

-- task 1
select post_id, content, created_at
from posts
where user_id = 1
order by created_at desc, topic_id asc;

-- task 2
select post_id, content, created_at, username
from posts
where user_id = 1
order by created_at desc, topic_id asc
limit 1;

-- task 3
select post_id, content, created_at
from posts
where user_id = 1 and created_at >= '2011-02-05'
order by created_at desc, topic_id asc;

-- task 4
-- так как тут нужно выводить user_id, то таблица posts не подходит, создадим новую таблицу для данной задачи только с необходимыми столбцами
-- создание таблицы и добавление данных
create table user_post
(
    user_id int,
    username text,
    post_id int,
    topic_id int,
    created_at timestamp,
    PRIMARY KEY (topic_id, created_at, user_id)
) with clustering order by (created_at desc, user_id asc);

insert into user_post (user_id, username, post_id, topic_id, created_at) values (1, 'Mary', 1, 1, '2011-02-03 04:05+0000');
insert into user_post (user_id, username, post_id, topic_id, created_at) values (1, 'Mary', 2, 1, '2011-02-05 16:18+0000');
insert into user_post (user_id, username, post_id, topic_id, created_at) values (2, 'Ivan', 7, 1, '2011-02-05 16:21+0000');
insert into user_post (user_id, username, post_id, topic_id, created_at) values (1, 'Mary', 3, 1, '2011-02-06 12:59+0000');
insert into user_post (user_id, username, post_id, topic_id, created_at) values (1, 'Mary', 4, 1, '2011-02-07 11:18+0000');
insert into user_post (user_id, username, post_id, topic_id, created_at) values (2, 'Ivan', 5, 2, '2011-03-01 07:28+0000');
insert into user_post (user_id, username, post_id, topic_id, created_at) values (2, 'Ivan', 6, 2, '2011-03-11 13:28+0000');

-- запрос
select user_id, username, post_id, created_at
from user_post
where topic_id=1 and created_at >= '2011-02-05' and created_at < '2011-02-06'
order by created_at desc;