#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "InstagramLoginUtils.h"


@interface InstagramLoginUtils ()

@property (copy, nonatomic, readwrite) NSString *clientID;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

SpecBegin(InstagramLoginUtilsTests)

describe(@"InstagramLoginUtils", ^{
    __block InstagramLoginUtils *utils;
    
    beforeEach(^{
        utils = [[InstagramLoginUtils alloc] initWithClientID:@"schlitz-blue-bull"
                                               andCallbackURL:[NSURL URLWithString:@"https://bluebull.32oz"]];
    });
    
    it(@"has a clientID", ^{
        expect(utils.clientID).to.equal(@"schlitz-blue-bull");
    });
    
    it(@"has a callbackURL", ^{
        expect(utils.callbackURL).to.equal([NSURL URLWithString:@"https://bluebull.32oz"]);
    });
    
    describe(@"#buildLoginRequestWithPermissionScope:", ^{
        __block NSURLRequest *request;
        
        context(@"populated scope permissions", ^{
            beforeEach(^{
                request = [utils buildLoginRequestWithPermissionScope:@[@"basic", @"relationships", @"likes", @"comments"]];
            });
            
            it(@"builds proper login request for Instagram login with scope permission params", ^{
                NSString *expectedLoginURLString = [NSString stringWithFormat:@"%@%@%@%@",
                                                    @"https://api.instagram.com/oauth/authorize/",
                                                    @"?client_id=schlitz-blue-bull&client=touch",
                                                    @"&redirect_uri=https://bluebull.32oz&response_type=code",
                                                    @"&scope=basic+relationships+likes+comments"];
                
                expect(request.URL.absoluteString).to.equal(expectedLoginURLString);
            });
        });
        
        context(@"empty scope permissions", ^{
            beforeEach(^{
                request = [utils buildLoginRequestWithPermissionScope:@[]];
            });
            
            it(@"builds proper login request for Instagram login WITHOUT scope permission params", ^{
                NSString *expectedLoginURLString = [NSString stringWithFormat:@"%@%@%@",
                                                    @"https://api.instagram.com/oauth/authorize/",
                                                    @"?client_id=schlitz-blue-bull&client=touch",
                                                    @"&redirect_uri=https://bluebull.32oz&response_type=code"];
                
                expect(request.URL.absoluteString).to.equal(expectedLoginURLString);
            });
        });
        
        context(@"nil scope permissions", ^{
            beforeEach(^{
                request = [utils buildLoginRequestWithPermissionScope:nil];
            });
            
            it(@"builds proper login request for Instagram login WITHOUT scope permission params", ^{
                NSString *expectedLoginURLString = [NSString stringWithFormat:@"%@%@%@",
                                                    @"https://api.instagram.com/oauth/authorize/",
                                                    @"?client_id=schlitz-blue-bull&client=touch",
                                                    @"&redirect_uri=https://bluebull.32oz&response_type=code"];
                
                expect(request.URL.absoluteString).to.equal(expectedLoginURLString);
            });
        });
    });
    
    describe(@"#requestHasAuthCode:", ^{
        __block BOOL requestContainsAuthCode;
        __block NSURLRequest *nonFancyURLRequest;
        
        context(@"request contains auth code", ^{
            describe(@"request passed in has a '/' between the auth code parameter", ^{
                beforeEach(^{
                    utils.callbackURL = [NSURL URLWithString:@"https://bluebull.32oz/"];
                    nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://bluebull.32oz/?code=buck"]];
                    requestContainsAuthCode = [utils requestHasAuthCode:nonFancyURLRequest];
                });
                
                it(@"returns YES", ^{
                    expect(requestContainsAuthCode).to.beTruthy();
                });
            });
            
            describe(@"equest passed DOES NOT have a '/' between the auth code parameter", ^{
                beforeEach(^{
                    utils.callbackURL = [NSURL URLWithString:@"https://bluebull.32oz/whocares.html"];
                    nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://bluebull.32oz/whocares.html?code=buck"]];
                    requestContainsAuthCode = [utils requestHasAuthCode:nonFancyURLRequest];
                });
                
                it(@"returns YES", ^{
                    expect(requestContainsAuthCode).to.beTruthy();
                });
            });
        });
        
        context(@"request DOES NOT contain auth code", ^{
            beforeEach(^{
                nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://bluebull.32oz/"]];
                requestContainsAuthCode = [utils requestHasAuthCode:nonFancyURLRequest];
            });
            
            it(@"returns NO", ^{
                expect(requestContainsAuthCode).to.beFalsy();
            });
        });
    });
    
    describe(@"#authCodeFromRequest:", ^{
        __block NSString *authCode;
        
        describe(@"request passed in has a '/' between the auth code parameter", ^{
            beforeEach(^{
                utils.callbackURL = [NSURL URLWithString:@"https://bluebull.32oz/"];
                NSURLRequest *nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://bluebull.32oz/?code=7awe-50me"]];
                authCode = [utils authCodeFromRequest:nonFancyURLRequest];
            });
            
            it(@"returns the auth code", ^{
                expect(authCode).to.equal(@"7awe-50me");
            });
        });
    
        describe(@"request passed DOES NOT have a '/' between the auth code parameter", ^{
            beforeEach(^{
                utils.callbackURL = [NSURL URLWithString:@"https://bluebull.32oz/whatever.html"];
                NSURLRequest *nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://bluebull.32oz/whatever.html?code=7awe-50me2"]];
                authCode = [utils authCodeFromRequest:nonFancyURLRequest];
            });
            
            it(@"returns the auth code", ^{
                expect(authCode).to.equal(@"7awe-50me2");
            });
        });
    });
});

SpecEnd