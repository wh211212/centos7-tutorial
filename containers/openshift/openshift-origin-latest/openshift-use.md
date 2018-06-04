# 在openshift部署应用程序

- 在主节点上添加一个作为Openshift用户的用户登录。

```
[root@master ~]# oc login
Authentication required for https://master.aniu.so:8443 (openshift)
Username: aniu
Password: 
Login successful.

You don't have any projects. You can try to create a new project, by running

    oc new-project <projectname>

[root@master ~]# oc new-project aniu-project
Now using project "aniu-project" on server "https://master.aniu.so:8443".

You can add applications to this project with the 'new-app' command. For example, try:

    oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git

to build a new example application in Ruby.
[root@master ~]#  oc new-app centos/ruby-22-centos7~https://github.com/openshift/ruby-ex.git
--> Found Docker image 90e3807 (4 hours old) from Docker Hub for "centos/ruby-22-centos7"

    Ruby 2.2 
    -------- 
    Ruby 2.2 available as container is a base platform for building and running various Ruby 2.2 applications and frameworks. Ruby is the interpreted scripting language for quick and easy object-oriented programming. It has many features to process text files and to do system management tasks (as in Perl). It is simple, straight-forward, and extensible.

    Tags: builder, ruby, ruby22

    * An image stream will be created as "ruby-22-centos7:latest" that will track the source image
    * A source build using source code from https://github.com/openshift/ruby-ex.git will be created
      * The resulting image will be pushed to image stream "ruby-ex:latest"
      * Every time "ruby-22-centos7:latest" changes a new build will be triggered
    * This image will be deployed in deployment config "ruby-ex"
    * Port 8080/tcp will be load balanced by service "ruby-ex"
      * Other containers can access this service through the hostname "ruby-ex"

--> Creating resources ...
    imagestream "ruby-22-centos7" created
    imagestream "ruby-ex" created
    buildconfig "ruby-ex" created
    deploymentconfig "ruby-ex" created
    service "ruby-ex" created
--> Success
    Build scheduled, use 'oc logs -f bc/ruby-ex' to track its progress.
    Application is not exposed. You can expose services to the outside world by executing one or more of the commands below:
     'oc expose svc/ruby-ex' 
    Run 'oc status' to view your app
#查看状态
[root@master ~]# oc status
In project aniu-project on server https://master.aniu.so:8443

svc/ruby-ex - 172.30.195.161:8080
  dc/ruby-ex deploys istag/ruby-ex:latest <-
    bc/ruby-ex source builds https://github.com/openshift/ruby-ex.git on istag/ruby-22-centos7:latest 
      build #1 pending for 7 seconds
    deployment #1 waiting on image or update


2 infos identified, use 'oc status -v' to see details.

[root@master ~]# oc status -v
In project aniu-project on server https://master.aniu.so:8443

svc/ruby-ex - 172.30.195.161:8080
  dc/ruby-ex deploys istag/ruby-ex:latest <-
    bc/ruby-ex source builds https://github.com/openshift/ruby-ex.git on istag/ruby-22-centos7:latest 
      build #1 running for about a minute - bbb6701: Merge pull request #18 from durandom/master (Ben Parees <bparees@users.noreply.github.com>)
    deployment #1 waiting on image or update

Info:
  * dc/ruby-ex has no readiness probe to verify pods are ready to accept traffic or ensure deployment is successful.
    try: oc set probe dc/ruby-ex --readiness ...
  * dc/ruby-ex has no liveness probe to verify pods are still running.
    try: oc set probe dc/ruby-ex --liveness ...

View details with 'oc describe <resource>/<name>' or list everything with 'oc get all'.

# 程序描述
[root@master ~]# oc describe svc/ruby-ex
Name:              ruby-ex
Namespace:         aniu-project
Labels:            app=ruby-ex
Annotations:       openshift.io/generated-by=OpenShiftNewApp
Selector:          app=ruby-ex,deploymentconfig=ruby-ex
Type:              ClusterIP
IP:                172.30.195.161
Port:              8080-tcp  8080/TCP
TargetPort:        8080/TCP
Endpoints:         <none>
Session Affinity:  None
Events:            <none>

# 删除应用
[root@master ~]# oc delete all -l app=ruby-ex
deploymentconfig "ruby-ex" deleted
buildconfig "ruby-ex" deleted
imagestream "ruby-22-centos7" deleted
imagestream "ruby-ex" deleted
service "ruby-ex" deleted
```

