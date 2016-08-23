# JQPagerScan


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
