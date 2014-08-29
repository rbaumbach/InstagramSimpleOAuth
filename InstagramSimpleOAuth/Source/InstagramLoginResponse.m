#import "InstagramLoginResponse.h"
#import "InstagramUser.h"


NSString *const InstagramAccessTokenKey = @"access_token";
NSString *const InstagramUserKey = @"user";

@interface InstagramLoginResponse ()

@property (copy, nonatomic, readwrite) NSString *authToken;
@property (strong, nonatomic, readwrite) InstagramUser *user;

@end

@implementation InstagramLoginResponse

#pragma mark - Init Methods

- (instancetype)initWithInstagramAuthResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        if (response) {
            self.authToken = response[InstagramAccessTokenKey];
            
            InstagramUser *user = [[InstagramUser alloc] initWithDictionary:response[InstagramUserKey]];
            self.user = user;
        }
    }
    return self;
}

@end
