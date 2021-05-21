# Azero SDK for iOS 简介

- Azero SDK for iOS 是⼀套由SoundAI提供的软件库，使iOS开发者可将SoundAI的语音唤醒、免唤醒、语音识别、技能等集成到自己的APP中使用。
- 关于 Azero SDK for iOS 的集成，请查阅我们详细的集成指南和 API 指南，也可参考下载的压缩包中附带的示例 demo 来通过代码学习本 SDK 的用法。

## Azero 系统结构![image (/doc/image.png)](/doc/image.png)

- 设备端：RTOS、Android、Linux、iOS、Windows等主流系统和平台均已支持。这些设备既可以作为控制端的入口，也可作为被控制的IoT设备。
- 服务端：技能的开发和部署属于这一部分，开发者主需要关注的是设备中心、技能商店、IoT，其中设备中心用来对产品进行管理，某个产品可根据产品定义配置所需的技能；技能商店包括Azero官方提供的技能、第三方开发的技能和“我的技能”，其中“我的技能”为自己开发的技能，可作为私有技能仅供自己设计的产品使用，从而做出差异化的优质产品，它包含自定义技能、内容信源、智能家居三类，也可开放成公有技能供其他使用者配置调用；IoT设备主要指接入到网络的物联网设备。
- 第三方：为了方便客户对产品功能进行扩展，Azero支持第三方的接入，主要分四类：某些产品需要此领域专有的NLP来完善功能；某些产品需要此领域专有的ASR来完善功能；产品有功能需要大型的私有部署的技能支持；需要对接一些独有的音频、视频、有声等内容。

