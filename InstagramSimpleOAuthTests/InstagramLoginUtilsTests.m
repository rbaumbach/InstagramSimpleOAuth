#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "InstagramLoginUtils.h"


SpecBegin(InstagramLoginUtilsTests)

describe(@"InstagramLoginUtils", ^{
    __block InstagramLoginUtils *utils;
    
    beforeEach(^{
        utils = [[InstagramLoginUtils alloc] init];
    });
    
    describe(@"#buildLoginRequestWithClientID:callbackURL:", ^{
        __block NSURLRequest *request;
        
        beforeEach(^{
            request = [utils buildLoginRequestWithClientID:@"schlitz-blue-bull"
                                               callbackURL:[NSURL URLWithString:@"https://bluebull.32oz"]];
        });
        
        it(@"builds proper login request for Instagram login", ^{
            NSString *expectedLoginURLString =
            @"https://api.instagram.com/oauth/authorize/?client_id=schlitz-blue-bull&client=touch&redirect_uri=https://bluebull.32oz&response_type=code";
            
            expect(request.URL.absoluteString).to.equal(expectedLoginURLString);
        });
    });
    
    describe(@"#request:hasAuthCodeWithCallbackURL:", ^{
        __block BOOL requestContainsAuthCode;
        __block NSURL *callbackURL;
        __block NSURLRequest *nonFancyURLRequest;
        
        context(@"request contains auth code", ^{
            beforeEach(^{
                callbackURL = [NSURL URLWithString:@"http://fluffy.dogs"];
                nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://fluffy.dogs/?code=buck"]];
                requestContainsAuthCode = [utils request:nonFancyURLRequest hasAuthCodeWithCallbackURL:callbackURL];
            });
            
            it(@"returns YES", ^{
                expect(requestContainsAuthCode).to.beTruthy();
            });
        });
        
        context(@"request DOES NOT contain auth code", ^{
            beforeEach(^{
                callbackURL = [NSURL URLWithString:@"http://fluffy.dogs"];
                nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://short.haired.dogs/?code=pancho"]];
                requestContainsAuthCode = [utils request:nonFancyURLRequest hasAuthCodeWithCallbackURL:callbackURL];
            });
            
            it(@"returns NO", ^{
                expect(requestContainsAuthCode).to.beFalsy();
            });
        });
    });
    
    describe(@"#authCodeFromRequest:withCallbackURL:", ^{
        __block NSString *authCode;
        
        beforeEach(^{
            NSURL *callbackURL = [NSURL URLWithString:@"http://dogs.with.booze.woof"];
            NSURLRequest *nonFancyURLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://dogs.with.booze.woof/?code=7awe-50me"]];
            authCode = [utils authCodeFromRequest:nonFancyURLRequest withCallbackURL:callbackURL];
        });
        
        it(@"returns the auth code", ^{
            expect(authCode).to.equal(@"7awe-50me");
        });
    });
});

SpecEnd