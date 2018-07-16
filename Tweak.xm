@interface SBDashBoardProudLockViewController : UIViewController
- (void)_setIconVisible:(BOOL)arg1 animated:(BOOL)arg2;
- (void)_setIconState:(long long)arg1 animated:(BOOL)arg2;
@end


@interface SBUIProudLockIconView : UIView
@end


@interface SBDashBoardViewController : UIViewController {
    SBDashBoardProudLockViewController* _proudLockViewController;
}
@end


@interface SBDashBoardView : UIView {
    SBUIProudLockIconView* _proudLockIconView;
}
@end


@interface SBFLockScreenDateView : UIView
@end


SBDashBoardProudLockViewController* proudLockViewController;
SBUIProudLockIconView* proudLockIconView;


CGRect dateViewFrame = CGRectZero;


// Create an instance of SBDashBoardProudLockViewController and add it to SBDashBoardViewController
%hook SBDashBoardViewController
- (void)loadView {
    proudLockViewController = MSHookIvar<SBDashBoardProudLockViewController*>(self, "_proudLockViewController");
    if (!proudLockViewController) {
        proudLockViewController = [%c(SBDashBoardProudLockViewController) new];
        MSHookIvar<SBDashBoardProudLockViewController*>(self,"_proudLockViewController") = proudLockViewController;
    }
    
    %orig;
}
%end    // %hook SBDashBoardViewController


// Add SBDashBoardProudLockViewController's _proudLockIconView to SBDashBoardView
%hook SBDashBoardView
- (void)layoutSubviews {
    proudLockIconView = MSHookIvar<SBUIProudLockIconView*>(self, "_proudLockIconView");
    if (!proudLockIconView) {
        proudLockIconView = (SBUIProudLockIconView*)proudLockViewController.view;
        MSHookIvar<SBUIProudLockIconView*>(self, "_proudLockIconView") = proudLockIconView;
        
        [self addSubview:proudLockIconView];
        [proudLockViewController _setIconVisible:YES animated:NO];
        [proudLockViewController _setIconState:1 animated:NO];
    }
    
    %orig;
}
%end    // %hook SBDashBoardView


// Fix unwanted transforms on iPad
// I don't know if this also happens on iPhone, but you can never know ;)
%hook SBUIProudLockIconView
- (void)setFrame:(CGRect)arg1 {
    arg1.origin.y = 53;
    %orig(arg1);
}

- (void)setTransform:(CGAffineTransform)arg1 {
    %orig(CGAffineTransformIdentity);
}
%end    // %hook SBUIProudLockIconView


// Move down the Lock Screen Clock
%hook SBFLockScreenDateView
- (void)setFrame:(CGRect)arg1 {
    if (!CGRectEqualToRect(arg1, CGRectZero) && CGRectEqualToRect(dateViewFrame, CGRectZero)) {
        dateViewFrame = arg1;
        dateViewFrame.origin.y += 35;
    }
    
    if (!CGRectEqualToRect(dateViewFrame, CGRectZero)) {
        %orig(dateViewFrame);
    } else {
        %orig;
    }
}
%end    // %hook SBFLockScreenDateView


// Fix glitches when Lock Screen fade animation starts
%hook SBFLockScreenDateSubtitleView
- (void)setFrame:(CGRect)arg1 {
    if (!CGRectEqualToRect(dateViewFrame, CGRectZero)) {
        CGRect dateSubtitleFrame = CGRectMake(arg1.origin.x,
                                              dateViewFrame.size.height - arg1.size.height,
                                              arg1.size.width,
                                              arg1.size.height);
        %orig(dateSubtitleFrame);
    } else {
        %orig;
    }
}
%end    // %hook SBFLockScreenDateView


// Load a fixed CAML bundle with @2x assets
%hook SBUICAPackageView
- (id)initWithPackageName:(id)arg1 inBundle:(id)arg2 {
    NSBundle* themeBundle = [NSBundle bundleWithPath:@"/Library/Application Support/ProudLock/biglock_fixed.bundle"];
    return %orig(@"biglock_fixed", themeBundle);
}
%end    // %hook SBUICAPackageView


// Fix notifications offset
%hook NCNotificationListCollectionView
- (void)setContentInset:(UIEdgeInsets)arg1 {
    arg1.top = 240;
    %orig(arg1);
}
%end    // %hook NCNotificationListCollectionView


// Fix widgets offset on Lock Screen only
%hook UIScrollView
- (void)setContentInset:(UIEdgeInsets)arg1 {
    if ([self.delegate isKindOfClass:%c(WGMajorListViewController)] && arg1.top == 205) {
        arg1.top = 240;
    }
    
    %orig(arg1);
}
%end    // %hook UIScrollView
