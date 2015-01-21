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

package com.flashformer.proto
{
import com.flashformer.display.UIElement;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class DebugButton extends UIElement
{
  private var _tf:TextField;
  private var _caption:String;
  private var _obj:Object;
  private var _selected:Boolean;

  public function DebugButton( caption:String, size:uint = 10, obj:Object = null )
  {
    _caption = caption;
    _obj = obj ? obj : _caption;

    buttonMode = true;
    mouseChildren = false;

    var tformat:TextFormat = new TextFormat();
    tformat.font = "Verdana";
    tformat.color = 0xffffff;
    tformat.size = size;

    _tf = new TextField();
    _tf.autoSize = TextFieldAutoSize.LEFT;
    _tf.defaultTextFormat = tformat;
    _tf.text = _caption;
    _tf.selectable = false;
    _tf.border = true;
    _tf.background = true;
    _tf.backgroundColor = 0x0;
    addChild( _tf );

    width = _tf.width;
    height = _tf.height;
  }

  public function select():void
  {
    _selected = true;

    _tf.backgroundColor = 0x009900;
    for( var i:uint = 0; i < parent.numChildren; i++ )
    {
      if( parent.getChildAt( i ) == this )
      {
        continue;
      }
      if( parent.getChildAt( i ) is DebugButton )
      {
        ( parent.getChildAt( i ) as DebugButton ).deselect();
      }
    }
  }

  public function deselect():void
  {
    _selected = false;

    _tf.backgroundColor = 0;
  }

  public function get obj():Object
  {
    return _obj;
  }

  public function get caption():String
  {
    return _caption;
  }

  public function set caption( caption:String ):void
  {
    _caption = caption;

    _tf.text = _caption;

    width = _tf.width;
    height = _tf.height;
  }

  public function set backgroundColor( value:uint ):void
  {
    _tf.backgroundColor = value;
  }

  public function get selected():Boolean
  {
    return _selected;
  }
}
}
