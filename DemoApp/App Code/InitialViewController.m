#import <InstagramSimpleOAuth/InstagramSimpleOAuth.h>

#import "InitialViewController.h"
#import "JustAViewController.h"
#import "TokenAlertControllerBuilder.h"
#import "InstagramSimpleOAuth.h"

@implementation InitialViewController

#pragma mark - IBActions

- (IBAction)presentInstagramVCTapped:(id)sender
{
    InstagramSimpleOAuthViewController
    *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"enter_your_client_ID_here"
                                                                      clientSecret:@"enter_your_client_secret_here"
                                                                       callbackURL:[NSURL URLWithString:@"http://enter.callback.url.here"]
                                                                        completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                            if (response.accessToken) {
                                                                                [self displayToken:response.accessToken];
                                                                            }
                                                                        }];
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

#pragma mark - Private Method

- (void)displayToken:(NSString *)authToken
{
    UIAlertController *tokenAlertController = [TokenAlertControllerBuilder buildUsingToken:authToken];
    
    [self presentViewController:tokenAlertController
                       animated:YES
                     completion:nil];
}

@end
