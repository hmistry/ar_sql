# ActiveRecord vs Sequel benchmark

Instructions for use:
1. Run `bundle install`
2. In each folder `ar/` and `sq/`:
    1. Select which database you want to use in `db.rb` and `db.rb`.
    2. Run database migration in using `ruby migrations.rb`.
    3. Seed the database using `ruby seed.rb`.
    4. Run benchmark script `ruby bench.rb`.
3. Speed performance results are logged to `results.txt`.
4. Memory usage are logged to various `*.txt` files (see `bench.rb` for filenames).
