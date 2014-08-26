#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "FakeInstagramAuthResponse.h"
#import "InstagramSimpleOAuth.h"


SpecBegin(InstagramLoginResponseTests)

describe(@"InstagramLoginResponse", ^{
    __block InstagramLoginResponse *loginResponse;
    
    beforeEach(^{
        loginResponse = [[InstagramLoginResponse alloc] initWithInstagramAuthResponse:[FakeInstagramAuthResponse response]];
    });
    
    describe(@"init", ^{
        it(@"calls -initWithInstagramAuthResponse:", ^{
            loginResponse = [[InstagramLoginResponse alloc] init];
            expect(loginResponse.authToken).to.beNil();
            expect(loginResponse.user).to.beNil();
        });
    });
    
    it(@"has an auth token", ^{
        expect(loginResponse.authToken).to.equal(@"12345IdiotLuggageCombo");
    });
    
    it(@"has an Instagram user", ^{
        expect(loginResponse.user.userID).to.equal(@"yepyepyep");
        expect(loginResponse.user.username).to.equal(@"og-gsta");
        expect(loginResponse.user.fullName).to.equal(@"Ice Cube");
        expect(loginResponse.user.profilePictureURL).to.equal([NSURL URLWithString:@"http://uh.yeah.yuuueaaah.com/og-gsta"]);
    });
});

SpecEnd