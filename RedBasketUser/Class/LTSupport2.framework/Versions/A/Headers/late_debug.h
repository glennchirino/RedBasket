//
//  Copyright (c) Lauer, Teuber GbR. All rights reserved.
//

#import <pthread.h>
#import <sys/time.h>
#import <assert.h>
#import <stdbool.h>
#import <sys/types.h>
#import <unistd.h>
#import <sys/sysctl.h>
#import <objc/runtime.h>

#import <UIKit/UIKit.h>

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

#define MakeColor(r,g,b) ( [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0] )

#define LATEDEBUG_NORMAL
//#define LATEDEBUG_FILE
//#define LATEDEBUG_COLOR

#define LATEDEBUG_FILE_FOLDER [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#pragma mark - Helpers

static BOOL isBeingRunWithDebuggerAttached()
{
    // Returns true if the current process is being debugged (either
    // running under the debugger or has a debugger attached post facto).
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag = 0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

static NSArray* __ltcolorArray;
static NSMutableDictionary* __ltthreadColorMap;
static NSMutableDictionary* __ltthreadNumberMap;
static NSDateFormatter* __ltdateFormatter;

static void initDebugSystem()
{
    NSMutableArray* m_colors = [[NSMutableArray alloc] init];
    
    [m_colors addObject:MakeColor( 0, 0, 0 )];
	[m_colors addObject:MakeColor( 60,  42, 144)];
	[m_colors addObject:MakeColor(140,  48,  40)];
	[m_colors addObject:MakeColor( 88,  51, 255)];
	[m_colors addObject:MakeColor( 42, 128,  37)];
	[m_colors addObject:MakeColor( 59, 124, 245)];
	[m_colors addObject:MakeColor( 66, 123, 255)];
	[m_colors addObject:MakeColor( 45, 159, 240)];
	[m_colors addObject:MakeColor(135,  52, 177)];
    
	[m_colors addObject:MakeColor( 31, 196,  37)];
	[m_colors addObject:MakeColor( 48, 196, 115)];
	[m_colors addObject:MakeColor( 39, 195, 155)];
	[m_colors addObject:MakeColor( 49, 195, 195)];
	[m_colors addObject:MakeColor( 32, 194, 235)];
	[m_colors addObject:MakeColor( 53, 193, 255)];
    
	[m_colors addObject:MakeColor( 50, 229,  35)];
	[m_colors addObject:MakeColor( 40, 229, 109)];
	[m_colors addObject:MakeColor( 27, 229, 149)];
	[m_colors addObject:MakeColor( 49, 228, 189)];
	[m_colors addObject:MakeColor( 33, 228, 228)];
	[m_colors addObject:MakeColor( 53, 227, 255)];
    
	[m_colors addObject:MakeColor( 27, 254,  30)];
	[m_colors addObject:MakeColor( 30, 254, 103)];
	[m_colors addObject:MakeColor( 45, 254, 143)];
	[m_colors addObject:MakeColor( 38, 253, 182)];
	[m_colors addObject:MakeColor( 38, 253, 222)];
	[m_colors addObject:MakeColor( 42, 253, 252)];
    
	[m_colors addObject:MakeColor(140,  48,  40)];
	[m_colors addObject:MakeColor(136,  51, 136)];
	[m_colors addObject:MakeColor(135,  56, 248)];
	[m_colors addObject:MakeColor(134,  53, 255)];
    
	[m_colors addObject:MakeColor(125, 125,  38)];
	[m_colors addObject:MakeColor(124, 125, 125)];
	[m_colors addObject:MakeColor(122, 124, 166)];
	[m_colors addObject:MakeColor(123, 124, 207)];
	[m_colors addObject:MakeColor(123, 122, 247)];
	[m_colors addObject:MakeColor(124, 121, 255)];
    
	[m_colors addObject:MakeColor(119, 160,  35)];
	[m_colors addObject:MakeColor(117, 160, 120)];
	[m_colors addObject:MakeColor(117, 160, 160)];
	[m_colors addObject:MakeColor(115, 159, 201)];
	[m_colors addObject:MakeColor(116, 158, 240)];
	[m_colors addObject:MakeColor(117, 157, 255)];
    
	[m_colors addObject:MakeColor(113, 195,  39)];
	[m_colors addObject:MakeColor(110, 194, 114)];
	[m_colors addObject:MakeColor(111, 194, 154)];
	[m_colors addObject:MakeColor(108, 194, 194)];
	[m_colors addObject:MakeColor(109, 193, 234)];
	[m_colors addObject:MakeColor(108, 192, 255)];
    
	[m_colors addObject:MakeColor(105, 228,  30)];
	[m_colors addObject:MakeColor(103, 228, 109)];
	[m_colors addObject:MakeColor(105, 228, 148)];
	[m_colors addObject:MakeColor(100, 227, 188)];
	[m_colors addObject:MakeColor( 99, 227, 227)];
	[m_colors addObject:MakeColor( 99, 226, 253)];
    
	[m_colors addObject:MakeColor( 92, 253,  34)];
	[m_colors addObject:MakeColor( 96, 253, 103)];
	[m_colors addObject:MakeColor( 97, 253, 142)];
	[m_colors addObject:MakeColor( 88, 253, 182)];
	[m_colors addObject:MakeColor( 93, 253, 221)];
	[m_colors addObject:MakeColor( 88, 254, 251)];
    
	[m_colors addObject:MakeColor(177,  53,  34)];
	[m_colors addObject:MakeColor(174,  54, 131)];
	[m_colors addObject:MakeColor(172,  55, 172)];
	[m_colors addObject:MakeColor(171,  57, 213)];
	[m_colors addObject:MakeColor(170,  55, 249)];
	[m_colors addObject:MakeColor(170,  57, 255)];
    
	[m_colors addObject:MakeColor(165, 123,  37)];
	[m_colors addObject:MakeColor(163, 123, 123)];
	[m_colors addObject:MakeColor(162, 123, 164)];
	[m_colors addObject:MakeColor(161, 122, 205)];
	[m_colors addObject:MakeColor(161, 121, 241)];
	[m_colors addObject:MakeColor(161, 121, 255)];
    
	[m_colors addObject:MakeColor(158, 159,  33)];
	[m_colors addObject:MakeColor(157, 158, 118)];
	[m_colors addObject:MakeColor(157, 158, 159)];
	[m_colors addObject:MakeColor(155, 157, 199)];
	[m_colors addObject:MakeColor(155, 157, 239)];
	[m_colors addObject:MakeColor(154, 156, 255)];
    
	[m_colors addObject:MakeColor(152, 193,  40)];
	[m_colors addObject:MakeColor(151, 193, 113)];
	[m_colors addObject:MakeColor(150, 193, 153)];
	[m_colors addObject:MakeColor(150, 192, 193)];
	[m_colors addObject:MakeColor(148, 192, 232)];
	[m_colors addObject:MakeColor(149, 191, 253)];
    
	[m_colors addObject:MakeColor(146, 227,  28)];
	[m_colors addObject:MakeColor(144, 227, 108)];
	[m_colors addObject:MakeColor(144, 227, 147)];
	[m_colors addObject:MakeColor(144, 227, 187)];
	[m_colors addObject:MakeColor(142, 226, 227)];
	[m_colors addObject:MakeColor(142, 225, 252)];
    
	[m_colors addObject:MakeColor(138, 253,  36)];
	[m_colors addObject:MakeColor(137, 253, 102)];
	[m_colors addObject:MakeColor(136, 253, 141)];
	[m_colors addObject:MakeColor(138, 254, 181)];
	[m_colors addObject:MakeColor(135, 255, 220)];
	[m_colors addObject:MakeColor(133, 255, 250)];
    
	[m_colors addObject:MakeColor(214,  57,  30)];
	[m_colors addObject:MakeColor(211,  59, 126)];
	[m_colors addObject:MakeColor(209,  57, 168)];
	[m_colors addObject:MakeColor(208,  55, 208)];
	[m_colors addObject:MakeColor(207,  58, 247)];
	[m_colors addObject:MakeColor(206,  61, 255)];
    
	[m_colors addObject:MakeColor(204, 121,  32)];
	[m_colors addObject:MakeColor(202, 121, 121)];
	[m_colors addObject:MakeColor(201, 121, 161)];
	[m_colors addObject:MakeColor(200, 120, 202)];
	[m_colors addObject:MakeColor(200, 120, 241)];
	[m_colors addObject:MakeColor(198, 119, 255)];
    
	[m_colors addObject:MakeColor(198, 157,  37)];
	[m_colors addObject:MakeColor(196, 157, 116)];
	[m_colors addObject:MakeColor(195, 156, 157)];
	[m_colors addObject:MakeColor(195, 156, 197)];
	[m_colors addObject:MakeColor(194, 155, 236)];
	[m_colors addObject:MakeColor(193, 155, 255)];
    
	[m_colors addObject:MakeColor(191, 192,  36)];
	[m_colors addObject:MakeColor(190, 191, 112)];
	[m_colors addObject:MakeColor(189, 191, 152)];
	[m_colors addObject:MakeColor(189, 191, 191)];
	[m_colors addObject:MakeColor(188, 190, 230)];
	[m_colors addObject:MakeColor(187, 190, 253)];
    
	[m_colors addObject:MakeColor(185, 226,  28)];
	[m_colors addObject:MakeColor(184, 226, 106)];
	[m_colors addObject:MakeColor(183, 225, 146)];
	[m_colors addObject:MakeColor(183, 225, 186)];
	[m_colors addObject:MakeColor(182, 225, 225)];
	[m_colors addObject:MakeColor(181, 224, 252)];
    
	[m_colors addObject:MakeColor(178, 255,  35)];
	[m_colors addObject:MakeColor(178, 255, 101)];
	[m_colors addObject:MakeColor(177, 254, 141)];
	[m_colors addObject:MakeColor(176, 254, 180)];
	[m_colors addObject:MakeColor(176, 254, 220)];
	[m_colors addObject:MakeColor(175, 253, 249)];
    
	[m_colors addObject:MakeColor(247,  56,  30)];
	[m_colors addObject:MakeColor(245,  57, 122)];
	[m_colors addObject:MakeColor(243,  59, 163)];
	[m_colors addObject:MakeColor(244,  60, 204)];
	[m_colors addObject:MakeColor(242,  59, 241)];
	[m_colors addObject:MakeColor(240,  55, 255)];
    
	[m_colors addObject:MakeColor(241, 119,  36)];
	[m_colors addObject:MakeColor(240, 120, 118)];
	[m_colors addObject:MakeColor(238, 119, 158)];
	[m_colors addObject:MakeColor(237, 119, 199)];
	[m_colors addObject:MakeColor(237, 118, 238)];
	[m_colors addObject:MakeColor(236, 118, 255)];
    
	[m_colors addObject:MakeColor(235, 154,  36)];
	[m_colors addObject:MakeColor(235, 154, 114)];
	[m_colors addObject:MakeColor(234, 154, 154)];
	[m_colors addObject:MakeColor(232, 154, 194)];
	[m_colors addObject:MakeColor(232, 153, 234)];
	[m_colors addObject:MakeColor(232, 153, 255)];
    
	[m_colors addObject:MakeColor(230, 190,  30)];
	[m_colors addObject:MakeColor(229, 189, 110)];
	[m_colors addObject:MakeColor(228, 189, 150)];
	[m_colors addObject:MakeColor(227, 189, 190)];
	[m_colors addObject:MakeColor(227, 189, 229)];
	[m_colors addObject:MakeColor(226, 188, 255)];
    
	[m_colors addObject:MakeColor(224, 224,  35)];
	[m_colors addObject:MakeColor(223, 224, 105)];
	[m_colors addObject:MakeColor(222, 224, 144)];
	[m_colors addObject:MakeColor(222, 223, 184)];
	[m_colors addObject:MakeColor(222, 223, 224)];
	[m_colors addObject:MakeColor(220, 223, 253)];
    
	[m_colors addObject:MakeColor(217, 253,  28)];
	[m_colors addObject:MakeColor(217, 253,  99)];
	[m_colors addObject:MakeColor(216, 252, 139)];
	[m_colors addObject:MakeColor(216, 252, 179)];
	[m_colors addObject:MakeColor(215, 252, 218)];
	[m_colors addObject:MakeColor(215, 251, 250)];
    
	[m_colors addObject:MakeColor(255,  61,  30)];
	[m_colors addObject:MakeColor(255,  60, 118)];
	[m_colors addObject:MakeColor(255,  58, 159)];
	[m_colors addObject:MakeColor(255,  56, 199)];
	[m_colors addObject:MakeColor(255,  55, 238)];
	[m_colors addObject:MakeColor(255,  59, 255)];
    
	[m_colors addObject:MakeColor(255, 117,  29)];
	[m_colors addObject:MakeColor(255, 117, 115)];
	[m_colors addObject:MakeColor(255, 117, 155)];
	[m_colors addObject:MakeColor(255, 117, 195)];
	[m_colors addObject:MakeColor(255, 116, 235)];
	[m_colors addObject:MakeColor(254, 116, 255)];
    
	[m_colors addObject:MakeColor(255, 152,  27)];
	[m_colors addObject:MakeColor(255, 152, 111)];
	[m_colors addObject:MakeColor(254, 152, 152)];
	[m_colors addObject:MakeColor(255, 152, 192)];
	[m_colors addObject:MakeColor(254, 151, 231)];
	[m_colors addObject:MakeColor(253, 151, 253)];
    
	[m_colors addObject:MakeColor(255, 187,  33)];
	[m_colors addObject:MakeColor(253, 187, 107)];
	[m_colors addObject:MakeColor(252, 187, 148)];
	[m_colors addObject:MakeColor(253, 187, 187)];
	[m_colors addObject:MakeColor(254, 187, 227)];
	[m_colors addObject:MakeColor(252, 186, 252)];
    
	[m_colors addObject:MakeColor(252, 222,  34)];
	[m_colors addObject:MakeColor(251, 222, 103)];
	[m_colors addObject:MakeColor(251, 222, 143)];
	[m_colors addObject:MakeColor(250, 222, 182)];
	[m_colors addObject:MakeColor(251, 221, 222)];
	[m_colors addObject:MakeColor(252, 221, 252)];
    
	[m_colors addObject:MakeColor(251, 252,  15)];
	[m_colors addObject:MakeColor(251, 252,  97)];
	[m_colors addObject:MakeColor(249, 252, 137)];
	[m_colors addObject:MakeColor(247, 252, 177)];
	[m_colors addObject:MakeColor(247, 253, 217)];
	[m_colors addObject:MakeColor(254, 255, 255)];
    
	// Grayscale
    
	[m_colors addObject:MakeColor( 52,  53,  53)];
	[m_colors addObject:MakeColor( 57,  58,  59)];
	[m_colors addObject:MakeColor( 66,  67,  67)];
	[m_colors addObject:MakeColor( 75,  76,  76)];
	[m_colors addObject:MakeColor( 83,  85,  85)];
	[m_colors addObject:MakeColor( 92,  93,  94)];
    
	[m_colors addObject:MakeColor(101, 102, 102)];
	[m_colors addObject:MakeColor(109, 111, 111)];
	[m_colors addObject:MakeColor(118, 119, 119)];
	[m_colors addObject:MakeColor(126, 127, 128)];
	[m_colors addObject:MakeColor(134, 136, 136)];
	[m_colors addObject:MakeColor(143, 144, 145)];
    
	[m_colors addObject:MakeColor(151, 152, 153)];
	[m_colors addObject:MakeColor(159, 161, 161)];
	[m_colors addObject:MakeColor(167, 169, 169)];
	[m_colors addObject:MakeColor(176, 177, 177)];
	[m_colors addObject:MakeColor(184, 185, 186)];
	[m_colors addObject:MakeColor(192, 193, 194)];
    
	[m_colors addObject:MakeColor(200, 201, 202)];
	[m_colors addObject:MakeColor(208, 209, 210)];
	[m_colors addObject:MakeColor(216, 218, 218)];
	[m_colors addObject:MakeColor(224, 226, 226)];
	[m_colors addObject:MakeColor(232, 234, 234)];
	[m_colors addObject:MakeColor(240, 242, 242)];
    
    __ltcolorArray = [[NSArray alloc] initWithArray:m_colors];
    __ltthreadColorMap = [NSMutableDictionary dictionary];
    __ltthreadNumberMap = [NSMutableDictionary dictionary];
    
    __ltdateFormatter = [[NSDateFormatter alloc] init];
    __ltdateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss.SSS";
}

static NSInteger currentThreadNumber()
{
    NSNumber* key = [NSNumber numberWithUnsignedInt:*(unsigned int *)pthread_self()];
    NSNumber* logNumberForThread = [__ltthreadNumberMap objectForKey:key];
    if ( !logNumberForThread )
    {
        NSString* threadString = [[NSThread currentThread] description];
        NSRange numRange = [threadString rangeOfString:@"num = "];
        NSUInteger numLength = [threadString length] - numRange.location - numRange.length;
        numRange.location = numRange.location + numRange.length;
        numRange.length   = numLength - 1;
        
        threadString = [threadString substringWithRange:numRange];
        logNumberForThread = [NSNumber numberWithInteger:[threadString integerValue]];
        [__ltthreadNumberMap setObject:logNumberForThread forKey:key];
    }
    return [logNumberForThread integerValue];
}

#pragma mark - File Logging

#define LT_FILE_LOG_HANDLE_ASSOCIATION_KEY (void*)0xdeffbeff
#define LT_FILE_LOG_NAME_ASSOCIATION_KEY (void*)0xdeffbfff

#define LT_FILE_LOG_CURRENT_FILENAME (NSString*)objc_getAssociatedObject([UIApplication sharedApplication], LT_FILE_LOG_NAME_ASSOCIATION_KEY)

static void LTFileLog( NSString* format, ... )
{
    FILE* fileHandle = (FILE*) [objc_getAssociatedObject([UIApplication sharedApplication], LT_FILE_LOG_HANDLE_ASSOCIATION_KEY) pointerValue];
    if ( !fileHandle )
    {
        struct tm ts;
        char filename[256];
        time_t current_time;
        time( &current_time );
        ts = *localtime( &current_time );
        strftime( filename, sizeof(filename), "%y%m%d_%H%M%S", &ts );
        NSString* string = [NSString stringWithFormat:@"%@/%s.log", LATEDEBUG_FILE_FOLDER, filename];
        objc_setAssociatedObject([UIApplication sharedApplication], LT_FILE_LOG_NAME_ASSOCIATION_KEY, string, OBJC_ASSOCIATION_RETAIN);
        NSLog( @"*** LT DEBUG FILE for this session at %@", string );
        fileHandle = fopen( string.UTF8String, "w" );
        assert( fileHandle );
        objc_setAssociatedObject([UIApplication sharedApplication], LT_FILE_LOG_HANDLE_ASSOCIATION_KEY, [NSValue valueWithPointer:fileHandle], OBJC_ASSOCIATION_RETAIN);
    }

    va_list ap;
    NSString *print;
    va_start( ap, format );
    print = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end( ap );
    
    fprintf( fileHandle, "%s: %s\r\n", [[[NSDate date] description] UTF8String], [print UTF8String] );
    
    NSLog( @"%@", print );
}

#pragma mark - TTY Logging

static void LTTTyLog( NSString* format, ... )
{
    if ( !isBeingRunWithDebuggerAttached() )
    {
        return;
    }
    
    if ( !__ltcolorArray )
    {
        initDebugSystem();
    }
    
    NSNumber* key = [NSNumber numberWithUnsignedInt:*(unsigned int *)pthread_self()];
    UIColor* logColorForThread;
    
    @synchronized( __ltthreadColorMap )
    {
        logColorForThread = [__ltthreadColorMap objectForKey:key];
        if ( !logColorForThread )
        {
            //NSLog( @"Assigning color %@ to thread with description %@ in %@", [colorArray objectAtIndex:[threadColorMap count]], key, threadColorMap );
            logColorForThread = [__ltcolorArray objectAtIndex:__ltthreadColorMap.count % __ltcolorArray.count];
            [__ltthreadColorMap setObject:logColorForThread forKey:key];
            //NSLog( @"thread map now %@", threadColorMap );
        }
        
        CGFloat r;
        CGFloat g;
        CGFloat b;
        [logColorForThread getRed:&r green:&g blue:&b alpha:nil];
        int rv = 255 * r;
        int gv = 255 * g;
        int bv = 255 * b;
        
        va_list ap;
        NSString *print;
        va_start( ap, format );
        print = [[NSString alloc] initWithFormat:format arguments:ap];
        va_end( ap );
        
        NSString* threadName = [NSThread currentThread].name.length > 0 ? [NSThread currentThread].name : @"-";
        
        NSMutableString* output = [[NSMutableString alloc] initWithFormat:@"%@ | %@ #%03ld | ", [__ltdateFormatter stringFromDate:[NSDate date]], threadName, (long)currentThreadNumber()];
        [output appendString:XCODE_COLORS_ESCAPE];
        [output appendFormat:@"fg%u,%u,%u;", rv, gv, bv];
        [output appendString:print];
        [output appendString:@"\n"];
        [output appendString:XCODE_COLORS_RESET];
        
        [[NSFileHandle fileHandleWithStandardOutput] writeData:[output dataUsingEncoding: NSNEXTSTEPStringEncoding]];
    }
}

#pragma mark - Switch

#ifdef LATEDEBUG

    #ifdef LATEDEBUG_FILE
        #define LOG(fmt, ...) LTFileLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
        #define LOGHERE() LTFileLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
        #define assert_not_reached() LTFileLog((@"WARNING! %s %d should never be reached in production code!"), __PRETTY_FUNCTION__, __LINE__);
    #endif

    #ifdef LATEDEBUG_COLOR
        #define LOG(fmt, ...) LTTTyLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
        #define LOGHERE() LTTTyLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
        #define assert_not_reached() assert(false);
    #endif

    #ifdef LATEDEBUG_NORMAL
        #define LOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
        #define LOGHERE() NSLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
        #define assert_not_reached() assert(false);
    #endif

#else
    #define LOG(...)
    #define LOGHERE()
    #define assert_not_reached() NSLog((@"WARNING! %s %d should never be reached in production code!"), __PRETTY_FUNCTION__, __LINE__);

#endif

#ifdef EXTRADEBUG
#   define XLOG(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#   define XLOGHERE() NSLog((@"%s [Line %d] reached"), __PRETTY_FUNCTION__, __LINE__);
#else
#   define XLOG(...)
#   define XLOGHERE()
#endif

