//
//  CocoaSecurityTests.m
//  CocoaSecurityTests
//
//  Created by Kelp on 12/5/13.
//  Copyright (c) 2012 Phate. All rights reserved.
//

#import "CocoaSecurityTests.h"

@implementation CocoaSecurityTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEncodeDecode
{
    CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
    CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
    
    // HEX
    STAssertEqualObjects([encoder hex:[decoder hex:@"CC0A69779E15780ADAE46C45EB451A23"] useLower:false],
                         @"CC0A69779E15780ADAE46C45EB451A23", nil);
    STAssertNil([encoder hex:[NSData new] useLower:YES], nil);
    STAssertNil([decoder hex:@""], nil);
    
    // Base64
    STAssertEqualObjects([encoder base64:[decoder base64:@"zT1PS64MnXIUDCUiy13RRg=="]], @"zT1PS64MnXIUDCUiy13RRg==", nil);
    STAssertNil([encoder base64:[NSData new]], nil);
    STAssertNil([decoder base64:@""], nil);
}

- (void)testAES
{
    // AES128
    CocoaSecurityResult *aes128 = [CocoaSecurity aesEncrypt:@"kelp"
                                                     hexKey:@"C40C69779E15780ADAE46C45EB451E23"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    STAssertEqualObjects(aes128.base64, @"zT1PS64MnXIUDCUiy13RRg==", nil);
    STAssertEqualObjects([CocoaSecurity aesDecryptWithBase64:aes128.base64
                                                      hexKey:@"C40C69779E15780ADAE46C45EB451E23"
                                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"].utf8String, @"kelp", nil);
    
    // AES192
    CocoaSecurityResult *aes192 = [CocoaSecurity aesEncrypt:@"kelp"
                                                     hexKey:@"C40C69779E15780ADAE46C45EB451E230000000000000000"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    STAssertEqualObjects(aes192.base64, @"zSpp/l/B/Gp+j0vByqcTVg==", nil);
    STAssertEqualObjects([CocoaSecurity aesDecryptWithBase64:aes192.base64
                                                      hexKey:@"C40C69779E15780ADAE46C45EB451E230000000000000000"
                                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"].utf8String, @"kelp", nil);
    
    // AES256
    CocoaSecurityResult *aes256 = [CocoaSecurity aesEncrypt:@"kelp"
                                                     hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    STAssertEqualObjects(aes256.base64, @"WQYg5qvcGyCBY3IF0hPsoQ==", nil);
    STAssertEqualObjects([CocoaSecurity aesDecryptWithBase64:aes256.base64
                                                      hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"].utf8String, @"kelp", nil);
    
    // AES default
    CocoaSecurityResult *aesDefault = [CocoaSecurity aesEncrypt:@"kelp" key:@"key"];
    STAssertEqualObjects(aesDefault.base64, @"ez9uubPneV1d2+rpjnabJw==", nil);
    STAssertEqualObjects([CocoaSecurity aesDecryptWithBase64:aesDefault.base64 key:@"key"].utf8String, @"kelp", nil);
}

- (void)testMD5
{
    CocoaSecurityResult *md5 = [CocoaSecurity md5:@"kelp"];
    CocoaSecurityResult *hmacMd5 = [CocoaSecurity hmacMd5:@"kelp" hmacKey:@"key"];
    
    STAssertEqualObjects(md5.hex, @"C40C69779E15780ADAE46C45EB451E23", nil);
    STAssertEqualObjects(md5.hexLower, @"c40c69779e15780adae46c45eb451e23", nil);
    STAssertEqualObjects(md5.base64, @"xAxpd54VeAra5GxF60UeIw==", nil);
    
    STAssertEqualObjects(hmacMd5.hex, @"2DFF352719234D5D6A9839FD8F43C8D2", nil);
    STAssertEqualObjects(hmacMd5.hexLower, @"2dff352719234d5d6a9839fd8f43c8d2", nil);
    STAssertEqualObjects(hmacMd5.base64, @"Lf81JxkjTV1qmDn9j0PI0g==", nil);
}

- (void)testSHA
{
    CocoaSecurityResult *sha1 = [CocoaSecurity sha1:@"kelp"];
    CocoaSecurityResult *sha224 = [CocoaSecurity sha224:@"kelp"];
    CocoaSecurityResult *sha256 = [CocoaSecurity sha256:@"kelp"];
    CocoaSecurityResult *sha384 = [CocoaSecurity sha384:@"kelp"];
    CocoaSecurityResult *sha512 = [CocoaSecurity sha512:@"kelp"];
    CocoaSecurityResult *hmacSha1 = [CocoaSecurity hmacSha1:@"kelp" hmacKey:@"key"];
    CocoaSecurityResult *hmacSha224 = [CocoaSecurity hmacSha224:@"kelp" hmacKey:@"key"];
    CocoaSecurityResult *hmacSha256 = [CocoaSecurity hmacSha256:@"kelp" hmacKey:@"key"];
    CocoaSecurityResult *hmacSha384 = [CocoaSecurity hmacSha384:@"kelp" hmacKey:@"key"];
    CocoaSecurityResult *hmacSha512 = [CocoaSecurity hmacSha512:@"kelp" hmacKey:@"key"];
    
    STAssertEqualObjects(sha1.hexLower, @"70b6a0495fb444a63297c83de187b1730a18e85a", nil);
    STAssertEqualObjects(sha1.base64, @"cLagSV+0RKYyl8g94YexcwoY6Fo=", nil);
    STAssertEqualObjects(hmacSha1.hexLower, @"fae888da051e44eb0c57f43935ad82cdbedf482f", nil);
    STAssertEqualObjects(hmacSha1.base64, @"+uiI2gUeROsMV/Q5Na2Czb7fSC8=", nil);
    
    STAssertEqualObjects(sha224.hexLower, @"1e124576cebf14ecdac30b8ca05ff94deb343f54ebb0eab21559dcf1", nil);
    STAssertEqualObjects(sha224.base64, @"HhJFds6/FOzawwuMoF/5Tes0P1TrsOqyFVnc8Q==", nil);
    STAssertEqualObjects(hmacSha224.hexLower, @"4777556ee573705fcf6194de22947e09562653a84684c4b015a91e0c", nil);
    STAssertEqualObjects(hmacSha224.base64, @"R3dVbuVzcF/PYZTeIpR+CVYmU6hGhMSwFakeDA==", nil);
    
    STAssertEqualObjects(sha256.hexLower, @"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9", nil);
    STAssertEqualObjects(sha256.base64, @"KA+LuMQ9Uy84nvDipTISILB4KwZSBdzfy42PAu1RFbk=", nil);
    STAssertEqualObjects(hmacSha256.hexLower, @"09e6c01ee44e4fc87871d3d8eb5265b67a941e9bf68d1b33851aeeed0114cd33", nil);
    STAssertEqualObjects(hmacSha256.base64, @"CebAHuROT8h4cdPY61JltnqUHpv2jRszhRru7QEUzTM=", nil);
    
    STAssertEqualObjects(sha384.hexLower, @"e0801e06e6eea6257018bc0f2aaf1f7ec23385ce2ac9865fe209322262f323e80c81f65e711e30d162af5638ef8b4334", nil);
    STAssertEqualObjects(sha384.base64, @"4IAeBubupiVwGLwPKq8ffsIzhc4qyYZf4gkyImLzI+gMgfZecR4w0WKvVjjvi0M0", nil);
    STAssertEqualObjects(hmacSha384.hexLower, @"99f2a12918f5e0c7e21ef4759ecb8dd882c95af32a204ac83928aa413e1d8e9ed312c29c41e2f3c00a78d448df11d15e", nil);
    STAssertEqualObjects(hmacSha384.base64, @"mfKhKRj14MfiHvR1nsuN2ILJWvMqIErIOSiqQT4djp7TEsKcQeLzwAp41EjfEdFe", nil);
    
    STAssertEqualObjects(sha512.hexLower, @"af8489a9fb6dcb8973515cdda3366c939ebcc8ac8fb0a7c322f1333babe03655222930ad48b4924f1a1f13c23856bc3c2e1b93cb10c74e72362e5457756517ff", nil);
    STAssertEqualObjects(sha512.base64, @"r4SJqftty4lzUVzdozZsk568yKyPsKfDIvEzO6vgNlUiKTCtSLSSTxofE8I4Vrw8LhuTyxDHTnI2LlRXdWUX/w==", nil);
    STAssertEqualObjects(hmacSha512.hexLower, @"3807619fdaa2dd77e3dd554a627284406000a5c924db72202af0e6b1832789a94bacc710dc2b7da61fbfd6e1065dfe39085a872538f5b19fde112092c90d893a", nil);
    STAssertEqualObjects(hmacSha512.base64, @"OAdhn9qi3Xfj3VVKYnKEQGAApckk23IgKvDmsYMnialLrMcQ3Ct9ph+/1uEGXf45CFqHJTj1sZ/eESCSyQ2JOg==", nil);
}

@end
