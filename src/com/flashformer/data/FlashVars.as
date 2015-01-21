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

public class FlashVars
{
  static private var _flashvarsObj:Object;

  public function FlashVars():void
  {
    throw new Error( "Error: FlashVars instantiation failed!" );
  }

  static public function init( obj:Object = null ):void
  {
    _flashvarsObj = obj;
  }

  static public function addDefaultVar( name:String, value:Object ):void
  {
    if( !_flashvarsObj[name] )
    {
      _flashvarsObj[name] = String( value );
    }
  }

  static public function getStringByName( name:String ):String
  {
    if( _flashvarsObj[name] != null )
    {
      return _flashvarsObj[name];
    }
    else
    {
      return "";
    }
  }

  static public function getNumberByName( name:String ):Number
  {
    if( _flashvarsObj[name] != null )
    {
      return Number( _flashvarsObj[name] );
    }
    else
    {
      return 0;
    }

    return 0;
  }

  static public function getBooleanByName( name:String ):Boolean
  {
    return ( _flashvarsObj[name] == "true" || _flashvarsObj[name] == "1" );
  }
}
}
