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

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_EXTERNALMEDIAADAPTERHANDLERINTERFACE_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_EXTERNALMEDIAADAPTERHANDLERINTERFACE_H_

#include <chrono>
#include <string>

#include "AVSCommon/SDKInterfaces/ExternalMediaAdapterInterface.h"

namespace alexaClientSDK {
namespace avsCommon {
namespace sdkInterfaces {

/**
 * The ExternalMediaAdapterHandlerInterface class provides generic ExternalMediaPlayer 1.1 Interface support
 * for extending functionality to custom handlers for managing multi player adapters as required by MACC.
 * Note: This interface may eventually be replaced with integrated support for multi player adapters.
 */
class ExternalMediaAdapterHandlerInterface {
public:
    /**
     * Destructor
     */
    virtual ~ExternalMediaAdapterHandlerInterface() = default;

    /**
     * Method to handle the ExternalMediaPlayer AuthorizeDiscoveredPlayers directive.
     *
     * @param payload The AuthorizeDiscoveredPlayers directive payload.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void authorizeDiscoveredPlayers(const std::string& payload) = 0;

    /**
     * Method to handle the ExternalMediaPlayer Login directive.
     *
     * @param payload The Login directive payload.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void login(const std::string& payload) = 0;

    /**
     * Method to handle the ExternalMediaPlayer Logout directive.
     *
     * @param payload The Logout directive payload.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void logout(const std::string& payload) = 0;

    /**
     * Method to handle the ExternalMediaPlayer Play directive.
     *
     * @param payload The Play directive payload.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void play(const std::string& payload) = 0;

    /**
     * Method to handle the Alexa.PlaybackController Play/Pause/Next/Previous/StartOver/Rewind/FastForward directives.
     *
     * @param payload The Play/Pause/Next/Previous/StartOver/Rewind/FastForward directive payload.
     * @param requestType The external media player request type.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void playControl(const std::string& payload, alexaClientSDK::avsCommon::sdkInterfaces::externalMediaPlayer::RequestType requestType) = 0;

    /**
     * Method to handle the Alexa.PlaybackController Play/Pause/Next/Previous/StartOver/Rewind/FastForward directives for a designated player (i.e. the player in focus).
     *
     * @param payload The Play/Pause/Next/Previous/StartOver/Rewind/FastForward directive payload.
     * @param requestType The external media player request type.
     *
     * @note Handles PlaybackHandlerInterface onTogglePressed() and onButtonPressed() notifications for the player in focus.
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void playControlForPlayer(const std::string& playerId, alexaClientSDK::avsCommon::sdkInterfaces::externalMediaPlayer::RequestType requestType) = 0;

    /**
     * Method to handle the Alexa.SeekController SetSeekPosition directive.
     *
     * @param payload The SetSeekPosition directive payload.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void seek(const std::string& payload) = 0;

    /**
     * Method to handle the Alexa.SeekController AdjustSeekPosition directive.
     *
     * @param payload The AdjustSeekPosition directive payload.
     *
     * @note With multiple adapter handlers, playerId can belong to another adapter handler.
     */
    virtual void adjustSeek(const std::string& payload) = 0;

    /**
     * Method to get adapter state for each of the handled players.
     */
    virtual std::vector<avsCommon::sdkInterfaces::externalMediaPlayer::AdapterState> getAdapterStates() = 0;
};

}  // namespace sdkInterfaces
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_SDKINTERFACES_INCLUDE_AVSCOMMON_SDKINTERFACES_EXTERNALMEDIAADAPTERHANDLERINTERFACE_H_
