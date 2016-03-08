//
//  ViewController.m
//  DropIt
//
//  Created by iOS Entwickler on 07.03.16.
//  Copyright (c) 2016 noorg. All rights reserved.
//

#import "ViewController.h"
#import "DropItBehavior.h"
#import "BezierPathView.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPathView *gameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropItBehavior *dropItBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;


@end

@implementation ViewController

static const CGSize DROP_SIZE = { 40, 40 };

- (UIDynamicAnimator *)animator{
    if(!_animator){
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator{
    
    [self removeCompletedRows];
    
}

- (BOOL)removeCompletedRows{
    
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for(CGFloat y = self.gameView.bounds.size.height-DROP_SIZE.height/2; y > 0; y-= DROP_SIZE.height){
        
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        
        for(CGFloat x = DROP_SIZE.width/2; x <= self.gameView.bounds.size.width-DROP_SIZE.width/2; x+= DROP_SIZE.width){
            
            UIView *hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if([hitView superview] == self.gameView){
                [dropsFound addObject:hitView];
            }
            else{
                rowIsComplete = NO;
                break;
            }
            if(![dropsFound count]) break;
            if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
        }
    }
    
    
    if([dropsToRemove count]){
        for(UIView *drop in dropsToRemove){
            [self.dropItBehavior removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove{
    [UIView animateWithDuration:1.0
                     animations:^{
                         
                         for(UIView *drop in dropsToRemove){
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x, -y); // calling center, alpha, frame, transform etc. starts animation
                         }
                     
                     
                     }
                     completion:^(BOOL finieshed){
                         
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         
                     }];
}

-(DropItBehavior *)dropItBehavior{
    
    if(!_dropItBehavior){
        _dropItBehavior = [[DropItBehavior alloc] init];
        [self.animator addBehavior:_dropItBehavior];
    }
    return _dropItBehavior;
}



- (IBAction)tap:(UITapGestureRecognizer *)sender {
    
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    
    
    if (UIGestureRecognizerStateBegan == sender.state){
        
        [self attachDroppingViewToPoint:gesturePoint];
        
        
    }
    else if(UIGestureRecognizerStateChanged == sender.state){
        
        self.attachment.anchorPoint = gesturePoint;
    }
    else if(UIGestureRecognizerStateEnded == sender.state){
        
        [self.animator removeBehavior:self.attachment];
        self.gameView.path = nil;
    }
}

- (void)attachDroppingViewToPoint:(CGPoint)anchorPoint{
    
    if(self.droppingView){
        
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        
        // create local var since its used in code block but set to nil afterwards --> this would effect execution of code block
        UIView *droppingView = self.droppingView;
        
        // create weak self since its used in code block
        __weak ViewController *weakSelf = self;
        
        
        self.attachment.action = ^{
            
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];
            [path addLineToPoint:droppingView.center];
            weakSelf.gameView.path = path;
        
        
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attachment];
        
    }
}



- (void)drop{
    
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random() % (int)self.gameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.gameView addSubview:dropView];
    
    self.droppingView = dropView;
    
    [self.dropItBehavior addItem:dropView];
}

- (UIColor *)randomColor{
    switch(arc4random()%5){
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
        default: return [UIColor blackColor];
            
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
