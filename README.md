# Httpie Helper

A simple shell script for use with [httpie](/), allowing to save endpoints to a file and reuse them.

### Requirements
- Httpie
- `httpierc` file containing endpoints.

### Example
httipierc:
```
todos=https://jsonplaceholder.typicode.com/todos/
posts=https://jsonplaceholder.typicode.com/posts/
users=https://jsonplaceholder.typicode.com/users/
```

Use saved endpoints with `$ ./helper.sh GET users`

