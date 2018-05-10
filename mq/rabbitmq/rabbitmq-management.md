管理插件
介绍
rabbitmq-management插件提供了一个基于HTTP的API，用于管理和监控您的RabbitMQ服务器，以及基于浏览器的用户界面和命令行工具rabbitmqadmin。功能包括：

声明，列出和删除交换，队列，绑定，用户，虚拟主机和权限。
监控队列长度，全局和每个通道的消息速率，每个连接的数据速率等。
监视资源使用情况，如文件描述符，内存使用情况，可用磁盘空间。
管理用户（提供当前用户的管理权限）。
将对象定义（虚拟主机，用户，权限，队列，交换，绑定，参数，策略）导出和导入JSON。
强制关闭连接，清除队列。
发送和接收消息（在开发环境和故障排除中很有用）。
入门
管理插件包含在RabbitMQ发行版中。要启用它，请使用rabbitmq-plugins：

rabbitmq-plugins enable rabbitmq_management

Web UI位于：http：// server-name：15672 /
Web UI使用由相同插件提供的HTTP API。所述API的文档可以通过http：// server-host：15672 / api /或我们 最新的HTTP API文档访问）。
下载rabbitmqadmin ：http：// server-name：15672 / cli /
注意：3.0之前的RabbitMQ版本的端口是55672。

要使用Web UI，您需要以RabbitMQ用户身份进行身份验证（在全新安装中，用户“guest”用密码“guest”创建）。从这里您可以管理交换，队列，绑定，虚拟主机，用户和权限。希望UI非常明了。

管理UI是作为一个静态HTML页面实现的，后者对HTTP API进行后台查询。因此，它会大量使用Javascript。已经使用最新版本的Firefox，Chromium和Safari以及Microsoft Internet Explorer版本回到6.0。

权限
管理插件在一定程度上扩展了现有的权限模型。用户可以在RabbitMQ中获得任意标签。管理插件使用名为“管理”，“决策者”，“监控”和“管理员”的标签。下表显示了不同类型的用户可以执行的操作：

标签	功能
（没有）	无法访问管理插件
管理	用户可以通过AMQP加上：
列出可通过AMQP登录的虚拟主机
查看“他们的”虚拟主机中的所有队列，交换和绑定
查看并关闭自己的渠道和连接
查看涵盖所有虚拟主机的“全局”统计信息，包括其中的其他用户的活动
政策制定者	一切“管理”可以加上：
查看，创建和删除可通过AMQP登录的虚拟主机的策略和参数
监控	一切“管理”可以加上：
列出所有虚拟主机，包括他们无法通过AMQP登录的虚拟主机
查看其他用户的连接和频道
查看节点级别的数据，如内存使用和群集
查看所有虚拟主机的真正全球统计数据
管理员	一切“决策者”和“监督”可以加上：
创建和删除虚拟主机
查看，创建和删除用户
查看，创建和删除权限
关闭其他用户的连接
请注意，由于“管理员”完成“监视”所做的所有工作，“监视”完成“管理”所做的一切工作，因此您经常只需为每个用户提供最多一个标记。

正常的RabbitMQ权限仍然适用于监视器和管理员; 仅仅是因为用户是监视器或管理员不能让他们通过AMQP或管理插件完全访问交换，队列和绑定。

如果所有用户对该虚拟主机有任何权限，则只能列出特定虚拟主机中的对象。

如果由于仅拥有非管理员用户或根本没有用户而被锁定，则可以使用rabbitmqctl add_user 创建非管理员用户，并使用rabbitmqctl set_user_tags将用户升级为管理员。

HTTP API
管理插件将在http：// server-name：15672 / api /上创建一个基于HTTP的API 。浏览到该位置以获取有关API的更多信息。为了方便起见，您可以阅读GitHub上的 最新HTTP API文档。

该API旨在用于监视和警报目的。它提供有关节点，连接，通道，队列，消费者等状态的详细信息。

可以在启用了rabbitmq-management插件的任何节点上使用HTTP API 。然后它将能够在任何（或全部）群集节点上提供度量。在监视节点集群时，不需要单独通过HTTP API联系每个节点。相反，请联系位于群集前的随机节点或负载均衡器。

对于多种语言的HTTP API客户端，请参阅开发人员工具。

一些API端点返回大量信息。可以通过过滤“HTTP GET”请求返回的列来减少音量。详情请参阅 最新的HTTP API文档。

