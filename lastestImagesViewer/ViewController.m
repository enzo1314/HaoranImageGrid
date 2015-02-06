//
//  ViewController.m
//  lastestImagesViewer
//
//  Created by enzo on 2/6/15.
//  Copyright (c) 2015 enzo. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface ViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *photos;
@end

@implementation ViewController

static NSString *const API_URL = @"http://api.getsimpleprints.com/api/post/newest/";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchLastestPhotos];
}

- (void)fetchLastestPhotos {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task =
        [session dataTaskWithRequest:request
                   completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                       if (!error) {
                           id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                           options:NSJSONReadingMutableContainers
                                                                             error:nil];
                           NSLog(@"%@", jsonObject);
                           
                           if ([jsonObject isKindOfClass:[NSArray class]]) {
                               self.photos = jsonObject;
                               
                               [self.collectionView reloadData];
                           }
                       }
                   }
         ];
        
        [task resume];
    });
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
    
    NSDictionary *photoDict;
    NSString *urlString;
    if ([[self.photos objectAtIndex:indexPath.row] isKindOfClass:[NSDictionary class]]) {
        photoDict = [self.photos objectAtIndex:indexPath.row];
    }
    
    if (photoDict[@"page_preview_thumbnail"]) {
        urlString = photoDict[@"page_preview_thumbnail"];
    }
    
    NSURL *photoURL = [NSURL URLWithString:urlString];
    
    [cell.imageView sd_setImageWithURL:photoURL];
    
    return cell;
}

@end
