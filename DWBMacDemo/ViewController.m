//
//  ViewController.m
//  DWBmacDemo
//
//  Created by 戴维保 on 2019/5/27.
//  Copyright © 2019 潮汐科技有限公司. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()<NSTableViewDataSource,NSTableViewDelegate>
{
    NSScrollView *_tableContainerView;
    NSMutableArray *_dataSourceArray;
    
    NSTextField *_scrollTF;
    NSButton *_deleteBtn;
    NSButton *_addBtn;
    
    NSInteger _selectedRowNum;
}

@property (nonatomic) NSTableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self crewateUI];
}

-(void)crewateUI{
    
    //虚拟的dataSource
    _dataSourceArray = [[NSMutableArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    _selectedRowNum = -1;
    
    //删除按钮
    _deleteBtn = [[NSButton alloc] initWithFrame:CGRectMake(415, 250, 70, 25)];
    _deleteBtn.title = @"删除选中行";
    _deleteBtn.wantsLayer = YES;
    _deleteBtn.layer.cornerRadius = 3.0f;
    _deleteBtn.layer.borderColor = [NSColor lightGrayColor].CGColor;
    [_deleteBtn setTarget:self];
    _deleteBtn.action = @selector(deleteTheSelectedRow);
    [self.view addSubview:_deleteBtn];
    
    //添加按钮
    _addBtn = [[NSButton alloc] initWithFrame:CGRectMake(415, 170, 70, 25)];
    _addBtn.title = @"上面添一行";
    _addBtn.wantsLayer = YES;
    _addBtn.layer.cornerRadius = 3.0f;
    _addBtn.layer.borderColor = [NSColor lightGrayColor].CGColor;
    [_addBtn setTarget:self];
    _addBtn.action = @selector(addRowUnderTheSelectedRow);
    [self.view addSubview:_addBtn];
    
    //滚动显示的TF
    _scrollTF = [[NSTextField alloc] initWithFrame:CGRectMake(415, 90, 80, 15)];
    _scrollTF.stringValue = @"滚动 0.0";
    _scrollTF.font = [NSFont systemFontOfSize:15.0f];
    _scrollTF.textColor = [NSColor blackColor];
    _scrollTF.drawsBackground = NO;
    _scrollTF.bordered = NO;
    _scrollTF.focusRingType = NSFocusRingTypeNone;
    _scrollTF.editable = NO;
    [self.view addSubview:_scrollTF];
    
    //tableView
    _tableContainerView = [[NSScrollView alloc] initWithFrame:CGRectMake(0, 0, 400, 309)];
    _tableView = [[NSTableView alloc] initWithFrame:CGRectMake(0, 20,
                                                               _tableContainerView.frame.size.width-20,
                                                               _tableContainerView.frame.size.height)];
    [_tableView setBackgroundColor:[NSColor colorWithCalibratedRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]];
    _tableView.focusRingType = NSFocusRingTypeNone;                             //tableview获得焦点时的风格
    _tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleRegular;//行高亮的风格
    _tableView.headerView.frame = NSZeroRect;                                   //表头
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // 第一列
    NSTableColumn * column1 = [[NSTableColumn alloc] initWithIdentifier:@"firstColumn"];
    [column1 setWidth:200];
    [_tableView addTableColumn:column1];//第一列
    
    // 第二列
    NSTableColumn * column2 = [[NSTableColumn alloc] initWithIdentifier:@"secondColumn"];
    [column2 setWidth:200];
    [_tableView addTableColumn:column2];//第二列
    
    [_tableContainerView setDocumentView:_tableView];
    [_tableContainerView setDrawsBackground:NO];        //不画背景（背景默认画成白色）
    [_tableContainerView setHasVerticalScroller:YES];   //有垂直滚动条
    //[_tableContainer setHasHorizontalScroller:YES];   //有水平滚动条
    _tableContainerView.autohidesScrollers = YES;       //自动隐藏滚动条（滚动的时候出现）
    [self.view addSubview:_tableContainerView];
    
    //监测tableview滚动
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(tableviewDidScroll:)
                                                name:NSViewBoundsDidChangeNotification
                                              object:[[_tableView enclosingScrollView] contentView]];
}


#pragma mark - NSTableViewDataSource,NSTableViewDelegate
#pragma mark -required methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _dataSourceArray.count;
}
//这个方法虽然不返回什么东西，但是必须实现，不实现可能会出问题－比如行视图显示不出来等。（10.11貌似不实现也可以，可是10.10及以下还是不行的）
- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    return nil;
}
#pragma mark -other methods
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 58;
}
- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSString *strIdt=[tableColumn identifier];
    NSTableCellView *aView = [tableView makeViewWithIdentifier:strIdt owner:self];
    if (!aView)
        aView = [[NSTableCellView alloc]initWithFrame:CGRectMake(0, 0, tableColumn.width, 58)];
    else
        for (NSView *view in aView.subviews)[view removeFromSuperview];
    
    NSTextField *textField = [[NSTextField alloc] initWithFrame:CGRectMake(15, 20, 156+50, 17)];
    textField.stringValue = [NSString stringWithFormat:@"我是第%@z个cell",[_dataSourceArray objectAtIndex:row]];
    textField.font = [NSFont systemFontOfSize:15.0f];
    textField.textColor = [NSColor blackColor];
    textField.drawsBackground = NO;
    textField.bordered = NO;
    textField.focusRingType = NSFocusRingTypeNone;
    textField.editable = NO;
    [aView addSubview:textField];
    return aView;
}
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    //    NSLog(@"====%ld", (long)row);
    _selectedRowNum = row;
    return YES;
}

