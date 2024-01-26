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



# Result 2024-01-27

### Active Record
```
-----------------

ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
      topic_first_ar     1.159k i/100ms
Calculating -------------------------------------
      topic_first_ar     11.713k (± 1.0%) i/s -     59.109k in   5.046875s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
 topic_first_cast_ar     1.059k i/100ms
Calculating -------------------------------------
 topic_first_cast_ar     10.430k (± 6.6%) i/s -     51.891k in   5.004948s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
       topic_find_ar   637.000 i/100ms
Calculating -------------------------------------
       topic_find_ar     16.907k (±22.6%) i/s -     77.714k in   5.021623s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
  topic_find_cast_ar     1.573k i/100ms
Calculating -------------------------------------
  topic_find_cast_ar     15.967k (±11.7%) i/s -     78.650k in   5.014822s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
     topic_findby_ar     1.942k i/100ms
Calculating -------------------------------------
     topic_findby_ar     19.261k (± 5.0%) i/s -     97.100k in   5.055466s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_findby_cast_ar     1.690k i/100ms
Calculating -------------------------------------
topic_findby_cast_ar     16.263k (± 9.5%) i/s -     81.120k in   5.064999s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
      topic_where_ar   631.000 i/100ms
Calculating -------------------------------------
      topic_where_ar      7.687k (±13.0%) i/s -     37.860k in   5.044236s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
 topic_where_cast_ar   776.000 i/100ms
Calculating -------------------------------------
 topic_where_cast_ar      7.784k (± 1.5%) i/s -     39.576k in   5.085823s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_eager_ar    86.000 i/100ms
Calculating -------------------------------------
topic_posts_eager_ar    857.327 (± 2.1%) i/s -      4.300k in   5.017992s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_eager_cast_ar
                        61.000 i/100ms
Calculating -------------------------------------
topic_posts_eager_cast_ar
                        583.121 (±10.1%) i/s -      2.928k in   5.091493s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_ar
                       267.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_ar
                          3.078k (± 6.0%) i/s -     15.486k in   5.050405s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_cast_ar
                       187.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_cast_ar
                          1.835k (± 3.7%) i/s -      9.163k in   5.000104s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_notime_cast_ar
                       289.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_notime_cast_ar
                          2.844k (± 4.0%) i/s -     14.450k in   5.089163s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_time_cast_ar
                       224.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_time_cast_ar
                          2.265k (± 4.0%) i/s -     11.424k in   5.053142s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
  topic_update_2x_ar   166.000 i/100ms
Calculating -------------------------------------
  topic_update_2x_ar    672.073 (±26.0%) i/s -      3.154k in   5.092559s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_update_save_2x_ar
                       238.000 i/100ms
Calculating -------------------------------------
topic_update_save_2x_ar
                          2.365k (± 8.2%) i/s -     11.900k in   5.071091s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
     topic_create_ar   466.000 i/100ms
Calculating -------------------------------------
     topic_create_ar      4.479k (± 6.3%) i/s -     22.368k in   5.019259s
31134--93916
10--10
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_create_validation_ar
                       454.000 i/100ms
Calculating -------------------------------------
topic_create_validation_ar
                          4.528k (± 2.6%) i/s -     22.700k in   5.016420s
31346--125252
10--10
-----------------

```


### Sequel

```
-----------------

ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
      topic_first_sq     1.669k i/100ms
Calculating -------------------------------------
      topic_first_sq     16.375k (± 5.4%) i/s -     81.781k in   5.011231s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
 topic_first_cast_sq     1.643k i/100ms
Calculating -------------------------------------
 topic_first_cast_sq     16.609k (± 3.4%) i/s -     83.793k in   5.050933s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
         topic_id_sq     1.637k i/100ms
Calculating -------------------------------------
         topic_id_sq     16.902k (± 3.1%) i/s -     85.124k in   5.041215s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
    topic_id_cast_sq     1.564k i/100ms
Calculating -------------------------------------
    topic_id_cast_sq     16.554k (± 4.4%) i/s -     82.892k in   5.018190s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
       topic_find_sq     1.530k i/100ms
Calculating -------------------------------------
       topic_find_sq     15.075k (± 6.0%) i/s -     76.500k in   5.097610s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
  topic_find_cast_sq     1.481k i/100ms
Calculating -------------------------------------
  topic_find_cast_sq     15.019k (± 4.6%) i/s -     75.531k in   5.041199s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
      topic_where_sq     1.356k i/100ms
Calculating -------------------------------------
      topic_where_sq     13.700k (± 2.5%) i/s -     69.156k in   5.050815s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
 topic_where_cast_sq     1.319k i/100ms
Calculating -------------------------------------
 topic_where_cast_sq     13.309k (± 4.9%) i/s -     67.269k in   5.068237s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_eager_sq    47.000 i/100ms
Calculating -------------------------------------
topic_posts_eager_sq    466.272 (± 4.1%) i/s -      2.350k in   5.049389s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_eager_cast_sq
                        40.000 i/100ms
Calculating -------------------------------------
topic_posts_eager_cast_sq
                        452.021 (± 7.5%) i/s -      2.280k in   5.080327s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_sq
                        80.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_sq
                        923.780 (± 5.7%) i/s -      4.640k in   5.043528s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_cast_sq
                        79.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_cast_sq
                        917.715 (± 7.0%) i/s -      4.582k in   5.024879s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_notime_cast_sq
                       470.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_notime_cast_sq
                          5.236k (± 7.9%) i/s -     26.320k in   5.075216s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_posts_filtered_time_cast_sq
                        99.000 i/100ms
Calculating -------------------------------------
topic_posts_filtered_time_cast_sq
                        898.770 (±13.0%) i/s -      4.455k in   5.079478s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
  topic_update_2x_sq   101.000 i/100ms
Calculating -------------------------------------
  topic_update_2x_sq      1.144k (±19.1%) i/s -      5.656k in   5.239601s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_update_save_2x_sq
                        24.000 i/100ms
Calculating -------------------------------------
topic_update_save_2x_sq
                          1.383k (±28.0%) i/s -      4.704k in   5.007492s
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
     topic_create_sq   246.000 i/100ms
Calculating -------------------------------------
     topic_create_sq      2.429k (±12.1%) i/s -     12.054k in   5.080655s
16818--16818
10--10
ruby 3.2.2 (2023-03-30 revision e51014f9c0) [arm64-darwin23]
Warming up --------------------------------------
topic_create_validation_sq
                       249.000 i/100ms
Calculating -------------------------------------
topic_create_validation_sq
                          2.417k (± 8.6%) i/s -     12.201k in   5.093634s
16749--33557
10--10
-----------------

```

## Memory 
Run it yourself
