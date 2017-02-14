//
//  UserModel.h
//  iMixedTape
//
//  Created by Mustafa on 09/01/2017.
//  Copyright © 2017 LemondeIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (strong,nonatomic) NSDictionary *userData;
@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *userID;
@property (nonatomic) BOOL isLoggedIn;



-(void)logoutUserSession;
+(void)postUserSessionWithEmail :(NSString *)email password :(NSString *)password success : (void (^)(id ))success;
+(void)forgotPasswordAPIForEmail :(NSString *)email callback :(void (^)(id))callback;
+(void)resetPasswordForEmail :(NSString *)email resetToken :(NSString *)resetToken password:(NSString *)pass confirmPass :(NSString *)confirmPass callback :(void (^)(id))callback;

+(void)changeUserPassword : (NSString *)pass confirmPass :(NSString *)confirmPass callback :(void (^)(id))callback;

@end

