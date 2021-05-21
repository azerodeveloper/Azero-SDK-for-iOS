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

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_PLAINTIMINGRECORD_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_PLAINTIMINGRECORD_H_

#include <chrono>
#include <mutex>
#include <thread>
#include <ostream>
#include <vector>

namespace alexaClientSDK {
namespace avsCommon {
namespace utils {
namespace timing {

class PlainTimingRecord {
	struct Item {
		Item() = default;
		Item( const std::string name, const std::chrono::steady_clock::time_point tp )
		: name ( name )
		, tp ( tp ) { }
		Item( Item && ) = default;
		Item & operator=( Item && ) = default;
		std::string name;
		std::chrono::steady_clock::time_point tp;
	};
public:
	PlainTimingRecord();

	void append( const std::string name, const std::chrono::steady_clock::time_point tp = std::chrono::steady_clock::now() );

    void dump();

    friend std::ostream & operator<<(std::ostream &stream, const PlainTimingRecord& rd);

private:
    mutable std::mutex m_mutex;
    std::vector<Item> m_items;
};

std::ostream & operator<<(std::ostream &stream, const PlainTimingRecord& rd);

}  // namespace timing
}  // namespace utils
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_PLAINTIMINGRECORD_H_
