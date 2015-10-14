//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (LaTe)

+(MBProgressHUD*)executeTaskInBackgroundWhileShowingHUDForView:(UIView*)v animated:(BOOL)yesOrNo usingBlock:(void (^)(void))block;


@end
