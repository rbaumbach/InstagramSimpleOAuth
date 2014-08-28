#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "InstagramSimpleOAuthViewController.h"
#import "InstagramConstants.h"
#import "InstagramLoginResponse.h"
#import "InstagramLoginUtils.h"


NSString *const InstagramAuthTokenEndpoint = @"/oauth/access_token/";

@interface InstagramSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (strong, nonatomic) InstagramLoginUtils *instagramLoginUtils;

@end

@implementation InstagramSimpleOAuthViewController

#pragma mark - Init Methods

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL
                      completion:(void (^)(InstagramLoginResponse *response, NSError *error))completion
{
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.clientSecret = clientSecret;
        self.callbackURL = callbackURL;
        self.completion = completion;
        self.shouldShowErrorAlert = YES;
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:InstagramAuthURL]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.instagramLoginUtils = [[InstagramLoginUtils alloc] initWithClientID:self.clientID
                                                                  andCallbackURL:self.callbackURL];
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
    if ([self.instagramLoginUtils requestHasAuthCode:request]) {
        [self showProgressHUD];
        
//        NSString *instagramAuthCode = [self.instagramLoginUtils authCodeFromRequest:request
//                                                                    withCallbackURL:self.callbackURL];
        
        NSString *instagramAuthCode = [self.instagramLoginUtils authCodeFromRequest:request];
        
        [self.sessionManager POST:InstagramAuthTokenEndpoint
                       parameters:[self instagramTokenParams:instagramAuthCode]
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              InstagramLoginResponse *loginResponse = [[InstagramLoginResponse alloc] initWithInstagramAuthResponse:responseObject];
                              
                              [self completeAuthWithLoginResponse:loginResponse];
                          } failure:^(NSURLSessionDataTask *task, NSError *error) {
                              [self completeWithError:error];
                          }];
        
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code != 102) {
        [self completeWithError:error];
        
        if (self.shouldShowErrorAlert) {
            [self showErrorAlert:error];
        }
        
        [self dismissViewController];
    }
    
    [self hideProgressHUD];
}

#pragma mark - Private Methods

- (void)loadInstagramLogin
{
    [self showProgressHUD];
    
    NSURLRequest *loginRequest = [self.instagramLoginUtils buildLoginRequest];
    [self.instagramWebView loadRequest:loginRequest];

}

- (NSDictionary *)instagramTokenParams:(NSString *)authCode
{
    return @{ @"client_id"     : self.clientID,
              @"client_secret" : self.clientSecret,
              @"grant_type"    : @"authorization_code",
              @"redirect_uri"  : self.callbackURL.absoluteString,
              @"code"          : authCode };
}

- (void)completeAuthWithLoginResponse:(InstagramLoginResponse *)response
{
    self.completion(response, nil);
    
    [self dismissViewController];
    [self hideProgressHUD];
}

- (void)completeWithError:(NSError *)error
{
    self.completion(nil, error);
    
    if (self.shouldShowErrorAlert) {
        [self showErrorAlert:error];
    }
    
    [self dismissViewController];
    [self hideProgressHUD];
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

- (void)showErrorAlert:(NSError *)error
{
    NSString *errorMessage = [NSString stringWithFormat:@"%@ - %@", error.domain, error.userInfo[@"NSLocalizedDescription"]];
    
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Instagram Login Error"
                                                         message:errorMessage
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [errorAlert show];
}

- (void)showProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view
                         animated:YES];
}

- (void)hideProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view
                         animated:YES];
}

@end
