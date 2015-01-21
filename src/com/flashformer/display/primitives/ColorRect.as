/*
 The MIT License (MIT)

 Copyright (c) 2008 Evgeny Nepomnyashchiy

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

package com.flashformer.display.primitives
{
import com.flashformer.display.UIElement;

import flash.display.LineScaleMode;

public class ColorRect extends UIElement
{
  private var _color:Number;
  private var _alpha:Number;
  private var _borderColor:uint;
  private var _borderAlpha:Number;
  private var _borderThickness:Number;
  private var _cornerRadius:Number;

  public function ColorRect( color:uint, alpha:Number = 1.0, borderColor:uint = 0.0, borderAlpha:Number = 0.0 )
  {
    super();

    mouseChildren = false;

    _color = color;
    _alpha = alpha;
    _borderColor = borderColor;
    _borderAlpha = borderAlpha;
    _borderThickness = 0.0;
    _cornerRadius = 0;

    drawOutline( color, 0 );
  }

  override public function draw():void
  {
    super.draw();

    with( graphics )
    {
      clear();
      lineStyle( _borderThickness, _borderColor, _borderAlpha, true, LineScaleMode.NONE );
      beginFill( _color, _alpha );

      if( width > 0 && height > 0 )
      {
        if( _cornerRadius <= 0 )
        {
          drawRect( 0, 0, width, height );
        }
        else
        {
          drawRoundRect( 0, 0, width, height, _cornerRadius, _cornerRadius );
        }
      }

      endFill();
    }
  }

  public function set cornerRadius( cornerRadius:Number ):void
  {
    _cornerRadius = cornerRadius;

    draw();
  }

  public function set backgroundColor( backgroundColor:Number ):void
  {
    _color = backgroundColor;

    draw();
  }

  public function set backgroundAlpha( backgroundAlpha:Number ):void
  {
    _alpha = backgroundAlpha;

    draw();
  }

  public function set borderColor( borderColor:Number ):void
  {
    _borderColor = borderColor;

    draw();
  }

  public function set borderAlpha( borderAlpha:Number ):void
  {
    _borderAlpha = borderAlpha;

    draw();
  }

  public function set borderThickness( borderThickness:Number ):void
  {
    _borderThickness = borderThickness;

    draw();
  }
}
}
