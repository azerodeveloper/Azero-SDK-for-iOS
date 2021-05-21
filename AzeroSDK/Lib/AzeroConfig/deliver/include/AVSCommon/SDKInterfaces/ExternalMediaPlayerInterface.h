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

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_EXTERNALMEDIAPLAYERINTERFACE_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_EXTERNALMEDIAPLAYERINTERFACE_H_

#ifdef EXTERNALMEDIAPLAYER_1_1
#include <AVSCommon/AVS/PlayerActivity.h>
#endif
#include <AVSCommon/SDKInterfaces/ContextManagerInterface.h>
#include <AVSCommon/SDKInterfaces/FocusManagerInterface.h>
#include <AVSCommon/SDKInterfaces/MessageSenderInterface.h>
#include <AVSCommon/SDKInterfaces/PlaybackHandlerInterface.h>
#include <AVSCommon/SDKInterfaces/PlaybackRouterInterface.h>
#include <AVSCommon/SDKInterfaces/SpeakerInterface.h>
#include <AVSCommon/SDKInterfaces/SpeakerManagerInterface.h>

namespace alexaClientSDK {
namespace avsCommon {
namespace sdkInterfaces {

/**
 * This class provides an interface to the @c ExternalMediaPlayer.
 * Currently it provides an interface for adapters to set the current activity
 * and set the player in focus when they acquire focus.
 */
class ExternalMediaPlayerInterface {
public:
    /**
     * Destructor
     */
    virtual ~ExternalMediaPlayerInterface() = default;

#ifdef EXTERNALMEDIAPLAYER_1_1
    /**
     * Method to set the current activity for the player in focus.
     *
     * @param currentActivity The current activity of the player.
     */
    virtual void setCurrentActivity(const avsCommon::avs::PlayerActivity currentActivity) = 0;

    /**
     * Method to set the player in focus after an adapter has acquired the channel.
     *
     * @param playerInFocus The business name of the adapter that has currently acquired focus.
     * @param focusAcquire If @c true, acquire the channel and manage the focus state.
     * If @c false release the channel when the player is the player in focus.
     */
    virtual void setPlayerInFocus(const std::string& playerInFocus, bool focusAcquire) = 0;
#endif

    /**
     * Method to set the player in focus after an adapter has acquired the channel.
     *
     * @param playerInFocus The business name of the adapter that has currently acquired focus.
     */
    virtual void setPlayerInFocus(const std::string& playerInFocus) = 0;
};

}  // namespace sdkInterfaces
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_EXTERNALMEDIAPLAYERINTERFACE_H_
