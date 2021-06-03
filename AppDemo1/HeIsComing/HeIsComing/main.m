//
//  main.m
//  test000
//
//  Created by silk on 2020/2/19.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) { 
    NSString * appDelegateClassName;
    @autoreleasepool {

        // Se tup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
