## 备份
```sh
# 注意密钥安全，禁止上传
cd ~ && tar -zcvf sshConfig.tar.gz .ssh/
mv sshConfig.tar.gz ~/Desktop 
```

## 恢复
```sh
tar -zxvf sshConfig.tar.gz -C ~/
```