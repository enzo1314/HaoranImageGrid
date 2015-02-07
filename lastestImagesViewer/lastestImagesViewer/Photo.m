//
//  Photo.m
//  lastestImagesViewer
//
//  Created by enzo on 2/6/15.
//  Copyright (c) 2015 enzo. All rights reserved.
//

#import "Photo.h"

//@property (nonatomic, strong) NSString *timestamp;
//@property (nonatomic, strong) NSURL *pagePreviewThumbnail;
//@property (nonatomic, strong) NSString *ownerId;
//@property (nonatomic, strong) NSString *key;
//@property (nonatomic, strong) NSString *treeId;

@implementation Photo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    if (self) {
        if (![dictionary isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        self = [[Photo alloc] init];
        
        if (dictionary[@"timestamp"]) {
            self.timestamp = (int)dictionary[@"timestamp"];
        }
        
        if ([dictionary[@"page_preview_thumbnail"] isKindOfClass:[NSString class]]) {
            self.pagePreviewThumbnail = [NSString stringWithFormat:@"%@", dictionary[@"page_preview_thumbnail"]];
        }
        
        if (dictionary[@"owner_id"]) {
            self.ownerId = (int)dictionary[@"owner_id"];
        }
        
        if ([dictionary[@"key"] isKindOfClass:[NSString class]]) {
            self.key = dictionary[@"key"];
        }
                            
        if (dictionary[@"tree_id"]) {
            self.treeId = (int)dictionary[@"tree_id"];
        }
    }
    
    return self;
}

@end
