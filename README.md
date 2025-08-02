<div align="center">
    <h2> China Collegiate Computing Contest
    <h1> Mobile Application Innovation Contest
</div>

<img src="./AppContest2025_Macintustin/docs/img/ouc.png" alt="ouc_alt" title="ouc_img">

<div align="center">
    <h3> 团队名：Macintustin &nbsp;&nbsp; 作品名：Lost Anchor
    <h3> 队长：赵禹惟 &nbsp;&nbsp; 队员：黄梓洋 
    <h3> 指导老师：高峰
</div>

---

## 一、项目简介
本项目为 “第十届中国高校计算机大赛 - 移动应用创新赛”  作品 **Lost Anchor** 的总设计流程，基于 **iPhone / iPad** 的 **AR** 功能实现低门槛、高沉浸感、富有温度的数字地图体验。

---

## 二、成果展示
<p align="center">
    <img src="./AppContest2025_Macintustin/docs/vlog.gif" width=600 alt="展示动画">
</p>

> 注：原视频见 [**演示视频**](./AppContest2025_Macintustin/docs/Macintustin视频.mp4)

---

## 三、项目结构
### 1. 项目主体结构
<pre><code>
AppContest2025_Macintustin/
├── 3DModel/                                 # 储存 3D 锚点模型
│   ├── Drummer.usdz
│   ├── RocketToy.usdz
│   └── ToyBiplane.usdz
│
├── Interface Components/                    # 用户交互主界面
│   ├── HomeView.swift                       # 主界面 (内置2D/AR视图)
│   ├── RecommendationView.swift             # Top10 推荐界面
│   └── UserView.swift                       # 用户设置界面
│
├── Map Components/                          # 地图相关功能模块
│   └── ...
│
├── Assets.xcassets/                         # 存储照片
│   └── ...
│
├── AR Components/                           # AR 功能组件
│   └── ...
│
├── Other Components/
│   ├── AppData.swift                        # App 内置小型数据库
│   └── LikeManager.swift                    # 管理点赞计数和状态持久化
│
├── Photos Components/
│   ├── ImagePicker.swift                    # 从用户照片库中选择多个图像的包装器
│   └── PhotosUpload.swift                   # 照片上传功能模块
│
├── Recommendation Components/
│   ├── CommentSection.swift                 # 照片和评论展示子视图
│   └── PlaceRow.swift                       # 地点展示 UI 管理组件
│
├── User Components/                         # 用户设置界面模块
│   ├── UserDataManager.swift                # 管理用户配置文件数据的单例实用组件
│   └── UserDetailsView.swift                # 用户信息展示 UI
│
├── AppDelegate.swift                        # 用于控制 App 各模块生命周期
├── ContentView.swift                        # 三大主视图缝合 Toolbar
└── StartView.swift                          # App 启动界面
</code></pre>

### 2. 子模块分结构
- **AR 功能组件结构**
<pre><code>
AR Components/                           # AR 功能组件
├── ARSessionHandler.swift               # 用于在增强现实视图中处理AR会话事件
├── ARViewContainer.swift                # 集成 RealityKit 的 ARView 和 SwiftUI 的容器视图
├── AugmentedRealityView.swift           # AR 界面主界面
├── GestureHandler.swift                 # 在 AR 视图中处理用户手势交互
├── LabelEntityBuilder.swift             # 用于在 RealityKit 场景中生成标记的UI元素
└── ModelPlacementHandler.swift          # 用于根据检测到的表面和位置在 AR 场景中放置 3D 模型
</code></pre>

- **地图功能组件结构**
<pre><code>
Map Components/                          # 地图相关功能模块
├── DetailsView Components/              # 地图功能细化模块
├── CommentView.swift                    # 特定位置编写、编辑和保存注释的视图
├── EmptyPhotoPlaceholderView.swift      # 当没有照片时显示的占位视图
│   ├── HeartButtonView.swift            # 一个喜欢按钮视图，可选的评论提示和弹窗支持
│   ├── LocationDetailsHeaderView.swift  # 显示位置名称和标题的标题视图
│   ├── NavigationButtonsView.swift      # 为基于地图的方向提供导航控制按钮的视图
│   └── PhotoCarouselView.swift          # 照片轮播视图显示可滑动的本地图像库
├── LocationDetailsView.swift            # 显示位置信息、照片和导航控件的详细视图。
└── PlainView.swift                      # 一个提供地图搜索、选择和导航功能的SwiftUI视图。
</code></pre>

---

1. 设计流程
- 1. 实现平面地图的定位、锚点设置以及信息呈现
- 2. 实现AR实景的锚点设置、动态路径显示以及锚点信息呈现
- 3. 实现用户界面的 Log in/out 功能
- 4. ...

## 2. 开发文档
- 1. AR相关信息:  
访问 [Apple][arkit-link] documentation
[arkit-link]: https://developer.apple.com/documentation/arkit/  
访问 [Apple][reality-link] documentation
[reality-link]: https://developer.apple.com/documentation/realitykit/
- 2. 地图相关信息:  
访问 [Apple][arworldmap-link] documentation
[arworldmap-link]: https://developer.apple.com/documentation/arkit/arworldmap
- 3. 锚点设置相关信息:  
访问 [Apple][anchor-link] documentation
[anchor-link]: https://developer.apple.com/documentation/arkit/anchor

## 3. 具体实现
- 1. 平面地图功能实现:

#### ⚠️ License: 该项目非开源. 详见 [LICENSE](./LICENSE).

---

<img src="./AppContest2025_Macintustin/docs/img/ouc2.png" alt="ouc2_alt" title="ouc2_img">