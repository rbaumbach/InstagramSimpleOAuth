#import "InitialViewController.h"
#import "JustAViewController.h"
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
                                                                            if (response.authToken) {
                                                                                [self displayToken:response.authToken];
                                                                            }
                                                                        }];

    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}

- (IBAction)instagramVCOnNavControllerTapped:(id)sender
{
    JustAViewController *viewController = [[JustAViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navController
                       animated:YES
                     completion:nil];
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
