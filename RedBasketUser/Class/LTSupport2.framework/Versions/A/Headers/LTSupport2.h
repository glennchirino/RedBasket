//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <Foundation/Foundation.h>

// guard against usage in non-ARC-projects
#if __has_feature(objc_arc)
#else
    #error This library is only available in automated reference counting (ARC) mode
#endif

// low level
#import "late_macros.h"
#import "late_debug.h"
#import "late_platforms.h"

// categories
#import "NSArray+Extensions.h"
#import "NSData+Hashing.h"
#import "NSData+Stringification.h"
#import "NSDateFormatter+LaTe.h"
#import "NSDate+ISO8601.h"
#import "NSDate+LaTe.h"
#import "NSDictionary+Extensions.h"
#import "NSFileManager+Extensions.h"
#import "NSMutableArray+Extensions.h"
#import "NSMutableURLRequest+Extensions.h"
#import "NSObject+BlockInvoke.h"
#import "NSObject+ObjectAssociation.h"
#import "NSObject+PerformBlockExtensions.h"
#import "NSObject+Persistence.h"
#import "NSString+Extensions.h"
#import "NSTimer+Blocks.h"
#import "NSURL+Extensions.h"
#import "SKProduct+PriceLocalization.h"
#import "UIApplication+LaTe.h"
#import "UIBarButtonItem+LaTe.h"
#import "UIButton+Extensions.h"
#import "UIColor+LaTe.h"
#import "UIControl+Blocks.h"
#import "UIDevice+LaTe.h"
#import "UIFont+LaTe.h"
#import "UIGestureRecognizer+Extensions.h"
#import "UIImage+Alpha.h"
#import "UIImage+Extensions.h"
#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Tint.h"
#import "UIImageView+Extensions.h"
#import "UILabel+Extensions.h"
#import "UINavigationController+Extensions.h"
#import "UINib+LTTableViewCellLoading.h"
#import "UIScrollView+Extensions.h"
#import "UISearchBar+Extensions.h"
#import "UITableView+Extensions.h"
#import "UITableViewCell+LaTe.h"
#import "UIView+Extensions.h"
#import "UIViewController+Extensions.h"
#import "UIWebView+Extensions.h"
#import "UIWindow+ControllerTransitions.h"
#import "UIWindow+Debugging.h"
#import "UIWindow+VisualMoveQue.h"

// data sources
#import "LTMultiSectionsDataSource.h"
#import "LTPlistTableViewDataSource.h"
#import "LTPlistTableViewSectionDataSource.h"
#import "LTPropertySheetTableViewDataSource.h"
#import "LTSimpleQuicklookDataSource.h"
#import "LTStaticTableViewDataSource.h"
#import "LTTableViewDataSource.h"

// data structures
#import "LTMutableDictionary.h"
#import "LTSerializableObject.h"

// database
#import "LTDataBase.h"

// formatters
#import "LTDateFormatter.h"
#import "LTNumberFormatter.h"

// 3rdparty
// don't import iCarousel.h in the global header, it does _NASTY_ _NASTY_ things like redefining release, retain, etc.
//#import "iCarousel.h"
#import "CoolButton.h"
#import "MBProgressHUD.h"
#import "TBXML.h"
#import "TDBadgedCell.h"
#import "TMReachability.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "TPKeyboardAvoidingTableView.h"
#import "SBJson.h"
#import "NICInfo.h"
#import "NICInfoSummary.h"

// 3rdparty extensions
#import "MBProgressHUD+LaTe.h"
#import "TBXML+LaTe.h"

// views
#import "LTActionSheet.h"
#import "LTAlertView.h"
#import "LTArcTextLabel.h"
#import "LTDashboardCloseButton.h"
#import "LTEmptyView.h"
#import "LTGradientView.h"
#import "LTImageView.h"
#import "LTLabel.h"
#import "LTLazyImageView.h"
#import "LTMarqueeView.h"
#import "LTNavigationBar.h"
#import "LTPieView.h"
#import "LTRemoteControlWindow.h"
#import "LTPullToRefreshView.h"
#import "LTScrollView.h"
#import "LTScrollViewAuxiliaryView.h"
#import "LTSimplePDFRenderingView.h"
#import "LTSimplePickerView.h"
#import "LTTableView.h"
#import "LTTextField.h"
#import "LTToolbar.h"
#import "LTWindow.h"

// view controllers
#import "LTChoiceViewController.h"
#import "LTFormViewController.h"
#import "LTMultiChoiseViewController.h"
#import "LTNavigationController.h"
#import "LTQLPreviewController.h"
#import "LTSplashScreenController.h"
#import "LTTableViewController.h"
#import "LTViewController.h"
#import "LTWebViewController.h"

// audio
#import "LTAudioEventManager.h"
#import "LTAudioSession.h"
#import "LTAudioStreamer.h"
#import "LTAudioStreamerStation.h"

// misc
#import "LTApplication.h"
#import "LTAppRatingReminder.h"
#import "LTAppStoreProductViewController.h"
#import "LTClock.h"
#import "LTCloudUserDefaults.h"
#import "LTCustomUIActivity.h"
#import "LTKeychainWrapper.h"
#import "LTResourceCache.h"
#import "LTFormHandler.h"

// networking
#import "LTAppStoreLookup.h"
#import "LTDownloadManager.h"
#import "LTGoogleAPI.h"
#import "LTImageFinder.h"
#import "LTNetworking.h"

// tracking
#import "LTEventTracker.h"
#import "LTInfrastructureClient.h"
#import "LTTrackingEvent.h"
#import "LTTrackingService.h"

