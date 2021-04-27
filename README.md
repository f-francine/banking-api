## Banking API

Banking API, where it is possible to make withdrawals and transfers between users

### How to run

> Make sure you have elixir and docker in your machine. If you don't have them, you can install here: <br>
elixir:  https://elixir-lang.org/install.html <br>
docker: https://docs.docker.com/get-docker/ <br>

In the project's root folder, run this command to have a Postgres database running on port 5432:
```
# Running a database on port 5432
docker-compose up -d
``` 

Configure the database and download the dependencies (in the root folder):
```
mix setup
```

Run tests:
```
mix test
```

Start the server:
```
iex -S mix phx.server
```
## Endpoints
### Create an account

Route: `/api/accounts`<br>
Method: `POST`
```json
{
	"user": "Some name"
}
```

If the input is valid (it's a string type, and the user it is not already taken), you will receive an awnser like this:

```json
{
    "account": {
        "balance": 1000,
        "user": "Some name"
    },
    "message": "Account created"
}
```

### Withdraw
Route: `/api/accounts/withdraw`<br>
Method: `POST`

```json
{
	"user": "Some name",
	"value": 10
}
```

If the user exists and the value is valid (value <= balance), you will receive an awnser like this:

```json
{
    "account": {
        "balance": 990,
        "user": "Some name"
    },
    "message": "Balance changed succesfully"
}
```

### Transaction
Route: `/api/accounts/transaction`<br>
Method: `POST`

```json
{
    "from": "Some name",
    "to": "Another name",
    "value": 10
 }
```
If both users exist and the value is valid (value <= balance), you will receive an awnser like this:

```json
{
    "deposit": {
        "balance": 1100,
        "user": "Another name"
    },
    "message": "Transaction done succesfully",
    "withdraw": {
        "balance": 980,
        "user": "Some name"
    }
}
```
### Fetch an account
Route: `/api/accounts/:id` <br>
Method: `GET` <br>
If the given id belongs to an account, you will receive an awnser like this:
```json
{
	"description":
		"Your current balance is 940"
}
```
