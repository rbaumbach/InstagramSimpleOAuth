#import "InitialViewController.h"
#import "JustAViewController.h"
#import "InstagramSimpleOAuth.h"


@implementation InitialViewController

#pragma mark - IBActions

- (IBAction)presentInstagramVCTapped:(id)sender
{
    InstagramSimpleOAuthViewController
    *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"d34a41b0195f4f50b829a278b9b534ee" // Don't worry, this doesn't exist anymore =)
                                                                      clientSecret:@"eb0f48287350402f862cf3a9b6e4aa1b" // Don't worry, this doesn't exist anymore =)
                                                                       callbackURL:[NSURL URLWithString:@"http://honeypot.xyz"]
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