- (void)tableView:(NSTableView *)tableView didClickTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"%@", tableColumn.dataCell);
}
#pragma mark - tableview滚动处理
-(void)tableviewDidScroll:(NSNotification *)notification
{
    NSClipView *contentView = [notification object];
    CGFloat scrollY = contentView.visibleRect.origin.y-20;//这里减去20是因为tableHeader的20高度
    _scrollTF.stringValue = [NSString stringWithFormat:@"滚动 %.1f",scrollY];
}


#pragma mark - 删除&&添加某一行
-(void)deleteTheSelectedRow
{
    if (_selectedRowNum == -1) {NSLog(@"请先选择要删除的行"); return;}
    [_tableView beginUpdates];
    [_dataSourceArray removeObjectAtIndex:_selectedRowNum];
    [_tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:_selectedRowNum] withAnimation:NSTableViewAnimationSlideUp];
    [_tableView endUpdates];
    _selectedRowNum = -1;
}
-(void)addRowUnderTheSelectedRow
{
    if (_selectedRowNum == -1) {NSLog(@"请先选择要哪行上面添一行"); return;}
    NSString *seletedDataObject = [_dataSourceArray objectAtIndex:_selectedRowNum];
    NSString *addObject = [NSString stringWithFormat:@"%@+",seletedDataObject];
    
    [_tableView beginUpdates];
    [_dataSourceArray insertObject:addObject atIndex:_selectedRowNum];
    [_tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:_selectedRowNum] withAnimation:NSTableViewAnimationSlideDown];
    [_tableView endUpdates];
    _selectedRowNum++;
}
#pragma mark -
- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}
// 选中的响应
-(void)tableViewSelectionDidChange:(nonnull NSNotification* )notification{
    self.tableView = notification.object;
    //do something
    NSLog(@"-----%ld", (long)self.tableView.selectedRow);
    
    NSAlert * alert = [[NSAlert alloc]init];
    alert.messageText = @"This is messageText";
    alert.alertStyle = NSAlertStyleInformational;
    [alert addButtonWithTitle:@"continue"];
    [alert addButtonWithTitle:@"cancle"];
    [alert setInformativeText:@"NSWarningAlertStyle \r Do you want to continue with delete of selected records"];
    [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
        NSLog(@"xxx");
        if (returnCode == NSModalResponseOK){
            NSLog(@"(returnCode == NSOKButton)");
        }else if (returnCode == NSModalResponseCancel){
            NSLog(@"(returnCode == NSCancelButton)");
        }else if(returnCode == NSAlertFirstButtonReturn){
            NSLog(@"if (returnCode == NSAlertFirstButtonReturn)");
        }else if (returnCode == NSAlertSecondButtonReturn){
            NSLog(@"else if (returnCode == NSAlertSecondButtonReturn)");
        }else if (returnCode == NSAlertThirdButtonReturn){
            NSLog(@"else if (returnCode == NSAlertThirdButtonReturn)");
        }else{
            NSLog(@"All Other return code %ld",(long)returnCode);
        }
    }];
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}


@end
