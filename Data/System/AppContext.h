//
//  AppContext.h
//  TaurusClient
//
//  Created by Tjatse on 12-12-13.
//  Copyright (c) 2012年 Taurus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppContext : NSObject

// Get a value indicating whether device network is available or not.
@property (nonatomic, readonly) BOOL online;

// Singleton instance.
+ (AppContext *) get;

@end
