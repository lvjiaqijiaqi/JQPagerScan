//
//  JQPageScanControll.m
//  JQPageScaner
//
//  Created by lvjiaqi on 16/7/3.
//  Copyright © 2016年 lvjiaqi. All rights reserved.
//
#define contentInsetTop 1
#define meunViewHeight 50
#define titleViewHeight 100

#define topLimit 80
#define buttomLimit 80

#import "JQPageScanControll.h"

@interface JQPageScanControll()<JQPagerMeunDelegate,UITableViewDelegate,UIScrollViewDelegate>

@property(nonatomic,weak) UITableView *PageTableView;

@property(nonatomic) NSInteger currentPage;
@property(nonatomic) NSInteger numberOfPage;
@property(nonatomic) NSInteger numberOfPages;

@property(nonatomic,strong) UIView* titleView;
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *replyLabel;
@property(nonatomic,strong) UILabel *scanLabel;
@property(nonatomic,strong) UILabel *zoneLabel;

@property(nonatomic,strong) UILabel *headLabelOfTable;
@property(nonatomic,strong) UILabel *tailLabelOfTable;

@property(nonatomic,strong) UIImageView *shadowView;

@property(nonatomic,strong) JQPagerMeunView *pagerMeunView;

@property(nonatomic,strong) NSMutableDictionary *pageHeigths;

@end

@implementation JQPageScanControll



#pragma mark - LazyLoadViews

-(UILabel *)headLabelOfTable{
    if (!_headLabelOfTable) {
        UILabel *headLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.PageTableView frameW], 30)];
        [headLable setCenter:CGPointMake([self.PageTableView frameW]/2,  -30-_PageTableView.contentInset.top )];
        headLable.textAlignment = NSTextAlignmentCenter;
        headLable.hidden = NO;
        headLable.text = @"首页";
        [self.PageTableView addSubview:headLable];
        self.headLabelOfTable = headLable;
    }
    return _headLabelOfTable;
}

-(UILabel *)tailLabelOfTable{
    if (!_tailLabelOfTable) {
        UILabel *tailLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [self.PageTableView frameW], 30)];
        tailLable.textAlignment = NSTextAlignmentCenter;
        tailLable.hidden = YES;
        tailLable.text = @"下拉至第2页";
        [self.PageTableView addSubview:tailLable];
        self.tailLabelOfTable = tailLable;
    }
    return  _tailLabelOfTable;
}

-(UIView *)titleView{
    if (_titleView == nil) {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, -titleViewHeight, [self.PageTableView frameW], titleViewHeight)];
        titleView.hidden = YES;
        [self.PageTableView addSubview:titleView];
        [self.PageTableView setContentInset:UIEdgeInsetsMake(titleViewHeight, 0, 0, 0)];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, [self.PageTableView frameW]-40, titleViewHeight/2)];
        self.titleLabel.text = @"杨幂和刘恺威完成婚礼";
        self.titleLabel.font = [UIFont systemFontOfSize:22];
        
        CGFloat segmentWidth = [self.PageTableView frameW]/5;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, titleViewHeight/2, segmentWidth, titleViewHeight/2)];
        self.nameLabel.text = @"杨幂";
        self.scanLabel = [[UILabel alloc] initWithFrame:CGRectMake(segmentWidth+20, titleViewHeight/2, segmentWidth, titleViewHeight/2)];
        self.scanLabel.text = @"浏览:100";
        self.replyLabel = [[UILabel alloc] initWithFrame:CGRectMake(segmentWidth*2+20, titleViewHeight/2, segmentWidth, titleViewHeight/2)];
        self.replyLabel.text = @"回复:2";
        self.zoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(segmentWidth*3+20, titleViewHeight/2, segmentWidth, titleViewHeight/2)];
        self.zoneLabel.text = @"版聊";
        
        [titleView addSubview:self.titleLabel];
        [titleView addSubview:self.nameLabel];
        [titleView addSubview:self.scanLabel];
        [titleView addSubview:self.replyLabel];
        [titleView addSubview:self.zoneLabel];
        self.titleView = titleView;
    }
    return _titleView;
}

-(JQPagerMeunView *)pagerMeunView{
    if (_pagerMeunView == nil) {
        JQPagerMeunView *pageMenu = [[JQPagerMeunView alloc] initWithFrame:CGRectMake([self.PageTableView frameX], [self.PageTableView frameY]+[self.PageTableView frameH], [self.PageTableView frameW], 50) With:self];
        _pagerMeunView = pageMenu;
    }
    return _pagerMeunView;
}

#pragma mark - ObserveControll

