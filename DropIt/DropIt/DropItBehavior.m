//
//  DropItBehavior.m
//  DropIt
//
//  Created by iOS Entwickler on 07.03.16.
//  Copyright (c) 2016 noorg. All rights reserved.
//

#import "DropItBehavior.h"

@interface DropItBehavior()

@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;

@end

@implementation DropItBehavior

-(instancetype)init{
    
    self = [super init];
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    return self;
    
}


- (UIGravityBehavior *)gravity{
    
    if(!_gravity){
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9; // somewhat gravity acceleration where 1.0 is approx. like real life gravity acceleration
    }
    return _gravity;
}

- (UICollisionBehavior *)collider{
    
    if(!_collider){
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collider;
}


- (void)addItem:(id <UIDynamicItem>)item{
    
    [self.gravity addItem:item];
    [self.collider addItem:item];
    
}

- (void)removeItem:(id <UIDynamicItem>)item{
    
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
}

@end