#ifndef __AZERO_SPEECH_CACHE_MANAGE_H_
#define __AZERO_SPEECH_CACHE_MANAGE_H_

#include <memory>
#include <mutex>
#include <string>
#include <unordered_map>
#include <fstream>
#include <future>
#include <chrono>

#include <AVSCommon/AVS/AVSDirective.h>

namespace Azero
{

using namespace alexaClientSDK::avsCommon::avs;
using namespace alexaClientSDK::avsCommon::avs::attachment;

class AzeroSpeechCacheManage
{
public:
    AzeroSpeechCacheManage(std::string rootPath);

    ~AzeroSpeechCacheManage();

    static std::shared_ptr<AzeroSpeechCacheManage> create(std::string rootPath=""){
        return std::make_shared<AzeroSpeechCacheManage>(rootPath);
    }

    std::shared_ptr<std::ifstream> getCacheStream(std::shared_ptr<AVSDirective> directive, std::unique_ptr<AttachmentReader> reader);

private:
    bool m_stop;
    std::string m_rootPath;

    std::string m_cacheId;

    /// Map of localStream, key = cacheId, name = music-ACV1 localpath-ACVversion, ACV = azero cache version
    struct localStreamInfo
    {
        std::string name;   //路径, 不包含 rootPath
        int64_t secondsCount; //1970年开始的时间戳
        long times; //使用次数
    };

    std::unordered_map<std::string, localStreamInfo> m_localStreamMap;
    std::unique_ptr<AttachmentReader> m_reader;

    std::future<void> m_asyncTask;

    std::shared_ptr<std::ifstream> findCacheStream(std::shared_ptr<AVSDirective> directive);

    void creatCacheStream(std::shared_ptr<AVSDirective> directive);

    void updateCacheMap(const std::string& cacheName);

    void eraseCacheMap(const std::string& key);

    bool judgeMemoryEnough();

    bool cmplocalStreamMap(const localStreamInfo& info1, const localStreamInfo& info2);
};

} // namespace Azero

#endif //__AZERO_SPEECH_CACHE_MANAGE_H_