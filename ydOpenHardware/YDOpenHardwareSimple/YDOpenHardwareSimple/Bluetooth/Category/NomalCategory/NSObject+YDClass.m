//
//  NSObject+YDClass.m
//  ivar
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import "NSObject+YDClass.h"
#import <objc/runtime.h>
#import "YDClass.h"


#define force_inline __inline__ __attribute__((always_inline))

@implementation NSObject (YDClass)

NSArray* MethodsOfClassFilter(Class cls, NSString *prefix){
    NSMutableArray *methodObjs = @[].mutableCopy;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        for (unsigned int i =0; i <methodCount; i++) {
            SEL sel = method_getName(methods[i]);
            const char *name = sel_getName(sel);
            NSString *nameString ;
            if (name) {
                nameString = [NSString stringWithUTF8String:name];
            }
            if ([nameString hasPrefix:prefix]) {
                YDClass *class = [YDClass new];
                class.name = nameString;
                class.sel = sel;
                [methodObjs addObject:class];
            }
        }
    }
    return methodObjs;
}

NSArray* MethodsOfClass(Class cls){
    NSMutableArray *methodObjs = @[].mutableCopy;
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList(cls, &methodCount);
    if (methods) {
        for (unsigned int i =0; i <methodCount; i++) {
            SEL sel = method_getName(methods[i]);
            const char *name = sel_getName(sel);
            NSString *nameString ;
            if (name) {
                nameString = [NSString stringWithUTF8String:name];
            }
            YDClass *class = [YDClass new];
            class.name = nameString;
            class.sel = sel;
            [methodObjs addObject:class];
        }
    }
    return methodObjs;
}


@end
