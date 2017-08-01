//
//  YDThirdPartLoader.m
//  YDOpenHardwareSimple
//
//  Created by 张旻可 on 16/6/29.
//  Copyright © 2016年 YD. All rights reserved.
//

#import "YDThirdPartLoader.h"

#import "MSJsonKit.h"
#import "YDThirdPardModel.h"
#import "MSVCRouter.h"
#import "YDThirdNavigationController.h"

#import "objc/runtime.h"

static NSArray<YDThirdPardModel *> *sThirdPartData;
static YDThirdPartLoader *singleton;

@implementation YDThirdPartLoader

+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[self alloc] init];
        }
    });
    return singleton;
}

- (void)load {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ThirdParts" ofType:@"plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:plistPath];
    sThirdPartData = [MSJsonKit jsonObjToObj:data asClass:[NSArray class] WithKeyClass:@{@"msroot": [YDThirdPardModel class]}];
    if (sThirdPartData) {
        for (YDThirdPardModel *model in sThirdPartData) {
            if (model.status) {
                if (model.yInitClassName) {
                    Class kClass = NSClassFromString(model.yInitClassName);
                    if (kClass && model.yInitClassSelector) {
                        [kClass load];
                        SEL kSel = NSSelectorFromString(model.yInitClassSelector);
                        if (kSel) {
                            //方法签名类
                            NSMethodSignature *sig=[kClass methodSignatureForSelector:kSel];
                            if (sig) {
                                //根据方法签名创建一个NSInvocation
                                NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
                                //设置调用者
                                [invocation setTarget:kClass];
                                //设置被调用的消息
                                [invocation setSelector:kSel];
                                //如果此消息有参数需要传入，那么就需要按照如下方法进行参数设置，需要注意的是，atIndex的下标必须从2开始。原因为：0 1 两个参数已经被target 和selector占用
                                if (model.yInitClassSelectorVarList) {
                                    NSInteger i = 2;
                                    for (id param in model.yInitClassSelectorVarList) {
                                        id inParam = param;
                                        [invocation setArgument:&inParam atIndex:i];
                                        i++;
                                    }
                                }
                                //retain 所有参数，防止参数被释放dealloc
                                [invocation retainArguments];
                                //消息调用
                                [invocation invoke];
                            } else {
#ifdef DEBUG
                                NSLog(@"%@ 方法名错误", model.yInitClassName);
#endif
                            }
                            
                        }
                        
                    } else{
#ifdef DEBUG
                        NSLog(@"插件初始化类名错误");
#endif
                    }
                }
            }
        }
    }
}

- (NSArray<YDThirdPardModel *> *)datas {
    return sThirdPartData;
}

- (void)toThirdPartVC {
    YDThirdPardModel *model = sThirdPartData.lastObject;
    if (model && model.rootVCName) {
        Class kClass = NSClassFromString(model.rootVCName);
        if (kClass) {
            [kClass load];
            [[MSVCRouter sharedInstance] mapKey:[NSString stringWithFormat:@"thirdpart_%@", model.rootVCName] toBlock:^UIViewController *{
                UIViewController *vc = [[kClass alloc] init];
                YDThirdNavigationController *nav = [[YDThirdNavigationController alloc] initWithRootViewController:vc];
                return nav;
            }];
            [[MSVCRouter sharedInstance] openURLString:[NSString stringWithFormat:@"modal://thirdpart_%@", model.rootVCName]];
        }
    }
}

@end
