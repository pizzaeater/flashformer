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

import flash.display.GradientType;
import flash.geom.Matrix;

public class GradientRect extends UIElement
{
  private var _colors:Array;
  private var _alphas:Array;
  private var _ratios:Array;
  private var _borderColor:uint;
  private var _borderAlpha:Number;
  private var _cornerRadius:Number;

  public function GradientRect( colors:Array, alphas:Array = null, ratios:Array = null, borderColor:uint = 0, borderAlpha:Number = 0 )
  {
    super();

    mouseChildren = false;

    _colors = colors;
    _alphas = alphas ? alphas : getDefaultAlphas();
    _ratios = ratios ? ratios : getDefaultRatios();
    _borderColor = borderColor;
    _borderAlpha = borderAlpha;
    _cornerRadius = 0;

    drawOutline( _colors[0], 0 );
  }

  private function getDefaultAlphas():Array
  {
    var alphas:Array = [];
    for( var i:uint = 0; i < _colors.length; i++ )
    {
      alphas.push( 1.0 );
    }

    return alphas;
  }

  private function getDefaultRatios():Array
  {
    var ratios:Array = [];
    for( var i:uint = 0; i < _colors.length; i++ )
    {
      ratios.push( i * (255 / (_colors.length - 1)) );
    }

    return ratios;
  }

  override public function draw():void
  {
    super.draw();

    var mGrad:Matrix = new Matrix();
    mGrad.createGradientBox( width, height, Math.PI / 2 );

    with( graphics )
    {
      clear();
      lineStyle( 0, _borderColor, _borderAlpha, true );
      beginGradientFill( GradientType.LINEAR, _colors, _alphas, _ratios, mGrad );

      if( _cornerRadius <= 0 )
      {
        drawRect( 0, 0, width, height );
      }
      else
      {
        drawRoundRect( 0, 0, width, height, _cornerRadius, _cornerRadius );
      }

      endFill();
    }
  }

  public function set cornerRadius( cornerRadius:Number ):void
  {
    _cornerRadius = cornerRadius;

    draw();
  }

  public function set colors( colors:Array ):void
  {
    _colors = colors;

    draw();
  }
}
}
