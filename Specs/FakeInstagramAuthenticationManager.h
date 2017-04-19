#import "InstagramAuthenticationManager.h"

@interface FakeInstagramAuthenticationManager : InstagramAuthenticationManager

@property (copy, nonatomic) NSString *authCode;
@property (copy, nonatomic) void (^success)(InstagramLoginResponse *response);
@property (copy, nonatomic) void (^failure)(NSError *error);

@end
