## iOS SDK API

- Function

  azeroManagerStartRecord

  azeroManagerEndRecord

  azeroSetUpAzeroSDK

  azeroManagerWriteData:

  azeroManagerReadDataWith: andSize:

  azeroManagerReadDataComplete

  azeroManagerReportTtsPlayStateStart

  azeroManagerReportMp3PlayStateStart

  azeroManagerReportTtsPlayStateStop

  azeroManagerReportMp3PlayStateStop

  azeroManagerReportTtsPlayStateFinished

  azeroManagerReportMp3PlayStateFinished

  azeroManagerReportMp3PlayStateError

  azeroManagerSentTxet:

  azeroPlayTtsStatePrepare:

  azeroPlaySongUrl:

  azeroListInfo:

  azeroManagerRenderTemplate:

  azeroManagerExpress:

  azeroManagerVadStart:

  azeroManagerVadStop:

  azeroLogoutAzeroSDK

  azeroAddContactsBegin

  azeroAddContactsEnd

  azeroAddContact:

  azeroQueryContact

  azeroSDKConnectionStatusChangedWithStatus:

  azeroManagerSetSongCycleMode:

  azeroManagerRemoveAlert:

  azeroManagerRemoveAllAlert

  azeroManagerSwitchMode: andValue:

  azeroButtonPressed:

  azeroManagerReportAlertPlayStateFinished

  azeroReportSystemCurrentVolume:

  azeroUpdateMessageWithLevel: tag: messmage:

###### azeroManagerStartRecord

- 接口定义

  ```
  - (void)azeroManagerStartRecord;
  ```

- Method - azeroManagerStartRecord

  调用此API来开启录音

- 样例代码

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerStartRecord];
  ```

###### azeroManagerEndRecord

- 接口定义

  ```
  - (void)azeroManagerEndRecord;
  ```

- Method - azeroManagerEndRecord

  调用此API来结束录音

- 样例代码

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerEndRecord];
  ```

###### azeroSetUpAzeroSDK

- 接口定义

  ```
  - (void)azeroSetUpAzeroSDK;
  ```

- Method - azeroSetUpAzeroSDK

  调用此API来初始化SDK
- 样例代码
  
  ```
  [[AzeroManager sharedAzeroManager] azeroSetUpAzeroSDK];
  ```

###### azeroManagerWriteData:

- 接口定义
```
- (void)azeroManagerWriteData:(NSData *)data;
```
- 参数说明
```
data:采集的音频数据
```


- Method - azeroManagerWriteData:

  调⽤此API来为SDK传输录音的数据

- 样例代码

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerWriteData:data];
  ```

###### azeroManagerReadDataWith: andSize:

- 接⼝定义
```
- (ssize_t)azeroManagerReadDataWith:(char*)buffer andSize:(size_t)bufferSize;
```


- Method - azeroManagerReadDataWith: andSize:

  调⽤此API来读取SDK返回的TTS数据

- 样例代码

  ```
      ssize_t i = [[AzeroManager sharedAzeroManager] azeroManagerReadDataWith:mp3Buffer andSize:mp3Size];
  ```

###### azeroManagerReadDataComplete

- 接⼝定义
```
- (bool)azeroManagerReadDataComplete;
```

- Method - azeroManagerReadDataComplete

  调⽤此API来判断读取的TTS数据是否完成

- 样例代码
    ```
        BOOL  isClosed = [[AzeroManager sharedAzeroManager] azeroManagerReadDataComplete];
    ```
###### azeroManagerReportTtsPlayStateStart

- 接⼝定义

```
- (void)azeroManagerReportTtsPlayStateStart;
```

- Method - azeroManagerReportTtsPlayStateStart

  用于TTS播放器上报当前播放器的播放状态-Start

- 样例代码

  ```
      [[AzeroManager sharedAzeroManager] azeroManagerReportTtsPlayStateStart];
  ```

###### azeroManagerReportMp3PlayStateStart

- 接⼝定义

```
- (void)azeroManagerReportMp3PlayStateStart;
```

- Method - azeroManagerReportMp3PlayStateStart

  用于MP3播放器上报当前播放器的播放状态-Start

- 样例代码

  ```
  [[AzeroManager sharedAzeroManager]azeroManagerReportMp3PlayStateStart];
  ```

###### azeroManagerReportTtsPlayStateStop

- 接⼝定义

```
- (void)azeroManagerReportTtsPlayStateStop;
```

- Method - azeroManagerReportTtsPlayStateStop

  用于TTS播放器上报当前播放器的播放状态-Stop

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerReportTtsPlayStateStop];
  ```

