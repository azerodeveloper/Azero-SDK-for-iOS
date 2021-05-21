/*
 * Copyright 2017-2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

#ifndef SOUNDAI_CLIENT_SDK_AZEROCOMMON_AZERO_INCLUDE_AZEROCOMMON_AZERO_AZEROATTRIBUTESHEADER_H_
#define SOUNDAI_CLIENT_SDK_AZEROCOMMON_AZERO_INCLUDE_AZEROCOMMON_AZERO_AZEROATTRIBUTESHEADER_H_

#include <string>

namespace alexaClientSDK {
namespace avsCommon {
namespace avs {

/**
 * The AVS message header, which contains the common fields required for an AVS message.
 */
class AzeroAttributesHeader {
public:
    /**
     * Constructor.
     *
     * @param azeroQoS The QoS of an AVS message.
     */
    AzeroAttributesHeader(
        int azeroQoS) :
            m_azeroQoS{azeroQoS} {
    }

    /**
     * Returns the QoS in an AVS message.
     *
     * @return The QoS , int.
     */
    int getazeroQoS() const;


    /**
     * Return a string representation of this @c AVSMessage's header.
     *
     * @return A string representation of this @c AVSMessage's header.
     */
    std::string getAsString() const;

private:
    /// A QoS volue.
    int m_azeroQoS;

};

}  // namespace avs
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // SOUNDAI_CLIENT_SDK_AZEROCOMMON_AZERO_INCLUDE_AZEROCOMMON_AZERO_AZEROATTRIBUTESHEADER_H_
