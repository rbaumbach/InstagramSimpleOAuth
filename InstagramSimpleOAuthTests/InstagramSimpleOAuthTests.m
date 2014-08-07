#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "InstagramSimpleOAuthViewController.h"

@interface InstagramSimpleOAuthViewController ()

@property (strong, nonatomic, readwrite) NSString *clientID;
@property (strong, nonatomic, readwrite) NSString *clientSecret;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

SpecBegin(InstagramSimpleOAuthViewControllerTests)

describe(@"InstagramSimpleOAuthViewController", ^{
    __block InstagramSimpleOAuthViewController *controller;
    __block NSURL *callbackURL;
    
    beforeEach(^{
        callbackURL = [NSURL URLWithString:@"http://swizzlean.com"];
        controller = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"fancyID"
                                                                     clientSecret:@"12345"
                                                                      callbackURL:callbackURL
                                                                       completion:^(NSString *authToken) {
        }];
    });
    
    it(@"has a clientID", ^{
        expect(controller.clientID).to.equal(@"fancyID");
    });
    
    it(@"has a clientSecet", ^{
        expect(controller.clientSecret).to.equal(@"12345");
    });
    
    it(@"has a callbackURL", ^{
        expect(controller.callbackURL).to.equal([NSURL URLWithString:@"http://swizzlean.com"]);
    });
});

SpecEnd
