create keyspace if not exists my_ks with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 };
use my_ks;
create table if not exists posts
(
    user_id    INT,
    username   VARCHAR,
    email      VARCHAR,
    post_id    INT,
    topic_id   INT,
    content    TEXT,
    created_at TIMESTAMP,
    PRIMARY KEY (user_id, created_at)
) with clustering order by (created_at DESC);

create table if not exists topic_posts
(
    user_id    INT,
    username   VARCHAR,
    email      VARCHAR,
    post_id    INT,
    topic_id   INT,
    content    TEXT,
    created_at TIMESTAMP,
    date       DATE,
    PRIMARY KEY ((topic_id, date), created_at)
) with clustering order by (created_at DESC);

INSERT INTO posts (user_id, username, email, post_id, topic_id, content, created_at)
VALUES (1, 'username1', 'email1', 1, 1, 'content1', '2022-01-01 00:00:00');
INSERT INTO posts (user_id, username, email, post_id, topic_id, content, created_at)
VALUES (2, 'username2', 'email2', 2, 2, 'content2', '2022-01-02 00:00:00');
INSERT INTO posts (user_id, username, email, post_id, topic_id, content, created_at)
VALUES (3, 'username3', 'email3', 3, 3, 'content3', '2022-01-03 00:00:00');

INSERT INTO topic_posts (user_id, username, email, post_id, topic_id, content, created_at, date)
VALUES (1, 'username1', 'email1', 1, 1, 'content1', '2022-01-01 00:00:00', '2022-01-01');
INSERT INTO topic_posts (user_id, username, email, post_id, topic_id, content, created_at, date)
VALUES (2, 'username2', 'email2', 2, 2, 'content2', '2022-01-02 00:00:00', '2022-01-02');
INSERT INTO topic_posts (user_id, username, email, post_id, topic_id, content, created_at, date)
VALUES (3, 'username3', 'email3', 3, 3, 'content3', '2022-01-03 00:00:00', '2022-01-03');

SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1;

SELECT post_id, content, created_at, username
FROM posts
WHERE user_id = 1
LIMIT 1;

SELECT post_id, content, created_at
FROM posts
WHERE user_id = 1
  AND created_at > '2021-01-01 00:00:00';

SELECT user_id, username, post_id, created_at
FROM topic_posts
WHERE topic_id = 1
  AND date = '2022-01-01';


