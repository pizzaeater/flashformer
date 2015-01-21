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

package com.flashformer.display.layouts
{
import flash.display.DisplayObject;

public class BothLayout extends BaseLayout
{
  private var _balanceLines:Boolean;
  private var _balanceRight:int;

  public function BothLayout( gap:int = 0, balanceLines:Boolean = false )
  {
    super( gap );

    _balanceLines = balanceLines;
  }

  override protected function position( startIndex:int = 0 ):void
  {
    super.position( startIndex );

    _length = 0;

    var rightRule:int = getRightRule();
    _balanceRight = rightRule;

    var el:DisplayObject;

    var xPos:int;
    var yPos:int;
    if( startIndex > 0 )
    {
      el = getChildAt( startIndex - 1 );
      xPos = el.x + el.width + _gap;
      yPos = el.y + el.height + _gap;
    }
    else
    {
      xPos = 0;
      yPos = 0;
    }

    var lineHeight:int;
    var nextEl:DisplayObject;
    var lastVisibleEl:DisplayObject;
    for( var i:int = startIndex; i < numChildren; i++ )
    {
      el = getChildAt( i ) as DisplayObject;
      el.x = xPos;
      el.y = yPos;

      if( el.visible )
      {
        lineHeight = Math.max( lineHeight, el.height );
        xPos += el.width + _gap;

        if( _balanceLines )
        {
          if( xPos > rightRule )
          {
            xPos = 0;
            yPos += lineHeight + _gap;

            lineHeight = 0;
          }

        }
        else
        {
          if( i < numChildren - 1 )
          { // если не последний элемент
            nextEl = getChildAt( i + 1 ) as DisplayObject;

            if( xPos + nextEl.width > rightRule )
            {
              xPos = 0;
              yPos += lineHeight + _gap;

              lineHeight = 0;
            }
          }
        }

        lastVisibleEl = el;

        _length++;
      }
    }

    if( startIndex >= numChildren )
    {
      lastVisibleEl = getLastVisibleElement();
    }

    if( lastVisibleEl )
    {
      height = yPos + lineHeight;
    }
    else
    {
      height = 0;
    }
  }

  private function getRightRule():int
  {
    if( _balanceLines )
    {
      var fullWidth:uint = getFullWidth();
      var linesCount:int = Math.ceil( fullWidth / width );
      var rule:int = fullWidth / linesCount;

      var el:DisplayObject;
      var pos:int = 0;
      for( var i:int = 0; i < numChildren; i++ )
      {
        el = getChildAt( i ) as DisplayObject;

        if( rule > pos && rule <= pos + el.width + _gap )
        {
          return pos + el.width;
        }

        pos += el.width + _gap;
      }
      return 0;

    }
    else
    {
      return width;
    }
  }

  private function getFullWidth():uint
  {
    var fullWidth:uint = 0;
    var el:DisplayObject;
    for( var i:int = 0; i < numChildren; i++ )
    {
      el = getChildAt( i ) as DisplayObject;
      fullWidth += el.width + _gap;
    }
    fullWidth -= _gap;

    return fullWidth;
  }

  public function get balanceRight():int
  {
    return _balanceRight;
  }
}
}
