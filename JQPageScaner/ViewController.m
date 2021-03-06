//
//  ViewController.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/1.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//

#import "ViewController.h"
#import "UITableView+PageScan.h"
#import "Floor.h"
#import "Post.h"
#import "PageTableViewCell.h"

@interface ViewController ()<UITableViewDataSource>

@property (nonatomic,strong) NSMutableDictionary< NSNumber *, NSArray *> *data;
@property (nonatomic,strong) Post *post;

@property (nonatomic,strong) UITableView *pagerScanView;

@end

@implementation ViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    
    self.pagerScanView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.pagerScanView.dataSource = self;
    [self.pagerScanView registerNib:[UINib nibWithNibName:@"PageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.pagerScanView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.pagerScanView];
    
    self.data = [[NSMutableDictionary alloc] init];
    self.post = [[Post alloc] init];
    
    __weak typeof(self)weakSelf = self;
    [self.pagerScanView statPageScanBlock:^( void (^callBack)(Post *post) ) {

            if ( [weakSelf.data objectForKey:[NSNumber numberWithInteger:weakSelf.pagerScanView.tag ]] ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.pagerScanView reloadData];
                    [weakSelf.pagerScanView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                    callBack(_post);
                });
            }else{
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
                     [weakSelf.data setObject:[weakSelf requireData:(int)weakSelf.pagerScanView.tag] forKey:[NSNumber numberWithInteger:weakSelf.pagerScanView.tag]];
                 dispatch_async(dispatch_get_main_queue(), ^{
                         [weakSelf.pagerScanView reloadData];
                         [weakSelf.pagerScanView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                         callBack(_post);
                     });
                 });
            }
    }];
    
    [self.pagerScanView setReplyBlock:^(NSString *uid) {
        NSLog(@"setReplyBlock%@",uid);
    }];
    [self.pagerScanView setCommentBlock:^(NSString *uid) {
         NSLog(@"setCommentBlock%@",uid);
    }];
    
    
}


-(NSArray *)requireData:(int)page{
    
    NSData *data = self.pagerScanView.tag%2 ? [NSData dataWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"data" withExtension:@"txt"]] : [NSData dataWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"data1" withExtension:@"txt"]] ;
    
    NSDictionary *a = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *floors = [a objectForKey:@"postsFloor"];
    
    NSDictionary *msg = [a objectForKey:@"postMsg"];
    Post *post = [[Post alloc] init];
    post.title = [msg objectForKey:@"name"];
    post.reply = [msg objectForKey:@"reply"];
    post.scan =  [msg objectForKey:@"scan"];
    post.Uid =  [msg objectForKey:@"Uid"];
    post.numberOfPages =  [msg objectForKey:@"numberOfpages"];
    _post = post;
    
    NSMutableArray *d = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        NSDictionary *floor = [floors objectAtIndex:i];
        Floor *f = [[Floor alloc] init];
        f.floorNum = [NSString stringWithFormat:@"%@",[floor objectForKey:@"floorNum"]];
        f.username = [floor objectForKey:@"name"];
        f.body = [floor objectForKey:@"content"];
        f.status = @"";
        f.time = [floor objectForKey:@"time"];
        [d addObject:f];
    }
 
    return [d copy];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self.data objectForKey:[NSNumber numberWithInteger:tableView.tag]] != nil) {
        
        return [self.data objectForKey:[NSNumber numberWithInteger:tableView.tag]].count;
        
    }else{
        
        return 0;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    Floor *f = [[self.data objectForKey:[NSNumber numberWithInteger:tableView.tag]] objectAtIndex:indexPath.row];
    
    [cell parseData:f];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;

}

@end
