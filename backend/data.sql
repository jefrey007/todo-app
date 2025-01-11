CREATE TABLE todos (
    id SERIAL PRIMARY KEY,
    task VARCHAR(255) NOT NULL
);

INSERT INTO todos (task) VALUES ('Task 1'), ('Task 2'), ('Task 3');
