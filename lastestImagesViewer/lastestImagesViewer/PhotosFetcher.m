//
//  PhotosFetcher.m
//  lastestImagesViewer
//
//  Created by enzo on 2/6/15.
//  Copyright (c) 2015 enzo. All rights reserved.
//

#import "PhotosFetcher.h"
#import "Photo.h"

@interface PhotosFetcher ()

@property (nonatomic, strong) NSMutableDictionary *checkExistenceDictionary;

@end

@implementation PhotosFetcher

static NSString *const API_URL = @"http://api.getsimpleprints.com/api/post/newest/";

- (NSDictionary *)checkExistenceDictionary {
    if (!_checkExistenceDictionary) {
        _checkExistenceDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return _checkExistenceDictionary;
}

- (void)fetchLastestPhotos {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:API_URL]];
    NSURLSessionConfiguration *defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:defaultConfiguration
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *jsonDownloadTask =
        [session dataTaskWithRequest:request
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               if (error) {
                   return;
               }
                
               id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                               options:NSJSONReadingMutableContainers
                                                                 error:nil];
               
               if ([jsonObject isKindOfClass:[NSArray class]]) {
                   NSArray *photoArray = [self jsonToPhotos:jsonObject];
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"GotNewPhotos"
                                                                       object:self
                                                                     userInfo:@{ @"photos": photoArray }];
               }
            }
        ];
    
    [jsonDownloadTask resume];
}

- (NSArray *)jsonToPhotos:(NSArray *)jsonObject {
    NSMutableArray *photoArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in jsonObject) {
        Photo *currentPhoto = [[Photo alloc] initWithDictionary:item];
        
        if (![self exist:currentPhoto]) {
            [photoArray addObject:currentPhoto];
        }
    }
    
    return photoArray;
}

- (BOOL)exist:(Photo *)photo {
    if (self.checkExistenceDictionary[photo.key]) {
        return YES;
    }
    
    [self.checkExistenceDictionary setValue:@1 forKey:photo.key];
    return NO;
}

@end
