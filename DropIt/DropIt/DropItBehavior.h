//
//  DropItBehavior.h
//  DropIt
//
//  Created by iOS Entwickler on 07.03.16.
//  Copyright (c) 2016 noorg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropItBehavior : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
