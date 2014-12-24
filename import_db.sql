CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_followers (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES user(id)
);


INSERT INTO users (fname, lname)
  VALUES ('Scott', 'Nelson');
INSERT INTO users (fname, lname)
  VALUES ('Eric', 'Hsu');
INSERT INTO users (fname, lname)
  VALUES ('Kush', 'Patel');


INSERT INTO questions (title, body, user_id)
  VALUES ('What is the Address?', 'I need to know the address for a/A', 1);
INSERT INTO questions (title, body, user_id)
  VALUES ('How many students?', 'I am wondering how many students per cohort', 2);

INSERT INTO replies (question_id, parent_reply_id, user_id, body)
  VALUES (1, NULL, 3, 'The address is: 1061 Market Street, SF, CA, Earth');
INSERT INTO replies (question_id, parent_reply_id, user_id, body)
  VALUES (2, NULL, 3, 'There are 50 students in a cohort.');
INSERT INTO replies (question_id, parent_reply_id, user_id, body)
  VALUES (2, 2, 2, 'Thanks for answering, Kush about cohort size!');

INSERT INTO question_likes(question_id, user_id)
  VALUES (1, 2);
INSERT INTO question_likes(question_id, user_id)
  VALUES (2, 1);
