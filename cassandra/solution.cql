-- Создаем keyspace
CREATE KEYSPACE usersposts
WITH REPLICATION = { 'class' : 'SimpleStrategy','replication_factor' : 1 };

USE usersposts;

-- Создаем таблицы
CREATE TABLE IF NOT EXISTS posts_by_user(
    userId   uuid,
    username text,
    email    text,
    topicId  uuid,
    content  text,
    postId   timeuuid,
    PRIMARY KEY ((userId), postId)
) WITH CLUSTERING ORDER BY (postId DESC);

CREATE TABLE IF NOT EXISTS posts_by_topic(
     topicId  uuid,
     userId   uuid,
     username text,
     email    text,
     content  text,
     postId   timeuuid,
     PRIMARY KEY ((topicId), postId)
) WITH CLUSTERING ORDER BY (postId DESC);

-- Заполняем данными
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId)
VALUES (f46b81f7-b58e-41c1-bed7-fea4cd75d670, 'User0', 'user0@example.com', 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff, 'Content User0 0', minTimeuuid('2023-11-01 00:00:00+0000'));
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId)
VALUES (f46b81f7-b58e-41c1-bed7-fea4cd75d671, 'User1', 'user1@example.com', 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff, 'Content User1 0', minTimeuuid('2023-11-01 00:00:00+0000'));
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId)
VALUES (f46b81f7-b58e-41c1-bed7-fea4cd75d671, 'User1', 'user1@example.com', 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff, 'Content User1 1', minTimeuuid('2023-11-03 00:00:00+0000'));
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId)
VALUES (f46b81f7-b58e-41c1-bed7-fea4cd75d671, 'User1', 'user1@example.com', 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff, 'Content User1 2', minTimeuuid('2023-11-15 00:00:00+0000'));
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId)
VALUES (f46b81f7-b58e-41c1-bed7-fea4cd75d672, 'User2', 'user2@example.com', 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff, 'Content User2 0', minTimeuuid('2023-11-05 00:00:00+0000'));
INSERT INTO posts_by_user (userId, username, email, topicId, content, postId)
VALUES (f46b81f7-b58e-41c1-bed7-fea4cd75d670, 'User0', 'user0@example.com', 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff, 'Content User0 1', minTimeuuid('2023-11-06 00:00:00+0000'));

-- 1) Запрос, который бы доставал посты заданного пользователя упорядоченные
-- по времени создания поста - сначала новые.
-- Запрос должен возвращать post_id, content, дату создания поста.
SELECT postId, content, dateOf(postId) FROM posts_by_user
WHERE userId = f46b81f7-b58e-41c1-bed7-fea4cd75d671;

-- 2) Запрос, который бы доставал последний пост заданного пользователя.
-- Запрос должен возвращать post_id, content, дату создания поста, username.
SELECT postId, content, dateOf(postId), username FROM posts_by_user
WHERE userId = f46b81f7-b58e-41c1-bed7-fea4cd75d670
LIMIT 1;

-- 3) Запрос, который бы доставал посты заданного пользователя,
-- опубликованные после заданной даты.
-- Запрос должен возвращать post_id, content, дату создания поста.
SELECT postId, content, dateOf(postId) FROM posts_by_user
WHERE userId = f46b81f7-b58e-41c1-bed7-fea4cd75d671
AND postId > maxTimeuuid('2023-11-03');

-- 4) Запрос, который бы доставал пользователей, которые сделали пост в заданный день
-- по заданной теме, упорядоченные по времени - сначала новые.
-- Запрос должен возвращать user_id, username, post_id, время создания поста.
SELECT userId, username, postId, dateOf(postId) FROM posts_by_topic
WHERE topicId = 987db2f6-6a1b-4f24-aaa2-39cb22d7c7ff
AND postId >= minTimeuuid('2023-11-01 00:00:00')
AND postId <= maxTimeuuid('2023-11-01 23:59:59');
