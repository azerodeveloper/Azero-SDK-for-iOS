/*
 * ErrorCode.h
 *
 *  Created on: Mar 26, 2020
 *      Author: nero
 */

#ifndef PLATFORM_INCLUDE_AACE_OPENDENOISE_ERRORCODE_H_
#define PLATFORM_INCLUDE_AACE_OPENDENOISE_ERRORCODE_H_

#include <system_error>

namespace aace {
namespace openDenoise {

	/// Error code for futures
	enum class OpenDenoiseErrc : int {
		Success = 0,
		NotInited,
		Busy,
		Rejected,
		InvalidConfiguration,
		PreconditionViolated,
		FatalError,
		UnknownError,
		Max,
	};

	/// Points to a statically-allocated object derived from error_category.
	const std::error_category&
	opendenoise_category() noexcept;

	inline std::error_code
	make_error_code(OpenDenoiseErrc errc) noexcept
	{ return std::error_code(static_cast<int>(errc), opendenoise_category()); }

	inline std::error_condition
	make_error_condition(OpenDenoiseErrc errc) noexcept
	{ return std::error_condition(static_cast<int>(errc), opendenoise_category()); }

} /* namespace openDenoise */
} /* namespace aace */

namespace std {

template<>
struct is_error_code_enum<aace::openDenoise::OpenDenoiseErrc> : public true_type { };

}

#endif /* PLATFORM_INCLUDE_AACE_OPENDENOISE_ERRORCODE_H_ */
