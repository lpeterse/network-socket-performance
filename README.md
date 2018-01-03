# network-socket-performance

Run `stack bench`!

There are some parameters to play with in the source file - feel free to modify them!

## Results

My machine is a **Lenovo x230** with **Intel(R) Core(TM) i7-3520M CPU** and **8GB RAM**. Your results may differ.

| _half-duplex/full-duplex_ | network       | socket         | network (threaded) | socket (threaded) |
|---------------------------|---------------|----------------|--------------------|-------------------|
| _chunkSize=40 bytes_      | 226ms / 453ms | 285ms / 1013ms | 374ms / 833ms      | 553ms / 1223ms    |
| _chunkSize=4000 bytes_    | 20ms / 38ms   | 21ms / 47ms    | 21ms / 42ms        | 21ms / 41ms       |

### `chunkSize=4000, iterations=250*1000, concurrency=1 (non-threaded)`

```
benchmarking transmission of 1000 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 1/socket
time                 100.5 ms   (73.92 ms .. 171.3 ms)
                     0.970 R²   (0.966 R² .. 1.000 R²)
mean                 187.7 ms   (129.9 ms .. 259.7 ms)
std dev              66.02 ms   (0.0 s .. 74.90 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 1000 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 1/network
time                 95.65 ms   (70.11 ms .. 165.5 ms)
                     0.968 R²   (0.965 R² .. 1.000 R²)
mean                 178.4 ms   (123.3 ms .. 219.7 ms)
std dev              63.04 ms   (0.0 s .. 71.50 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 1000 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 1/socket
time                 221.5 ms   (169.7 ms .. 404.8 ms)
                     0.967 R²   (0.951 R² .. 1.000 R²)
mean                 425.9 ms   (290.8 ms .. 529.6 ms)
std dev              159.5 ms   (0.0 s .. 179.6 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 1000 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 1/network
time                 190.9 ms   (140.3 ms .. 329.6 ms)
                     0.968 R²   (0.966 R² .. 1.000 R²)
mean                 355.3 ms   (245.9 ms .. 437.2 ms)
std dev              125.2 ms   (0.0 s .. 142.0 ms)
variance introduced by outliers: 73% (severely inflated)
```

### `chunkSize=4000, iterations=250*1000, concurrency=1 (-threaded -with-rtsopts=-N2)`

```
benchmarking transmission of 1000 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 1/socket
time                 116.9 ms   (67.49 ms .. 233.4 ms)
                     0.934 R²   (0.923 R² .. 1.000 R²)
mean                 233.3 ms   (152.5 ms .. 292.2 ms)
std dev              89.15 ms   (0.0 s .. 101.9 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 1000 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 1/network
time                 101.3 ms   (86.65 ms .. 155.6 ms)
                     0.986 R²   (0.975 R² .. 1.000 R²)
mean                 172.9 ms   (126.8 ms .. 208.6 ms)
std dev              55.02 ms   (0.0 s .. 61.77 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 1000 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 1/socket
time                 211.7 ms   (123.5 ms .. 320.9 ms)
                     0.955 R²   (0.926 R² .. 1.000 R²)
mean                 392.4 ms   (270.3 ms .. 476.4 ms)
std dev              126.3 ms   (0.0 s .. 145.6 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 1000 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 1/network
time                 221.2 ms   (146.9 ms .. 519.9 ms)
                     0.936 R²   (0.831 R² .. 1.000 R²)
mean                 447.4 ms   (294.4 ms .. 668.9 ms)
std dev              196.4 ms   (0.0 s .. 216.2 ms)
variance introduced by outliers: 74% (severely inflated)
```

### `chunkSize=4000, iterations=50*1000, concurrency=5 (non-threaded)`

```
benchmarking transmission of 200 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/socket
time                 21.74 ms   (13.63 ms .. 37.65 ms)
                     0.954 R²   (0.940 R² .. 1.000 R²)
mean                 40.47 ms   (27.64 ms .. 49.67 ms)
std dev              13.90 ms   (0.0 s .. 15.93 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/network
time                 20.78 ms   (18.08 ms .. 35.96 ms)
                     0.979 R²   (0.945 R² .. 1.000 R²)
mean                 37.62 ms   (26.73 ms .. 46.27 ms)
std dev              13.47 ms   (0.0 s .. 14.98 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/socket
time                 47.27 ms   (31.64 ms .. 70.41 ms)
                     0.969 R²   (0.954 R² .. 1.000 R²)
mean                 93.78 ms   (63.79 ms .. 115.4 ms)
std dev              32.76 ms   (0.0 s .. 37.50 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/network
time                 38.08 ms   (30.91 ms .. 72.96 ms)
                     0.965 R²   (0.927 R² .. 1.000 R²)
mean                 76.33 ms   (51.40 ms .. 110.2 ms)
std dev              30.44 ms   (0.0 s .. 33.98 ms)
variance introduced by outliers: 74% (severely inflated)
```

