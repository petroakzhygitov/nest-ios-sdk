/**
 *  Copyright 2014 Nest Labs Inc. All Rights Reserved.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#import "UIColor+NestBlue.h"

@implementation UIColor (NestBlue)

+ (UIColor *)nestBlue
{
    return [UIColor colorWithRed:0 green:0.69 blue:0.85 alpha:1];
}

+ (UIColor *)nestBlueSelected
{
    return [UIColor colorWithRed:0.07 green:0.79 blue:0.99 alpha:1];
}

@end
