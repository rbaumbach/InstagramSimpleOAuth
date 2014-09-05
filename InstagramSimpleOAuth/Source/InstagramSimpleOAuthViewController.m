//Copyright (c) 2014 Ryan Baumbach <rbaumbach.github@gmail.com>
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the "Software"),
//to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <MBProgressHUD/MBProgressHUD.h>
#import "InstagramSimpleOAuthViewController.h"
#import "InstagramLoginManager.h"
#import "InstagramLoginUtils.h"


@interface InstagramSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;
@property (strong, nonatomic) InstagramLoginManager *loginManager;
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
        self.loginManager = [[InstagramLoginManager alloc] initWithClientID:self.clientID
                                                               clientSecret:self.clientSecret
                                                                callbackURL:self.callbackURL];
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
        
        NSString *instagramAuthCode = [self.instagramLoginUtils authCodeFromRequest:request];
        
        [self.loginManager authenticateWithAuthCode:instagramAuthCode
                                            success:^(InstagramLoginResponse *instagramLoginResponse) {
                                                [self completeAuthWithLoginResponse:instagramLoginResponse];
                                            } failure:^(NSError *error) {
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
    
    NSURLRequest *loginRequest = [self.instagramLoginUtils buildLoginRequestWithPermissionScope:self.permissionScope];
    [self.instagramWebView loadRequest:loginRequest];
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
