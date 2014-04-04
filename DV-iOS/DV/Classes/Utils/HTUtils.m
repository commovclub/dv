//
//  HTUtils.m
//  HotWord
//
//  Created by Jack Liu on 13-5-25.
//
//

#import "HTUtils.h"

@implementation HTUtils


+ (NSString *)getExamNameByCode:(NSString *)code
{
    NSDictionary *examDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Exam_List" ofType:@"plist"]];
    NSArray *exams = [examDic objectForKey:@"exam"];
    for (NSDictionary *dic in exams) {
        if ([code isEqualToString:[dic objectForKey:@"exam_code"]]) {
            return [dic objectForKey:@"exam_name"];
        }
    }
    return @"";
    
}

+ (NSString *)getSectionNameByCode:(NSString *)code
{
    NSDictionary *sectionDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Teacher_Section_List" ofType:@"plist"]];
    
    NSDictionary *sectionDics = [sectionDic objectForKey:@"sections"];
    for (NSString *key in [sectionDics allKeys]) {
        NSArray *sections = [sectionDics objectForKey:key];
        for (NSDictionary *sectionDic in sections) {
            if ([code isEqualToString:[sectionDic objectForKey:@"section_id"]]) {
                return [sectionDic objectForKey:@"section_content"];
            }
        }
    }
    return @"";
}

@end
