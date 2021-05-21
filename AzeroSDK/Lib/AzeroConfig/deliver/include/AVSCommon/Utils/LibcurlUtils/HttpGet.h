/*
 * Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *     http://aws.amazon.com/apache2.0/
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_LIBCURLUTILS_HTTPGET_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_LIBCURLUTILS_HTTPGET_H_

#include <memory>
#include <mutex>
#include <string>

#include <curl/curl.h>

#include "AVSCommon/Utils/LibcurlUtils/CurlEasyHandleWrapper.h"
#include "HttpGetInterface.h"

namespace alexaClientSDK {
namespace avsCommon {
namespace utils {
namespace libcurlUtils {

/// LIBCURL based implementation of HttpGetInterface.
class HttpGet : public HttpGetInterface {
public:
    /**
     * Create a new HttpGet instance, passing ownership of the new instance on to the caller.
     *
     * @return Returns an std::unique_ptr to the new HttpGet instance, or @c nullptr of the operation failed.
     */
    static std::unique_ptr<HttpGet> create();

    /**
     * HttpGet destructor
     */
    ~HttpGet() = default;

    /**
     * Deleted copy constructor.
     *
     * @param rhs The 'right hand side' to not copy.
     */
    HttpGet(const HttpGet& rhs) = delete;

    /**
     * Deleted assignment operator.
     *
     * @param rhs The 'right hand side' to not copy.
     * @return The object assigned to.
     */
    HttpGet& operator=(const HttpGet& rhs) = delete;

    HTTPResponse doGet(const std::string& url, const std::vector<std::string>& headers) override;

    HTTPResponse doGet(const std::string& url, const std::vector<std::string>& headers, std::chrono::seconds timeout) override;

private:
    /**
     * Default HttpGet constructor.
     */
    HttpGet() = default;

    /// Mutex to serialize access to @c m_curl.
    std::mutex m_mutex;

    /// CURL handle with which to make requests
    CurlEasyHandleWrapper m_curl;
};

}  // namespace libcurlUtils
}  // namespace utils
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_LIBCURLUTILS_HTTPGET_H_
