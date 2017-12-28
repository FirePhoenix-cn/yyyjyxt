//
//  CYButton.m
//  ChuYouYun
//
//  Created by 钱程远 on 2017/7/14.
//  Copyright © 2017年 ZhiYiForMac. All rights reserved.
//

#import "CYButton.h"
#import <objc/runtime.h>

@implementation CYButton

-(void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    [super sendAction:action to:target forEvent:event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
    });
    self.userInteractionEnabled = NO;
}

@end