### `chunkSize=4000, iterations=50*1000, concurrency=5 (-threaded -with-rtsopts=-N2)`

```
benchmarking transmission of 200 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/socket
time                 21.72 ms   (13.12 ms .. 41.26 ms)
                     0.943 R²   (0.932 R² .. 1.000 R²)
mean                 42.02 ms   (27.98 ms .. 52.21 ms)
std dev              15.43 ms   (0.0 s .. 17.65 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 4 kB) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/network
time                 21.38 ms   (8.524 ms .. 33.38 ms)
                     0.920 R²   (0.818 R² .. 1.000 R²)
mean                 38.95 ms   (26.57 ms .. 46.65 ms)
std dev              11.63 ms   (0.0 s .. 13.33 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/socket
time                 41.55 ms   (10.80 ms .. 84.50 ms)
                     0.866 R²   (0.752 R² .. 1.000 R²)
mean                 85.09 ms   (53.01 ms .. 106.2 ms)
std dev              31.70 ms   (0.0 s .. 36.59 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 4 kB) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/network
time                 42.05 ms   (NaN s .. 94.90 ms)
                     0.943 R²   (0.852 R² .. 1.000 R²)
mean                 83.48 ms   (55.53 ms .. 106.1 ms)
std dev              35.59 ms   (0.0 s .. 39.27 ms)
variance introduced by outliers: 74% (severely inflated)
```

### `chunkSize=40, iterations=5000*1000, concurrency=5 (non-threaded)`

```
time                 285.0 ms   (210.4 ms .. 491.7 ms)
                     0.969 R²   (0.967 R² .. 1.000 R²)
mean                 531.2 ms   (367.6 ms .. 654.0 ms)
std dev              187.6 ms   (55.51 as .. 212.7 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 40 bytes) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/network
time                 226.6 ms   (155.9 ms .. 383.5 ms)
                     0.965 R²   (0.956 R² .. 1.000 R²)
mean                 424.3 ms   (292.0 ms .. 521.3 ms)
std dev              147.3 ms   (0.0 s .. 168.1 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 40 bytes) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/socket
time                 1.013 s    (649.7 ms .. 1.711 s)
                     0.958 R²   (0.944 R² .. 1.000 R²)
mean                 2.044 s    (1.363 s .. 2.539 s)
std dev              751.5 ms   (0.0 s .. 858.6 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 40 bytes) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/network
time                 453.9 ms   (338.4 ms .. 776.2 ms)
                     0.970 R²   (0.968 R² .. 1.000 R²)
mean                 842.0 ms   (584.8 ms .. 1.035 s)
std dev              295.5 ms   (0.0 s .. 334.8 ms)
```

### `chunkSize=40, iterations=5000*1000, concurrency=5 (-threaded -with-rtsopts=-N2)`

```
benchmarking transmission of 200 MB (in chunks of 40 bytes) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/socket
time                 553.3 ms   (407.9 ms .. 1.310 s)
                     0.930 R²   (0.852 R² .. 1.000 R²)
mean                 1.168 s    (751.7 ms .. 1.501 s)
std dev              518.5 ms   (0.0 s .. 575.8 ms)
variance introduced by outliers: 74% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 40 bytes) over an Inet4-TCP-Socket (half-duplex) with concurrency 5/network
time                 374.4 ms   (288.9 ms .. 717.0 ms)
                     0.962 R²   (0.936 R² .. 1.000 R²)
mean                 730.8 ms   (494.4 ms .. 914.0 ms)
std dev              282.6 ms   (0.0 s .. 317.2 ms)
variance introduced by outliers: 74% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 40 bytes) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/socket
time                 1.223 s    (842.4 ms .. 2.063 s)
                     0.965 R²   (0.956 R² .. 1.000 R²)
mean                 2.218 s    (1.544 s .. 3.018 s)
std dev              745.0 ms   (0.0 s .. 850.8 ms)
variance introduced by outliers: 73% (severely inflated)
             
benchmarking transmission of 200 MB (in chunks of 40 bytes) in each direction over an Inet4-TCP-Socket (full-duplex) with concurrency 5/network
time                 833.9 ms   (591.4 ms .. 1.419 s)
                     0.967 R²   (0.961 R² .. 1.000 R²)
mean                 1.553 s    (1.073 s .. 1.908 s)
std dev              540.6 ms   (0.0 s .. 615.2 ms)
variance introduced by outliers: 73% (severely inflated)
```