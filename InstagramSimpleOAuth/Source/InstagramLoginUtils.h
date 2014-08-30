

@interface InstagramLoginUtils : NSObject

@property (copy, nonatomic, readonly) NSString *clientID;
@property (strong, nonatomic, readonly) NSURL *callbackURL;

- (instancetype)initWithClientID:(NSString *)clientID
                  andCallbackURL:(NSURL *)callbackURL;

- (NSURLRequest *)buildLoginRequestWithPermissionScope:(NSArray *)permissionScope;

- (BOOL)requestHasAuthCode:(NSURLRequest *)request;

- (NSString *)authCodeFromRequest:(NSURLRequest *)request;

@end
