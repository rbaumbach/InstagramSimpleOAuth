# InstagramSimpleOAuth [![Build Status](https://img.shields.io/travis/rbaumbach/InstagramSimpleOAuth.svg)](https://travis-ci.org/rbaumbach/InstagramSimpleOAuth) [![Cocoapod Version](https://img.shields.io/cocoapods/v/InstagramSimpleOAuth.svg)](http://cocoapods.org/?q=InstagramSimpleOAuth) [![Cocoapod Platform](https://img.shields.io/badge/platform-iOS-blue.svg)](http://cocoapods.org/?q=InstagramSimpleOAuth) [![License](https://img.shields.io/dub/l/vibe-d.svg)](https://github.com/rbaumbach/InstagramSimpleOAuth/blob/master/MIT.LICENSE)

A quick and simple way to authenticate an Instagram user in your iPhone or iPad app.

<p align="center">
   <img src="https://github.com/rbaumbach/InstagramSimpleOAuth/blob/master/iPhone5Screenshot.jpg?raw=true" alt="iPhone5 Screenshot"/>
   <img src="https://github.com/rbaumbach/InstagramSimpleOAuth/blob/master/iPadScreenshot.jpg?raw=true" alt="iPad Screenshot"/>
</p>

## Adding InstagramSimpleOAuth to your project

### Cocoapods

[CocoaPods](http://cocoapods.org) is the recommended way to add InstagramSimpleOAuth to your project.

1.  Add InstagramSimpleOAuth to your Podfile `pod 'InstagramSimpleOAuth'`.
2.  Install the pod(s) by running `pod install`.
3.  Add InstagramSimpleOAuth to your files with `#import <InstagramSimpleOAuth/InstagramSimpleOAuth.h>`.

### Clone from Github

1.  Clone repository from github and copy files directly, or add it as a git submodule.
2.  Add all files from 'Source' directory to your project (as well as the dependencies listed in the Podfile).

## How To

* Create an instance of `InstagramSimpleOAuthViewController` and pass in an [Instagram client ID, client secret, client callback URL](http://instagram.com/developer/register/#) and completion block to be executed with `InstagramLoginResponse` and `NSError` arguments.
* Once the instance of `InstagramSimpleOAuthViewController` is presented (either as a modal or pushed on the navigation stack), it will allow the user to login.  After the user logs in, the completion block given in the initialization of the view controller will be executed.  The argument in the completion block, `InstagramLoginResponse`, contains an accessToken and other login information for the authenticated user provided by [Instagram API Response](http://instagram.com/developer/authentication/).  If there is an issue attempting to authenticate, an error will be given instead.
* By default, if there are issues with authentication, an UIAlertView will be given to the user.  To disable this, and rely on the NSError directly, set the property `shouldShowErrorAlert` to NO.
* The default Instagram scope permissions for authentication are 'basic.'  If additional permissions are needed, the permissions can be set using the `permissionScope` property.
* Note: Even though an instance of the view controller itself can be initalized without client ID, client secret, client callback and completion block (to help with testing), this data must be set using the view controller's properties before it is presented to the user.

### Example Usage

```objective-c
// Simplest Example:

InstagramSimpleOAuthViewController
    *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"123I_am_a_client_id_567890"
                                                                      clientSecret:@"shhhhhh, I'm a secret"
                                                                       callbackURL:[NSURL URLWithString:@"http://your.fancy.site"]
                                                                        completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                            NSLog(@"My Access Token is: %@", response.accessToken);
                                                                        }];
[self.navigationController pushViewController:viewController
                                     animated:YES];

// Authenticate with all scope permissions and disable error UIAlertViews Example:

InstagramSimpleOAuthViewController
    *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"clients_r_us"
                                                                      clientSecret:@"shhhhhh, don't tell"
                                                                       callbackURL:[NSURL URLWithString:@"http://your.non.fancy.site"]
                                                                        completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                            NSLog(@"My Username is: %@", response.user.username);
                                                                        }];
viewController.shouldShowErrorAlert = NO;
viewController.permissionScope = @[@"basic", @"comments", @"relationships", @"likes"];

[self.navigationController pushViewController:viewController
                                     animated:YES];
```

## Testing

* Prerequisites: [ruby](https://github.com/sstephenson/rbenv), [ruby gems](https://rubygems.org/pages/download), [bundler](http://bundler.io)

This project has been setup to use [fastlane](https://fastlane.tools) to run the tests.

First, run the setup.sh script to bundle required gems and cocoapods when in the project directory:

```bash
$ ./setup.sh
```

And then use fastlane to run the tests on the command line:

```bash
$ bundle exec fastlane test
```

## Version History

Version history can be found at the [InstagramSimpleOAuth wiki](https://github.com/rbaumbach/InstagramSimpleOAuth/wiki/Version-History).

## Suggestions, requests, and feedback

Thanks for checking out InstagramSimpleOAuth for your in-app Instagram Authentication.  Any feedback can be can be sent to: github@ryan.codes.
