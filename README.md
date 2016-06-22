# Castle Playground

1. Initialize the Rails environment:

   ```
   bundle install
   rake db:setup
   ```

1. Create an account at [Castle](https://castle.io).

1. Once you have your Castle credentials, start the Rails server with the following environment variables:

   ```
   CASTLE_APP_ID=100000000000000
   CASTLE_API_SECRET=secret
   ```

   For example:

   ```
   CASTLE_APP_ID=100000000000000 CASTLE_API_SECRET=secret rails s -p 4000
   ```

1. [Contact us](mailto:team@castle.io) if you have any questions.
