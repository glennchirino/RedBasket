//
//  constant.h
//  Order
//
//  Created by glenn on 2/24/15.
//  Copyright (c) 2015 glenn. All rights reserved.
//

#ifndef Order_constant_h
#define Order_constant_h



#define API_URL @"http://app.redbasket.net/api/"
#define SERVER_IP @"http://app.redbasket.net"

#define TWITTER_POST_FEED @"https://api.twitter.com/1.1/statuses/update.json"
#define TWITTER_POST_MEDIA @"https://api.twitter.com/1.1/statuses/update_with_media.json"

#define APP_RED_COLOR [UIColor colorWithRed:198/255.0f green:15/255.0f blue:37.0f/255.0f alpha:1.0f]
#define APP_PINK_COLOR [UIColor colorWithRed:250/255.0f green:190/255.0f blue:200.0f/255.0f alpha:1.0f] 

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define PAYPAL_SANDBOX_APPID  @"APP-80W284485P519543T"  // Sandbox Account
#define PAYPAL_LIVE_APPID @"APP-0GF14287FJ478505R"  // Live Account
#define PAYPAL_LIVE_FLAG  NO


/////////      Action Names   ////////////////

#define USER_SIGNIN @"userSignIn"
#define USER_LOCATION_UPDATE @"userLocationUpdate"
#define SAVE_USER_PREFERENCE @"saveUserPreference"
#define GET_STORES @"getStoreList"
#define GET_ORDERNUMBER @"getOrderNumber"
#define ADD_ORDER @"addOrder"
#define GET_ORDERHISTORY @"getUserOrderList"
#define GET_USERDATA @"getUserData"
#define GET_STOREDATA @"getStoreData"

///////////   Segue Name    ///////////

#define GOTO_LISTVIEW @"gotoStoreList"
#define GOTO_MAPVIEW @"gotoMapView"
#define GOTO_STOREVIEW @"gotoStoreView"
#define GOTO_MAP_STOREVIEW @"gotoStoreViewFromMap"
#define GOTO_CHECKOUTVIEW @"gotoCheckoutView"
#define GOTO_RECEIPTVIEW @"gotoReceiptView"


// Notification

#define   UPDATE_EXPIRE_TIMER @"UPDATE_EXPIRE_TIMER"

#endif
