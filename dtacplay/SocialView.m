//
//  SocialView.m
//  dtacplay
//
//  Created by attaphon eamsahard on 11/20/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "SocialView.h"
#import "FBSDKShareKit.h"
#import "Line.h"
#import "Constant.h"
#import "LKLineActivity.h"
#import <Social/Social.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "Manager.h"
@implementation SocialView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)whenShareContent:(int)channel{
    NSString *jsonString =
    [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":%d,\"musicId\":null,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
    switch (self.subCate) {
        case FREEZONE_MUSIC:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":%d,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_MUSIC_HIT:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":%d,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_MUSIC_INTER:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":%d,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_MUSIC_LOOKTHOONG:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":%d,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_MUSIC_NEW:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":%d,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_GAME_GAMECLUB:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":%d,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_GAME_GAMEROOM:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":%d,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_GAME_NEW:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":%d,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case DOWNLOAD_GAME_HIT:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":%d,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case FREEZONE_GAME:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":%d,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
        case FREEZONE_APPLICATION:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":null,\"appId\":%d,\"channel\":%d}}",self.contentID,channel];
            break;
        case FREEZONE_RECOMMENDED_APPLICATION:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":null,\"musicId\":null,\"gameId\":null,\"appId\":%d,\"channel\":%d}}",self.contentID,channel];
            break;
        default:
            jsonString =
            [NSString stringWithFormat:@"{\"jsonrpc\":\"2.0\", \"id\":20140317, \"method\":\"shareContent\", \"params\":{\"conId\":%d,\"musicId\":null,\"gameId\":null,\"appId\":null,\"channel\":%d}}",self.contentID,channel];
            break;
    }
    
    NSString *valueHeader;
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ShareContent"
//                                                    message:[NSString stringWithFormat:@"cate : %@ , subCate : %@ ,contentID : %d",[Manager getCateName:self.cate withThai:YES] , [Manager getSubcateName:self.subCate withThai:YES] , self.contentID]
//                                                   delegate:self
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];

    valueHeader = [NSString stringWithFormat:@"x-tksm-lang=1;"];
    
    NSMutableURLRequest *requestHTTP = [Manager createRequestHTTP:jsonString cookieValue:valueHeader];
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:requestHTTP];
    
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        if ([[responseObject objectForKey:@"result"] isEqual:[NSNull null]]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success"
//                                                            message:[NSString stringWithFormat:@"success"]
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }

        //  ...
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        //[[Manager sharedManager] showErrorAlert:self];
    }];
    [op start];
    
    
    
}

-(void)setValueForShareTitle:(NSString*)title Description:(NSString*)description ImageUrl:(NSString*)imageURL ContentURL:(NSString*)contentURL Category:(CategorryType)cate SubCategoryType:(SubCategorry)subcate contentID:(int)contentID{
    
    self.cate = cate;
    self.subCate = subcate;
    self.contentID = contentID;
    contentURL = [contentURL stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    NSArray *keys = [NSArray arrayWithObjects:@"title", @"description", @"imageURL", @"contentURL", nil];
    NSArray *objects = [NSArray arrayWithObjects:title == nil ? @"" : title , description == nil ? @"" : description ,imageURL == nil ? @"" : imageURL,contentURL, nil];
    _contentDictionary = [NSDictionary dictionaryWithObjects:objects
                                                           forKeys:keys];
}
-(NSString*)bitlyURL{
    NSString *accessToken = @"5b875a8f52d7bfeeab281a041c8d316b7a1c29fe";
    NSString *url =[[_contentDictionary objectForKey:@"contentURL"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *bitlyRequest = [NSString stringWithFormat:@"https://api-ssl.bitly.com/v3/shorten?access_token=%@&longUrl=%@",accessToken, url];
    NSString *bitlyResponse = [NSString stringWithContentsOfURL:[NSURL URLWithString:bitlyRequest] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [bitlyResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *bitlyDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
   
    

    return bitlyDictionary[@"data"][@"url"];
 
   
    
}
- (IBAction)shareFBAction:(id)sender {
    [self whenShareContent:1];
    
    
    [_facebookButton setUserInteractionEnabled:NO];
    NSURL *url = [NSURL URLWithString:[self bitlyURL]];
    if(url == nil)
        url =[_contentDictionary objectForKey:@"contentURL"];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    
    content.contentTitle = [_contentDictionary objectForKey:@"title"];
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithData:[[_contentDictionary objectForKey:@"description"] dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                                          NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                     documentAttributes:nil
                                                                  error:nil];
    NSString *finalString = [attr string];
    
    
    content.contentDescription = finalString;
    content.imageURL = [NSURL URLWithString:[_contentDictionary objectForKey:@"imageURL"]];//http://dtacplay-web.dev5.thinksmart.co.th/th/main
    content.contentURL =url;
    //content.contentDescription= [NSString stringWithFormat:@"%@",self.case_object.descriptions];
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]){
        dialog.mode = FBSDKShareDialogModeNative;
    }
    else {
        dialog.mode = FBSDKShareDialogModeBrowser; //or FBSDKShareDialogModeAutomatic
    }
    dialog.shareContent = content;
    dialog.delegate = self;
    dialog.fromViewController = self.parentView;
    [dialog show];

}
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    [_facebookButton setUserInteractionEnabled:YES];
}
- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    [_facebookButton setUserInteractionEnabled:YES];
}
-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    [_facebookButton setUserInteractionEnabled:YES];
}
- (IBAction)shareTweeter:(id)sender {
      [self whenShareContent:2];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
         NSURL *url = [NSURL URLWithString:[self bitlyURL]];
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[_contentDictionary objectForKey:@"title"]];
        [tweetSheet addURL:url];
        
        [self.parentView presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"กรุณา Login Twitter ก่อนแชร์นะคะ"
                                  delegate:self
                                  cancelButtonTitle:@"ตกลง"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)shareLine:(id)sender {
      [self whenShareContent:3];
    if ([Line isLineInstalled]) {
        [Line shareText:[self bitlyURL]];
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@""
                                  message:@"ไม่พบแอพลิเคชั่นไลน์!"
                                  delegate:self
                                  cancelButtonTitle:@"ตกลง"
                                  otherButtonTitles:nil];
        [alertView show];
    }
//    id<SocialShare> strongDelegate = self.delegate;
//    
//    // Our delegate method is optional, so we should
//    // check that the delegate implements it
//    if ([strongDelegate respondsToSelector:@selector(shareSocial:)]) {
//        [strongDelegate shareSocial:3];
//    }
}

@end
