#import "InstagramLoginManager.h"


@interface FakeInstagramLoginManager : InstagramLoginManager

@property (copy, nonatomic) NSString *authCode;
@property (copy, nonatomic) void (^success)(InstagramLoginResponse *instagramLoginResponse);
@property (copy, nonatomic) void (^failure)(NSError *error);

@end
