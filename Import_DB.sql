PRAGMA foreign_keys = ON;



DROP TABLE IF EXISTS questions_follow;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id  INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);


CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);



CREATE TABLE questions_follow (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    follower_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (follower_id) REFERENCES users(id)
);



CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    reply_author_id INTEGER NOT NULL,

    FOREIGN Key (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id), 
    FOREIGN KEY (reply_author_id) REFERENCES users(id)
);




CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    liker_id INTEGER NOT NULL,

    FOREIGN KEY(question_id) REFERENCES questions(id), 
    FOREIGN KEY(liker_id) REFERENCES users(id)
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Zarif', 'Rahat'),
  ('Jonny', 'Hakimian'),
  ('Rich', 'Lim');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What is a cat?', 'Never seen one.', 2);

  INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What is a dog?', 'Never seen one.', 2);

  INSERT INTO questions (title, body, author_id)
VALUES
  ('What is a bird?', 'Never seen one.', 2);

  

INSERT INTO
    questions_follow (question_id, follower_id)
VALUES
    ((SELECT id FROM questions WHERE id = 1), (SELECT id FROM questions WHERE id = 1));

INSERT INTO
    questions_follow (question_id, follower_id)
VALUES
    (2,1);
INSERT INTO
    questions_follow (question_id, follower_id)
VALUES
    (2,1);

INSERT INTO
    replies (body, question_id, parent_reply_id, reply_author_id)
VALUES 
    ('A cat is an animal', 1, null, 3);

INSERT INTO
    replies
    (body, question_id, parent_reply_id, reply_author_id)
VALUES
    ('Thanks Rich!', 1, 1, 1);

INSERT INTO
    replies
    (body, question_id, parent_reply_id, reply_author_id)
VALUES
    ('A cat is also a mammal!', 1, null, 1);

INSERT INTO
    question_likes (question_id, liker_id)
VALUES
    (1, 1);
  