#ifdef __OBJC__
#import <Foundation/Foundation.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FIRCoreDiagnistics.h"

FOUNDATION_EXPORT double FirebaseCoreDiagnosticsVersionNumber;
FOUNDATION_EXPORT const unsigned char FirebaseCoreDiagnosticsVersionString[];

