

@class InstagramUser;

@interface InstagramLoginResponse : NSObject

@property (copy, nonatomic) NSString *authToken;
@property (strong, nonatomic) InstagramUser *user;

- (instancetype)initWithInstagramAuthResponse:(NSDictionary *)response;

@end
