//
//  YDBridgeWebView.h
//  SportsBar
//
//  Created by 张旻可 on 2017/7/20.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YDDefine.h"
#import <WebKit/WebKit.h>

@class YDBridgeWebView;
@class YDBridgeWebMgr;
@class YDMBaseViewController;
@class NJKWebViewProgress;

@protocol YDBridgeWebViewDelegate <NSObject>

@optional
- (BOOL)webView:(YDBridgeWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
- (void)webViewDidStartLoad:(YDBridgeWebView *)webView;
- (void)webViewDidFinishLoad:(YDBridgeWebView *)webView;
- (void)webView:(YDBridgeWebView *)webView didFailLoadWithError:(NSError *)error;
- (void)webView:(YDBridgeWebView *)webView updateProgress:(double)progress;
//- (void)webView:(YDBridgeWebView *)webView solveURLDelivery:(YDURLDelivery *)URLDelivery;

@end

@interface YDBridgeWebView : UIView

@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, copy) NSString *originalUrlString;
@property (nonatomic, assign) YDWebViewType type;
@property (nonatomic, weak, readonly) YDBridgeWebMgr *webMgr;
@property (nonatomic, weak, readwrite) UIViewController *currentViewController;
@property (nonatomic, strong, readonly) id webView;
@property (nonatomic, weak, readonly) UIWebView *oldWebView;
@property (nonatomic, weak, readonly) WKWebView *freshWebView;

@property (nonatomic, strong, readonly) NJKWebViewProgress *progressProxy;

@property (nonatomic, weak) id<YDBridgeWebViewDelegate> mDelegate;

@property (nonatomic, assign) CGFloat topEdge;
@property (nonatomic, assign) BOOL showProgress;

+ (instancetype)instanceWithType:(YDWebViewType)type urlString:(NSString *)urlString webMgr:(YDBridgeWebMgr *)webMgr;
- (instancetype)initWithUrl:(NSString *)urlString andType:(YDWebViewType)type webMgr:(YDBridgeWebMgr *)webMgr;

- (void)updateProgressConstraints;
- (void)setCurrentViewController:(UIViewController *)viewController;
- (void)getSnapShotImage:(void(^)(UIImage *snapShotImage))then;
- (void)updateTopEdge:(CGFloat)topEdge;
- (void)comInit;
- (id)webView;

#pragma mark -- wkwebview
@property (nonatomic, readonly, copy) WKWebViewConfiguration *configuration;

/*! @abstract The web view's navigation delegate. */
@property (nonatomic, weak) id <WKNavigationDelegate> navigationDelegate;

/*! @abstract The web view's user interface delegate. */
@property (nonatomic, weak) id <WKUIDelegate> UIDelegate;

/*! @abstract The web view's back-forward list. */
@property (nonatomic, readonly, strong) WKBackForwardList *backForwardList;

/*! @abstract Navigates to a requested URL.
 @param request The request specifying the URL to which to navigate.
 @result A new navigation for the given request.
 */
- (WKNavigation *)loadRequest:(NSURLRequest *)request;

/*! @abstract Navigates to the requested file URL on the filesystem.
 @param URL The file URL to which to navigate.
 @param readAccessURL The URL to allow read access to.
 @discussion If readAccessURL references a single file, only that file may be loaded by WebKit.
 If readAccessURL references a directory, files inside that file may be loaded by WebKit.
 @result A new navigation for the given file URL.
 */
- (WKNavigation *)loadFileURL:(NSURL *)URL allowingReadAccessToURL:(NSURL *)readAccessURL;// API_AVAILABLE(macosx(10.11), ios(9.0));

/*! @abstract Sets the webpage contents and base URL.
 @param string The string to use as the contents of the webpage.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 @result A new navigation.
 */
- (WKNavigation *)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

/*! @abstract Sets the webpage contents and base URL.
 @param data The data to use as the contents of the webpage.
 @param MIMEType The MIME type of the data.
 @param encodingName The data's character encoding name.
 @param baseURL A URL that is used to resolve relative URLs within the document.
 @result A new navigation.
 */
- (WKNavigation *)loadData:(NSData *)data MIMEType:(NSString *)MIMEType characterEncodingName:(NSString *)characterEncodingName baseURL:(NSURL *)baseURL;// API_AVAILABLE(macosx(10.11), ios(9.0));

/*! @abstract Navigates to an item from the back-forward list and sets it
 as the current item.
 @param item The item to which to navigate. Must be one of the items in the
 web view's back-forward list.
 @result A new navigation to the requested item, or nil if it is already
 the current item or is not part of the web view's back-forward list.
 @seealso backForwardList
 */
- (WKNavigation *)goToBackForwardListItem:(WKBackForwardListItem *)item;

/*! @abstract The page title.
 @discussion @link WKWebView @/link is key-value observing (KVO) compliant
 for this property.
 */
@property (nonatomic, readonly, copy) NSString *title;

/*! @abstract The active URL.
 @discussion This is the URL that should be reflected in the user
 interface.
 @link WKWebView @/link is key-value observing (KVO) compliant for this
 property.
 */
@property (nonatomic, readonly, copy) NSURL *URL;

/*! @abstract A Boolean value indicating whether the view is currently
 loading content.
 @discussion @link WKWebView @/link is key-value observing (KVO) compliant
 for this property.
 */
@property (nonatomic, readonly, getter=isLoading) BOOL loading;

