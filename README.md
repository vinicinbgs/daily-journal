# How it works
```bash
[Usage]: run.sh

[Parameters]:
 -d directory
 -t "title"
 -k "task description"
 -s "status" (open, done, close, breakfast, lunch, dinner, pause)

[Example]: ./run.sh -d example -k "my first task" -s open

[Help]: ./run.sh -h

[Interactive mode]: ./run.sh -i

[Warning]: Important to use 'space' remember of quotes "hello world"
```

# Execute
```bash
cd daily-blog
chmod +x run.sh
./run.sh -d example -k "my first task" -s done
```
Will be created directory and file with follow name example/{timestamp}.md

```markdown
# Daily 17/12/2021
[🌃][00:41:58] - my first task [✅]<br />
```