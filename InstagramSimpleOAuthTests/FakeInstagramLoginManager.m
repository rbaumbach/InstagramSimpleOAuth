#import "FakeInstagramLoginManager.h"


@implementation FakeInstagramLoginManager

- (void)authenticateWithAuthCode:(NSString *)authCode
                         success:(void (^)(InstagramLoginResponse *instagramLoginResponse))success
                         failure:(void (^)(NSError *error))failure
{
    self.authCode = authCode;
    self.success = success;
    self.failure = failure;
}

@end
