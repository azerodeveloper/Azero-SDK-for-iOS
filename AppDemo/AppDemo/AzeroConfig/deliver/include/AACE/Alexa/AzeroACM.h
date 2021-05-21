/*
 * Copyright 2017-2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

#ifndef AACE_ALEXA_AZERO_ACM_H
#define AACE_ALEXA_AZERO_ACM_H

#include "AACE/Core/PlatformInterface.h"
#include "AACE/Alexa/AlexaEngineInterfaces.h"


/** @file */

namespace aace {
namespace alexa {

class AzeroACM : public aace::core::PlatformInterface {
protected:
    AzeroACM() = default;

public:
    virtual ~AzeroACM();

    /**
     * @param [in] payload need more parsed metadata in structured JSON format
     */
    virtual void handleDirective( const std::string& name, const std::string& payload );

    void sendEvent(const std::string& jsonContent);

    void setEngineInterface( std::shared_ptr<aace::alexa::AzeroACMEngineInterface> AzeroACMEngineInterface );

private:
    std::shared_ptr<aace::alexa::AzeroACMEngineInterface> m_AzeroACMEngineInterface;
};

} // aace::alexa
} // aace

#endif // AACE_ALEXA_AZERO_ACM_H
