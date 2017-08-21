//
//  NSObject+YDClass.h
//  ivar
//
//  Created by Aka on 2017/8/21.
//  Copyright © 2017年 Aka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (YDClass)

NSArray* MethodsOfClassFilter(Class cls, NSString *prefix);
NSArray * MethodsOfClass(Class cls);

@end
