#import <UIKit/UIKit.h>


@interface InstagramSimpleOAuthViewController : UIViewController

@property (strong, nonatomic, readonly) NSString *clientID;
@property (strong, nonatomic, readonly) NSString *clientSecret;
@property (strong, nonatomic, readonly) NSURL *callbackURL;

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL
                      completion:(void (^)(NSString *authToken))completion;

@end
