# c_eval

## Requirements

- [Docker](https://docs.docker.com/engine/install/ubuntu/)
- [Maketool](https://www.gnu.org/software/make/)

## Running

The application uses docker for all and maketool to create shortcuts in order to keep some organization in commands

Availabel commands:
- `make up` starts the application, creates the container id not exists
- `make up_build` starts the application forcing re-create the dockerfiles
- `make testing` run the backend tests, needs to create the containers first
- `make iex` enters in the interactive elixir console with all the project code loaded
- `make bash` enters into the terminal in the backend container
- `make routes` get all the phoenix available routes
- `make rollback` rollbacks the last ecto migration
- `make migrate` run the ecto migrations
- `make format` formats the code

## Structure

Creates 3 containers:
- web: its the frontend here in the `3000` port
- app: the backend side in the `4000` port
- db: the postgres database in the `5432` port
