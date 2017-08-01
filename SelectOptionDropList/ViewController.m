//
//  ViewController.m
//  SelectOptionDropList
//
//  Created by qq on 2017/8/1.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "ViewController.h"
#import "SelectOptionDropList.h"
#import "dimensions.h"
#import "Masonry.h"

@interface ViewController (){
//    SelectOptionDropList* selectList;// 手动布局代码
    __weak IBOutlet SelectOptionDropList *selectList;// 自动布局代码
    __weak IBOutlet SelectOptionDropList *selectList2;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /* 手动布局代码
    selectList = [[SelectOptionDropList alloc]initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 44)];
    [self.view addSubview:selectList];
     */

    // 发布范围
    selectList.title = @"发布范围";
    selectList.options = @[@"国资教育小学",@"一年级一班",@"市少工委",@"团中央"];
    
    // 通知类型
    selectList2.title = @"通知类型";
    selectList2.multiSelectEnable = NO;// 禁止多选，默认 YES
    selectList2.options = @[@"会议通知",@"放假通知",@"缴费通知",@"家长会通知",@"停电通知",@"其它"];

    /* 手动布局代码
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectList.frame)+1, SCREEN_WIDTH, 1)];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(selectList.mas_bottom).offset(10);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@1);
    }];
     */
    

}

/// 自动布局代码
- (IBAction)buttonAction:(id)sender {
    NSLog(@"%@",selectList.selectedText);
    NSLog(@"%@",selectList2.selectedText);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
