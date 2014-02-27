#import <UIKit/UIKit.h>

/***************************** Forward-Declarations *****************************/

@interface PLWallpaperImageViewController : UIViewController <UIActionSheetDelegate> {
    UIActionSheet *_wallpaperOptionsSheet;
}
@end

@interface PLStaticWallpaperImageViewController : PLWallpaperImageViewController
@end

/******************************* Custom Category ********************************/

@interface PLStaticWallpaperImageViewController (Homepaper) <UIAlertViewDelegate> 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

/****************************** UIActionSheet Hook ******************************/

%hook UIActionSheet

- (void)showInView:(UIView *)view{
    if([self.delegate isKindOfClass:%c(PLStaticWallpaperImageViewController)]){
        NSLog(@"[Homepaper] Detected wallpaper action sheet tentative deployment, overriding...");
        UIAlertView *replacement = [[UIAlertView alloc] initWithTitle:@"Set Home Screen" message:@"Are you sure you want to set this picture as your Home Screen wallpaper?" delegate:self.delegate cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [replacement show];
        [replacement release];
    }

    else{
        NSLog(@"[Homepaper] Detected action sheet tentative deployment, but it's not trying to set wallpaper, ignoring...");
        %orig();
    }
}

%end

%hook PLWallpaperImageViewController

%new - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIActionSheet *originalSheet = MSHookIvar<UIActionSheet *>(self, "_wallpaperOptionsSheet");

    if(buttonIndex != alertView.cancelButtonIndex){
        NSLog(@"[Homepaper] Setting Home Screen wallpaper (faking %@)...", originalSheet);
        [self actionSheet:originalSheet clickedButtonAtIndex:originalSheet.firstOtherButtonIndex+1];
    }

    else{
        NSLog(@"[Homepaper] Cancelling set of Home Screen wallpaper (faking %@)...", originalSheet);
        [self actionSheet:originalSheet clickedButtonAtIndex:originalSheet.cancelButtonIndex];
    }
}

%end