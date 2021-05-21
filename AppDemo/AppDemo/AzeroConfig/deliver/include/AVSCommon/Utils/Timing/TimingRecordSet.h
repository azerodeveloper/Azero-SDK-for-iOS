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

#ifndef ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_TIMINGRECORDSET_H_
#define ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_TIMINGRECORDSET_H_

#include "TimingRecord.h"
#include "PlainTimingRecord.h"
#include <string>
#include <memory>
#include <unordered_map>
#include <mutex>
#include <iostream>
#include <fstream>

#include <AVSCommon/Utils/Logger/Logger.h>

namespace alexaClientSDK {
namespace avsCommon {
namespace utils {
namespace timing {

template< typename T, typename RecordType = TimingRecord >
class TimingRecordSet {
private:
	using LogEntry = alexaClientSDK::avsCommon::utils::logger::LogEntry;
	using RecordMap = std::unordered_map<std::string, std::shared_ptr<RecordType>>;
public:
	using ThisRecordType = RecordType;
	using ThisType = TimingRecordSet<T>;
public:
	static TimingRecordSet & instance() {
		static TimingRecordSet set;
		return set;
	}

	std::shared_ptr<RecordType> operator[]( const std::string key ) {
		std::shared_ptr<RecordType> ptr;
		{
			std::lock_guard<std::mutex> lock(m_mutex);
			ptr = m_recordMap[key];
		}
		if ( !ptr ) {
			ptr.reset( new RecordType() );
			m_recordMap[key] = ptr;
		}
		return ptr;
	}

	bool insert( const std::string key, std::shared_ptr<RecordType> record ) {
		if ( !record ) {
			return false;
		}
		std::lock_guard<std::mutex> lock(m_mutex);
		if ( m_recordMap.count( key ) != 0 ) {
			return false;
		}
		m_recordMap[key] = record;
		return true;
	}

	void dumpRecords() {
		static const std::string TAG = "TimingRecordSet";
		ACSDK_WARN(LogEntry(TAG, "dumpRecords").d("trait struct", typeid(T).name()));
		std::lock_guard<std::mutex> lock(m_mutex);
		for ( auto &kv : m_recordMap ) {
			ACSDK_WARN(LogEntry(TAG, "key").m(kv.first));
			kv.second->dump();
		}
	}

	void appendToCSVFile( const std::string path, bool clear = false, bool splitByRecord = true ) {
		std::fstream fs( path, std::fstream::app | std::fstream::ate | std::fstream::out );
		if ( !fs.good() ) {
			return;
		}

		std::lock_guard<std::mutex> lock(m_mutex);
		for ( auto &kv : m_recordMap ) {
			fs << "\"" << kv.first << "\", ";
			fs << *(kv.second);
			if ( splitByRecord ) {
				fs << "\r\n";
			}
		}
		if ( !splitByRecord ) {
			fs << "\r\n";
		}
		fs.flush();
		if ( clear ) {
			m_recordMap.clear();
		}
	}

private:
	TimingRecordSet() = default;

private:
	mutable std::mutex m_mutex;
	RecordMap m_recordMap;
};

struct DefaultTimingRecordSetTraitType {};
using DefaultTimingRecordSet = TimingRecordSet<DefaultTimingRecordSetTraitType>;

using DefaultPlainTimingRecordSet = TimingRecordSet<DefaultTimingRecordSetTraitType, timing::PlainTimingRecord>;

}  // namespace timing
}  // namespace utils
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif  // ALEXA_CLIENT_SDK_AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_TIMINGRECORDSET_H_
