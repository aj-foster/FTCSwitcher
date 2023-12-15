/* -LICENSE-START-
** Copyright (c) 2023 Blackmagic Design
**
** Permission is hereby granted, free of charge, to any person or organization
** obtaining a copy of the software and accompanying documentation covered by
** this license (the "Software") to use, reproduce, display, distribute,
** execute, and transmit the Software, and to prepare derivative works of the
** Software, and to permit third-parties to whom the Software is furnished to
** do so, all subject to the following:
** 
** The copyright notices in the Software and this entire statement, including
** the above license grant, this restriction and the following disclaimer,
** must be included in all copies of the Software, in whole or in part, and
** all derivative works of the Software, unless such copies or derivative
** works are solely in the form of machine-executable object code generated by
** a source language processor.
** 
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
** FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
** SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
** FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
** ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
** DEALINGS IN THE SOFTWARE.
** -LICENSE-END-
*/
/* BMDSwitcherAPIDispatch.cpp */

#include "BMDSwitcherAPI.h"
#include <pthread.h>

#define kBMDSwitcherAPI_BundlePath "/Library/Application Support/Blackmagic Design/Switchers/BMDSwitcherAPI.bundle"

typedef IBMDSwitcherDiscovery* (*CreateDiscoveryFunc)(void);

static pthread_once_t						gBMDSwitcherOnceControl		= PTHREAD_ONCE_INIT;
static CFBundleRef							gBundleRef					= NULL;
static CreateDiscoveryFunc					gCreateDiscoveryFunc		= NULL;

static void	InitBMDSwitcherAPI (void)
{
	CFURLRef		bundleURL;
	
	bundleURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, CFSTR(kBMDSwitcherAPI_BundlePath), kCFURLPOSIXPathStyle, true);
	if (bundleURL != NULL)
	{
		gBundleRef = CFBundleCreate(kCFAllocatorDefault, bundleURL);
		if (gBundleRef != NULL)
		{
			gCreateDiscoveryFunc = (CreateDiscoveryFunc)CFBundleGetFunctionPointerForName(gBundleRef, CFSTR("GetBMDSwitcherDiscoveryInstance_0009"));
		}
		CFRelease(bundleURL);
	}
}

IBMDSwitcherDiscovery*				CreateBMDSwitcherDiscoveryInstance (void)
{
	pthread_once(&gBMDSwitcherOnceControl, InitBMDSwitcherAPI);
	
	if (gCreateDiscoveryFunc == NULL)
		return NULL;

	return gCreateDiscoveryFunc();
}

void DoEverythingWithMaximumEffort (void) {
    IBMDSwitcherDiscovery* discovery = CreateBMDSwitcherDiscoveryInstance();
    IBMDSwitcher* switcher = NULL;
    BMDSwitcherConnectToFailure failureReason = 0;
    HRESULT res = discovery->ConnectTo(CFSTR(""), &switcher, &failureReason);
    
    printf("ConnectTo result: %d\n", res);
    
    switch(failureReason) {
        case _BMDSwitcherConnectToFailure::bmdSwitcherConnectToFailureNoResponse:
            printf("bmdSwitcherConnectToFailureNoResponse");
            break;
        case _BMDSwitcherConnectToFailure::bmdSwitcherConnectToFailureIncompatibleFirmware:
            printf("bmdSwitcherConnectToFailureIncompatibleFirmware");
            break;
        case _BMDSwitcherConnectToFailure::bmdSwitcherConnectToFailureCorruptData:
            printf("bmdSwitcherConnectToFailureCorruptData");
            break;
        case _BMDSwitcherConnectToFailure::bmdSwitcherConnectToFailureStateSync:
            printf("bmdSwitcherConnectToFailureStateSync");
            break;
        case _BMDSwitcherConnectToFailure::bmdSwitcherConnectToFailureStateSyncTimedOut:
            printf("bmdSwitcherConnectToFailureStateSyncTimedOut");
            break;
        default:
            printf("No idea.");
    }
    
    IBMDSwitcherMacroControl* controller;
    switcher->QueryInterface(IID_IBMDSwitcherMacroControl, (void **)&controller);
    
    controller->Run(0);
}
