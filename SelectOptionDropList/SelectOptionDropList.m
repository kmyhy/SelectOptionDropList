//
//  SelectOptionDropList.m
//  SelectOptionDropList
//
//  Created by qq on 2017/8/1.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "SelectOptionDropList.h"
#import "Masonry.h"

@interface SelectOptionDropList(){
    NSMutableArray<UIButton*>* buttons;
    UILabel* lbTitle;
    UILabel* lbDetail;
    UIButton* btnDisclosure;
    UIView* listView;
    CGFloat savedHeight;
    NSLayoutConstraint* heightConstraint;
    
}

@end

@implementation SelectOptionDropList

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setup];
    }
    return self;
}
-(void)setup{
    for (NSLayoutConstraint *constraint in self.constraints) {
        if (constraint.firstItem == self && constraint.firstAttribute == NSLayoutAttributeHeight) {
            savedHeight = constraint.constant;
            heightConstraint = constraint;
        }
    }
    if(!heightConstraint){
        savedHeight = self.frame.size.height;
    }
    
    self.backgroundColor = [UIColor clearColor];
    _options = @[];
    _multiSelectEnable = YES;
    _optionFontSize= 11;
    _selectedIndex = [NSMutableArray new];
    _selectedText = [NSMutableArray new];
    _optionInsets= UIEdgeInsetsMake(8, 13, 8, 13);
    _listInsets = UIEdgeInsetsMake(12,15, 12, 15);

    lbTitle = [[UILabel alloc]init];
    
    lbTitle.font = [UIFont systemFontOfSize:15];
    lbTitle.textColor = [UIColor colorWithRed:0x2a/255.0 green:0x2a/255.0 blue:0x2a/255.0 alpha:0.9];
    lbTitle.text=@"发布范围";
    [self addSubview: lbTitle];
    [lbTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@120);
        make.height.equalTo(@15);
        make.top.equalTo(@15);
        make.left.equalTo(@15);
    }];
    
    btnDisclosure = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDisclosure setImage:[UIImage imageNamed:@"disclosure_indicator"] forState:UIControlStateNormal];
    [self addSubview: btnDisclosure];
    [btnDisclosure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@15);
        make.height.equalTo(@15);
        make.right.equalTo(@(-15));
        make.top.equalTo(@15);
    }];
    [btnDisclosure addTarget:self action:@selector(expandOrCollapse:) forControlEvents:UIControlEventTouchUpInside];
    
    lbDetail = [UILabel new];
    lbDetail.font = [UIFont systemFontOfSize:11];
    lbDetail.textColor = [UIColor colorWithRed:0x90/255.0 green:0x90/255.0 blue:0x90/255.0 alpha:0.9];
    lbDetail.text = @"未选择";
    lbDetail.textAlignment = NSTextAlignmentRight;
    [self addSubview:lbDetail];
    [lbDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.right.equalTo(btnDisclosure.mas_left).offset(-8);
        make.height.equalTo(@15);
        make.left.equalTo(lbTitle).offset(5);
    }];
    
    listView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbDetail.frame)+15, self.frame.size.width, 10)];
    [self addSubview:listView];
    listView.hidden = YES;
    
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = [UIColor blueColor].CGColor;
}
// MARK: - Setters
-(void)setTitle:(NSString *)title{
    lbTitle.text= title;
}
-(void)setOptions:(NSArray<NSString*> *)options{
    _options = options;
    buttons = [NSMutableArray new];
    
    // 上一个 button 的 frame
    CGRect lastFrame = CGRectMake(0, _listInsets.top, 0, 0);
    
    for(int i = 0;i< options.count;i++){
        CGSize size=[self buttonSizeAtIndex:i];
        
        CGFloat left = CGRectGetMaxX(lastFrame)+_listInsets.left;
        
        CGFloat top = CGRectGetMinY(lastFrame);
        
        if( left+size.width > self.frame.size.width){// 宽度超过，换行
            
            left = _listInsets.left;
            top += _listInsets.top+ CGRectGetHeight(lastFrame);
        }
        
        CGRect frame = CGRectMake(left, top, size.width, size.height);
        
        UIButton* btn = [self buttonWithTitle:_options[i] frame:frame index:i];
        if(btn){
            [listView addSubview:btn];
            [buttons addObject:btn];
        }
        
        lastFrame = frame;
    }
    
    listView.frame= CGRectMake(CGRectGetMinX(listView.frame), savedHeight, CGRectGetWidth(self.frame), CGRectGetMaxY(lastFrame)+_listInsets.bottom);
    
    UIView* line  = [self lineWithFrame:CGRectZero];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(_listInsets.left));
        make.top.equalTo(listView);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    
    line = [self lineWithFrame:CGRectZero];
    [listView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(_listInsets.left));
        make.bottom.equalTo(listView);
        make.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
}
// MARK: - Actions
-(void)expandOrCollapse:(UIButton*)sender{
    _isExpanded = !_isExpanded;
    
    [self setNeedsLayout];
}
-(void)buttonClick:(UIButton*)sender{
    
    if(sender.selected){// 当状态为已选时，清除选择
        sender.selected = NO;
        sender.layer.borderColor = [UIColor colorWithRed:0xd0/255.0 green:0xd0/255.0 blue:0xd0/255.0 alpha:0.9].CGColor;
        
        NSUInteger idx = [_selectedIndex indexOfObject:@(sender.tag)];
        if(idx!=NSNotFound){
            [_selectedIndex removeObjectAtIndex:idx];
            [_selectedText removeObjectAtIndex:idx];
        }
    }else{// 否则，标记为选中状态
        if(!_multiSelectEnable){// 如果不允许多选，需要先将所有选项反选
            for(UIButton* btn in buttons){
                btn.selected= NO;
                btn.layer.borderColor = [UIColor colorWithRed:0xd0/255.0 green:0xd0/255.0 blue:0xd0/255.0 alpha:0.9].CGColor;
            }
            [_selectedIndex removeAllObjects];
            [_selectedText removeAllObjects];
        }
        sender.selected = YES;
        sender.layer.borderColor = [UIColor colorWithRed:0xf5/255.0 green:0x23/255.0 blue:0x1e/255.0 alpha:0.9].CGColor;
        
        if(![_selectedIndex containsObject:@(sender.tag)] ){
            [_selectedIndex addObject:@(sender.tag)];
            [_selectedText addObject:_options[sender.tag]];
        }
    }

    lbDetail.text = _selectedIndex.count>0?@"":@"未选择";
}
// MARK: - Override
- (void)layoutSubviews {
    [super layoutSubviews];
    if(_isExpanded){
        listView.hidden = NO;
        btnDisclosure.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI_2);
        
        if(heightConstraint){
            heightConstraint.constant = CGRectGetMaxY(listView.frame);
        }else{
            self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), CGRectGetMaxY(listView.frame));
        }
    }else{
        listView.hidden = YES;
        btnDisclosure.transform= CGAffineTransformIdentity;
        if(heightConstraint){
            heightConstraint.constant= savedHeight;
        }else{
            self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), savedHeight);
        }
    }
}
// 覆盖这个方法，否则 UIView 无法响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *hitView = [super hitTest:point withEvent:event];
    // 如果只想让某个 subview 响应事件，可以用下句：