######  azeroManagerReportMp3PlayStateStop

- 接⼝定义

```
- (void)azeroManagerReportMp3PlayStateStop;
```

- Method - azeroManagerReportMp3PlayStateStop

  用于MP3播放器上报当前播放器的播放状态-Stop

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerReportMp3PlayStateStop];
  ```

###### azeroManagerReportTtsPlayStateFinished

- 接⼝定义

```
- (void)azeroManagerReportTtsPlayStateFinished;
```

- Method - azeroManagerReportTtsPlayStateFinished

  用于TTS播放器上报当前播放器的播放状态-Finished

- 代码样例:

  ```
   [[AzeroManager sharedAzeroManager] azeroManagerReportTtsPlayStateFinished];
  ```

###### azeroManagerReportMp3PlayStateFinished

- 接⼝定义

```
- (void)azeroManagerReportMp3PlayStateFinished;
```

- Method - azeroManagerReportMp3PlayStateFinished

  用于MP3播放器上报当前播放器的播放状态-Finished

- 代码样例:

  ```
      [[AzeroManager sharedAzeroManager] azeroManagerReportMp3PlayStateFinished];
  ```

###### azeroManagerReportMp3PlayStateError

- 接⼝定义

```
- (void)azeroManagerReportMp3PlayStateError;
```

- Method - azeroManagerReportMp3PlayStateError

  用于MP3播放器上报当前播放器的播放状态-Error

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerReportMp3PlayStateError];
  ```

###### azeroManagerSentTxet:

- 接⼝定义

```
- (void)azeroManagerSentTxet:(NSString *)text;
```

- 参数说明

  ```
  text:发送的文字信息
  ```

- Method - azeroManagerSentTxet:

  调用此API来发送文字信息到SDK

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerSentTxet:@"现在几点钟"];
  ```

###### azeroPlayTtsStatePrepare:

- 接⼝定义

```
- (void)azeroPlayTtsStatePrepare:(azeroManagerPreparePlayTtsBlock)azeroPreparePlayTts;
```

- 参数说明

  ```
  azeroPlayTtsStatePrepare:准备播放tts时候的回调block
  ```

- Method - azeroPlayTtsStatePrepare:

  当SDK准备调用TTS播放器播放TTS数据的时候回调此block

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroPlayTtsStatePrepare:^{
  }];
  ```

###### azeroPlaySongUrl:

- 接⼝定义

```
- (void)azeroPlaySongUrl:(azeroManagerPreparePlaySongUrlBlock)azeroPlaySongUrl;
```

- 参数说明

  ```
  azeroPlaySongUrl:歌曲url的回调block
  ```

