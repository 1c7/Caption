//
//  NSSet+Additions.m
//  Quick Caption
//
//  Created by Blue on 4/27/19.
//  Copyright © 2019 Bright. All rights reserved.
//

#import "NSSet+Additions.h"
@import ObjectiveC;

@implementation NSSet (Additions)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(intersectsSet:);
        SEL swizzledSelector = @selector(swz_intersectsSet:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        // ...
        // Method originalMethod = class_getClassMethod(class, originalSelector);
        // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)swz_intersectsSet:(id)arg1 {
    NSString *argType = NSStringFromClass([arg1 class]);
    NSSet *set;
    BOOL shouldPrint = YES;
    if ([arg1 isKindOfClass:[NSMutableSet class]]) {
        set = ((NSOrderedSet *)arg1).set;
        shouldPrint = NO;
    } else if ([arg1 isKindOfClass:[NSSet class]]) {
        set = arg1;
    } else {
        set = [[NSSet alloc] initWithObjects:arg1, nil];
    }
    if (shouldPrint) {
        NSLog(@"swz_intersectsSet: %@, arg: %@ of type %@, converted: %@", self, arg1, argType, set);
    }
    @try {
        [self swz_intersectsSet:set];
    } @catch (NSException *e) {
        NSLog(@"Caught exception: %@", e);
    }
}


@end