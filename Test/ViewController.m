//
//  ViewController.m
//  Test
//
//  Created by huanxin xiong on 2016/11/30.
//  Copyright © 2016年 xiaolu zhao. All rights reserved.
//

#define SCREEN_W  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_H [[UIScreen mainScreen] bounds].size.height

#import "ViewController.h"
#import "ZCollectionViewCell.h"
#import "ZBroswerView.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZBroswerView *broswer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"图片浏览器";
    
    [self setupSubViews];
}

- (void)setupSubViews
{
    [self.view addSubview:self.collection];
}

#pragma getter
- (UICollectionView *)collection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake((SCREEN_W-52)/3, (SCREEN_W-52)/3+30);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 1;
    if (!_collection) {
        _collection = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collection.backgroundColor = [UIColor whiteColor];
        _collection.delegate = self;
        _collection.dataSource = self;
        _collection.pagingEnabled = YES;
        [_collection registerClass:[ZCollectionViewCell class] forCellWithReuseIdentifier:@"string"];
        _collection.showsVerticalScrollIndicator = NO;
    }
    return _collection;
}

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
        for (int i = 0; i < 5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"火影0%d", i + 1]];
            [_dataSource addObject:image];
        }
    }
    return  _dataSource;
}

#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(18, 18, 0, 18);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"string" forIndexPath:indexPath];
    cell.headImageView.image = self.dataSource[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (ZCollectionViewCell *)[self.collection cellForItemAtIndexPath:indexPath];
    
    if (self.broswer == nil) {
        self.broswer = [[ZBroswerView alloc] initWithImageArray:self.dataSource currentIndex:indexPath.row];
        [self.broswer showInCell:cell];
    }else{
        [self.broswer removeFromSuperview];
        self.broswer = [[ZBroswerView alloc] initWithImageArray:self.dataSource currentIndex:indexPath.row];
        [self.broswer showInCell:cell];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
