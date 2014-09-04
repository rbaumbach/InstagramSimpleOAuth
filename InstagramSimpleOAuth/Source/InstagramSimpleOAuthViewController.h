

@class InstagramLoginResponse;

@interface InstagramSimpleOAuthViewController : UIViewController

@property (copy, nonatomic) NSString *clientID;
@property (copy, nonatomic) NSString *clientSecret;
@property (strong, nonatomic) NSURL *callbackURL;
@property (copy, nonatomic) void (^completion)(InstagramLoginResponse *response, NSError *error);
@property (nonatomic) BOOL shouldShowErrorAlert;
@property (strong, nonatomic) NSArray *permissionScope;

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL
                      completion:(void (^)(InstagramLoginResponse *response, NSError *error))completion;

@end
