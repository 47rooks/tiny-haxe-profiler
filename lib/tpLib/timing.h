#pragma once
/// <summary>
/// Timing provides support for various timing functions.
/// </summary>
class __declspec(dllexport) Timing {
public:
	/// <summary>
	/// Get a microsecond resolution time stamp. This value is not related to calendar time. Only interval calculations
	/// make any sense.
	/// </summary>
	/// <returns>a microsecond resolution integer timestamp</returns>
	static signed long long get_hirestime();

	/// <summary>
	/// Get the performance frequency. This is the number of ticks per second for the hardware tick counter.
	/// This is currently only known to be a Windows value.
	/// </summary>
	/// <returns>the integer number of ticks per second</returns>
	static long long get_performance_frequency();
};