-(void)startListening:(UITableView *)tabelView{
    
    [tabelView addObserver:self forKeyPath:@"panGestureRecognizer.state" options:NSKeyValueObservingOptionNew context:nil];
    [tabelView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [tabelView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    tabelView.delegate = self;
    self.PageTableView = tabelView;
    
    self.titleView.hidden = NO;
    
    self.headLabelOfTable.hidden = NO;
    self.tailLabelOfTable.hidden = YES;
    
    self.pageHeigths = [NSMutableDictionary dictionary];
    _numberOfPage = 10;
    _numberOfPages = 0;
    _currentPage = 0;
    _isloading = NO;
    
}

-(void)removeListening:(UITableView *)tabelView{
    [tabelView removeObserver:self forKeyPath:@"panGestureRecognizer.state"];
    [tabelView removeObserver:self forKeyPath:@"contentSize"];
    [tabelView removeObserver:self forKeyPath:@"contentOffset"];
}




-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
   if ([keyPath isEqual:@"contentSize"]){
        [self adjustTheTailY:[change[@"new"] CGSizeValue].height]; 
    }else if ([keyPath isEqual:@"contentOffset"]){
    }
}


#pragma mark - pageSwitch 

-(void)setCurrentPage:(NSInteger)currentPage{
    
    if ( _isloading || currentPage == _currentPage || currentPage < 0 || currentPage >= _numberOfPages ) {
        return;
    }
    
    _isloading = YES;
    
    UIImageView *imageView = [self createMaskView];
    
    
    if (currentPage > _currentPage) {
        [_PageTableView.superview insertSubview:imageView aboveSubview:_PageTableView];
    }else{
        _PageTableView.transform = CGAffineTransformMakeTranslation(0, -imageView.frame.size.height);
        [_PageTableView.superview insertSubview:imageView belowSubview:_PageTableView];
    }

        
    _PageTableView.scrollEnabled = NO;
    
    _PageTableView.tag = currentPage;
    [_PageTableView reloadData];
    
    if (currentPage > _currentPage) {
         _currentPage = currentPage;
        if ([_PageTableView.dataSource tableView:_PageTableView numberOfRowsInSection:0] != 0) {
                 [self.PageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [self updateDataFromSource:NO];
        }else{
            [self updateDataFromSource:YES];
        }
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            imageView.transform = CGAffineTransformMakeTranslation(0, -imageView.frame.size.height);
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
        
    }else{
        
         _currentPage = currentPage;
        if ([_PageTableView.dataSource tableView:_PageTableView numberOfRowsInSection:0] != 0) {
                [self.PageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_PageTableView.dataSource tableView:_PageTableView numberOfRowsInSection:0]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
               [self updateDataFromSource:NO];
            
        }else{
            [self updateDataFromSource:YES];
        }

        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            _PageTableView.transform = CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
            _PageTableView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        
    }
        

}

-(void)updateDataFromSource:(bool)sourcing{
    void (^callBack)(NSDictionary *) = ^(NSDictionary *msg){
        if (msg != nil) {
            
            self.replyLabel.text = [msg objectForKey:@"reply"]!=nil ? [NSString stringWithFormat:@"%d",[[msg objectForKey:@"reply"] intValue]] : @"";
            self.scanLabel.text = [msg objectForKey:@"scan"]!=nil ? [NSString stringWithFormat:@"%d",[[msg objectForKey:@"scan"] intValue]] : @"";
            _numberOfPages = [[msg objectForKey:@"numberOfpages"] intValue];
            
        }
        
        _isloading = NO;
        _PageTableView.scrollEnabled = YES;
        [self.pagerMeunView setCurrent:_currentPage+1 of:_numberOfPages];
        self.headLabelOfTable.text = _currentPage != 0 ? [[NSString alloc] initWithFormat:@"上拉至第%ld页",(long)_currentPage] : @"首页";
        self.tailLabelOfTable.text = _currentPage+1 != _numberOfPages? [[NSString alloc] initWithFormat:@"下拉至第%ld页",(long)_currentPage+2] : @"没有啦";
    };
    if (sourcing)  self.prepareData( _PageTableView , callBack);
    else callBack(nil);
}

-(void)adjustTheTailY:(CGFloat)h{
    
    if (h == 0) return;
    self.tailLabelOfTable.hidden = NO;
    [self.tailLabelOfTable setCenter:CGPointMake(self.tailLabelOfTable.center.x, h+50)];
    
}


#pragma mark - MaskView

-(UIImageView *)createMaskView{
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake([_PageTableView frameX], [_PageTableView frameY], [_PageTableView frameW],[_PageTableView frameH])];
    maskView.image = [self convertViewToImage:_PageTableView.superview];
    return maskView;
}

-(UIImage*)convertViewToImage:(UIView *)v{
    
    CGSize s = CGSizeMake(v.frame.size.width, v.frame.size.height);
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [v.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, CGRectMake([_PageTableView frameX]*[UIScreen mainScreen].scale, [_PageTableView frameY]*[UIScreen mainScreen].scale, [_PageTableView frameW]*[UIScreen mainScreen].scale, [_PageTableView frameH]*[UIScreen mainScreen].scale));
    UIImage *image = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    
    return image;
}

#pragma mark - UIscrollViewDelegate


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
     return 300;
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    NSInteger p = [self validNewPage:scrollView];
    if (p != -1 ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:scrollView.contentOffset animated:NO];
            [scrollView setNeedsLayout];
            [scrollView layoutIfNeeded];
            [self setCurrentPage:p];
        });
    }
   
}
-(NSInteger)validNewPage:(UIScrollView *)scrollView{
    
    if ( [self.PageTableView contentY] < - (topLimit + self.PageTableView.contentInset.top) ) {
        
        return _currentPage <= 0 ? -1 : _currentPage-1;
        
    }else if( [self.PageTableView contentY] > [self.PageTableView contentH] - [self.PageTableView frameH] + buttomLimit
    ){
        
        return _currentPage+1 >= _numberOfPages? -1 : _currentPage+1;
    }
    return -1;
}


#pragma mark - PageViewDelegate

-(void)doEdit{
    self.cblock(@"1");
}
-(void)doReply{
    self.rblock(@"1");
}
-(void)nextPage{
    self.currentPage = _currentPage+1;
}
-(void)jumpTo:(NSInteger)page{
   self.currentPage = page;
}
-(void)beforePage{
   self.currentPage = _currentPage-1;
}



@end
