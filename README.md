# theRush - theScore Job Application Challenge

To apply for a job at theScore, we should complete a coding challenge that shows a table with some player entries. It should have some features, too - like sorting, filtering, and a CSV exporter.

This project is my approach to solving this challenge. It shows a paginated table with player entries, and some columns have the sorting option. A user can also export their results to a CSV file.

You can find more info about this challenge here: https://github.com/tsicareers/nfl-rushing

## Testing the app

To test the application, you should have either Elixir/Erlang installed and running in your system or `asdf` in your path. You can find instructions on installing them [here](https://elixir-lang.org/install.html) (Elixir/Erlang) and [here](https://asdf-vm.com/#/core-manage-asdf?id=install) (asdf).

For convenience, we're shipping a `docker-compose.yml` file with the project so that you can start up a container with PostgreSQL.

The steps for testing the application - assuming you are in the project folder - are:

`asdf install` (if you choose on running it through `asdf`)
`docker-compose up` (add `-d` flag if you want it dettached)
`mix test`

Tests should be green out of the box.

## Running the application

As we're using Elixir releases, running the application should have issues. We only need to export some variables, and we're good to go.

An `.env.sample` file was created at the root of the project folder. If you use something as `direnv`, you can either generate a new `.envrc` file based on the template, or rename it and use its default values. A quick way to use the file is copying/renaming it to `.env` and running `eval $(cat .env)`

After exporting the environment variables to your session, run the following command to get everything up and running in no time:

`docker-compose -f docker-compose.prod.yml up`

Bear in mind that if it's the first time you are running the application, you should run the migrations and seed the database with the contents of `rushing.json`. To do that, with the application running, run the following commands:

```
$ docker exec -it <app_container_name_or_id> entrypoint migrate # Run the
migrations
$ docker exec -it <app_container_name_or_id> entrypoint seed # Seeds the
database
```

You only need to do that once.

After all these steps, the app should be running at `http://localhost:4004`.
