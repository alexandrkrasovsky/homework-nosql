-- TODO: Implementation

create keyspace home_task1 with replication =
{ 'class' : 'SimpleStrategy', 'replication_factor': 2} AND durable_writes = true;
-- будет создано 2 копии каждой записи
-- полагаем что WQ + RQ > RF === 2 + 1 > 2 для гарантированного чтения данных
use home_task1;

create table users(
    user_id int,
    username text,
    email text,
    PRIMARY KEY (user_id, username)
    ) with clustering order by (username desc);
    -- Partytion key (по нодам кластера - считает ХЭШ) = user_id
    -- Clustering key (сортировка врунти партиции по ФИО или имени) = username

insert into users (user_id, username, email) values (101,'Vasiliy','101@mail.ru');
insert into users (user_id, username, email) values (102,'Semen','102@mail.ru');
insert into users (user_id, username, email) values (103,'Vladislav','103@mail.ru');
insert into users (user_id, username, email) values (104,'Sergey','104@mail.ru');
insert into users (user_id, username, email) values (105,'Denis','105@mail.ru');
update users set email='106@mail.ru' where user_id = 106 and username='Mikhail'; -- а почему бы и нет?=);
update users set email='107@mail.ru' where user_id = 107 and username='Alexey';  -- и тут
update users set email='108@mail.ru' where user_id = 108 and username='Arkadiy'; --  и тут тоже

select * from users; -- проверка

create table posts(
    post_id int,
    user_id int,
    username text,  -- денормализация
    topic_id int,
    content text,
    created_at timestamp,
    PRIMARY KEY ((user_id), created_at, post_id)
) with clustering order by (created_at desc, post_id asc );
-- Partytion key (по нодам кластера - считает ХЭШ) = user_id
-- Clustering key (сортировка врунти партиции по дате создания и id поста)

insert into posts (post_id, user_id,username, topic_id, content, created_at) values (51,101,'Vasiliy',201,'1A','2023-12-01');
insert into posts (post_id, user_id,username, topic_id, content, created_at) values (52,101,'Vasiliy',202,'1B','2023-12-02');
insert into posts (post_id, user_id,username, topic_id, content, created_at) values (53,102,'Semen',203,'2C','2023-12-03');
insert into posts (post_id, user_id,username, topic_id, content, created_at) values (54,102,'Semen',204,'2D','2023-12-04');
insert into posts (post_id, user_id,username, topic_id, content, created_at) values (55,103,'Vladislav',205,'3E','2023-12-05');
insert into posts (post_id, user_id,username, topic_id, content, created_at) values (56,104,'Sergey',206,'4F','2023-12-06');
insert into posts (post_id, user_id,username, topic_id, content, created_at) values (57,106,'Mikhail',207,'6G','2023-12-07');

select * from posts; -- проверка

---- TASK 1
-- пусть заданный пользователь (101,'Vasiliy','101@mail.ru');
select post_id, content, created_at from posts where user_id = 101;


---- TASK 2
-- в данной таске эффективным решением будет проивести денормализацюи и к исходой таблице posts добавить
-- столбец username
select post_id, content, created_at, username from posts where user_id = 101 limit 1;

---- TASK 3
--- пусть будет заданная дата влючающая оба поста и ни одного - проверено выводом
-- 2023-11-30
-- 2023-12-05
select post_id, content, created_at from posts where user_id = 101 and created_at > '2023-11-30'; -- вывод оба поста
select post_id, content, created_at from posts where user_id = 101 and created_at > '2023-12-05'; -- вывод ни одного поста

---- TASK 4
select user_id, username, post_id from posts where topic_id = 202 and  created_at > '2023-11-30' ALLOW FILTERING;
-- да в лекции было что ALLOW FILTERING - плохая практика - но обращаться к конкретной ноде по id пользователя перебором было бы еще дольше


