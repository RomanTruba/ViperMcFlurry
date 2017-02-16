//
//  UIViewController+RamblerViperModuleTransitionHandlerProtocol.m
//  ViperMcFlurry
//
//  Copyright (c) 2015 Rambler DS. All rights reserved.
//

#import "ViewController+RamblerViperModuleTransitionHandlerProtocol.h"
#import <objc/runtime.h>
#import "RamblerViperOpenModulePromise.h"
#import "RamblerViperModuleFactory.h"
#import "RamblerViperModuleInput.h"

static IMP originalPrepareForSegueMethodImp;

@protocol TranditionalViperViewWithOutput <NSObject>
- (id)output;
@end

@implementation ViperMcFluryViewControllerClass (RamblerViperModuleTransitionHandlerProtocol)

#pragma mark - RamblerViperModuleTransitionHandlerProtocol

+ (void)initialize {
    [self swizzlePrepareForSegue];
}

- (id)moduleInput {
    id result = objc_getAssociatedObject(self, @selector(moduleInput));
    if (result == nil && [self respondsToSelector:@selector(output)]) {
        result = [(id<TranditionalViperViewWithOutput>)self output];
    }
    return result;
}

- (void)setModuleInput:(id<RamblerViperModuleInput>)moduleInput {
    objc_setAssociatedObject(self, @selector(moduleInput), moduleInput, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// Performs segue without any actions, useful for unwind segues
- (void)performSegue:(NSString *)segueIdentifier {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:segueIdentifier sender:nil];
    });
}

// Method opens module using segue
- (RamblerViperOpenModulePromise*)openModuleUsingSegue:(NSString*)segueIdentifier {
    RamblerViperOpenModulePromise *openModulePromise = [[RamblerViperOpenModulePromise alloc] init];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:segueIdentifier sender:openModulePromise];
    });
    return openModulePromise;
}

// Method opens module using module factory
- (RamblerViperOpenModulePromise*)openModuleUsingFactory:(id <RamblerViperModuleFactoryProtocol>)moduleFactory withTransitionBlock:(ModuleTransitionBlock)transitionBlock {
    RamblerViperOpenModulePromise *openModulePromise = [[RamblerViperOpenModulePromise alloc] init];
    id<RamblerViperModuleTransitionHandlerProtocol> destinationModuleTransitionHandler = [moduleFactory instantiateModuleTransitionHandler];
    id<RamblerViperModuleInput> moduleInput = nil;
    if ([destinationModuleTransitionHandler respondsToSelector:@selector(moduleInput)]) {
        moduleInput = [destinationModuleTransitionHandler moduleInput];
    }

    openModulePromise.moduleInput = moduleInput;
    if (transitionBlock != nil) {
        openModulePromise.postLinkActionBlock = ^{
            transitionBlock(self,destinationModuleTransitionHandler);
        };
    }
    return openModulePromise;
}
// Method removes/closes module
- (void)closeCurrentModule:(BOOL)animated {
#if TARGET_OS_IPHONE
    BOOL isInNavigationStack = [self.parentViewController isKindOfClass:[UINavigationController class]];
    BOOL hasManyControllersInStack = isInNavigationStack ? ((UINavigationController *)self.parentViewController).childViewControllers.count > 1 : NO;

    if (isInNavigationStack && hasManyControllersInStack) {
        UINavigationController *navigationController = (UINavigationController*)self.parentViewController;
        [navigationController popViewControllerAnimated:animated];
    }
    else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:animated completion:nil];
    }
    else if (self.view.superview != nil){
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
#elif TARGET_OS_MAC
    if (self.storyboard) {
        [self dismissController:nil];
    } else if (self.presentingViewController) {
        [self.presentingViewController dismissViewController:self];
    } else if (self.parentViewController) {
        [self removeFromParentViewController];
    }
#endif
}

#pragma mark - PrepareForSegue swizzling

+ (void)swizzlePrepareForSegue {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        IMP reamplerPrepareForSegueImp = (IMP)RamblerViperPrepareForSegueSender;

        Method prepareForSegueMethod = class_getInstanceMethod([self class], @selector(prepareForSegue:sender:));
        originalPrepareForSegueMethodImp = method_setImplementation(prepareForSegueMethod, reamplerPrepareForSegueImp);
    });
}

#if TARGET_OS_IPHONE || TARGET_OS_TV
#define AppSegueRef UIStoryboardSegue*
#define AppControllerRef UIViewController*
#elif TARGET_OS_MAC
#define AppSegueRef NSStoryboardSegue*
#define AppControllerRef id
#endif

static AppControllerRef sourceViewControllerFromSegue(AppSegueRef segue) {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    return segue.sourceViewController;
#elif TARGET_OS_MAC
    return segue.sourceController;
#endif
}

static AppControllerRef destinationViewControllerFromSegue(AppSegueRef segue) {
#if TARGET_OS_IPHONE || TARGET_OS_TV
    AppControllerRef destinationViewController = segue.destinationViewController;
    if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = destinationViewController;
        destinationViewController = navigationController.topViewController;
    }
    return destinationViewController;
#elif TARGET_OS_MAC
    return segue.destinationController;
#endif
}

void RamblerViperPrepareForSegueSender(id self, SEL selector, AppSegueRef segue, id sender) {

    ((void(*)(id,SEL,AppSegueRef,id))originalPrepareForSegueMethodImp)(self,selector,segue,sender);

    id<RamblerViperModuleInput> moduleInput = nil;

    id<RamblerViperModuleTransitionHandlerProtocol> targetModuleTransitionHandler = destinationViewControllerFromSegue(segue);
    if ([targetModuleTransitionHandler respondsToSelector:@selector(moduleInput)]) {
        moduleInput = [targetModuleTransitionHandler moduleInput];
    } else {
        return;
    }

    if ([sender isKindOfClass:[RamblerViperOpenModulePromise class]]) {
        RamblerViperOpenModulePromise *openModulePromise = sender;
        openModulePromise.moduleInput = moduleInput;
    }

    if ([moduleInput respondsToSelector:@selector(setModuleOutput:)]) {
        id sourceOutput = [sourceViewControllerFromSegue(segue) moduleInput];
        [moduleInput setModuleOutput:sourceOutput];
    }
}

#undef AppSegueClass
#undef AppController

@end
