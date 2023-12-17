describe
cluster;

create keyspace my_ks with replication = {'class':'SimpleStrategy', 'replication_factor':1};

use my_ks;
/*
Таблица для заданий 1,2,3
*/
CREATE TABLE user_post
(
    user_id    int,
    username   text,
    post_id    int,
    content    text,
    created_at timestamp,
    PRIMARY KEY ((user_id), created_at)
) WITH CLUSTERING ORDER BY (created_at DESC);


INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (1, 'user1', 1, 'content-1-1', '2023-01-01');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (3, 'user3', 2, 'content-3-2', '2023-01-02');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (1, 'user1', 3, 'content-1-3', '2023-02-04');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (2, 'user2', 4, 'content-2-4', '2023-03-01');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (3, 'user3', 5, 'content-3-5', '2023-03-05');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (1, 'user1', 6, 'content-1-6', '2023-04-01');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (4, 'user4', 7, 'content-4-7', '2023-04-16');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (3, 'user3', 8, 'content-3-8', '2023-05-08');

INSERT INTO user_post (user_id, username, post_id, content, created_at)
VALUES (1, 'user1', 9, 'content-1-9', '2023-06-11');

/*
Задание 1
Запрос, который бы доставал посты заданного пользователя упорядоченные по времени создания поста - сначала новые.
Запрос должен возвращать post_id, content, дату создания поста.
*/
SELECT post_id, content, created_at
FROM user_post
WHERE user_id = 1;

/*
Задание 2
Запрос, который бы доставал последний пост заданного пользователя.
Запрос должен возвращать post_id, content, дату создания поста, username.
*/
SELECT post_id, content, created_at, username
FROM user_post
WHERE user_id = 1
LIMIT 1;


/*
Задание 3
Запрос, который бы доставал посты заданного пользователя, опубликованные после заданной даты.
Запрос должен возвращать post_id, content, дату создания поста.
*/
SELECT post_id, content, created_at
FROM user_post
WHERE user_id = 1
  AND created_at > '2023-01-01'
ORDER BY created_at;

/*
Таблица для задания 4
*/

CREATE TABLE user_post_topic
(
    user_id    int,
    username   text,
    post_id    int,
    topic_id   int,
    content    text,
    created_at timestamp,
    post_date  date,
    PRIMARY KEY ((topic_id, post_date), created_at)
) WITH CLUSTERING ORDER BY (created_at DESC);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (1, 'user1', 1, 'content-1-1', '2023-03-01 00:01:00.000', '2023-01-01', 1);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (3, 'user3', 2, 'content-3-2', '2023-01-02', '2023-01-02', 1);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (1, 'user1', 3, 'content-1-3', '2023-02-04', '2023-02-04', 2);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (2, 'user2', 4, 'content-2-4', '2023-03-01', '2023-03-01', 5);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (3, 'user3', 5, 'content-3-5', '2023-03-05', '2023-03-05', 6);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (1, 'user1', 6, 'content-1-6', '2023-04-01', '2023-04-01', 1);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (4, 'user4', 7, 'content-4-7', '2023-04-16', '2023-04-16', 2);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (3, 'user3', 8, 'content-3-8', '2023-05-08', '2023-05-08', 2);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (1, 'user1', 9, 'content-1-9', '2023-06-11', '2023-06-11', 2);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (4, 'user4', 10, 'content-4-9', '2023-01-01', '2023-01-01', 2);

INSERT INTO user_post_topic (user_id, username, post_id, content, created_at, post_date, topic_id)
VALUES (4, 'user4', 11, 'content-4-9', '2023-03-01 00:02:00.000', '2023-01-01', 1);


/*
Задание 4
Запрос, который бы доставал пользователей, которые сделали пост в заданный день по заданной теме, упорядоченные
по времени - сначала новые. Запрос должен возвращать user_id, username, post_id, время создания поста.
*/
SELECT user_id, username, post_id, created_at
FROM user_post_topic
WHERE post_date = '2023-01-01' AND topic_id = 1;

