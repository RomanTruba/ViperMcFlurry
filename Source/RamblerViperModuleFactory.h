//
//  RamblerViperModuleFactory.h
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define ViperMcFlurryModuleStoryboard UIStoryboard
#elif TARGET_OS_MAC
#import <AppKit/AppKit.h>
#define ViperMcFlurryModuleStoryboard NSStoryboard
#endif

#import "RamblerViperModuleFactoryProtocol.h"

@protocol RamblerViperModuleFactoryLoader <NSObject>

- (id<RamblerViperModuleTransitionHandlerProtocol>)instantiateViewControllerWithIdentifier:(NSString*)identifier;

@end

/**
 Universal Viper module factory.
 */
@interface RamblerViperModuleFactory : NSObject<RamblerViperModuleFactoryProtocol>

/**
 @param loader The object which loads the view controller, loader should respond to instantiateViewControllerWithIdentifier:. E.g. UIStoryboard or TyphoonNibLoader.
 @param identifier The view controller's identifier. E.g. storyboard ID for UIStoryboard or nib name for TyphoonNibLoader.
 */
- (instancetype)initWithViewControllerLoader:(id<RamblerViperModuleFactoryLoader>)loader andViewControllerIdentifier:(NSString*)identifier;
- (instancetype)initWithViewHandler:(id<RamblerViperModuleTransitionHandlerProtocol>(^)(void))viewHandler;

- (instancetype)initWithStoryboard:(ViperMcFlurryModuleStoryboard*)storyboard andRestorationId:(NSString*)restorationId __attribute__((deprecated("use initWithViewControllerKeeper:andViewControllerIdentifier: instead.")));

@property (nonatomic,strong,readonly) ViperMcFlurryModuleStoryboard *storyboard __attribute__((deprecated("use viewControllerLoader instead.")));

@property (nonatomic,strong,readonly) NSString* restorationId __attribute__((deprecated("use viewControllerIdentifier instead.")));

@property (nonatomic,strong,readonly) id<RamblerViperModuleFactoryLoader> viewControllerLoader;
@property (nonatomic,strong,readonly) NSString* viewControllerIdentifier;

@end