rabbitmqadmin是一个与HTTP API交互的Python命令行工具。它可以从任何启用了管理插件的RabbitMQ节点下载，请参阅http：// server-name：15672 / cli /

组态
有几个配置选项会影响管理插件。这些通过主要的RabbitMQ 配置文件进行管理 。

HTTP请求记录
要为HTTP API创建简单的请求访问日志，请将rabbitmq_management应用程序中的http_log_dir变量的值设置为可以创建日志的目录的名称，然后重新启动RabbitMQ。请注意，只记录API在/ api的请求，而不是对组成基于浏览器的GUI的静态文件的请求。

统计间隔
默认情况下，服务器每隔5000ms发出一次统计事件。管理插件中显示的消息速率值是在此期间计算的。因此，您可能希望增加此值，以便在较长时间内对速率进行采样，或者减少具有大量队列或通道的服务器上的统计负载。

为此，请将兔子应用程序的collect_statistics_interval变量的值设置为所需的时间间隔（以毫秒为单位），然后重新启动RabbitMQ。

留言率
管理插件默认显示全局消息速率，以及每个队列，通道，交换和虚拟主机。这些被称为基本消息速率。

它还可以显示所有交换信道组合，交换队列和队列到信道的消息速率。这些被称为详细的消息速率。详细的消息速率在默认情况下是禁用的，因为当通道，队列和交换机的组合数量很多时，它们可能会占用大量内存。

或者，消息速率可以完全禁用。这可以帮助从CPU绑定的服务器获得最佳性能。

消息速率模式由  rabbitmq_management中的rates_mode配置变量  控制。这可以是  基本的（默认），详细的或  没有。

在启动时加载定义
管理插件允许您导出包含所有代理对象（队列，交换，绑定，用户，虚拟主机，权限和参数）定义的JSON文件。在某些情况下，确保每次启动时都存在这些对象可能很有用。

为此，请将management.load_definitions（ 经典配置格式中的rabbitmq_management.load_definitions）config密钥设置为之前导出的包含所需定义的JSON文件的路径：

management.load_definitions = /path/to/definitions/file.json
使用经典配置格式：
[
{rabbitmq_management，[
  {load_definitions，“/path/ to / definitions / file.json ” }
  ]}
].
请注意，文件中的定义将覆盖代理中的所有内容; 使用此选项不会删除已存在的任何内容。但是，如果您从完全重置代理程序开始，则使用此选项将会阻止创建通常的默认用户/虚拟主机/权限。

事件积压
在重负载下，统计事件的处理会增加内存消耗。为了减少这种情况，可以调整通道和队列统计收集器的最大积压大小。rabbitmq_management应用程序中stats_event_max_backlog变量的值 设置了两个积压件的最大尺寸。默认为250。

配置HTTP侦听器
可以将rabbitmq-web-dispatch配置为在不同端口或网络接口上使用SSL等方式为管理插件提供服务。为此，应该配置  监听器配置项; 例如更改端口：

management.listener.port = 12345
或者，使用经典配置格式：
[
  {rabbitmq_management，[{listener，[{port，12345 }]}]}，
].
或者使管理插件使用HTTPS：

management.listener.port = 15671
management.listener.ssl = true
management.listener.ssl_opts.cacertfile = /path/to/cacert.pem
management.listener.ssl_opts.certfile = /path/to/cert.pem
management.listener.ssl_opts.keyfile = /path/to/key.pem
或者，使用经典配置格式：
[{rabbitmq_management，
  [{listener，[{port，      15671 }，
               {ssl，true}，
               {ssl_opts，[{cacertfile，“/path/ to / cacert.pem ” }，
                           {certfile，“/path/ to / cert.pem    ” }，
                           {keyfile，     “/path/to/key.pem” }]}
              ]}
  ]}
].
有关 更多详细信息，请参阅rabbitmq-web-dispatch指南。

示例保留策略
管理插件将保留一些数据的样本，如消息速率和队列长度。您可以配置保留这些数据的时间。

management.sample_retention_policies.global.minute = 5
management.sample_retention_policies.global.hour = 60
management.sample_retention_policies.global.day = 1200

management.sample_retention_policies.basic.minute = 5
management.sample_retention_policies.basic.hour = 60

management.sample_retention_policies.detailed.10 = 5
有三个政策：

