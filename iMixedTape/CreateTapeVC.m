//
//  ViewController.m
//  iMixedTape
//
//  Created by Mustafa on 17/10/2016.
//  Copyright © 2016 LemondeIT. All rights reserved.
//

#import "CreateTapeVC.h"


@interface CreateTapeVC (){
    NSString *childVCIdentifier;
    int vcIndexCount;
}

@end

@implementation CreateTapeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboardOnTap)];
    
    //  [self addViewControllerAsChildVC:@"createStep1VC"];
    //self.createStepsImageView.image = [UIImage imageNamed:@"step1"];
    
    [self.view addGestureRecognizer:tap];
    [self setDelegate];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    vcIndexCount = 0;
    self.prevButtonOutlet.hidden = YES;
    self.createButtonOutlet.hidden = YES;
    self.nextButtonOutlet.hidden = NO;
    [self childVCAtIndex];
}

#pragma mark - Child ViewControllers

-(void)addViewControllerAsChildVC :(NSString *)identifier
{
    
    childVCIdentifier = identifier;
    
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    
    [self addChildViewController:vc];
    
    [self.parentView addSubview:vc.view];
    
    
    vc.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                UIViewAutoresizingFlexibleHeight);
    vc.view.frame = self.parentView.bounds;
    
    
}

#pragma mark - TextView and TextField Delegate Method

-(void)setDelegate
{
    self.messageTextView.delegate = self;
    self.sendToTextField.delegate = self;
    self.emailOrMobileTextField.delegate = self;
    self.fromTextField.delegate = self;
}

#pragma mark - Dismiss Keyboard on tap
-(void)dismissKeyboardOnTap
{
    [self.messageTextView resignFirstResponder];
    [self.sendToTextField resignFirstResponder];
    [self.emailOrMobileTextField resignFirstResponder];
    [self.fromTextField resignFirstResponder];
    
    [self animateViewWhenKeyboardAppear:0];
}

#pragma mark - Animate View When Keyboard Appears

-(void)animateViewWhenKeyboardAppear :(int)constant
{
    [UIView animateWithDuration:2.0
                     animations:^{
                         self.animateViewTopWhenKeyboardAppearsConstraint.constant = constant;
                     }];
}

#pragma mark - TextView Delegate Method

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self animateViewWhenKeyboardAppear:-100];
    
    return YES;
}

#pragma mark - TextField Delegate Method

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self animateViewWhenKeyboardAppear:-200];
    
    return YES;
}

