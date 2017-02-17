//
//  RamblerModuleBetaViewController.h
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "RamblerModuleBetaViewInput.h"
#import <ViperMcFlurry/ViperMcFlurry.h>

@protocol RamblerViperModuleConfiguratorProtocol;
@protocol RamblerModuleBetaViewOutput;

@interface RamblerModuleBetaViewController : NSViewController <RamblerModuleBetaViewInput,RamblerViperModuleTransitionHandlerProtocol>

@property (nonatomic, strong) id<RamblerModuleBetaViewOutput> output;
@property (nonatomic, weak)   id<RamblerViperModuleConfiguratorProtocol> moduleConfigurator;

@property (nonatomic, strong) IBOutlet NSTextField *exampleStringLabel;

@end

