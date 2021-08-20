##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.0.1](https://www.ruby-lang.org/en/news/2021/04/05/ruby-3-0-1-released/)
- Rails [6.1](https://github.com/rails/rails)

##### 1. Check out the repository

```bash
    git clone https://github.com/guilotmsc/inventory-control.git
```

##### 2. Run bundle install

```ruby
    bundle install

    rails webpacker:install
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
    rails db:migrate
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
    rails s
```

And now you can visit the site with the URL http://localhost:3000

##### 5. Run the test suite

You can run the test suite using the command given below.

```ruby
    rspec
```