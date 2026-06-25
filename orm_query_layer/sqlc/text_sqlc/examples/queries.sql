-- name: CreateUser :one
INSERT INTO users (name, email) VALUES ($1, $2) RETURNING *;

-- name: GetUser :one
SELECT * FROM users WHERE id = $1;

-- name: UpdateUserEmail :exec
UPDATE users SET email = $1 WHERE id = $2;

-- name: DeleteUser :execrows
DELETE FROM users WHERE id = $1;