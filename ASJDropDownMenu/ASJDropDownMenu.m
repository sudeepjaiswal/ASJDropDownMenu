//
//  ASJDropDownMenu.m
//  ASJDropDownMenu
//
//  Created by Sudeep Jaiswal on 13/09/14.
//  Copyright (c) 2014 Sudeep Jaiswal. All rights reserved.
//

#import "ASJDropDownMenu.h"

static NSString *const kCellIdentifier = @"dropDownCell";

@interface ASJDropDownMenu () <UITableViewDataSource, UITableViewDelegate> {
  UITableView *menuTableView;
}

@property (copy) ASJDropDownMenuCompletionBlock callback;

- (void)setUp;
- (void)setDefaults;
- (void)setUI;
- (void)addTable;
- (void)reloadTable;

@end

@implementation ASJDropDownMenu


#pragma mark - Init methods

- (instancetype)initWithTextField:(UITextField *)textField
{
  self = [super init];
  if (self) {
    _textField = textField;
    [self setUp];
  }
  return self;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    [self setUp];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
  self = [super initWithCoder:coder];
  if (self) {
    [self setUp];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self setUp];
  }
  return self;
}


#pragma mark - Set up

- (void)setUp {
  [self setDefaults];
  [self setUI];
  [self addTable];
}

- (void)setDefaults {
  _menuColor = [[UIColor clearColor] colorWithAlphaComponent:0.8];
  _itemColor = [UIColor whiteColor];
  _itemFont = [UIFont systemFontOfSize:14.0];
  _itemHeight = 40.0;
  _indicatorStyle = ASJDropDownMenuScrollIndicatorStyleDefault;
}

- (void)setUI {
  self.clipsToBounds = YES;
  self.layer.cornerRadius = 3.0;
  self.backgroundColor = _menuColor;
}

- (void)addTable {
  if (menuTableView) {
    return;
  }
  menuTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
  menuTableView.dataSource = self;
  menuTableView.delegate = self;
  menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  menuTableView.backgroundColor = [UIColor clearColor];
  menuTableView.delaysContentTouches = NO;
  menuTableView.indicatorStyle = (UIScrollViewIndicatorStyle)_indicatorStyle;
  [menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
  [self addSubview:menuTableView];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
  cell.textLabel.textColor = _itemColor;
  cell.textLabel.font = _itemFont;
  cell.backgroundColor = [UIColor clearColor];
  cell.textLabel.text = _menuItems[indexPath.row];
  return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (_callback) {
    _callback(self, _menuItems[indexPath.row], indexPath.row);
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return _itemHeight;
}


#pragma mark - Property setters

- (void)setMenuColor:(UIColor *)menuColor {
  _menuColor = menuColor;
  self.backgroundColor = _menuColor;
}

- (void)setItemColor:(UIColor *)itemColor {
  _itemColor = itemColor;
  [self reloadTable];
}

- (void)setItemFont:(UIFont *)itemFont {
  _itemFont = itemFont;
  [self reloadTable];
}

- (void)setItemHeight:(CGFloat)itemHeight {
  _itemHeight = itemHeight;
  [self reloadTable];
}

- (void)reloadTable {
  dispatch_async(dispatch_get_main_queue(), ^{
    [menuTableView reloadData];
  });
}

- (void)setIndicatorStyle:(ASJDropDownMenuScrollIndicatorStyle)indicatorStyle {
  _indicatorStyle = indicatorStyle;
  menuTableView.indicatorStyle = (UIScrollViewIndicatorStyle)_indicatorStyle;
}


#pragma mark - Show-hide

- (void)showMenuWithCompletion:(ASJDropDownMenuCompletionBlock)callback {
  
  _callback = callback;
  CGFloat x = _textField.frame.origin.x;
  CGFloat y = _textField.frame.origin.y + _textField.frame.size.height;
  CGFloat width = _textField.frame.size.width;
  CGFloat height = _itemHeight * _menuItems.count;
  if (_menuItems.count > 5) {
    height = _itemHeight * 5;
  }
  self.frame = CGRectMake(x, y, width, height);
  [_textField.superview addSubview:self];
}

- (void)hideMenu {
  [self removeFromSuperview];
  [menuTableView deselectRowAtIndexPath:menuTableView.indexPathForSelectedRow animated:NO];
}

@end