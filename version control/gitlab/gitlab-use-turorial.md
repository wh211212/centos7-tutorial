# 使用Gitlab创建git项目

- 登录gitlab系统,访问自己的gitlab.example.com,然后使用gitlab用户，登录

![这里写图片描述](http://img.blog.csdn.net/20170710181939663?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 第一次登录需要重新修改默认登录密码

![这里写图片描述](http://img.blog.csdn.net/20170710182130674?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 登录成功，看到下面界面，新建一个项目test,描述为test for git,然后点击创建如下图：

![这里写图片描述](http://img.blog.csdn.net/20170710182222482?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 如上图可以看到项目已经创建成功

![这里写图片描述](http://img.blog.csdn.net/20170710182248092?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 根据提示设置用户信息

```
git config --global user.name "test"
git config --global user.email "test@aniu.tv"
```

- 然后把本地的项目（test）上传到gitlab上

![这里写图片描述](http://img.blog.csdn.net/20170710182326576?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)
![这里写图片描述](http://img.blog.csdn.net/20170710182342407?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 在命令行界面依次执行下面界面

```
git init
git remote add origin https://test:testpassword@gitlab.example.com/test/test.git
# test:testpassword 换成自己的用户名和密码
git add .
git commit -m "Initial commit"
git push -u origin master
```
![这里写图片描述](http://img.blog.csdn.net/20170710182553614?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 上面的报错通过下面设置避免

> C:\Program Files (x86)\Git\etc\gitconfig  # 编辑gitconfig，路径可以不一致，可以直接搜索到gitconfig文件，然后编辑，添加下面三行

```
[http]
    sslVerify = false
    sslCAinfo = /bin/curl-ca-bundle.crt
```

- 然后重新git push ,可以看到已经成功啦。

![这里写图片描述](http://img.blog.csdn.net/20170710182730136?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

- 返回到gitlab UI界面，可以看到本地的test项目已经添加到gitlab仓库。

![这里写图片描述](http://img.blog.csdn.net/20170710182833318?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvd2gyMTEyMTI=/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/SouthEast)

> 到这里通过使用giltab，上传本地的项目到gitlab系统。
