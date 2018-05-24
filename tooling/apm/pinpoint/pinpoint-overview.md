
现在的服务通常由许多不同的组件组成，彼此之间进行通信以及对外部服务进行API调用。每个事务如何执行通常都是作为一个黑匣子。精确追踪这些组件之间的事务流，并提供清晰的视图来识别问题区域和潜在的瓶颈。

- ServerMap - 通过查看组件的互连方式，了解任何分布式系统的拓扑结构。点击一个节点会显示组件的详细信息，例如其当前状态和事务计数。
- Realtime Active Thread Chart 实时活动线程图 - 实时监控应用程序内的活动线程。
- Request/Response Scatter Chart 请求/响应散点图 - 随时间推移可视化请求计数和响应模式，以发现潜在问题。通过拖动图表可以选择事务处理以获取更多详细信息。

- CallStack - 获得分布式环境中每个事务的代码级可见性，在单个视图中识别瓶颈和故障点。

- Inspector - 查看有关应用程序的其他详细信息，如CPU使用情况，内存/垃圾收集，TPS和JVM参数。


## 架构

http://naver.github.io/pinpoint/images/pinpoint-architecture.png

## 技术实现

- http://naver.github.io/pinpoint/techdetail.html

分布式事务跟踪，模仿Google的Dapper

## 插件

- http://naver.github.io/pinpoint/additionalplugins.html