//    if (hitView != btnDisclosure) return nil;
    return hitView;
}
// MARK: - Private
-(CGSize)textSizeAtIndex:(int)idx{
    if(idx>=0 && idx<_options.count){
        NSString * text=_options[idx];
        NSMutableParagraphStyle* textStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
        textStyle.alignment = NSTextAlignmentCenter;
        
        NSDictionary* textFontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize: _optionFontSize], NSParagraphStyleAttributeName: textStyle};
        
        CGSize textSize = [text boundingRectWithSize: CGSizeMake(self.frame.size.width, _optionFontSize)  options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingTruncatesLastVisibleLine attributes: textFontAttributes context: nil].size;
        return textSize;
    }
    return CGSizeZero;
}
-(CGSize)buttonSizeAtIndex:(int)idx{
    CGSize textSize = [self textSizeAtIndex:idx];
    if(!CGSizeEqualToSize(textSize, CGSizeZero)){
        
        return CGSizeMake(_optionInsets.left+_optionInsets.right+textSize.width, textSize.height+_optionInsets.top+_optionInsets.bottom);
    }
    return CGSizeZero;
}
-(UIButton*)buttonWithTitle:(NSString*)title frame:(CGRect)frame index:(int)index{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame= frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font= [UIFont systemFontOfSize:_optionFontSize];
    [button setTitleColor:[UIColor colorWithRed:0x51/255.0 green:0x51/255.0 blue:0x51/255.0 alpha:0.9] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:0xf5/255.0 green:0x23/255.0 blue:0x1e/255.0 alpha:0.9] forState:UIControlStateSelected];
    button.layer.cornerRadius = CGRectGetHeight(frame)/2;
    button.layer.borderColor= [UIColor colorWithRed:0xd0/255.0 green:0xd0/255.0 blue:0xd0/255.0 alpha:0.9].CGColor;
    button.layer.borderWidth = 1;
    
    button.tag= index;
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}
-(UIView*)lineWithFrame:(CGRect)frame{
    UIView* line = [[UIView alloc]initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithRed:0xf2/255.0 green:0xf2/255.0 blue:0xf2/255.0 alpha:0.9];
    return line;
}

@end
