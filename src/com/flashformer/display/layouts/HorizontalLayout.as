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

public class HorizontalLayout extends BaseLayout
{
  public function HorizontalLayout( gap:int = 0 )
  {
    super( gap );
  }

  override protected function position( startIndex:int = 0 ):void
  {
    super.position( startIndex );

    _length = 0;

    var el:DisplayObject;

    var pos:int;
    if( startIndex > 0 )
    {
      el = getChildAt( startIndex - 1 );
      pos = el.x + el.width + _gap;
    }
    else
    {
      pos = 0;
    }

    var lastVisibleEl:DisplayObject;
    for( var i:int = startIndex; i < numChildren; i++ )
    {
      el = getChildAt( i ) as DisplayObject;
      el.x = pos;

      if( el.visible )
      {
        pos += el.width + _gap;
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
      width = lastVisibleEl.x + lastVisibleEl.width;
    }
    else
    {
      width = 0;
    }
  }
}
}
