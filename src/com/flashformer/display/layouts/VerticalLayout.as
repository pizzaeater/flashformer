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
import com.flashformer.display.UIElement;

import flash.display.DisplayObject;

public class VerticalLayout extends BaseLayout
{
  private var _widthChange:Boolean;
  private var _paddingTop:int;
  private var _paddingBottom:int;
  private var _center:Boolean;

  public function VerticalLayout( gap:int = 0, widthChange:Boolean = true, paddingTop:int = 0, paddingBottom:int = 0, center:Boolean = false )
  {
    super( gap );

    _widthChange = widthChange;
    _paddingTop = paddingTop;
    _paddingBottom = paddingBottom;
    _center = center;
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
      pos = el.y + el.height + _gap;
    }
    else
    {
      pos = _paddingTop;
    }

    var lastVisibleEl:DisplayObject;
    for( var i:int = startIndex; i < numChildren; i++ )
    {
      el = getChildAt( i ) as DisplayObject;
      el.y = pos;
      if( el is UIElement )
      {
        el.y += ( el as UIElement ).margin.top;
      }

      if( _useUnvisible || el.visible )
      {
        if( _widthChange )
        {
          if( el is UIElement )
          {
            if( ( el as UIElement ).margin.left > 0 || ( el as UIElement ).margin.right > 0 )
            {
              el.x = ( el as UIElement ).margin.left;
              el.width = width - el.x - ( el as UIElement ).margin.right;
            }
            else
            {
              el.width = width - el.x;
            }
            ( el as UIElement ).draw();
          }
          else
          {
            el.width = width - el.x;
          }
        }
        else if( _center )
        {
          el.x = width / 2 - el.width / 2;
        }

        pos += el.height + _gap;
        if( el is UIElement )
        {
          pos += ( el as UIElement ).margin.top + ( el as UIElement ).margin.bottom;
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
      height = lastVisibleEl.y + lastVisibleEl.height + _paddingBottom;
      if( lastVisibleEl is UIElement )
      {
        height += ( lastVisibleEl as UIElement ).margin.bottom;
      }
    }
    else
    {
      height = 0;
    }
  }
}
}
