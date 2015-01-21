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

package com.flashformer.logger
{

public class FFLoggerTypes
{
  public static const QUICK_TRACE:int = -1;
  public static const QUICK_TRACE_LIGHT:int = -2;
  public static const DEBUG:int = 0;
  public static const DEBUG_HEADER:int = 1;
  public static const INFO:int = 2;
  public static const INFO_HEADER:int = 3;
  public static const FUNCTION_CALL:int = 4;
  public static const WARNING:int = 5;
  public static const ERROR:int = 6;
  public static const RESULT_FAILED:int = 7;
  public static const RESULT_OK:int = 8;
  public static const HIGHLIGHT:int = 9;

  private static var _styles:Object;

  internal static function getStyleByType( type:int ):Array
  {
    if( _styles == null )
    {
      _styles = {};

      _styles[QUICK_TRACE] = ["quick trace", 0xcc00cc, 0xffffff, true];
      _styles[QUICK_TRACE_LIGHT] = ["quick trace", 0xffddff, 0x0, false];
      _styles[DEBUG] = ["debug", 0xffffff, 0x0, false];
      _styles[DEBUG_HEADER] = ["debug", 0xffffff, 0x0, true];
      _styles[INFO] = ["info", 0xffffcc, 0x0, false];
      _styles[INFO_HEADER] = ["info", 0xffffcc, 0x0, true];
      _styles[FUNCTION_CALL] = ["function call", 0xddddff, 0x0, true];
      _styles[WARNING] = ["warning", 0xffaa99, 0x0, true];
      _styles[ERROR] = ["error", 0xcc0000, 0xffffff, true];
      _styles[RESULT_FAILED] = ["result failed", 0xcc3333, 0xffffff, true];
      _styles[RESULT_OK] = ["result ok", 0xddffdd, 0x0, true];
      _styles[HIGHLIGHT] = ["debug", 0xffff00, 0x0, true];
    }

    return _styles[type] as Array;
  }
}
}