- Method - azeroPlaySongUrl:

  SDK下发将要播放的歌曲url的时候回调此block

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroPlaySongUrl:^(NSString *songUrl) {
          
      }];
  ```

###### azeroListInfo:

- 接⼝定义

```
- (void)azeroListInfo:(azeroManagerListInfoBlock)azeroListInfo;
```

- 参数说明

  ```
  azeroListInfo:列表回调的block
  ```

- Method - azeroListInfo:

  调用此API来回调SDK返回的列表信息

- 代码样例:

  ```
   [[AzeroManager sharedAzeroManager] azeroListInfo:^(NSString *ListStr) {
          TYLog(@"hello - saiAzeroSongListInfo ： renderPlayerInfo 内容：%@",ListStr);
      }];
  ```

###### azeroManagerRenderTemplate:

- 接⼝定义

```
- (void)azeroManagerRenderTemplate:(azeroManagerRenderTemplateBlock)azeroManagerRenderTemplate;
```

- 参数说明

  ```
  azeroManagerRenderTemplate:回调模板信息的block
  ```

- Method - azeroManagerRenderTemplate:

  调用此API来回调SDK下发的模板信息

- 代码样例:

  ```
      [[AzeroManager sharedAzeroManager] azeroManagerRenderTemplate:^(NSString *renderTemplateStr) {
          TYLog(@"hello - AzeroManagerRenderTemplate ： renderTemplate 内容： %@",renderTemplateStr);
      }];
  ```

###### azeroManagerExpress:

- 接⼝定义

```
- (void)azeroManagerExpress:(azeroManagerExpressBlock)azeroManagerExpress;
```

- 参数说明

  ```
  azeroManagerExpress:回调SDK下发的表述信息的block
  ```

- Method - azeroManagerExpress:

  调用此API来回调SDK下发的表述信息

- 代码样例:

  ```
      [[AzeroManager sharedAzeroManager] azeroManagerExpress:^(NSString *type, NSString *content) {
          TYLog(@"&&&&&&type : %@ ,content : %@",type,content);
      }];
  ```

###### azeroManagerVadStart:

- 接⼝定义

```
- (void)azeroManagerVadStart:(azeroManagerVadStartBlock)vadStart;
```

- 参数说明

  ```
  vadStart:vad触发的回调block
  ```

- Method - azeroManagerVadStart:

  当触发VadStart的回调此函数

- 代码样例:

  ```
      [[AzeroManager sharedAzeroManager] azeroManagerVadStart:^{
          TYLog(@" ==================================================================================================== AzeroManagerVadStart");
          dispatch_async(dispatch_get_main_queue(), ^{
              [SaiSoundWaveView showHudAni];
          });
      }];
  ```

###### azeroManagerVadStop:

- 接⼝定义

```
- (void)azeroManagerVadStop:(azeroManagerVadStopBlock)vadStop;
```

- 参数说明

  ```
  vadStop:vad结束时的回调block
  ```

- Method - azeroManagerVadStop:

  用于监听vad的结束

- 代码样例:

  ```
      [[AzeroManager sharedAzeroManager] azeroManagerVadStop:^{
          dispatch_async(dispatch_get_main_queue(), ^{
              [SaiSoundWaveView dismissHudAni];
              TYLog(@"--**localDetectorEventSpeechStopDetected4");
              
          });
      }];
  ```

###### azeroLogoutAzeroSDK

- 接⼝定义

```
- (void)azeroLogoutAzeroSDK;
```

- Method -  azeroLogoutAzeroSDK

  退出SDK

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroLogoutAzeroSDK];
  ```

###### azeroAddContactsBegin

- 接⼝定义

```
- (BOOL)azeroAddContactsBegin;
```

- Method - azeroAddContactsBegin

  通知SDK开始上传通讯录

- 代码样例:

  ```
      BOOL begin = [[AzeroManager sharedAzeroManager] azeroAddContactsBegin];
  ```

###### azeroAddContactsEnd

- 接⼝定义

```
- (BOOL)azeroAddContactsEnd;
```

- Method - azeroAddContactsEnd

  通知SDK上传通讯录结束

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroAddContactsEnd];
  ```

###### azeroAddContact:

- 接⼝定义

```
- (BOOL)azeroAddContactsEnd:(NSString *)contact;
```

- 参数说明

  ```
  contact:通讯录的json字符串
  ```

- Method - azeroAddContactsEnd:

  调用此API来上传通讯录

- 代码样例:

  ```
  BOOL success = [[AzeroManager sharedAzeroManager] azeroAddContactsEnd:[dic modelToJSONString]];
  ```

###### azeroQueryContact

- 接⼝定义

```
- (NSString *)azeroQueryContact;
```

- Method - azeroQueryContact

  调用此API来查询通讯录信息

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroQueryContact]
  ```

###### azeroSDKConnectionStatusChangedWithStatus:

- 接⼝定义

```
- (void)azeroSDKConnectionStatusChangedWithStatus:(azeroManagerConnectionStatusBlock )connectionStatus;
```

- 参数说明

  ```
  connectionStatus:连接状态的block
  ```

