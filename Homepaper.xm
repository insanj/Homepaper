#import <UIKit/UIKit.h>

%hook UIActionSheet

- (NSInteger)addButtonWithTitle:(NSString *)title{
    if ([title isEqualToString:@"Set Lock Screen"]) {
        NSLog(@"[Homepaper] Detected tentative addition of option <%@>, preventing...", title);
        return 0;
    }

    return %orig();
}

%end