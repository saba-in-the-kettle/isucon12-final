```
[
  {
    "Type": "pprof",
    "Label": "s1",
    "URL": "http://localhost:8080/debug/pprof/profile",
    "Duration": 60
  },
  {
    "Type": "httplog",
    "Label": "s1",
    "URL": "http://localhost:8080/debug/log/httplog",
    "Duration": 60
  },
  {
    "Type": "slowlog",
    "Label": "s1",
    "URL": "http://localhost:8080/debug/log/slowlog",
    "Duration": 60
  }
]
```

```
matching_groups:
    - ^/user/[0-9a-zA-Z_-]+/gacha/index$
    - ^/user/[0-9a-zA-Z_-]+/gacha/draw/[0-9a-zA-Z_-]+/[0-9a-zA-Z_-]+$
    - ^/user/[0-9a-zA-Z_-]+/present/index/[0-9a-zA-Z_-]+$
    - ^/user/[0-9a-zA-Z_-]+/present/receive$
    - ^/user/[0-9a-zA-Z_-]+/item$
    - ^/user/[0-9a-zA-Z_-]+/card/addexp/[0-9a-zA-Z_-]+$
    - ^/user/[0-9a-zA-Z_-]+/card$
    - ^/user/[0-9a-zA-Z_-]+/reward$
    - ^/user/[0-9a-zA-Z_-]+/home$
    - ^/admin/user/[0-9a-zA-Z_-]+$
    - ^/admin/user/[0-9a-zA-Z_-]+/ban$
```
