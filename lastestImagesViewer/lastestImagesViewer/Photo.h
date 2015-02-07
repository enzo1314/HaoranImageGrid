//
//  Photo.h
//  lastestImagesViewer
//
//  Created by enzo on 2/6/15.
//  Copyright (c) 2015 enzo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (nonatomic, assign) int timestamp;
@property (nonatomic, strong) NSString *pagePreviewThumbnail;
@property (nonatomic, assign) int ownerId;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, assign) int treeId;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
