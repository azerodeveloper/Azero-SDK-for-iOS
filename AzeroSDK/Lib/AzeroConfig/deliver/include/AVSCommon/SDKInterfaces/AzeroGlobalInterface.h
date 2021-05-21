/*
 * Copyright 2016-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_AZEROGLOBALINTERFACE_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_AZEROGLOBALINTERFACE_H_

#include <memory>
#include <string>

extern bool m_enableESP;
extern bool m_configlocalVAD;
extern bool g_isNetworkSupportSendMessage;
extern std::string m_configendpoint;
extern std::string m_capabilitiesApiEndpoint;
extern std::string m_SeverSetApiEndpoint;
extern std::string m_CBLURLChangedMethod;
extern std::string m_accessTokenStorage;
extern std::string m_productIDStorage;
extern int m_streamTimeout;

extern std::string AZERO_SERVER_TYPE;

namespace alexaClientSDK {
namespace avsCommon {
namespace sdkInterfaces {


namespace AzeroGlobalVar {
    // std::string m_configendpoint;
    // std::string m_capabilitiesApiEndpoint;
    // static bool m_configlocalVAD;
}  // namespace AzeroGlobalVar


//class AzeroGlobalInterface {
//public:
//    AzeroGlobalInterface() = default;
    // AzeroGlobalInterface(
    //     std::string& entpoint,
    //     std::string& capendpoint);
    /**
     * Virtual destructor to assure proper cleanup of derived types.
     */
//    virtual ~AzeroGlobalInterface() = default;

//    static std::string m_configendpoint;
//    static std::string m_capabilitiesApiEndpoint;
    // static void SAI_config_endpoint( std::string& endpoint );
    // std::string get_configendpoint(void);
    //virtual std::string getAuthToken() = 0;

//};
//   std::string AzeroGlobalInterface::m_configendpoint = "";
//   std::string AzeroGlobalInterface::m_capabilitiesApiEndpoint = "";

}  // namespace AzeroGlobalInterface
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_AZEROGLOBALINTERFACE_H_
