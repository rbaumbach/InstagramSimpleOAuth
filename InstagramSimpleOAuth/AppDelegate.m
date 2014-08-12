#import "AppDelegate.h"
#import "InstagramSimpleOAuthViewController.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    InstagramSimpleOAuthViewController *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"client_id_abc"
                                                                                                         clientSecret:@"client_secret_def"
                                                                                                          callbackURL:[NSURL URLWithString:@"http://web.r.us"]
                                                                                                           completion:^(NSString *authTokent) {}];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
