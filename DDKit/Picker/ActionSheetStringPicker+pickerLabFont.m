//
//  ActionSheetStringPicker+pickerLabFont.m
//  ActionPickerDemo
//
//  Created by USER on 2018/12/21.
//  Copyright © 2018 dd01.leo. All rights reserved.
//

#import "ActionSheetStringPicker+pickerLabFont.h"
#import <objc/runtime.h>

@implementation ActionSheetStringPicker (pickerLabFont)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method originMethod = class_getInstanceMethod(self, @selector(pickerView:viewForRow:forComponent:reusingView:));
        Method newMethod = class_getInstanceMethod(self, @selector(picker_pickerView:viewForRow:forComponent:reusingView:));
        method_exchangeImplementations(originMethod, newMethod);
    });
}

- (UIView *)picker_pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    [self picker_pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
    //kvc 获取对象的私有变量
    NSArray *data = [self valueForKey:@"_data"];

    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        pickerLabel = [[UILabel alloc] init];
    }
    id obj = (data)[(NSUInteger) row];
    
    NSAttributedString *attributeTitle = nil;
    // use the object if it is already a NSString,
    // otherwise, use the description, just like the toString() method in Java
    // else, use String with no text to ensure this delegate do not return a nil value.
    
    if ([obj isKindOfClass:[NSString class]])
        attributeTitle = [[NSAttributedString alloc] initWithString:obj attributes:self.pickerTextAttributes];
    
    if ([obj respondsToSelector:@selector(description)])
        attributeTitle = [[NSAttributedString alloc] initWithString:[obj performSelector:@selector(description)] attributes:self.pickerTextAttributes];
    
    if (attributeTitle == nil) {
        attributeTitle = [[NSAttributedString alloc] initWithString:@"" attributes:self.pickerTextAttributes];
    }
    pickerLabel.attributedText = attributeTitle;
    pickerLabel.font = [UIFont systemFontOfSize:21];

    return pickerLabel;
}
@end