全局 - 保留概览和虚拟主机页面的数据需要多长时间
基本 - 为各个连接，通道，交换和队列保留数据需要多长时间
详细 - 保留连接，通道，交换和队列对之间的消息速率数据的时间（如“消息速率细分”所示）
此配置（默认设置）以5秒的分辨率（每5秒采样一次）保留全局数据10分钟和5秒，然后以1分钟的分辨率保持1小时1分钟，然后以10分钟的分辨率大约8个小时。它以5秒的分辨率保存1分钟和5秒的基本数据，然后以1分钟的分辨率保存1小时，详细的数据仅保留10秒。所有这三项策略都是强制性的，并且必须至少包含一个保留对{MaxAgeInSeconds，SampleEveryNSeconds}。
跨源资源共享（CORS）
管理API默认不允许访问不同来源的网站。允许的来源必须在配置中明确列出。

[
  {rabbitmq_management，
    [{cors_allow_origins，[ “http://rabbitmq.com”，“http://example.org” ]}]}，
].
可以允许任何来源使用API​​。但是，如果可以从外部访问API，则不推荐使用。

[
  {rabbitmq_management，
    [{cors_allow_origins，[ “*” ]}]}，
].
CORS预发送请求由浏览器缓存。管理插件默认定义30分钟的超时时间。您可以在配置中修改此值。它在几秒钟内定义。

[
  {rabbitmq_management，
    [{cors_allow_origins，[ “http://rabbitmq.com”，“http://example.org” ]}，
     {cors_max_age，3600 }]}，
].
路径前缀
某些环境要求对管理插件的所有HTTP请求使用自定义前缀。该  串流中设置允许的任意的前缀来在管理插件的所有HTTP请求处理程序来设定。

将path_prefix设置为/ my-prefix 指定使用URI 主机的所有API请求  ：port / my-prefix / api / [...]

管理用户界面登录页面将具有URI  host：port / my-prefix / - 请注意，在这种情况下，需要结尾的斜杠。

[
  ...
  {rabbitmq_management，
    [{path_prefix，“/ my-prefix” }]}，
  ...
].
例
RabbitMQ的一个示例配置文件用于切换请求日志记录，将统计信息时间间隔增加为10000毫秒，并将一些其他相关参数显式设置为其默认值，如下所示：

listeners.tcp.default = 5672

collect_statistics_interval = 10000

＃management.load_definitions = /path/to/exported/definitions.json

management.listener.port = 15672
management.listener.ip = 0.0.0.0
management.listener.ssl = true

management.listener.ssl_opts.cacertfile = /path/to/cacert.pem
management.listener.ssl_opts.certfile = /path/to/cert.pem
management.listener.ssl_opts.keyfile = /path/to/key.pem

management.http_log_dir = / path / to / rabbit / logs / http

management.rates_mode =基本

＃配置
保留
聚合数据（如消息速率和队列长度）的时间。＃您可以使用'分钟'，'小时'和'日'键或整数键（以秒为单位）
management.sample_retention_policies.global.minute = 5
management.sample_retention_policies.global.hour = 60
management.sample_retention_policies.global.day = 1200

management.sample_retention_policies.basic.minute = 5
management.sample_retention_policies.basic.hour = 60

management.sample_retention_policies.detailed.10 = 5
或者，使用经典配置格式：
[
{rabbit，[{tcp_listeners，[ 5672 ]}，
          {collect_statistics_interval，10000 }]}，

{rabbitmq_management，
  [
   %%来自以下JSON文件的预加载模式定义。
   %% 
   %% {load_definitions，“/path/to/definitions.json”}，

   %%将所有对管理HTTP API的请求记录到一个目录中。
   %% 
   {http_log_dir，“/ path / to / rabbit / logs / http” }，

   %%更改HTTP侦听器侦听的端口，
   %%指定HTTP服务器要绑定的接口。
   %%还要将侦听器设置为使用TLS并提供TLS选项。
   %% 
   %% {listener，[{port，15672}，
   %% {ip，“0.0.0.0”}，
   %% {ssl，true}，
   %% {ssl_opts，[{cacertfile，“/ path / to / cacert .pem“}，
   %% {certfile，”/path/to/cert.pem“}，
   %% {keyfile，”/path/ to/key.pem “}]}]}，

   %%'基本'，'详细'或'无'之一。
   {rates_mode，基本}，

   %%增加此参数将使HTTP API缓存数据
   更积极地从其他集群对等节点
   检索%% %% {management_db_cache_multiplier，5}，

   %%如果事件收集落后于统计排放，
   %%将这些事件保存在积压中，剩下的
   %%将被删除以避免内存消耗增长失控。
   %%此设置是每个节点。除非有
   %%统计收集器积压的
   证据，否则不需要更改此值。%% {stats_event_max_backlog，250}，

   HTTP API的%% CORS设置
   %% {cors_allow_origins，[“https：//rabbitmq.eng.megacorp.local”，“https：//monitoring.eng.megacorp.local”]}，
   %% {cors_max_age，1800} ，

   %%配置
   保留
   聚合数据（如消息速率和队列%%长度）的时间长度。%%％
   {sample_retention_policies，
   %% [{global，[{60,5}，{3600，60}，{86400，1200}]}，
   %% {basic，[{60,5}，{3600，60 }]}，
   %% {detailed，[{10，5}]}]}
  ]}
].
内存使用分析
管理UI可用于检查节点的内存使用情况，包括显示每个类别的故障。详情请参阅内存使用分析指南。

关于聚类的注意事项
管理插件了解集群。您可以在集群中的一个或多个节点上启用它，并查看有关整个集群的信息，而不管您连接到哪个节点。

如果要部署未启用完整管理插件的群集节点，则仍需要在每个节点上启用rabbitmq-management-agent插件。

当群集管理插件执行群集范围的查询时，这意味着它可能会受到各种网络事件（如 分区）的影响。

（反向HTTP）代理设置
可以通过任何符合RFC 1738的代理使Web UI可用。以下示例Apache配置说明了使Apache符合要求的最低必要指令。它假定默认端口为15672的管理Web UI：

AllowEncodedSlashes  On 
ProxyPass         / api http：// localhost：15672 / api nocanon
 ProxyPass         / http：// localhost：15672 /
 ProxyPassReverse / http：// localhost：15672 /
重新启动统计数据库
统计数据库完全存储在内存中。它的所有内容都是短暂的，应该这样对待。在版本3.6.7之前，统计数据库存储在单个节点上。从版本3.6.7开始，每个节点都有自己的统计数据库，其中包含记录在该节点上的一小部分统计数据。可以重新启动统计数据库。

统计数据库存储在以前的RabbitMQ 3.6.2统计过程的内存中，并存储在RabbitMQ 3.6.2的ETS表中。要使用早于3.6.2的版本重新启动数据库，请使用

rabbitmqctl EVAL  '退出（二郎：whereis（rabbit_mgmt_db），please_terminate）。'
从RabbitMQ 3.6.2开始，最高可达3.6.5，请使用
rabbitmqctl EVAL  “supervisor2：terminate_child（rabbit_mgmt_sup_sup，rabbit_mgmt_sup），
                  rabbit_mgmt_sup_sup：start_child（）“。
这些命令必须在承载数据库的节点上执行。从RabbitMQ 3.6.7开始，可以使用每个节点重置数据库
rabbitmqctl EVAL  'rabbit_mgmt_storage：复位（）'。
重置所有节点上的整个管理数据库
rabbitmqctl EVAL  'rabbit_mgmt_storage：RESET_ALL（）'。
还有HTTP API端点来重置数据库整个数据库
DELETE / api / reset
对于单个节点
DELETE / api / reset /：节点
内存管理
管理数据库的内存使用情况可以通过rabbitmqctl获取：
rabbitmqctl状态
或通过 HTTP API向/ api / nodes / name发送GET请求。
统计信息定期发布，由上述统计时间间隔调整，或者创建/声明某些组件时（例如打开新连接或频道或声明队列）或关闭/删除。消息速率不会直接影响管理数据库内存使用情况。

统计数据库消耗的内存总量取决于事件发射间隔，有效速率模式和保留策略。

将rabbit.collect_statistics_interval值增加到30-60s（注意：该值应以毫秒为单位设置，例如30000）将减少具有大量队列/通道/连接的系统的内存消耗。调整保留策略以保留较少的数据也会有所帮助。

通过使用参数stats_event_max_backlog设置最大积压队列大小，可以限制通道和统计信息收集器进程的内存使用情况 。如果积压队列已满，则将删除新的通道和队列统计数据，直至处理完先前的统计数据。

统计间隔也可以在运行时更改。这样做不会影响现有的连接，通道或队列。只有新的统计排放实体受到影响。

rabbitmqctl EVAL  '应用：set_env（兔，collect_statistics_interval，60000）。'
统计数据库可以重新启动（见上），并因此被迫释放所有内存。