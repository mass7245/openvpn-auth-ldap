/*
 * TRArray.m vi:ts=4:sw=4:expandtab:
 * TRArray Unit Tests
 *
 * Author: Landon Fuller <landonf@threerings.net>
 *
 * Copyright (c) 2006 Three Rings Design, Inc.
 * Copyright (c) 2012 Landon Fuller <landonf@bikemonkey.org>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 * 3. Neither the name of Landon Fuller nor the names of any contributors
 *    may be used to endorse or promote products derived from this
 *    software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#ifdef HAVE_CONFIG_H
#import <config.h>
#endif

#import "PXTestCase.h"

#import "TRArray.h"
#import "TRString.h"

@interface TRArrayTests : PXTestCase @end

@implementation TRArrayTests

- (void) test_addObject {
    TRArray *array = [[TRArray alloc] init];
    TRString *string1 = [[TRString alloc] initWithCString: "String 1"];
    TRString *string2 = [[TRString alloc] initWithCString: "String 2"];
    TRString *string3 = [[TRString alloc] initWithCString: "String 3"];

    /* Add 3 items to the array */
    [array addObject: string1];
    fail_unless([array lastObject] == string1);
    fail_unless([string1 retainCount] == 2);

    [array addObject: string2];
    fail_unless([array lastObject] == string2);
    fail_unless([string2 retainCount] == 2);

    [array addObject: string3];
    fail_unless([array lastObject] == string3);
    fail_unless([string3 retainCount] == 2);

    /* Clean up the array */
    [array release];

    /* Verify that the array released all objects */
    fail_unless([string1 retainCount] == 1);
    fail_unless([string2 retainCount] == 1);
    fail_unless([string3 retainCount] == 1);

    /* Clean up our remaining objects */
    [string1 release];
    [string2 release];
    [string3 release];
}

- (void) test_removeObject {
    TRArray *array = [[TRArray alloc] init];
    TRString *string1 = [[TRString alloc] initWithCString: "String 1"];
    TRString *string2 = [[TRString alloc] initWithCString: "String 2"];

    /* Fill our array */
    [array addObject: string1];
    [array addObject: string2];

    /* Pop an object off the stack */
    fail_unless([array lastObject] == string2);
    [array removeObject];
    fail_unless([array lastObject] == string1);
    [array removeObject];
    fail_unless([array lastObject] == nil);

    [array release];
    [string1 release];
    [string2 release];
}

- (void) test_containsObject {
    TRArray *array = [[TRArray alloc] init];
    TRString *string1 = [[TRString alloc] initWithCString: "String 1"];

    /* Fill our array */
    [array addObject: string1];

    /* Look for our object */
    STAssertTrue([array containsObject: string1], "Array claims to not contain the added object.");

    /* And a known bad one ... */
    STAssertFalse([array containsObject: array], "Array claims to contain itself.");

    [array release];
    [string1 release];
}

- (void) test_count {
    TRArray *array = [[TRArray alloc] init];
    TRString *string1 = [[TRString alloc] initWithCString: "String 1"];

    /* Fill our array */
    [array addObject: string1];

    /* Check the count */
    fail_unless([array count] == 1);

    [array release];
    [string1 release];

}

- (void) test_objectEnumerator {
    TRArray *array = [[TRArray alloc] init];
    TRString *string1 = [[TRString alloc] initWithCString: "String 1"];
    TRString *string2 = [[TRString alloc] initWithCString: "String 2"];
    TREnumerator *iter;
    id obj;

    /* Insert */
    [array addObject: string1];
    [array addObject: string2];

    /* Grab an enumerator */
    iter = [array objectEnumerator];
    obj = [iter nextObject];
    fail_unless(obj == string2);
    obj = [iter nextObject];
    fail_unless(obj == string1);

    /* Grab a reverse enumerator */
    iter = [array objectReverseEnumerator];
    obj = [iter nextObject];
    fail_unless(obj == string1);
    obj = [iter nextObject];
    fail_unless(obj == string2);


    /* Clean up */
    [array release];
    [string1 release];
    [string2 release];
}

@end