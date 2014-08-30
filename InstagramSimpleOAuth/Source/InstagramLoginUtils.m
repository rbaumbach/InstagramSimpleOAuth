#import "InstagramLoginUtils.h"
#import "InstagramConstants.h"


NSString *const InstagramAuthClientIDEndpoint = @"/oauth/authorize/?client_id=";
NSString *const InstagramAuthRedirectParams = @"&client=touch&redirect_uri=";
NSString *const InstagramAuthResponseTypeParams = @"&response_type=code";
NSString *const InstagramAuthCodeParam = @"/?code=";
NSString *const InstagramScopePermissionsParam = @"&scope=";

@interface InstagramLoginUtils ()

@property (copy, nonatomic, readwrite) NSString *clientID;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

@implementation InstagramLoginUtils

#pragma mark - Init Methods

- (instancetype)initWithClientID:(NSString *)clientID andCallbackURL:(NSURL *)callbackURL
{
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.callbackURL = callbackURL;
    }
    return self;
}

#pragma mark - Public Methods

- (NSURLRequest *)buildLoginRequestWithPermissionScope:(NSArray *)permissionScope
{
    NSURL *fullInstagramLoginURL = [NSURL URLWithString:[self instagramLoginURLStringWithPermissionScope:permissionScope]];
    return [NSURLRequest requestWithURL:fullInstagramLoginURL];
}

- (BOOL)requestHasAuthCode:(NSURLRequest *)request
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self callbackWithAuthCode];
    
    return [requestURLString hasPrefix:callbackWithAuthParam];
}

- (NSString *)authCodeFromRequest:(NSURLRequest *)request
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self callbackWithAuthCode];
    
    return [requestURLString substringFromIndex:[callbackWithAuthParam length]];
}

#pragma mark - Private Methods

- (NSString *)instagramLoginURLStringWithPermissionScope:(NSArray *)permissionScope
{
    NSMutableString *instagramLoginURLString = [[NSMutableString alloc] init];
    [instagramLoginURLString appendString:[NSString stringWithFormat:@"%@%@%@%@%@%@",
                                          InstagramAuthURL,
                                          InstagramAuthClientIDEndpoint,
                                          self.clientID,
                                          InstagramAuthRedirectParams,
                                          self.callbackURL.absoluteString,
                                          InstagramAuthResponseTypeParams]];
    
    if (permissionScope.count > 0) {
        [instagramLoginURLString appendString:InstagramScopePermissionsParam];
        
        [permissionScope enumerateObjectsUsingBlock:^(NSString *permission, NSUInteger idx, BOOL *stop) {
            if (idx != 0) {
                [instagramLoginURLString appendString:@"+"];
            }
            
            [instagramLoginURLString appendString:permission];
        }];
    }
    
    return instagramLoginURLString;
}

- (NSString *)callbackWithAuthCode
{
    return [NSString stringWithFormat:@"%@%@", self.callbackURL.absoluteString, InstagramAuthCodeParam];
}

@end
