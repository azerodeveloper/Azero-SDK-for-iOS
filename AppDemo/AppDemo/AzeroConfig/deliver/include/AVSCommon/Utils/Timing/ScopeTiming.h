/*
 * ScopeTiming.h
 *
 *  Created on: Apr 29, 2020
 *      Author: nero
 */

#ifndef AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_SCOPETIMING_H_
#define AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_SCOPETIMING_H_

#include <string>
#include "TimingRecord.h"
#include <memory>

namespace alexaClientSDK {
namespace avsCommon {
namespace utils {
namespace timing {

class ScopeTiming {
public:
	ScopeTiming( std::shared_ptr<TimingRecord> record );
	ScopeTiming( ScopeTiming &&inst );
	ScopeTiming( const ScopeTiming & ) = delete;

	~ScopeTiming();

	ScopeTiming & operator=( ScopeTiming &&inst );
	ScopeTiming & operator=( const ScopeTiming & ) = delete;

	void stop();

	void * operator new ( size_t ) = delete;

private:
	std::shared_ptr<TimingRecord> m_record;
};

}  // namespace timing
}  // namespace utils
}  // namespace avsCommon
}  // namespace alexaClientSDK

#endif /* AVSCOMMON_UTILS_INCLUDE_AVSCOMMON_UTILS_TIMING_SCOPETIMING_H_ */
