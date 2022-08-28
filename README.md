##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby 2.7.1
- Rails 6.0.5

##### 1. Clone the repository

```bash
git clone git@github.com:luvcjssy/funny-movies.git
```

##### 2. Go to project directory

```bash
cd <path_to_project>
```

##### 3. Install gem
```bash
bundle install
```

##### 4. Install libs
```bash
yarn install
```

##### 5. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rake db:create
bundle exec rake db:migrate
```

##### 6. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000