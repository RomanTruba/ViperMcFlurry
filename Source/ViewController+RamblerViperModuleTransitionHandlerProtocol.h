//
//  UIViewController+RamblerViperModuleTransitionHandlerProtocol.h
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#endif

#import "RamblerViperModuleTransitionHandlerProtocol.h"

#if TARGET_OS_IPHONE
#define ViperMcFluryViewControllerClass UIViewController
#elif TARGET_OS_MAC
#define ViperMcFluryViewControllerClass NSViewController
#endif

@interface ViperMcFluryViewControllerClass (RamblerViperModuleTransitionHandlerProtocol)<RamblerViperModuleTransitionHandlerProtocol>

@end
