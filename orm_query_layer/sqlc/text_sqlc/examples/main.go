db := generated.New(conn)
user, _ := db.CreateUser(ctx, generated.CreateUserParams{
    Name: "Alice", Email: "alice@example.com",
})
u, _ := db.GetUser(ctx, user.ID)
db.UpdateUserEmail(ctx, generated.UpdateUserEmailParams{
    ID: user.ID, Email: "new@example.com",
})
db.DeleteUser(ctx, user.ID)