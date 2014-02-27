#import <UIKit/UIKit.h>

/***************************** Forward-Declarations *****************************/

@interface PLUIImageViewController : UIViewController
- (id)cropOverlay;
@end

@interface PLWallpaperImageViewController : PLUIImageViewController <UIActionSheetDelegate> {
    UIActionSheet *_wallpaperOptionsSheet;
}

- (void)setImageAsHomeScreenClicked:(id)arg1;
- (void)cropOverlayWasCancelled:(id)arg1;
- (void)cropOverlayWasOKed:(id)arg1;
@end

@interface PLStaticWallpaperImageViewController : PLWallpaperImageViewController
@end

/******************************* Custom Category ********************************/

@interface PLWallpaperImageViewController (Homepaper) <UIAlertViewDelegate> 
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIActionSheet *originalSheet = MSHookIvar<UIActionSheet *>(self, "_wallpaperOptionsSheet");

    if(buttonIndex != alertView.cancelButtonIndex){
        NSLog(@"[Homepaper] Setting Home Screen wallpaper (faking %@)...", originalSheet);
        [self actionSheet:originalSheet clickedButtonAtIndex:originalSheet.firstOtherButtonIndex];
    }

    else{
        NSLog(@"[Homepaper] Cancelling set of Home Screen wallpaper (faking %@)...", originalSheet);
        [self actionSheet:originalSheet clickedButtonAtIndex:originalSheet.cancelButtonIndex];
    }
}

%end