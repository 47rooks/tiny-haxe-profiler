#include <windows.h>
#include <profileapi.h>
#include <stdio.h>
#include <limits.h>
#include "timing.h"

#define HL_NAME(n) tpLib_##n
#include <hl.h>

signed long long Timing::get_hirestime()
{
	LARGE_INTEGER CurrentTime;
	LARGE_INTEGER Frequency;

	QueryPerformanceFrequency(&Frequency);
	QueryPerformanceCounter(&CurrentTime);

#ifdef LLONG_MAX
	CurrentTime.QuadPart *= 1000;
	CurrentTime.QuadPart /= (Frequency.QuadPart / 1000);
	return CurrentTime.QuadPart;
#else
	return ((static_cast<long long>(CurrentTime.HighPart) << 32) | CurrentTime.LowPart) * 1000000 / ((static_cast<long long>(Frequency.HighPart) << 32) | Frequency.LowPart);
#endif
}

HL_PRIM signed long long HL_NAME(hl_get_hirestime)()
{
	return Timing::get_hirestime();
}
DEFINE_PRIM(_I64, hl_get_hirestime, _NO_ARG);

long long Timing::get_performance_frequency()
{
	LARGE_INTEGER Frequency;

	QueryPerformanceFrequency(&Frequency);

#ifdef LLONG_MAX
	return Frequency.QuadPart;
#else
	return ((static_cast<long long>(Frequency.HighPart) << 32) | Frequency.LowPart);
#endif
}