## 目录
* [快速试用](#quicktrial)
* [试用前提](#prerequisites)
* [直接安装](#install)
* [注册设备](#registeredPlant)
* [试用步骤](#trialStep)
* [体验Azero](#test)
* [更多技能](#more_skill)
* [Azero SDK集成指南](#integrationGuide)
* [进阶集成与调优](#tuning)
* [注意事项](#attention)
* [新手指南](#newbieGuide)
* [联系我们](#contactUs)

## 快速试用<a id="quicktrial"> </a>

Azero for iOS 可支持在绝大多数iOS设备直接安装试用，可体验Azero 默认的通用技能，覆盖了主流语音交互的大部分能力，可帮助开发者快速体验Azero的主要功能、初步了解语音交互的基本流程。

## 试用前提<a id="prerequisites"> </a>

- ⽀持的iOS版本为10.0及以上版本
- 支持iPhone 5s及以上设备

## 直接安装<a id="install"> </a>

你可选择可直接下载 **Azero_Sample_for_iOS** ,安装到手机上进行试用。

## 注册设备<a id="registeredPlant"> </a>

请遵循如下步骤去Azero开发平台完成设备的注册。

1. 登录到[Azero开放平台](https://azero.soundai.com.cn)注册账号，账号需进行实名认证。

2. 接下来创建设备，请参考[设备接入介绍](https://document-azero.soundai.com.cn/azero/IntroductionToDeviceCenter.html)进行设备注册。
   ![demo (/doc/demo.png)](/doc/demo.png)

3. 创建完毕后，在**设备中心 -> 已创建设备**页面可以看到创建的设备，点击对应设备的“查看”进入设备信息页面，页面中的“产品ID”项对应的值即为productId；"Client ID"项对应的值即为clientId。

##  试用步骤<a id="trialStep"> </a>

1）下载SDK以及示例程序包

2）如步骤注册设备 所示，申请productID、clientId

3）打开Azero_Sample_for_iOS的demo示例

3）将申请的client id 、product id 填入AppDemo的config.json中，并传入设备唯一标识，其他默认即可。示例如下所示：
![con (/doc/con.png)](/doc/con.png)
4）安装app到设备端

5）赋予app录音、读取设备权限

完成上述步骤，即可正常体验Azero 默认功能。

## 体验Azero<a id="test"> </a> 

经过上述步骤后，可以立刻体验Azero , 主要功能包括：

1. 唤醒。您可以对设备说"小易小易"唤醒设备，因为当前使用的单路mic数据，因此您需要距离设备稍近些进行唤醒。
2. 听歌。唤醒“小易”后，您可以对他说“我想听歌”等命令词。
3. 聊天。唤醒“小易”后，您可以问他一些问题，“小易”将与您进行聊天。
4. 如2,3 ,Azero默认支持绝大多数语音交互场景，你可以尝试与他进行更多的交流。

**注：部分设备因为系统权限问题，可能需要赋予弹窗权限，否则将无法显示唤醒框；

## 更多技能<a id="more_skill"> </a> 

如需体验更丰富的技能和个性化定制体验，可去 **Azero开放平台 -> 技能商店** 为设备配置更多的官方或者第三方技能，或者按照 [技能接入介绍](https://document-azero.soundai.com.cn/azero/IntroductionToSkillCenter.html) 创建自有技能，实现定制化需求。

##  Azero SDK集成指南<a id="integrationGuide"> </a>

- 资源⽂件
  Lib⽂件夹：AzeroConfig、AzeroSubclass、AzeroManager、Mp3ToPcm（SaiMpToPcmManager：负责将MP3转化为pcm数据，主要用到了一个lame库对数据进行转化）、RecorderManager（XBEchoCancellation：主要负责声音的采集，里面有一些重要的参数配置，回声消除、采样率、通道数等）、PcmPlayManager（AudioQueuePlay：负责底层音频TTS的播放，主要是用音频队列进行实现的；SaiPlaySoundManager：播放闹钟相关铃声的类，可以播放.mp3结尾的本地文件）
  README 文件：SDK 相关说明
  Demo 文件夹：示例

- 配置工程、 在 Xcode 中选择 “Add files to 'Your project name'...”，将解压后的 Lib 子⽂件夹添加到你的⼯程⽬录中

- AzeroConfig：C++部分的SDK、唤醒算法库和部分配置文件；

  Mp3ToPcm：Mp3转PCM类库

  AzeroSubclass：主要继承AzeroSDK文件夹中的类，用于部分基础功能的实现。

  RecorderManager：用于录音的类，控制录音的开始与结束

  PcmPlayManager：用于控制播放PCM的类

  AzeroManager：控制SDK初始化核心方法的类

## 进阶集成与调优<a id="tuning"> </a>

完成上述过程，您已经对Azero的语音基本交互过程有了初步体验，如需将Azero SDK集成到您的工程，并针对您的自有设备进行唤醒、识别等语音交互效果的调优请参照进阶文档。

- [声智Azero系统说明文档](https://github.com/sai-azero/Azero_SDK_for_Android/blob/master/docs/%E5%A3%B0%E6%99%BAAzero%E7%B3%BB%E7%BB%9F%E8%AF%B4%E6%98%8E%E6%96%87%E6%A1%A3.md)
- [Azero SDK API](/doc/apk.md)

##  注意事项<a id="attention"> </a>
- 在Header Search Paths中添加

  $(PROJECT_DIR)/AzeroDemo/AzeroConfig/deliver/include

  $(PROJECT_DIR)/AzeroDemo/AzeroConfig/include

  $(PROJECT_DIR)/AzeroDemo/AzeroConfig/cpp/audio/include

- Enable Bitcode 设置为NO

- Link Binary With Libraries中添加libsqlite3.tbd、libz.tbd

- Demo中添加了FreeStreamer、SuperPlayer三方库，用户音频播放。也可以使用其他的音频播放器进行集成播放

- 本SDK主要是基于C++层面提供的，用OC对C++层面进行了封装，方便开发者进行自定义开发。

- Demo是比较完整的例子，里面是基于SDK之后，包含TTS播放器播放、MP3播放器播放、闹钟播放器播放、MP3流转PCM流、音频的录制等功能；除了SDK的基础功能之外，其他的功能均可以自己自定义，根据需求选择合适的方式去完善

- UIClasses  主要是界面相关  ，使用的时候不需要用到， UI根据自己的需求去定制。主要的manager类主要在/Users/mac/Desktop/AzeroDemo/AzeroDemo/SaiResource/Main/AzeroManager这个AzeroManager管理着SDK的初始化以及一些函数的定义，主要使用的这个类。

- 详细的使用参加函数注释。

- 其他的类除了UIClasses文件夹之外，均为配置类项，都需要添加到项目中。

- Azero中要是使用相关类对象的功能，需要先用engine进行注册，注册完成之后，才可以使用相关类的相关功能。例如：播放TTS需要使用到SaiTtsAzeroSpeaker这个类，需要先初始化SaiTtsAzeroSpeaker这个类的实例对象，然后用AzeroEngine这个类进行注册，注册成功之后，才可以使用这个类实例对象的相关方法。

- AzeroSDK中需要与服务器端同步播放的相关状态。例如：TTS播报状态和音乐播放器的播放状态。当播放开始的时候，需要调用相关接口，上传当前的状态信息，让服务端知道当前SDK的状态，实时地保持SDK的状态与服务端的状态同步。

- 需要在真机上完成想过测试，暂不支持模拟器。

- 环境的切换主要是在config.json中去修改相关配置文件的信息。"clientId","productId","cbl_endpoint","def_endpoint"中去修改配置。

- 免唤醒与唤醒的设置；免唤醒：config.json中修改defaultWakeupMode参数为：wakeupFree；唤醒：config.json中修改defaultWakeupMode参数为：NormalMode,并在-(**void**) onWakeWordDetectedWithTag:(**int**)tag andSequenceId:(aace::openDenoise::LocalSpeechDetector::SequenceIdType)sequenceId andAngle:(**float**)angle{

  }函数回调中设置应答词。
##  新⼿指南<a id="newbieGuide"> </a>

- 下载本 SDK文件。
- 参考iOS SDK集成指南快速把 Demo 跑起来，体验 Azero 的服务。

##  联系我们<a id="contactUs"> </a>

- 如果您对产品有任何bug 反馈、产品建议，请及时与我们联系。
