//
//  ViewController.m
//  Dice
//
//  Created by Matt Mohorn on 2/3/15.
//  Copyright (c) 2015 Murray Boodle. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

#define ARC4RANDOM_MAX      0x100000000

@interface ViewController (){
    int color;
    int diceSize;
    int diceCorner;
}
@property(nonatomic)UIImageView*dice1;
@property(nonatomic)UIImageView*dice2;

@end

@implementation ViewController
@synthesize dice1,dice2;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //hide status bar
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    //set constants
    color=4;
    diceSize=61;
    diceCorner=10;

    
    
    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    //gesture recognizers
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    [singleFingerTap requireGestureRecognizerToFail:doubleTap];

    
    
//    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
//    [pinch requireGestureRecognizerToFail:tripleTap];
//    [self.view addGestureRecognizer:pinch];

    //dice views
    dice1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"black_1" ]];
    dice1.frame=[self startRect];
    dice1.layer.cornerRadius=diceCorner;
    dice1.layer.masksToBounds=YES;
    [self.view addSubview:dice1];
    
    dice2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"black_2" ]];
    dice2.frame= [self startRect];
    dice2.layer.cornerRadius=diceCorner;
    dice2.layer.masksToBounds=YES;
    [self.view addSubview:dice2];

}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    [self moveDiceOffScreen];
    [self setRandomDice];
    [self rollDice];
    
}


- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    //NSLog(@"double tapp");
    
    [self moveDiceOffScreen];
    [self forceASevenEleven];
    [self rollDice];
    
}


- (void)handlePinch:(UITapGestureRecognizer *)recognizer
{
    if(recognizer.state==UIGestureRecognizerStateBegan){
        NSLog(@"pinch began");
    }
    if(recognizer.state==UIGestureRecognizerStateEnded){
        NSLog(@"pinch ended");
        [self moveDiceOffScreen];
        [self forceAThree];
        [self rollDice];
    }
    
    
}



-(void)rollDice
{
    double randomSpin1 = [self random]*M_PI;
    double randomSpin2 = [self random]*M_PI;
    double randomX1 = [self random]*(self.view.bounds.size.width/4)+3*self.view.bounds.size.width/8;
    double randomY1 = [self random]*(self.view.bounds.size.height/4)+3*self.view.bounds.size.height/8;
    
    double theta = 2.0*[self random]*M_PI-M_PI;
    
  
    
    double r = diceSize*2.0;
    
    double randomX2 = randomX1+cos(theta)*r;
    double randomY2 = randomY1+sin(theta)*r;
    
    
    
    [UIView beginAnimations:@"MoveAndRotateAnimation" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];

    [dice1 setCenter:CGPointMake(randomX1, randomY1)];
    [dice1 setTransform:CGAffineTransformMakeRotation(randomSpin1)];
    
    [dice2 setCenter:CGPointMake(randomX2, randomY2)];
    [dice2 setTransform:CGAffineTransformMakeRotation(randomSpin2)];
    
    [UIView commitAnimations];
}

-(void)setRandomDice
{

    [dice1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],[self random6] ]]];
    [dice2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],[self random6] ]]];
}

-(void)forceAThree
{
    
    [dice1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],3 ]]];
    [dice2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],[self random6] ]]];
}

-(void)forceASevenEleven
{
    int rand=[self random4];
    if([self random4]<4){
        NSLog(@"%u",rand);
        int firstNumber = [self random6];
        [dice1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],firstNumber ]]];
        [dice2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],7-firstNumber ]]];
    }
    else{
        [dice1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],5 ]]];
        [dice2 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%u",[self getColorString],6 ]]];
    }
    
}

-(void)moveDiceOffScreen
{
    [dice1 setTransform:CGAffineTransformMakeRotation(0)];
    [dice1 setFrame:[self startRect]];
    
    [dice2 setTransform:CGAffineTransformMakeRotation(0)];
    [dice2 setFrame:[self startRect]];
}

-(double)random
{
    return drand48();
}

-(int)random6
{
    return 1 + arc4random() % (7 - 1);
}

-(int)random2
{
    return 1 + arc4random() % (3 - 1);
}

-(int)random4
{
    return 1 + arc4random() % (5 - 1);
}

-(CGRect)startRect
{
    return CGRectMake(self.view.bounds.size.width, self.view.bounds.size.height/2, diceSize, diceSize);
}



- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(BOOL)shouldAutorotate
{
    return false;
}

-(NSString*)getColorString
{
    switch (color) {
        case 4:
            return @"black";
            break;
            
        default:
            return @"black";
            break;
    }
}


@end
