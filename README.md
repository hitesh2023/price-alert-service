# README
## Setup the service locally
1. Clone the repo `git clone git@github.com:hitesh2023/price-alert-service.git`
2. Change directory `cd price-alert-service`
3. Run bundle install to install all project dependencies `bundle install`
4. Make sure your postgres & redis-cli are setup locally
    * `brew install postgresql`
    * `brew services start postgresql`
    * `brew install redis-cli`
    * `brew services start redis-cli`
5. Create new DB in your local postgres, by running
    `rails db:create`
6. Run the migrations to create all tables & corresponding indexes
    `rails db:migrate`
7. Run your server `rails server`

## Tech used
1. Ruby on rails
2. REDIS (Sorted sets)
3. Sidekiq (Schedular / Background processing)


## Features covered
1. All API's are authenticated via JWT tokens
2. Authenticated user's can create new stop loss alerts (`POST /alerts`)
3. Authenticated user's can delete the alerts configured by them (`DELETE /alerts`)
4. Authenticated user's can fetch all the alerts configured by them (`GET /alerts`)
    * Can provide custom filtering options. `/alerts?status=CREATED,TRIGGERED`)
    * Paginated response. `/alerts?page=1&size=10`
5. Once the alert's condition is met, status of the alert is changed to `TRIGGERED`


## Features not covered
1. User's signup/registration is not implemented.
2. No actual email is triggered to the end user, but instead we are logging the user's email to the console with necessary info [Can be easily incorporated using [SMTP](https://ruby-doc.org/stdlib-2.5.3/libdoc/net/smtp/rdoc/Net/SMTP.html) library].


## Steps to Test the workflow
1. `REGISTRATION`: We first need to register inorder to create alerts, but as mentioned above, registration API is not in scope of this, but we can register ourself directly via rails console for testing purpose:
    * Go to rails console: `rails console`
    * Create new user: `User.create(email: 'hiteshsarangal2023@gmail.com',password: 'password123')`

2. `LOGIN`: Once the registration is done, we need to login now:
    ```
    curl --location --request POST 'http://localhost:3000/login' \ --header 'Content-Type: application json' \ --data-raw '{ "email": "hiteshsarangal2023@gmail.com", "password": "password" }'
    ```
    In response, we will get the JWT token.
    TTL of this JWT token is valid upto `24 hours`
    ```
    {
        "auth_token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NTE0ODYyNDB9._lVCGbm1BBnko9Vbp8nc8XVoOjjF2q5c6lhyBwRfXzU"
    }
    ```

3. `CREATE ALERT`: Use the JWT token generated in Step 2 to create an alert now:
    ```
    curl --location --request POST 'http://localhost:3000/alerts' \
    --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NTE0ODI3NTZ9.ubQ5A2WB1uQygvMlqMhN-pb9ZqC92I4W7-0TM3MJNBo' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "coin_id": "BTC",
        "price": 201.5
    }'
    ```
    In response, we will get the status of the request
    ```
    {
        "status": 201,
        "alert": {
            "id": 5,
            "price": 2775.23,
            "status": "CREATED",
            "coin_id": "eth"
        }
    }

    ```

4. `DELETE ALERT`: Use the same JWT token & delete any of the alert created by current user
    ```
    curl --location --request DELETE 'http://localhost:3000/alerts/23' \ --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NTE0NjY4OTN9.AWJTjB7EWRJ6VGdlTsjvQFlvSqjTjX7bj5rsfUG4kOg'
    ```

5. `LIST ALL ALERTS OF USER`: Fetch all the alerts configured by current User
    ```
    curl --location --request GET 'http://localhost:3000/alerts' \ --header 'Authorization: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE2NTE0ODI3NTZ9.ubQ5A2WB1uQygvMlqMhN-pb9ZqC92I4W7-0TM3MJNBo'
    ```

    Response: 
    ```
    {
        "status": 200,
        "alerts": [
            {
                "id": 5,
                "created_at": "2022-05-01T09:13:27.053Z",
                "price": 2775.23,
                "status": "CREATED",
                "coin_id": "eth"
            },
            {
                "id": 4,
                "created_at": "2022-05-01T09:13:25.291Z",
                "price": 1.001,
                "status": "TRIGGERED",
                "coin_id": "usdt"
            },
            {
                "id": 3,
                "created_at": "2022-05-01T09:13:22.795Z",
                "price": 0.998153,
                "status": "CREATED",
                "coin_id": "usdc"
            },
            {
                "id": 2,
                "created_at": "2022-05-01T09:13:19.482Z",
                "price": 89.18,
                "status": "TRIGGERED",
                "coin_id": "sol"
            },
            {
                "id": 1,
                "created_at": "2022-05-01T09:13:15.835Z",
                "price": 38023.0,
                "status": "FAILED",
                "coin_id": "btc"
            }
        ]
    }
    ```

6. `RUN CRON`: Run the scheduler which is cofigured at a frequency of every 1 minute ( `*/1 * * * *` )
    `bundle exec sidekiq -e development -C config/sidekiq.yml`.


----

## To visualize the DB schema, navigate to `db/schema.rb`
## All background processing implementation is in `app/jobs/fetch_latest_crpto_prices_job.rb`
## Dev testing screenshots
<img width="1680" alt="Screenshot 2022-05-01 at 2 59 24 PM" src="https://user-images.githubusercontent.com/30936452/166142387-88fe544d-438c-40ad-b3ea-6e3f8539d80c.png">
