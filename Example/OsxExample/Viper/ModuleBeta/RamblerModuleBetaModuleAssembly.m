//
//  RamblerModuleBetaModuleAssembly.m
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#import "RamblerModuleBetaModuleAssembly.h"

#import <ViperMcFlurry/ViperMcFlurry.h>

#import "RamblerModuleBetaViewController.h"
#import "RamblerModuleBetaInteractor.h"
#import "RamblerModuleBetaPresenter.h"
#import "RamblerModuleBetaRouter.h"


@interface  RamblerModuleBetaModuleAssembly()

@end

@implementation  RamblerModuleBetaModuleAssembly

- (id<RamblerViperModuleFactoryProtocol>)factoryBetaModule {
    return [TyphoonDefinition withClass:[RamblerViperModuleFactory class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(initWithViewControllerLoader:andViewControllerIdentifier:)
                                              parameters:^(TyphoonMethod *initializer) {
                                                  [initializer injectParameterWith:[self storyboardBetaModule]];
                                                  [initializer injectParameterWith:@"RamblerModuleBetaViewController"];
                                              }];
                          }];
}

- (NSStoryboard*)storyboardBetaModule {
    return [TyphoonDefinition withClass:[TyphoonStoryboard class]
                          configuration:^(TyphoonDefinition *definition) {
                              [definition useInitializer:@selector(storyboardWithName:factory:bundle:)
                                              parameters:^(TyphoonMethod *initializer) {
                                                  [initializer injectParameterWith:@"Main"];
                                                  [initializer injectParameterWith:self];
                                                  [initializer injectParameterWith:nil];
                                              }];
                          }];
}

- (RamblerModuleBetaViewController *)viewRamblerModuleBeta {

    return [TyphoonDefinition withClass:[RamblerModuleBetaViewController class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(output) 
                                                  with:[self presenterRamblerModuleBeta]];
             }];
}

- (RamblerModuleBetaInteractor *)interactorRamblerModuleBeta {

    return [TyphoonDefinition withClass:[RamblerModuleBetaInteractor class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(output) 
                                                  with:[self presenterRamblerModuleBeta]];
             }];
}

- (RamblerModuleBetaPresenter *)presenterRamblerModuleBeta {

    return [TyphoonDefinition withClass:[RamblerModuleBetaPresenter class]
                          configuration:^(TyphoonDefinition *definition) {
                            [definition injectProperty:@selector(view) 
                                                  with:[self viewRamblerModuleBeta]];                                            
                            [definition injectProperty:@selector(interactor) 
                                                  with:[self interactorRamblerModuleBeta]];
                            [definition injectProperty:@selector(router) 
                                                  with:[self routerRamblerModuleBeta]];
            }];
}

- (RamblerModuleBetaRouter *)routerRamblerModuleBeta {
    return [TyphoonDefinition withClass:[RamblerModuleBetaRouter class] configuration:^(TyphoonDefinition *definition) {
        [definition injectProperty:@selector(transitionHandler)
                              with:[self viewRamblerModuleBeta]];
    }];
}

@end
