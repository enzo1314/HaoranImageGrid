//
//  ViewController.m
//  lastestImagesViewer
//
//  Created by enzo on 2/6/15.
//  Copyright (c) 2015 enzo. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "PhotosFetcher.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) PhotosFetcher *photoFetcher;
@end

@implementation ViewController

#pragma mark - Initialization

- (PhotosFetcher *)photoFetcher {
    if (!_photoFetcher) {
        _photoFetcher = [[PhotosFetcher alloc] init];
    }
    
    return _photoFetcher;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchLastestPhotos];
    [self setupRefreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertLastestPhotos:)
                                                 name:@"GotNewPhotos"
                                               object:nil];

}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GotNewPhotos" object:nil];
}

# pragma mark - update photos

- (void)fetchLastestPhotos {
    [self.photoFetcher fetchLastestPhotos];
}

- (void)insertLastestPhotos:(NSNotification *)notification {
    NSArray *newPhotos;
    
    if ([notification.userInfo[@"photos"] isKindOfClass:[NSArray class]]) {
        newPhotos = notification.userInfo[@"photos"];
    }
    
    [self.photos addObjectsFromArray:newPhotos];
    [self.collectionView reloadData];
    [self.refreshControl endRefreshing];
    
    return;
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PHOTO_CELL"
                                                                       forIndexPath:indexPath];
    
    Photo *photo = self.photos[self.photos.count - 1 - indexPath.row];
    NSURL *photoURL = [NSURL URLWithString:photo.pagePreviewThumbnail];
    
    [cell.imageView sd_setImageWithURL:photoURL];
    
    return cell;
}

#pragma mark - Miscell

- (void)setupRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchLastestPhotos)
                  forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

@end
