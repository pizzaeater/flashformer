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

package com.flashformer.data
{
import flash.display.DisplayObject;
import flash.events.Event;

public class BinaryLoaderEvent extends Event
{
  static public const LOAD_COMPLETE:String = 'LOAD_COMPLETE';
  static public const LOAD_ERROR:String = 'LOAD_ERROR';
  private var _id:uint;
  private var _binaryContent:DisplayObject;

  public function BinaryLoaderEvent( type:String, id:uint, binaryContent:DisplayObject = null )
  {
    super( type );

    _id = id;
    _binaryContent = binaryContent;
  }

  override public function clone():Event
  {
    return new BinaryLoaderEvent( type, _id, _binaryContent );
  }

  public function get id():uint
  {
    return _id;
  }

  public function get binaryContent():DisplayObject
  {
    return _binaryContent;
  }
}
}
