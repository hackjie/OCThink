//
//  StringViewController.m
//  OCThink
//
//  Created by leoli on 2018/8/16.
//  Copyright © 2018 leoli. All rights reserved.
//

#import "StringViewController.h"

@interface StringViewController ()
@property (nonatomic, strong) NSString *strongString;
@property (nonatomic, copy) NSString *copyedString;

@property (nonatomic, copy) NSMutableString *copyedMutableString;
@end

@implementation StringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

//    NSString *string = [NSString stringWithFormat:@"abc"];
    NSMutableString *string = [NSMutableString stringWithFormat:@"abc"];
    self.strongString = string;
    self.copyedString = string;

    NSLog(@"origin string: %@ %p, %p",string, string, &string);// 指针指向对象地址；指针内存地址
    NSLog(@"strong string: %@ %p, %p",_strongString, _strongString, &_strongString);
    NSLog(@"copy string: %@ %p, %p",_copyedString, _copyedString, &_copyedString);

//    string= @"lijie";
    [string appendString:@"haha"];

    NSLog(@"origin string: %@ %p, %p",string, string, &string);// 指针指向对象地址；指针内存地址
    NSLog(@"strong string: %@ %p, %p",_strongString, _strongString, &_strongString);
    NSLog(@"copy string: %@ %p, %p",_copyedString, _copyedString, &_copyedString);

    //------1------
    // 通过copy方法可以创建可变对象或不可变对象的不可变副本，对于不可变副本，其对象的值不可以改变。
    // 通过mutableCopy方法可以创建可变对象或不可变对象的可变副本，对于可变副本其对象是可变的。
    //------------

    //------2-------
    // 不可变与可变理解

    // NSString 是不可变的， NSMutableString 是可变的，为什么这么说呢，
    // 如果是 NSString 对象赋值 @"lijie", 之后再赋其他值比如 @"haha"，那么
    // 这个对象的内存地址变了，所以说 NSString 是不可变的字符串

    // NSMutableString 是可变的，为什么这么说呢，
    // 因为当对象的值变化的时候，对象的内存地址并没有变化
    // 所以是可变字符串
    //-------------

    //------3-----------------------
    // NSString NSArray 是用 copy 还是 strong

    // 其实 NSString 是用 copy 还是 strong 修饰将直接影响它的 set 方法实现
    // 但使用 copy 修饰时，set 方法里会进行判断来源是 NSString 还是 NSMutableString
    // 如果来源是 NSString 那没关系啊，因为它是不可变对象，给其他值，它就会有其他内存空间
    // 不会影响到其他属性
    // 如果来源是 NSMutableString，那么就会进行深拷贝，直接自己独立使用一块内存，随便
    // 原来的怎么变

    // 使用 strong 修饰的话，就会和来源 字符串 对象共享一块内存，如果来源是不可变对象
    // 没关系因为是不可变对象，所以来源字符串值变了就会重新用另一块内存，不会影响到原来的
    // 但如果来源是可变对象，它的值变化还是在原来的内存上，那么肯定会影响指向这块内存的其他对象啊
    //-----------------------------

    //------4--------
    // NSMutableString NSMutableArray 一定不能用 copy
    // 如果要用可以重写 set 方法
    // 因为第1步说了用 copy 得到的都是不可变对象，相当于 [str copy] 操作，
    // 所以不能进行 可变对象的 操作
    //--------------
//    self.copyedMutableString = [NSMutableString stringWithFormat:@""];
//    [self.copyedMutableString appendString:@"hh"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
