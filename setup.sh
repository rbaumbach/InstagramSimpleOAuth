#!/bin/bash

# Install Gem Dependencies
bundle

# Install Project Dependencies
bundle exec pod install
bundle exec carthage bootstrap --platform iOS
