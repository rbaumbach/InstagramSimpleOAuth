

@interface InstagramLoginUtils : NSObject

- (NSURLRequest *)buildLoginRequestWithClientID:(NSString *)clientID
                                    callbackURL:(NSURL *)callbackURL;

- (BOOL)request:(NSURLRequest *)request hasAuthCodeWithCallbackURL:(NSURL *)callbackURL;

- (NSString *)authCodeFromRequest:(NSURLRequest *)request withCallbackURL:(NSURL *)callbackURL;

@end
