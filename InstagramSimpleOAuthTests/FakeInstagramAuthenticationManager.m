#import "FakeInstagramAuthenticationManager.h"


@implementation FakeInstagramAuthenticationManager

- (void)authenticateClientWithAuthCode:(NSString *)authCode
                               success:(void (^)(InstagramLoginResponse *response))success
                               failure:(void (^)(NSError *error))failure
{
    self.authCode = authCode;
    self.success = success;
    self.failure = failure;
}

@end
