//
//  SelectOptionDropList.h
//  SelectOptionDropList
//
//  Created by qq on 2017/8/1.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectOptionDropList : UIView


@property(copy,nonatomic)NSArray<NSString*>* options;
@property(assign,nonatomic)BOOL isExpanded;
@property(copy,nonatomic)NSString* title;
@property(assign,nonatomic)CGFloat optionFontSize;
@property(assign,nonatomic)UIEdgeInsets optionInsets;
@property(assign,nonatomic)UIEdgeInsets listInsets;
@property(assign,nonatomic)BOOL multiSelectEnable; // 是否允许多选
@property(copy,nonatomic,readonly)NSMutableArray<NSNumber*>* selectedIndex;// 选中的选项的索引
@property(copy,nonatomic,readonly)NSMutableArray<NSString*>* selectedText;// 选中的选项的文字
@end
