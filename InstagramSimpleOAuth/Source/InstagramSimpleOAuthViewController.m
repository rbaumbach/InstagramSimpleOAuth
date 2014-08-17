#import <AFNetworking/AFNetworking.h>
#import "InstagramSimpleOAuthViewController.h"


NSString *const INSTAGRAM_AUTH_URL = @"https://api.instagram.com";
NSString *const INSTAGRAM_AUTH_CLIENT_ID_ENDPOINT = @"/oauth/authorize/?client_id=";
NSString *const INSTAGRAM_AUTH_REDIRECT_PARAMS = @"&client=touch&redirect_uri=";
NSString *const INSTAGRAM_AUTH_RESPONSE_TYPE_PARAMS = @"&response_type=code";
NSString *const INSTAGRAM_AUTH_CODE_PARAM = @"/?code=";
NSString *const INSTAGRAM_AUTH_TOKEN_ENDPOINT = @"/oauth/access_token/";

@interface InstagramSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation InstagramSimpleOAuthViewController

#pragma mark - Init Methods

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL
                      completion:(void (^)(NSString *authToken))completion
{
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.clientSecret = clientSecret;
        self.callbackURL = callbackURL;
        self.completion = completion;
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:INSTAGRAM_AUTH_URL]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

- (instancetype)init
{
    return [self initWithClientID:nil
                     clientSecret:nil
                      callbackURL:nil
                       completion:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadInstagramLogin];
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *expectedInstagramCallbackPrefix = [NSString stringWithFormat:@"%@%@", self.callbackURL.absoluteString, INSTAGRAM_AUTH_CODE_PARAM];
    
    if ([requestURLString hasPrefix:expectedInstagramCallbackPrefix]) {
        NSString *instagramAuthCode = [requestURLString substringFromIndex:[expectedInstagramCallbackPrefix length]];

        [self.sessionManager POST:INSTAGRAM_AUTH_TOKEN_ENDPOINT
                  parameters:[self instagramTokenParams:instagramAuthCode]
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         self.completion(responseObject[@"access_token"]);
                         
                         [self dismissViewController];
                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                         self.completion(nil);
                         
                         [self dismissViewController];
                     }];

        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code != 102) {
        [self showErrorAlert:error];
        
        [self dismissViewController];
    }
}

#pragma mark - Private Methods

- (void)loadInstagramLogin
{
    NSString *fullInstagramLoginURLString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                             INSTAGRAM_AUTH_URL,
                                             INSTAGRAM_AUTH_CLIENT_ID_ENDPOINT,
                                             self.clientID,
                                             INSTAGRAM_AUTH_REDIRECT_PARAMS,
                                             self.callbackURL,
                                             INSTAGRAM_AUTH_RESPONSE_TYPE_PARAMS];
    
    NSURL *fullInstagramLoginURL = [NSURL URLWithString:fullInstagramLoginURLString];
    NSURLRequest *fullInstagramLoginRequest = [NSURLRequest requestWithURL:fullInstagramLoginURL];
    [self.instagramWebView loadRequest:fullInstagramLoginRequest];
}

- (void)showErrorAlert:(NSError *)error
{
    NSString *errorMessage = [NSString stringWithFormat:@"%@ - %@", error.domain, error.userInfo[@"NSLocalizedDescription"]];
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Load Request Error"
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (NSDictionary *)instagramTokenParams:(NSString *)authCode
{
    return @{ @"client_id"     : self.clientID,
              @"client_secret" : self.clientSecret,
              @"grant_type"    : @"authorization_code",
              @"redirect_uri"  : self.callbackURL.absoluteString,
              @"code"          : authCode };
}

- (void)dismissViewController
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES
                                 completion:nil];
    }
}

@end