- Method - azeroSDKConnectionStatusChangedWithStatus:

  调用此API来检测SDK的链接状态

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroSDKConnectionStatusChangedWithStatus:^(ConnectionStatus status) {
          dispatch_async(dispatch_get_main_queue(), ^{
              switch (status) {
                  case ConnectionStatusConnect:{
  //                    [MessageAlertView showHudMessage:@"与SDK服务器建立连接"];
                      [[SaiPlaySoundManager sharedPlaySoundManager] playSoundWithSource:@"alert_network_connected.mp3"];
                  }
                      
                      break;
                  case ConnectionStatusPENDING:{
  //                    [MessageAlertView showHudMessage:@"与SDK服务器断开连接"];
                      [[SaiPlaySoundManager sharedPlaySoundManager] playSoundWithSource:@"alert_network_disconnected.mp3"];
                      [SaiSoundWaveView hideAllView];
                  }
                      break;
                  case ConnectionStatusDisConnect:
                      [SaiSoundWaveView hideAllView];
                      break;
                  default:
                      break;
              }
          });
      }];
  ```

###### azeroManagerSetSongCycleMode:

- 接⼝定义

```
- (void)azeroManagerSetSongCycleMode:(SongCycleMode)mode;
```

- 参数说明

  ```
  mode:播放模式
  ```

- Method - azeroManagerSetSongCycleMode:

  调用此API来设置播放器的播放模式

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerSetSongCycleMode:SongCycleModeSingle];
  ```

###### azeroManagerRemoveAlert:

- 接⼝定义

```
- (void)azeroManagerRemoveAlert:(NSString *)alert_token;
```

- 参数说明

  ```
  alert_token:闹钟的token
  ```

- Method - azeroManagerRemoveAlert:

  调用此API来移除单个闹钟

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerRemoveAlert:[AzeroManager sharedAzeroManager].alert_token];
  ```

###### azeroManagerRemoveAllAlert:

- 接⼝定义

```
- (void)azeroManagerRemoveAllAlert;
```

- Method - azeroManagerRemoveAllAlert

  调用此API来移除所有的闹钟

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerRemoveAllAlert];
  ```

######  azeroManagerSwitchMode: andValue:

- 接⼝定义

```
- (void)azeroManagerSwitchMode:(ModeType )localeMode andValue:(BOOL )value;
```

- 参数说明

  ```
  localeMode :SDK的模式.
  value: YES/NO.
  ```

- Method - azeroManagerSwitchMode: andValue:

  切换SDK的模式

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerSwitchMode:ModeHeadset andValue:YES];
  ```

###### azeroButtonPressed:

- 接⼝定义

```
- (void)azeroButtonPressed:(ButtonType)button;
```

- 参数说明

  ```
  button :按钮类型的枚举
  ```

- Method - azeroButtonPressed:

  按钮的点击事件

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroButtonPressed:ButtonTypePAUSE];
  ```

###### azeroManagerReportAlertPlayStateFinished

- 接⼝定义

```
- (void)azeroManagerReportAlertPlayStateFinished;
```

- Method - azeroManagerReportAlertPlayStateFinished

  上报闹钟播放完毕的状态

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroManagerReportAlertPlayStateFinished];
  ```

###### azeroReportSystemCurrentVolume:

- 接⼝定义

```
- (void)azeroReportSystemCurrentVolume:(int )volume;
```

- 参数说明

  ```
  volume :系统音量大小
  ```

- Method - azeroReportSystemCurrentVolume:

  向SDK上报系统音量

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroReportSystemCurrentVolume:value*100];
  ```

###### azeroUpdateMessageWithLevel: tag: messmage:

- 接⼝定义

```
- (void)azeroUpdateMessageWithLevel:(SaiAppLoggerLevel )level tag:(NSString *)tag messmage:(NSString *)message;
```

- 参数说明

  ```
  level :日志类型.
  tag:日志标示.
  message:日志内容
  ```

- Method - azeroUpdateMessageWithLevel: tag: messmage:

  上传日志信息

- 代码样例:

  ```
  [[AzeroManager sharedAzeroManager] azeroUpdateMessageWithLevel:SaiINFO tag:nil messmage:@"日志内容"];
  ```

