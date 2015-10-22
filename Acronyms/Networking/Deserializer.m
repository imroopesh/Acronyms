#import "Deserializer.h"

@implementation Deserializer


- (NSArray *) deserialize:(NSDictionary *)jsonDictionary
{
    NSMutableArray *acronymFullForms = [NSMutableArray array];

    if (jsonDictionary != (id)[NSNull null])
    {
        NSArray *arrayDict = jsonDictionary[@"lfs"];
        for (NSDictionary *meaningDict in arrayDict)
        {
            NSString *meaning = meaningDict[@"lf"];
            [acronymFullForms addObject:meaning];
        }
        return [acronymFullForms copy];
    }
    return nil;
}

@end


//{
//    lfs =     (
//               {
//                   freq = 18;
//                   lf = "Federal Bureau of Investigation";
//                   since = 1986;
//                   vars =             (
//                                       {
//                                           freq = 17;
//                                           lf = "Federal Bureau of Investigation";
//                                           since = 1986;
//                                       },
//                                       {
//                                           freq = 1;
//                                           lf = "Federal Bureau of Investigations";
//                                           since = 1995;
//                                       }
//                                       );
//               }
//               );
//    sf = FBI;
//}

