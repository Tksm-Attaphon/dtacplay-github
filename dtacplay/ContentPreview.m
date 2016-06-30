//
//  ContentPreView.m
//  dtacplay
//
//  Created by attaphon eamsahard on 10/9/2558 BE.
//  Copyright © 2558 attaphon eamsahard. All rights reserved.
//

#import "ContentPreview.h"
#import "DtacImage.h"
#import "Manager.h"
@implementation ContentPreview
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    
    if(self = [super init]){
        self.contentID = [self isNSNull: [dictionary objectForKey:@"conId"]];
        self.subCateID = [[self isNSNull: [dictionary objectForKey:@"subCateId"]] intValue];
        self.cateID = [self isNSNull: [dictionary objectForKey:@"cateId"]];
        self.feedID = [self isNSNull: [dictionary objectForKey:@"feedId"]];
        self.smrtAdsRefId = [self isNSNull: [dictionary objectForKey:@"smrtAdsRefId"]];
        self.title = [self isNSNull:  [dictionary objectForKey:@"title"]];
        self.descriptionContent = [self isNSNull: [dictionary objectForKey:@"description"]];
        self.link =[self isNSNull: [dictionary objectForKey:@"link"]] ;
        
        NSDictionary *imageDic = [self isNSNull: [dictionary objectForKey:@"images"]] ;
        self.images = [[DtacImage alloc]initWithDictionary:imageDic];
        NSString *date = [self isNSNull: [dictionary objectForKey:@"pubDate"]];
   
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromString = [[NSDate alloc] init];
        // voila!
        dateFromString = [dateFormatter dateFromString:date];
        self.publishDate = dateFromString;
        
        
        date = [self isNSNull: [dictionary objectForKey:@"startDate"]];//endDate
        dateFromString = [dateFormatter dateFromString:date];
        self.startDate = dateFromString;
        
        date = [self isNSNull: [dictionary objectForKey:@"endDate"]];//endDate
        dateFromString = [dateFormatter dateFromString:date];
        self.endDate = dateFromString;
        
        _dateString = [self showDateTimeReadable:self.startDate];
        _descriptionContent = [self clearEntityHtml:_descriptionContent];
        NSString *result = [_descriptionContent stringByReplacingOccurrencesOfString:@"<[^>]*>" withString:@"" options:NSCaseInsensitiveSearch | NSRegularExpressionSearch range:NSMakeRange(0, [_descriptionContent length])];

        self.previewTitle = [NSString stringWithFormat:@"%@ - %@dtacPlay ตอบโจทย์ทุกไลฟ์สไตล์ อัพเดททุกวันไม่มีเอาท์ ทั้งข่าวสาร ดวงรายวัน รู้ลึกทุกซอยแหล่งกิน ดื่ม เที่ยว และสาระความบันเทิงมากมายแบบฟรีๆ แถมยังได้ช้อปออนไลน์สบายกระเป๋า รับรองไม่มีเหงา",self.title,result];
         NSLog(@"create titlepreview finished");
        
        
         _cpaConId = [self isNSNull: [dictionary objectForKey:@"cpaConId"]];
        _aocLink = [self isNSNull: [dictionary objectForKey:@"aocLink"]];
        _flgNew = [[self isNSNull: [dictionary objectForKey:@"flgNew"]] boolValue];
        _flgHot = [[self isNSNull: [dictionary objectForKey:@"flgHot"]] boolValue];
        _flgRec = [[self isNSNull: [dictionary objectForKey:@"flgRec"]] boolValue];
        
    }
    return self;
}
-(NSString*)clearEntityHtml:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"&ndash;"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&nbsp;"
                                               withString:@" "];
    string = [string stringByReplacingOccurrencesOfString:@"&idquo;"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&rdquo;"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&ldquo;"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&quot;"
                                               withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"&hellip;"
                                               withString:@"..."];
    return string;
}
-(NSDate*)convertJsonDate:(NSString*)jsonDate{
    NSString * dateStr = jsonDate;
    NSArray *dateStrParts = [dateStr componentsSeparatedByString:@" "];
    NSString *datePart = [dateStrParts objectAtIndex:0];
    NSString *timePart = [dateStrParts objectAtIndex:1];
    
    NSString *t = [[timePart componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString *newDateStr = [NSString stringWithFormat:@"%@ %@",datePart,t];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; // Change here for your formated output
    NSDate *date = [df dateFromString:newDateStr];
    return date;
}
-(NSString*)showDateTimeReadable:(NSDate*)date{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSString *textMouth;
    switch (month) {
        case 1:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"January" :@"ม.ค.";
            break;
        case 2:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"February" :@"ก.พ.";
            break;
        case 3:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"March" :@"มี.ค.";
            break;
        case 4:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"April" :@"เม.ย.";
            break;
        case 5:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"May" :@"พ.ค.";
            break;
        case 6:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"June" :@"มิ.ย.";
            break;
        case 7:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"July" :@"ก.ค.";
            break;
        case 8:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"August" :@"ส.ค.";
            break;
        case 9:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"September":@"ก.ย.";
            break;
        case 10:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"October" :@"ต.ค.";
            break;
        case 11:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"November":@"พ.ย.";
            break;
        case 12:
            textMouth = [[Manager sharedManager]language]!= THAI  ? @"December" :@"ธ.ค.";
            break;
        default:
            break;
    }
    
    if(self.endDate){
        components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:self.endDate];
        
        NSInteger dayEnd = [components day];
        NSInteger monthEnd = [components month];
        NSInteger yearEnd = [components year];
        NSString *textMouthEnd;
        switch (monthEnd) {
            case 1:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"January" :@"ม.ค.";
                break;
            case 2:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"February" :@"ก.พ.";
                break;
            case 3:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"March" :@"มี.ค.";
                break;
            case 4:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"April" :@"เม.ย.";
                break;
            case 5:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"May" :@"พ.ค.";
                break;
            case 6:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"June" :@"มิ.ย.";
                break;
            case 7:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"July" :@"ก.ค.";
                break;
            case 8:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"August" :@"ส.ค.";
                break;
            case 9:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"September":@"ก.ย.";
                break;
            case 10:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"October" :@"ต.ค.";
                break;
            case 11:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"November":@"พ.ย.";
                break;
            case 12:
                textMouthEnd = [[Manager sharedManager]language]!= THAI  ? @"December" :@"ธ.ค.";
                break;
            default:
                break;
        }
        NSString *string = [NSString stringWithFormat:@"%d",year+543];
        NSString *code = [string substringFromIndex: [string length] - 2];
        
        
        NSString *stringEnd = [NSString stringWithFormat:@"%d",year+543];
        NSString *codeEnd = [stringEnd substringFromIndex: [stringEnd length] - 2];
         return [NSString stringWithFormat:@"%ld %@ %@ - %ld %@ %@",(long)day,textMouth,code,(long)dayEnd,textMouthEnd,codeEnd];
    }
    NSString *string = [NSString stringWithFormat:@"%d",year+543];
    NSString *code = [string substringFromIndex: [string length] - 2];
    return [NSString stringWithFormat:@"%ld %@ %@",(long)day,textMouth,code];
}

-(id)isNSNull:(id)object{
    if([object isEqual:[NSNull null]]){
        return nil;
    }
    else{
        return object;
    }
}
@end
