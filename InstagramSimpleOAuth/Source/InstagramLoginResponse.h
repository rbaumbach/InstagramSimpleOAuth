

@class InstagramUser;

@interface InstagramLoginResponse : NSObject

@property (copy, nonatomic, readonly) NSString *authToken;
@property (strong, nonatomic, readonly) InstagramUser *user;

- (instancetype)initWithInstagramAuthResponse:(NSDictionary *)response;

@end