/*! @abstract An estimate of what fraction of the current navigation has been completed.
 @discussion This value ranges from 0.0 to 1.0 based on the total number of
 bytes expected to be received, including the main document and all of its
 potential subresources. After a navigation completes, the value remains at 1.0
 until a new navigation starts, at which point it is reset to 0.0.
 @link WKWebView @/link is key-value observing (KVO) compliant for this
 property.
 */
@property (nonatomic, readonly) double estimatedProgress;

/*! @abstract A Boolean value indicating whether all resources on the page
 have been loaded over securely encrypted connections.
 @discussion @link WKWebView @/link is key-value observing (KVO) compliant
 for this property.
 */
@property (nonatomic, readonly) BOOL hasOnlySecureContent;

/*! @abstract A SecTrustRef for the currently committed navigation.
 @discussion @link WKWebView @/link is key-value observing (KVO) compliant
 for this property.
 */
@property (nonatomic, readonly) SecTrustRef serverTrust;// API_AVAILABLE(macosx(10.12), ios(10.0));

/*! @abstract A Boolean value indicating whether there is a back item in
 the back-forward list that can be navigated to.
 @discussion @link WKWebView @/link is key-value observing (KVO) compliant
 for this property.
 @seealso backForwardList.
 */
@property (nonatomic, readonly) BOOL canGoBack;

/*! @abstract A Boolean value indicating whether there is a forward item in
 the back-forward list that can be navigated to.
 @discussion @link WKWebView @/link is key-value observing (KVO) compliant
 for this property.
 @seealso backForwardList.
 */
@property (nonatomic, readonly) BOOL canGoForward;

/*! @abstract Navigates to the back item in the back-forward list.
 @result A new navigation to the requested item, or nil if there is no back
 item in the back-forward list.
 */
- (WKNavigation *)goBack;

/*! @abstract Navigates to the forward item in the back-forward list.
 @result A new navigation to the requested item, or nil if there is no
 forward item in the back-forward list.
 */
- (WKNavigation *)goForward;

/*! @abstract Reloads the current page.
 @result A new navigation representing the reload.
 */
- (WKNavigation *)reload;

//#warning -- test
- (WKNavigation *)loadWithBundleFile:(NSString *)file;


/*! @abstract Reloads the current page, performing end-to-end revalidation
 using cache-validating conditionals if possible.
 @result A new navigation representing the reload.
 */
- (WKNavigation *)reloadFromOrigin;

/*! @abstract Stops loading all resources on the current page.
 */
- (void)stopLoading;

/* @abstract Evaluates the given JavaScript string.
 @param javaScriptString The JavaScript string to evaluate.
 @param completionHandler A block to invoke when script evaluation completes or fails.
 @discussion The completionHandler is passed the result of the script evaluation or an error.
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id result, NSError *error))completionHandler;

/*! @abstract A Boolean value indicating whether horizontal swipe gestures
 will trigger back-forward list navigations.
 @discussion The default value is NO.
 */
@property (nonatomic) BOOL allowsBackForwardNavigationGestures;

/*! @abstract The custom user agent string or nil if no custom user agent string has been set.
 */
@property (nonatomic, copy) NSString *customUserAgent;// API_AVAILABLE(macosx(10.11), ios(9.0));

/*! @abstract A Boolean value indicating whether link preview is allowed for any
 links inside this WKWebView.
 @discussion The default value is YES on Mac and iOS.
 */
@property (nonatomic) BOOL allowsLinkPreview;// API_AVAILABLE(macosx(10.11), ios(9.0));

/*! @abstract The scroll view associated with the web view.
 */
@property (nonatomic, readonly, strong) UIScrollView *scrollView;

#pragma mark -- uiwebview
@property (nonatomic, assign) id <UIWebViewDelegate> delegate;
@property (nonatomic) BOOL scalesPageToFit;
@property (nonatomic) BOOL detectsPhoneNumbers NS_DEPRECATED_IOS(2_0, 3_0);
@property (nonatomic) UIDataDetectorTypes dataDetectorTypes NS_AVAILABLE_IOS(3_0);
@property (nonatomic) BOOL allowsInlineMediaPlayback NS_AVAILABLE_IOS(4_0); // iPhone Safari defaults to NO. iPad Safari defaults to YES
@property (nonatomic) BOOL mediaPlaybackRequiresUserAction NS_AVAILABLE_IOS(4_0); // iPhone and iPad Safari both default to YES
@property (nonatomic) BOOL mediaPlaybackAllowsAirPlay NS_AVAILABLE_IOS(5_0); // iPhone and iPad Safari both default to YES
@property (nonatomic) BOOL suppressesIncrementalRendering NS_AVAILABLE_IOS(6_0); // iPhone and iPad Safari both default to NO
@property (nonatomic) BOOL keyboardDisplayRequiresUserAction NS_AVAILABLE_IOS(6_0); // default is YES
@property (nonatomic) UIWebPaginationMode paginationMode NS_AVAILABLE_IOS(7_0);
@property (nonatomic) UIWebPaginationBreakingMode paginationBreakingMode NS_AVAILABLE_IOS(7_0);
@property (nonatomic) CGFloat pageLength NS_AVAILABLE_IOS(7_0);
@property (nonatomic) CGFloat gapBetweenPages NS_AVAILABLE_IOS(7_0);
@property (nonatomic, readonly) NSUInteger pageCount NS_AVAILABLE_IOS(7_0);
@property (nonatomic) BOOL allowsPictureInPictureMediaPlayback NS_AVAILABLE_IOS(9_0);

@end
