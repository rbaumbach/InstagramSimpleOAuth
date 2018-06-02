#import "FakeInstagramOAuthResponse.h"

@implementation FakeInstagramOAuthResponse

+ (NSDictionary *)response
{
    return @{
             @"access_token": @"12345IdiotLuggageCombo",
             @"user": @{
                     @"id": @"yepyepyep",
                     @"username": @"og-gsta",
                     @"full_name": @"Ice Cube",
                     @"profile_picture": @"http://uh.yeah.yuuueaaah.com/og-gsta"
                     }
             };
}

+ (NSDictionary *)userResponse
{
    return @{
             @"id": @"yepyepyep",
             @"username": @"og-gsta",
             @"full_name": @"Ice Cube",
             @"profile_picture": @"http://uh.yeah.yuuueaaah.com/og-gsta"
             };
}

@end
