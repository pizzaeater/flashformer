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
import com.flashformer.display.UIPad;

import flash.display.DisplayObject;

internal class BaseLayout extends UIPad
{
  protected var _gap:int;
  protected var _length:uint;
  protected var _useUnvisible:Boolean;

  public function BaseLayout( gap:int )
  {
    super();

    _gap = gap;
  }

  override public function draw():void
  {
    position();

    super.draw();
  }

  override public function addChild( child:DisplayObject ):DisplayObject
  {
    var el:DisplayObject = super.addChild( child );
//    el.addEventListener( GuiEvent.DRAW, onChildDraw );

    return el;
  }

  override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
  {
    var el:DisplayObject = super.addChildAt( child, index );
//    el.addEventListener( GuiEvent.DRAW, onChildDraw );

    return el;
  }

  override public function removeChild( child:DisplayObject ):DisplayObject
  {
    var el:DisplayObject = super.removeChild( child );
//    el.removeEventListener( GuiEvent.DRAW, onChildDraw );

    return el;
  }

  override public function removeChildAt( index:int ):DisplayObject
  {
    var el:DisplayObject = super.removeChildAt( index );
//    el.removeEventListener( GuiEvent.DRAW, onChildDraw );

    return el;
  }

  protected function position( startIndex:int = 0 ):void
  {
  }

  protected function getLastVisibleElement():DisplayObject
  {
    var el:DisplayObject;
    for( var i:int = 0; i < numChildren; i++ )
    {
      el = getChildAt( numChildren - i - 1 );
      if( _useUnvisible || el.visible )
      {
        return el;
      }
    }

    return null;
  }

//  private function onChildDraw( event:GuiEvent ):void
//  {
//    var el:DisplayObject = event.currentTarget as DisplayObject;
//    position( getChildIndex( el ) + 1 );
//  }

  public function set gap( gap:int ):void
  {
    _gap = gap;
  }

  public function get gap():int
  {
    return _gap;
  }

  public function get length():uint
  {
    return _length;
  }

  public function set useUnvisible( value:Boolean ):void
  {
    _useUnvisible = value;
  }
}
}
