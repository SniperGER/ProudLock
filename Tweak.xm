@interface SBDashBoardProudLockViewController : UIViewController
- (void)_setIconVisible:(BOOL)arg1 animated:(BOOL)arg2;
- (void)_setIconState:(long long)arg1 animated:(BOOL)arg2;

@end

@interface SBUIProudLockIconView : UIView {
	UIView* _lockView;
}
@end


@interface SBDashBoardViewController : UIViewController {
	SBDashBoardProudLockViewController* _proudLockViewController;
}
@end

@interface SBDashBoardView : UIView {
	SBUIProudLockIconView* _proudLockIconView;
}
@end

SBDashBoardProudLockViewController* proudLockViewController;

%hook SBDashBoardViewController
- (void)loadView {
	proudLockViewController = MSHookIvar<SBDashBoardProudLockViewController*>(self,"_proudLockViewController");
	if (!proudLockViewController) {
		proudLockViewController = [%c(SBDashBoardProudLockViewController) new];
		MSHookIvar<SBDashBoardProudLockViewController*>(self,"_proudLockViewController") = proudLockViewController;
	}
	
	%orig;
}
%end	/// %hook SBDashBoardViewController

%hook SBDashBoardView
- (void)layoutSubviews {
	SBUIProudLockIconView* proudLockIcon = MSHookIvar<SBUIProudLockIconView*>(self,"_proudLockIconView");
	if (!proudLockIcon) {
		proudLockIcon = (SBUIProudLockIconView*)proudLockViewController.view;
		MSHookIvar<SBUIProudLockIconView*>(self,"_proudLockIconView") = proudLockIcon;
		[self addSubview:proudLockIcon];
		
		[proudLockViewController _setIconVisible:YES animated:NO];
		[proudLockViewController _setIconState:1 animated:NO];
	}
	
	%orig;
}
%end	/// %hook SBDashBoardView
