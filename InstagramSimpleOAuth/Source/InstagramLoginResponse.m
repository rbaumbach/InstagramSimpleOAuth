#import "InstagramLoginResponse.h"
#import "InstagramUser.h"


@implementation InstagramLoginResponse

#pragma mark - Init Methods

- (instancetype)initWithInstagramAuthResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        if (response) {
            self.authToken = response[@"access_token"];
            
            InstagramUser *user = [[InstagramUser alloc] initWithUserResponse:response[@"user"]];
            self.user = user;
        }
    }
    return self;
}

- (instancetype)init
{
    return [self initWithInstagramAuthResponse:nil];
}

@end
