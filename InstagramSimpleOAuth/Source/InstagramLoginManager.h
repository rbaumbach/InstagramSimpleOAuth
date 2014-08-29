

@class InstagramLoginResponse;

@interface InstagramLoginManager : NSObject

@property (copy, nonatomic, readonly) NSString *clientID;
@property (copy, nonatomic, readonly) NSString *clientSecret;
@property (strong, nonatomic, readonly) NSURL *callbackURL;

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL;

- (void)authenticateWithAuthCode:(NSString *)authCode
                         success:(void (^)(InstagramLoginResponse *instagramLoginResponse))success
                         failure:(void (^)(NSError *error))failure;

@end
