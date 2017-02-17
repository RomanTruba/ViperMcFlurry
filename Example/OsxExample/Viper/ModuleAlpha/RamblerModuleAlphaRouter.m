//
//  RamblerModuleAlphaRouter.m
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#import "RamblerModuleAlphaRouter.h"
#import "RamblerModuleBetaInput.h"
#import "RamblerModuleGammaInput.h"

static NSString* const RamblerAlphaToBetaSegue = @"RamblerAlphaToBetaSegue";

@interface RamblerModuleAlphaRouter()

@end

@implementation RamblerModuleAlphaRouter

#pragma mark - RamblerModuleAlphaRouterInput

- (void)openBetaModuleWithExampleString:(NSString*)exampleString {
    
    [[self.transitionHandler openModuleUsingSegue:RamblerAlphaToBetaSegue]
     thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerModuleBetaInput> moduleInput) {
         [moduleInput configureWithExampleString:exampleString];
         return nil;
     }];
}

- (void)instantiateBetaModuleWithExampleString:(NSString*)exampleString {
    [[self.transitionHandler openModuleUsingFactory:self.betaModuleFactory
                                withTransitionBlock:^(id <RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler,
                                        id <RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {

                                    NSViewController *sourceViewController = (id) sourceModuleTransitionHandler;
                                    NSViewController *destinationViewController = (id) destinationModuleTransitionHandler;

                                    [sourceViewController presentViewControllerAsModalWindow:destinationViewController];

                                }] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerModuleBetaInput> moduleInput) {
                                   [moduleInput configureWithExampleString:exampleString];
                                   return nil;
                               }];
}

- (void)instantiateGammaModuleWithExampleString:(NSString*)exampleString {
    [[self.transitionHandler openModuleUsingFactory:self.gammaModuleFactory
                                withTransitionBlock:^(id <RamblerViperModuleTransitionHandlerProtocol> sourceModuleTransitionHandler,
                                                      id <RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler) {
                                    
                                    NSViewController *sourceViewController = (id) sourceModuleTransitionHandler;
                                    NSViewController *destinationViewController = (id) destinationModuleTransitionHandler;
                                    
                                    [sourceViewController presentViewControllerAsModalWindow:destinationViewController];
                                    
                                }] thenChainUsingBlock:^id<RamblerViperModuleOutput>(id<RamblerModuleGammaInput> moduleInput) {
                                    [moduleInput configureWithExampleString:exampleString];
                                    return nil;
                                }];
}

@end