#pragma mark - IBActions
- (IBAction)nextButton:(UIButton *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //UserModel *userModel = [[UserModel alloc]init];
    CreateTapeModel *cModel = [[CreateTapeModel alloc]init];
    NSLog(@"%@", cModel.emailOrMobile);
   // NSLog(@"%@", userModel.userID);
    
    
      
        if ([defaults valueForKey:key_createTapeTitle] == nil ||
             [defaults valueForKey:key_createTapeImage] == nil ||
             [defaults valueForKey:key_createTapeUploadImageID] == nil ||
             [defaults valueForKey:key_createTapeMessage] == nil ||
             [defaults valueForKey:key_createTapeSendTo] == nil ||
             [defaults valueForKey:key_createTapeEmailOrMobile] == nil) {
        
        [SharedHelper AlertControllerWithTitle:@"" message:@"Please fill the required fields to continue." viewController:self];
        NSLog(@"EMPTY");
    }else{
         NSLog(@"%d",[[NSUserDefaults standardUserDefaults]boolForKey:key_ifemail]);
        if ([[NSUserDefaults standardUserDefaults]boolForKey:key_ifemail]) {
            NSString *email = [cModel.emailOrMobile stringByTrimmingCharactersInSet : [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            BOOL emailValid = [SharedHelper validateEmail : email
                                                 required : YES
                                                 minChars : 1
                                                 maxChars : 100];
            if (emailValid) {
                self.prevButtonOutlet.hidden = NO;
                vcIndexCount++;
                
                if (vcIndexCount == 2) {
                    self.createButtonOutlet.hidden = NO;
                    self.nextButtonOutlet.hidden = YES;
                }
                [self childVCAtIndex];
            }else{
                [SharedHelper AlertControllerWithTitle:@"" message:@"Please enter a valid email." viewController:self];
            }
            

            
        }else{
            NSString *phone = [cModel.emailOrMobile stringByTrimmingCharactersInSet : [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            BOOL phoneValid = [SharedHelper validatePhone:phone];
            
            if (phoneValid) {
                self.prevButtonOutlet.hidden = NO;
                vcIndexCount++;
                
                if (vcIndexCount == 2) {
                    self.createButtonOutlet.hidden = NO;
                    self.nextButtonOutlet.hidden = YES;
                }
                [self childVCAtIndex];
            }else{
                [SharedHelper AlertControllerWithTitle:@"" message:@"Please enter a valid phone number." viewController:self];
            }
        }
            // Validating username
    }
    
            
//        }else{
//            self.prevButtonOutlet.hidden = NO;
//            vcIndexCount++;
//            
//            if (vcIndexCount == 2) {
//                self.createButtonOutlet.hidden = NO;
//                self.nextButtonOutlet.hidden = YES;
//            }
//            [self childVCAtIndex];
//        }
//    }
    
}

- (IBAction)previousButton:(UIButton *)sender
{
    vcIndexCount--;
    
    self.nextButtonOutlet.hidden = NO;
    self.createButtonOutlet.hidden = YES;
    
    if (vcIndexCount == 0) {
        self.prevButtonOutlet.hidden = YES;
    }else{
        self.prevButtonOutlet.hidden = NO;
    }
    
    
    [self childVCAtIndex];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    UIAlertController *discardTapeAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want to discard?" preferredStyle:UIAlertControllerStyleAlert];
    
    [discardTapeAlert addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        vcIndexCount = 0;
        [self childVCAtIndex];
        
        [SharedHelper removeTapeDefaults];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults removeObjectForKey:key_createTapeTitle];
//        [defaults removeObjectForKey:key_createTapeUploadImageID];
//        [defaults removeObjectForKey:key_createTapeMessage];
//        [defaults removeObjectForKey:key_createTapeSendTo];
//        [defaults removeObjectForKey:key_createTapeEmailOrMobile];
//        [defaults removeObjectForKey:key_createTapeFrom];
//        [defaults removeObjectForKey:key_createTapeImage];
//        [defaults removeObjectForKey:key_createTapeSongs];
        
        self.tabBarController.selectedIndex = 0;
        
    }]];
    
    [discardTapeAlert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:discardTapeAlert animated:YES completion:nil];
}

- (IBAction)createButton:(UIButton *)sender
{
    CreateTapeModel *createTapeModel = [[CreateTapeModel alloc]init];
    UserModel *userModel = [[UserModel alloc]init];
    SharedHelper *helper = [[SharedHelper alloc]init];
    NSMutableArray *tempArr = helper.tapeSongsArray;
    
    
        if (!userModel.isLoggedIn) {
            [SharedHelper AlertControllerWithTitle:@"" message:@"You need to login to create tape." viewController:self];
        }else{
    
    for (int i = 0; i<tempArr.count; i++) {
        NSMutableDictionary *dict = [[tempArr objectAtIndex:i]mutableCopy];
        [dict removeObjectForKey:@"duration"];
        [dict removeObjectForKey:@"albumArt"];
        
        
        [tempArr replaceObjectAtIndex:i withObject:dict];
    }
    NSLog(@"%@",tempArr);
    
    [createTapeModel postFinalTapeToServer:createTapeModel.title
                                   message:createTapeModel.message
                                    userID:userModel.userID
                             uploadImageID:createTapeModel.uploadImageID
                           savedSongsArray:tempArr
                                  callback:^(id callback) {
                                      NSLog(@"%@",callback);
                                      if ([callback isKindOfClass:[NSDictionary class]]) {
                                          if ([[callback valueForKey:@"error"]boolValue] == NO) {
                                              
                                              CreateTapeModel *cModel = [[CreateTapeModel alloc]init];
                                              cModel.albumImage = nil;
                                              
                                              [SharedHelper sharedInstance].tapeSongsArray = [[NSMutableArray alloc]init];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self addViewControllerAsChildVC:@"createStep1VC"];
                                              });
                                              
                                              
                                              [SharedHelper removeTapeDefaults];
//                                              NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                                              [defaults removeObjectForKey:key_createTapeTitle];
//                                              [defaults removeObjectForKey:key_createTapeUploadImageID];
//                                              [defaults removeObjectForKey:key_createTapeMessage];
//                                              [defaults removeObjectForKey:key_createTapeSendTo];
//                                              [defaults removeObjectForKey:key_createTapeEmailOrMobile];
//                                              [defaults removeObjectForKey:key_createTapeFrom];
//                                              [defaults removeObjectForKey:key_createTapeImage];
//                                              [defaults removeObjectForKey:key_createTapeSongs];
//                                              [defaults synchronize];
                                              
                                              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                  self.tabBarController.selectedIndex = 0;
                                                  vcIndexCount = 0;
                                                  
                                              });
                                              
                                              [SharedHelper AlertControllerWithTitle:@"" message:@"Mixed tape sent successfully" viewController:self];
                                              
                                          }
                                      }
                                  }];
            
        }
}
- (IBAction)saveTapeButton:(UIButton *)sender
{
    UIAlertController *discardTapeAlert = [UIAlertController alertControllerWithTitle:@"" message:@"Your changes have been saved." preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    [discardTapeAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.tabBarController.selectedIndex = 0;
        vcIndexCount = 0;
        [self childVCAtIndex];
    }]];
    
    [self presentViewController:discardTapeAlert animated:YES completion:nil];
    
}
#pragma mark - Create Step Child VC's at index
-(void)childVCAtIndex
{
    
    switch (vcIndexCount) {
        case 0:
            [self addViewControllerAsChildVC:@"createStep1VC"];
            self.createStepsImageView.image = [UIImage imageNamed:@"step1"];
            break;
        case 1:
            [self addViewControllerAsChildVC:@"createStep2VC"];
            self.createStepsImageView.image = [UIImage imageNamed:@"step2"];
            break;
        case 2:
            [self addViewControllerAsChildVC:@"createStep3VC"];
            self.createStepsImageView.image = [UIImage imageNamed:@"step3"];
            break;
        default:
            break;
    }
}

- (IBAction)step1MelodyButton:(UIButton *)sender
{
    vcIndexCount = 0;
    [self childVCAtIndex];
}

- (IBAction)step2MelodyButton:(UIButton *)sender
{
    vcIndexCount = 1;
    [self childVCAtIndex];
}

- (IBAction)step3MelodyButton:(UIButton *)sender
{
    vcIndexCount = 2;
    [self childVCAtIndex];
}
@end