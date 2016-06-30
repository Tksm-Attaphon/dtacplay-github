//
//  DownloadCategory.m
//  dtacplay
//
//  Created by attaphon eamsahard on 5/30/2559 BE.
//  Copyright © 2559 attaphon eamsahard. All rights reserved.
//

#import "DownloadCategory.h"

@implementation DownloadCategory
- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if(self = [super init]){
        if([self isNSNull:dictionary]){
            self.cateID = [[self isNSNull:[dictionary objectForKey:@"cateId"]] intValue];
            
            self.name = [self isNSNull:[dictionary objectForKey:@"name"]];
            self.engName = [self isNSNull:[dictionary objectForKey:@"nameEn"]];
            NSArray *subCate = [self isNSNull:[dictionary objectForKey:@"subcates"]];
            
            self.subcates = [[NSMutableArray alloc]init];
            for (NSDictionary* subcate in subCate){
                DtacSubCategory *temp = [[DtacSubCategory alloc]initWithDictionary:subcate];
                [self.subcates addObject:temp];
                switch (temp.subCateID) {
                    case 12:
                        self.game_new = temp;
                        break;
                    case 13:
                        self.music_new = temp;
                        break;
                    case 14:
                        self.music_hit = temp;
                        break;
                    case 15:
                        self.music_inter= temp;
                        break;
                    case 16:
                        self.music_lookthoong = temp;
                        break;
                    case 19:
                        self.game_hit = temp;
                        break;
                    case 38:
                        self.game_club = temp;
                        break;
                    case 39:
                        self.game_room = temp;
                        break;
                    default:
                        break;
                }
                
            }
        }
    }
    
    
    return self;
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
