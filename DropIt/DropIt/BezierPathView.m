//
//  BezierPathView.m
//  DropIt
//
//  Created by iOS Entwickler on 08.03.16.
//  Copyright (c) 2016 noorg. All rights reserved.
//

#import "BezierPathView.h"

@implementation BezierPathView


- (void)setPath:(UIBezierPath *)path{
    
    _path = path;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect{
    [self.path stroke];
}


@end
