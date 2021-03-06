/*
 Copyright (c) 2013, salesforce.com Co.,Ltd. inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "MemoBoard.h"

@implementation MemoBoard

typedef enum {
	ENUM_BLACK,
	ENUM_BLUE,
	ENUM_RED,
  ENUM_ERASE
} penType;

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
		// キャンバスのインスタンスを生成
		canvas = [[UIImageView alloc] initWithImage:nil];
		canvas.backgroundColor= [UIColor whiteColor];
		CGRect r = self.frame;
		r.origin.x = 0;
		r.origin.y = 0;
		canvas.frame = r;
		[canvas.layer setBorderWidth:1.0f];
		[self insertSubview:canvas atIndex:0];

    _penMode = 0;
    
    _width0 = 5.0; // 黒の線の太さ
    _width1 = 5.0; // 青
    _width2 = 5.0; // 赤
    _width3 = 5.0; // 消しゴム
  }
  return self;
}


-(void)viewDidLoad
{
}
// 画面に指をタッチしたとき
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  // タッチ開始座標をインスタンス変数touchPointに保持
  UITouch *touch = [touches anyObject];
  touchPoint = [touch locationInView:canvas];
}

// 画面に指がタッチされた状態で動かしているとき
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
  // 現在のタッチ座標をローカル変数currentPointに保持
  UITouch *touch = [touches anyObject];
  CGPoint currentPoint = [touch locationInView:canvas];
  
  // 描画領域をcanvasの大きさで生成
  UIGraphicsBeginImageContext(canvas.frame.size);
  
  // canvasにセットされている画像（UIImage）を描画
  [canvas.image drawInRect:
	 CGRectMake(0, 0, canvas.frame.size.width, canvas.frame.size.height)];
  
  // 線の角を丸くする
  CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
  
  // 線の太さを指定
  switch (_penMode) {
    case 0:
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width0);
      break;
    case 1:
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width1);
      break;
    case 2:
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width2);
      break;
    case 3:
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width3);
      break;
    default:
      CGContextSetLineWidth(UIGraphicsGetCurrentContext(), _width0);
      break;
  }
  //CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 5.0);
  
  // 線の色を指定（RGB）
  switch (_penMode) {
    case 0:
      color[0]=0.0;
      color[1]=0.0;
      color[2]=0.0;
      color[3]=1.0;
      break;
    case 1:
      color[0]=1.0;
      color[1]=0.0;
      color[2]=0.0;
      color[3]=1.0;
      break;
    case 2:
      color[0]=0.0;
      color[1]=0.0;
      color[2]=1.0;
      color[3]=1.0;
      break;
    case 3:
      color[0]=1.0;
      color[1]=1.0;
      color[2]=1.0;
      color[3]=1.0;
      break;
    default:
      color[0]=1.0;
      color[1]=1.0;
      color[2]=1.0;
      color[3]=1.0;
      break;
  }
  CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), color[0], color[1], color[2], color[3]);
  
  // 線の描画開始座標をセット
	CGContextMoveToPoint(UIGraphicsGetCurrentContext(), touchPoint.x, touchPoint.y);
  
  // 線の描画終了座標をセット
  CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
  
  // 描画の開始～終了座標まで線を引く
  CGContextStrokePath(UIGraphicsGetCurrentContext());
  
  // 描画領域を画像（UIImage）としてcanvasにセット
  canvas.image = UIGraphicsGetImageFromCurrentImageContext();
  
  // 描画領域のクリア
  UIGraphicsEndImageContext();
  
  // 現在のタッチ座標を次の開始座標にセット
  touchPoint = currentPoint;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
