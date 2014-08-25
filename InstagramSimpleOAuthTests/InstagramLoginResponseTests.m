#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "InstagramLoginResponse.h"


SpecBegin(InstagramLoginResponseTests)

describe(@"InstagramLoginResponse", ^{
    __block InstagramLoginResponse *loginResponse;
    
    beforeEach(^{
        loginResponse = [[InstagramLoginResponse alloc] init];
        loginResponse.authToken = @"arcade token";
    });
    
    it(@"has an auth token", ^{
        expect(loginResponse.authToken).to.equal(@"arcade token");
    });
});

SpecEnd