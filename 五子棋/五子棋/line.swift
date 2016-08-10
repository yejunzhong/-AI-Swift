//
//  File.swift
//  五子棋
//
//  Created by 叶俊中 on 16/7/17.
//  Copyright © 2016年 叶俊中. All rights reserved.
//

import UIKit
protocol step:class {
    func stepnum(_: Int)
    func wininfo(_:Int)
}
//class a :prtocol1{
//    var c:b
//    b.delegate = self
//    声明协议内方法
//}
//class b {数据从b到a
//    weak var delegate:protocol1
//    delegate.(协议内方法) 触发协议内方法
//}
class lineView: UIView {
    weak var delegate : step?
    let AIstep = UIView(frame: CGRectMake(0,0, UIScreen.mainScreen().bounds.width / 14 - 50, UIScreen.mainScreen().bounds.width / 14 - 50) )
    let linenum = 13
    var stepnumber = 0
    let path = UIBezierPath()
    var qizi = Array<Array<Int>>(count: 15, repeatedValue:Array<Int>(count:15,repeatedValue: 0))
    override init(frame:CGRect){
        super.init(frame: frame)
        for i in 0 ..< linenum+2 {
            let horizentalLine = UIView.init(frame: CGRectMake(0, CGFloat(i) * frame.size.height / (CGFloat(linenum + 1)), frame.size.width, 1))
            horizentalLine.backgroundColor = UIColor.blackColor()
            self.addSubview(horizentalLine)
        }
        for i in 0 ..< linenum+2 {
            let verticalline = UIView.init(frame: CGRectMake(CGFloat(i) * frame.size.width / (CGFloat(linenum + 1)),0, 1,frame.size.height))
            verticalline.backgroundColor = UIColor.blackColor()
            self.addSubview(verticalline)
        }
        return
    }
    struct winInf{
        var win = false
        var winside = 0
        var winx = 0
        var winy = 0
        var win2x = 0
        var win2y = 0
    }
    override func drawRect(rect: CGRect) {
        UIColor.redColor().set()
        path.stroke()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !win().win {
        let touch = (touches as NSSet).anyObject()
        let touchpoint = touch!.locationInView(self)
        let h = lrintf(Float(touchpoint.x / ((self.frame.size.width) / CGFloat(linenum + 1))))
        let c = lrintf(Float(touchpoint.y / ((self.frame.size.width) / CGFloat(linenum + 1))))
        if qizi[h][c] == 0 {
        let piece = UIImageView.init(frame: CGRectMake(0, 0, 10, 10))
        piece.image = UIImage(named: "black")
        self.addSubview(piece)
        let pieceX = CGFloat(h) * self.frame.size.width / CGFloat(linenum + 1)
        let pieceY = CGFloat(c) * self.frame.size.width / CGFloat(linenum + 1)
        piece.center = CGPointMake(pieceX, pieceY)
        qizi[h][c] = 1
        stepnumber = stepnumber + 1
        delegate?.stepnum(stepnumber)
        //print(stepnumber)
        let wininf = win()
        if wininf.win {
            if wininf.winside > 0 {
                print("黑赢")
            }else if wininf.winside < 0{
                print("白赢")
            }
            let x0 = CGFloat(wininf.winx) * self.frame.size.width / CGFloat(linenum + 1)
            let y0 = CGFloat(wininf.winy) * self.frame.size.width / CGFloat(linenum + 1)
            let x1 = CGFloat(wininf.win2x) * self.frame.size.width / CGFloat(linenum + 1)
            let y1 = CGFloat(wininf.win2y) * self.frame.size.width / CGFloat(linenum + 1)
            let start = CGPointMake(x0, y0)
            let end = CGPointMake(x1, y1)
            let cp1 = CGPointMake((x0 + x1)/2, (y0 + y1)/2)
            path.moveToPoint(start)
            path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp1)
            path.lineWidth = 10
            self.setNeedsDisplay()
        }else{
            AIfunc()
        }
            }}
    }
    func win() -> winInf{
        var sum = 0
        var wininf = winInf()
        charge : for qizix in 0...linenum + 1 {
            for qiziy in 0...linenum + 1 {
//横向胜利************************
                for i in 0...4 {
                    if qizix + i <= linenum + 1{
                        sum = sum + qizi[qizix + i][qiziy]
                    }
                }
                if sum  == 5{
                    wininf = winInf(win: true, winside: 1, winx: qizix, winy: qiziy, win2x: qizix + 4, win2y: qiziy)
                    break charge
                }else if sum == -5{
                    wininf = winInf(win: true, winside: -1, winx: qizix, winy: qiziy, win2x: qizix + 4, win2y: qiziy)
                    break charge
                }else{
                    sum = 0
                }
//竖向胜利************************
                for i in 0...4 {
                    if qiziy + i <= linenum + 1{
                        sum = sum + qizi[qizix][qiziy + i]
                    }
                }
                if sum  == 5{
                    wininf = winInf(win: true, winside: 1, winx: qizix, winy: qiziy, win2x: qizix, win2y: qiziy + 4)
                    break charge
                }else if sum == -5{
                    wininf = winInf(win: true, winside: -1, winx: qizix, winy: qiziy, win2x: qizix, win2y: qiziy + 4)
                    break charge
                }else{
                    sum = 0
                }
//右下胜利************************
                for i in 0...4 {
                    if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1{
                        sum = sum + qizi[qizix + i][qiziy + i]
                    }
                }
                if sum  == 5{
                    wininf = winInf(win: true, winside: 1, winx: qizix, winy: qiziy, win2x: qizix + 4, win2y: qiziy + 4)
                    break charge
                }else if sum == -5{
                    wininf = winInf(win: true, winside: -1, winx: qizix, winy: qiziy, win2x: qizix + 4, win2y: qiziy + 4)
                    break charge
                }else{
                    sum = 0
                }
//右上胜利************************
                for i in 0...4 {
                    if qizix + i <= linenum + 1 && qiziy - i >= 0{
                        sum = sum + qizi[qizix + i][qiziy - i]
                    }
                }
                if sum  == 5{
                    wininf = winInf(win: true, winside: 1, winx: qizix, winy: qiziy, win2x: qizix + 4, win2y: qiziy - 4)
                    break charge
                }else if sum == -5{
                    wininf = winInf(win: true, winside: -1, winx: qizix, winy: qiziy, win2x: qizix + 4, win2y: qiziy - 4)
                    break charge
                }else{
                    sum = 0
                }
            }
        }
        if wininf.win{
            delegate?.wininfo(wininf.winside)
        }
        return wininf
    }
    func AIfunc(){
        var quan = Array<Array<Int>>(count: linenum + 2, repeatedValue:Array<Int>(count:linenum + 2,repeatedValue: 0))
        var quan2 = Array<Array<Int>>(count: linenum + 2, repeatedValue:Array<Int>(count:linenum + 2,repeatedValue: 0))
        var count = 1
        var aix = 0
        var aiy = 0
        var aix2 = 0
        var aiy2 = 0
        var maxquan = 0
        var maxquan2 = 0
        //棋子周围4层加权重
        //黑棋权，白棋权，绝对值相加和最大者为最佳落点
        //权值扩散，当前同一方向上下一点的属性（黑白空）需回朔当前点的权值
        for qizix in 0...linenum + 1 {
            for qiziy in 0...linenum + 1 {
                if qizi[qizix][qiziy] == 1{//黑棋权
                    count = 1
//右扩展**********************************************************************************************
                    xup:for i in 1...4 {
                        if qizix + i <= linenum + 1{
                            if qizi[qizix + i][qiziy] != -1{
                                for h in 1...i {
                                    if qizi[qizix + h][qiziy] == 0 {
                                        quan[qizix + h][qiziy] = quan[qizix + h][qiziy] + 10
                                    }
                                }
                            }else{
                                break xup
                            }
                        }
                    }
                    for i in 1...4 {//数组边界益处，反方向也考虑同色子数
                        if qizix + i <= linenum + 1 {
                            if qizi[qizix + i][qiziy] == 1 {
                                count = count + 1
                            }else if qizi[qizix + i][qiziy] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix + i <= linenum + 1 {
                            quan[qizix + i][qiziy] = quan[qizix + i][qiziy] * count
                        }
                    }
                    count = 1
//左扩展**********************************************************************************************
                    xdown:for i in 1...4{
                        if qizix - i >= 0{
                            if qizi[qizix - i][qiziy] != -1{
                                for h in 1...i {
                                    if qizi[qizix - h][qiziy] == 0 {
                                        quan[qizix - h][qiziy] = quan[qizix - h][qiziy] + 10
                                    }
                                }
                            }else{
                                break xdown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix - i >= 0{
                            if qizi[qizix - i][qiziy] == 1 {
                                count = count + 1
                            }else if qizi[qizix - i][qiziy] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix - i >= 0 {
                            quan[qizix - i][qiziy] = quan[qizix - i][qiziy] * count
                        }
                    }
                    count = 1
//上扩展**********************************************************************************************
                    yup:for i in 1...4 {
                        if qiziy + i <= linenum + 1{
                            if qizi[qizix][qiziy + i] != -1{
                                for h in 1...i {
                                    if qizi[qizix][qiziy + h] == 0 {
                                        quan[qizix][qiziy + h] = quan[qizix][qiziy + h] + 10
                                    }
                                }
                            }else{
                                break yup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qiziy + i <= linenum + 1 {
                            if qizi[qizix][qiziy + i] == 1 {
                                count = count + 1
                            }else if qizi[qizix][qiziy + i] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qiziy + i <= linenum + 1 {
                            quan[qizix][qiziy + i] = quan[qizix][qiziy + i] * count
                        }
                    }
                    count = 1
//下扩展**********************************************************************************************
                    ydown:for i in 1...4 {
                        if qiziy - i >= 0{
                            if qizi[qizix][qiziy - i] != -1{
                                for h in 1...i {
                                    if qizi[qizix][qiziy - h] == 0 {
                                        quan[qizix][qiziy - h] = quan[qizix][qiziy - h] + 10
                                    }
                                }
                            }else{
                                break ydown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qiziy - i >= 0{
                            if qizi[qizix][qiziy - i] == 1 {
                                count = count + 1
                            }else if qizi[qizix][qiziy - i] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qiziy - i >= 0 {
                            quan[qizix][qiziy - i] = quan[qizix][qiziy - i] * count
                        }
                    }
                    count = 1
                    //斜方向**********************************************************************************************
//右上扩展**********************************************************************************************
                    xupyup:for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1{
                            if qizi[qizix + i][qiziy + i] != -1{
                                for h in 1...i {
                                    if qizi[qizix + h][qiziy + h] == 0 {
                                        quan[qizix + h][qiziy + h] = quan[qizix + h][qiziy + h] + 10
                                    }
                                }
                            }else{
                                break xupyup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1 {
                            if qizi[qizix + i][qiziy + i] == 1 {
                                count = count + 1
                            }else if qizi[qizix + i][qiziy + i] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1 {
                            quan[qizix + i][qiziy + i] = quan[qizix + i][qiziy + i] * count
                        }
                    }
                    count = 1
//左上扩展**********************************************************************************************
                    xdownydown:for i in 1...4{
                        if qizix - i >= 0 && qiziy - i >= 0{
                            if qizi[qizix - i][qiziy - i] != -1{
                                for h in 1...i {
                                    if qizi[qizix - h][qiziy - h] == 0 {
                                        quan[qizix - h][qiziy - h] = quan[qizix - h][qiziy - h] + 10
                                    }
                                }
                            }else{
                                break xdownydown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix - i >= 0 && qiziy - i >= 0{
                            if qizi[qizix - i][qiziy - i] == 1 {
                                count = count + 1
                            }else if qizi[qizix - i][qiziy - i] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix - i >= 0 && qiziy - i >= 0{
                            quan[qizix - i][qiziy - i] = quan[qizix - i][qiziy - i] * count
                        }
                    }
                    count = 1
//右下扩展**********************************************************************************************
                    xupydown:for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy - i >= 0{
                            if qizi[qizix + i][qiziy - i] != -1{
                                for h in 1...i {
                                    if qizi[qizix + h][qiziy - h] == 0 {
                                        quan[qizix + h][qiziy - h] = quan[qizix + h][qiziy - h] + 10
                                    }
                                }
                            }else{
                                break xupydown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix + i <= linenum + 1 && qiziy - i >= 0 {
                            if qizi[qizix + i][qiziy - i] == 1 {
                                count = count + 1
                            }else if qizi[qizix + i][qiziy - i] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy - i >= 0 {
                            quan[qizix + i][qiziy - i] = quan[qizix + i][qiziy - i] * count
                        }
                    }
                    count = 1
//左下扩展**********************************************************************************************
                    xdownyup:for i in 1...4{
                        if qizix - i >= 0 && qiziy + i <= linenum + 1{
                            if qizi[qizix - i][qiziy + i] != -1{
                                for h in 1...i {
                                    if qizi[qizix - h][qiziy + h] == 0 {
                                        quan[qizix - h][qiziy + h] = quan[qizix - h][qiziy + h] + 10
                                    }
                                }
                            }else{
                                break xdownyup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix - i >= 0 && qiziy + i <= linenum + 1 {
                            if qizi[qizix - i][qiziy + i] == 1 {
                                count = count + 1
                            }else if qizi[qizix - i][qiziy + i] == -1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix - i >= 0 && qiziy + i <= linenum + 1 {
                            quan[qizix - i][qiziy + i] = quan[qizix - i][qiziy + i] * count
                        }
                    }
                    count = 1
                }else if qizi[qizix][qiziy] == -1{//白棋权
                    count = 1
//右扩展**********************************************************************************************
                    xup:for i in 1...4 {
                        if qizix + i <= linenum + 1{
                            if qizi[qizix + i][qiziy] != 1{
                                for h in 1...i {
                                    if qizi[qizix + h][qiziy] == 0 {
                                        quan2[qizix + h][qiziy] = quan2[qizix + h][qiziy] + 10
                                    }
                                }
                            }else{
                                break xup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix + i <= linenum + 1 {
                            if qizi[qizix + i][qiziy] == -1 {
                                count = count + 1
                            }else if qizi[qizix + i][qiziy] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix + i <= linenum + 1 {
                            quan2[qizix + i][qiziy] = quan2[qizix + i][qiziy] * count
                        }
                    }
                    count = 1
//左扩展**********************************************************************************************
                    xdown:for i in 1...4{
                        if qizix - i >= 0{
                            if qizi[qizix - i][qiziy] != 1{
                                for h in 1...i {
                                    if qizi[qizix - h][qiziy] == 0 {
                                        quan2[qizix - h][qiziy] = quan2[qizix - h][qiziy] + 10
                                    }
                                }
                            }else{
                                break xdown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix - i >= 0 {
                            if qizi[qizix - i][qiziy] == -1 {
                                count = count + 1
                            }else if qizi[qizix - i][qiziy] == +1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix - i >= 0 {
                            quan2[qizix - i][qiziy] = quan2[qizix - i][qiziy] * count
                        }
                    }
                    count = 1
//上扩展**********************************************************************************************
                    yup:for i in 1...4 {
                        if qiziy + i <= linenum + 1{
                            if qizi[qizix][qiziy + i] != 1{
                                for h in 1...i {
                                    if qizi[qizix][qiziy + h] == 0 {
                                        quan2[qizix][qiziy + h] = quan2[qizix][qiziy + h] + 10
                                    }
                                }
                            }else{
                                break yup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qiziy + i <= linenum + 1 {
                            if qizi[qizix][qiziy + i] == -1 {
                                count = count + 1
                            }else if qizi[qizix][qiziy + i] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qiziy + i <= linenum + 1 {
                            quan2[qizix][qiziy + i] = quan2[qizix][qiziy + i] * count
                        }
                    }
                    count = 1
//下扩展**********************************************************************************************
                    ydown:for i in 1...4 {
                        if qiziy - i >= 0{
                            if qizi[qizix][qiziy - i] != 1{
                                for h in 1...i {
                                    if qizi[qizix][qiziy - h] == 0 {
                                        quan2[qizix][qiziy - h] = quan2[qizix][qiziy - h] + 10
                                    }
                                }
                            }else{
                                break ydown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qiziy - i >= 0 {
                            if qizi[qizix][qiziy - i] == -1 {
                                count = count + 1
                            }else if qizi[qizix][qiziy - i] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qiziy - i >= 0 {
                            quan2[qizix][qiziy - i] = quan2[qizix][qiziy - i] * count
                        }
                    }
                    count = 1
                    //斜方向**********************************************************************************************
//右上扩展**********************************************************************************************
                    xupyup:for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1{
                            if qizi[qizix + i][qiziy + i] != 1{
                                for h in 1...i {
                                    if qizi[qizix + h][qiziy + h] == 0 {
                                        quan2[qizix + h][qiziy + h] = quan2[qizix + h][qiziy + h] + 10
                                    }
                                }
                            }else{
                                break xupyup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1 {
                            if qizi[qizix + i][qiziy + i] == -1 {
                                count = count + 1
                            }else if qizi[qizix + i][qiziy + i] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy + i <= linenum + 1 {
                            quan2[qizix + i][qiziy + i] = quan2[qizix + i][qiziy + i] * count
                        }
                    }
                    count = 1
//左上扩展**********************************************************************************************
                    xdownydown:for i in 1...4{
                        if qizix - i >= 0 && qiziy - i >= 0{
                            if qizi[qizix - i][qiziy - i] != 1{
                                for h in 1...i {
                                    if qizi[qizix - h][qiziy - h] == 0 {
                                        quan2[qizix - h][qiziy - h] = quan2[qizix - h][qiziy - h] + 10
                                    }
                                }
                            }else{
                                break xdownydown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix - i >= 0 && qiziy - i >= 0 {
                            if qizi[qizix - i][qiziy - i] == -1 {
                                count = count + 1
                            }else if qizi[qizix - i][qiziy - i] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix - i >= 0 && qiziy - i >= 0 {
                            quan2[qizix - i][qiziy - i] = quan2[qizix - i][qiziy - i] * count
                        }
                    }
                    count = 1
//右下扩展**********************************************************************************************
                    xupydown:for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy - i >= 0{
                            if qizi[qizix + i][qiziy - i] != 1{
                                for h in 1...i {
                                    if qizi[qizix + h][qiziy - h] == 0 {
                                        quan2[qizix + h][qiziy - h] = quan2[qizix + h][qiziy - h] + 10
                                    }
                                }
                            }else{
                                break xupydown
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix + i <= linenum + 1 && qiziy - i >= 0 {
                            if qizi[qizix + i][qiziy - i] == -1 {
                                count = count + 1
                            }else if qizi[qizix + i][qiziy - i] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix + i <= linenum + 1 && qiziy - i >= 0 {
                            quan2[qizix + i][qiziy - i] = quan2[qizix + i][qiziy - i] * count
                        }
                    }
                    count = 1
//左下扩展**********************************************************************************************
                    xdownyup:for i in 1...4{
                        if qizix - i >= 0 && qiziy + i <= linenum + 1{
                            if qizi[qizix - i][qiziy + i] != 1{
                                for h in 1...i {
                                    if qizi[qizix - h][qiziy + h] == 0 {
                                        quan2[qizix - h][qiziy + h] = quan2[qizix - h][qiziy + h] + 10
                                    }
                                }
                            }else{
                                break xdownyup
                            }
                        }
                    }
                    for i in 1...4 {
                        if qizix - i >= 0 && qiziy + i <= linenum + 1 {
                            if qizi[qizix - i][qiziy + i] == -1 {
                                count = count + 1
                            }else if qizi[qizix - i][qiziy + i] == 1{
                                break
                            }
                        }
                    }
                    for i in 1...4{
                        if qizix - i >= 0 && qiziy + i <= linenum + 1 {
                            quan2[qizix - i][qiziy + i] = quan2[qizix - i][qiziy + i] * count
                        }
                    }
                    count = 1
                }
            }
        }
        for qizix in 0...linenum + 1 {
            for qiziy in 0...linenum + 1{
                quan[qizix][qiziy] = quan[qizix][qiziy]
            }
        }
        for qizix in 0...linenum + 1{
            for qiziy in 0...linenum + 1{
                if quan[qizix][qiziy] > maxquan {
                    maxquan = quan[qizix][qiziy]
                    aix = qizix
                    aiy = qiziy
                }
                if quan2[qizix][qiziy] > maxquan2 {
                    maxquan2 = quan2[qizix][qiziy]
                    aix2 = qizix
                    aiy2 = qiziy
                }
            }
        }
        if quan[aix][aiy] <= quan2[aix2][aiy2] {
            aix = aix2
            aiy = aiy2
        }
        //AI落子
        let piece = UIImageView.init(frame: CGRectMake(0, 0, 10, 10))
        piece.image = UIImage(named: "white")
        self.addSubview(piece)
        //AIstep.removeFromSuperview()
        self.addSubview(AIstep)
        AIstep.backgroundColor = UIColor.clearColor()
        AIstep.layer.borderWidth = 1
        let pieceX = CGFloat(aix) * self.frame.size.width / CGFloat(linenum + 1)
        let pieceY = CGFloat(aiy) * self.frame.size.width / CGFloat(linenum + 1)
        piece.center = CGPointMake(pieceX, pieceY)
        AIstep.center = CGPointMake(pieceX, pieceY)
        qizi[aix][aiy] = -1
        let wininf = win()
        if wininf.win {
            if wininf.winside > 0 {
                print("黑赢")
            }else if wininf.winside < 0{
                print("白赢")
            }
            let x0 = CGFloat(wininf.winx) * self.frame.size.width / CGFloat(linenum + 1)
            let y0 = CGFloat(wininf.winy) * self.frame.size.width / CGFloat(linenum + 1)
            let x1 = CGFloat(wininf.win2x) * self.frame.size.width / CGFloat(linenum + 1)
            let y1 = CGFloat(wininf.win2y) * self.frame.size.width / CGFloat(linenum + 1)
            //let path = UIBezierPath()
            let start = CGPointMake(x0, y0)
            let end = CGPointMake(x1, y1)
            let cp1 = CGPointMake((x0 + x1)/2, (y0 + y1)/2)
            path.moveToPoint(start)
            path.addCurveToPoint(end, controlPoint1: cp1, controlPoint2: cp1)
            path.lineWidth = 10
            self.setNeedsDisplay()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


