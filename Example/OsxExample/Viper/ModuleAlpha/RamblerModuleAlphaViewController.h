//
//  RamblerModuleAlphaViewController.h
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "RamblerModuleAlphaViewInput.h"
#import <ViperMcFlurry/ViperMcFlurry.h>

@protocol RamblerModuleAlphaViewOutput;

@interface RamblerModuleAlphaViewController : NSViewController <RamblerModuleAlphaViewInput>

@property (nonatomic, strong) id<RamblerModuleAlphaViewOutput> output;

@property (nonatomic, weak) IBOutlet NSTextField *textField;
- (IBAction)didClickSendDataButton:(id)sender;
- (IBAction)didClickInstantiateBetaButton:(id)sender;
- (IBAction)didClickInstantiateGammaButton:(id)sender;

@property (nonatomic, weak) IBOutlet NSView *moduleContainerView;

@end

