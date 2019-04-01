//
//  SWActionSheet+addBackgroudTapGesture.m
//  ActionPickerDemo
//
//  Created by USER on 2018/12/21.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

#import "SWActionSheet+addBackgroudTapGesture.h"
#import <objc/runtime.h>

@implementation SWActionSheet (addBackgroudTapGesture)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(showInContainerView));
        Method newMethod = class_getInstanceMethod(self, @selector(picker_showInContainerView));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (void)picker_showInContainerView {
    [self picker_showInContainerView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
        [self addGestureRecognizer:tap];
}

- (void)tapGestureAction {
    [self dismissWithClickedButtonIndex:0 animated:true];
}


@end
