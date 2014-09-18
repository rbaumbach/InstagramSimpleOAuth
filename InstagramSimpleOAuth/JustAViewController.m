#import "JustAViewController.h"
#import "InstagramSimpleOAuth.h"

@implementation JustAViewController

#pragma mark - IBActions

- (IBAction)pushInstagramVCOnNavStackTapped:(id)sender
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
    
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}

#pragma mark - Private Method

- (void)displayToken:(NSString *)authToken
{
    UIAlertView *tokenAlert = [[UIAlertView alloc] initWithTitle:@"Instagram Token"
                                                         message:[NSString stringWithFormat:@"Your Token is: %@", authToken]
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil, nil];
    [tokenAlert show];
}

@end
