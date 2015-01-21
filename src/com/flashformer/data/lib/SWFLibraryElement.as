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

package com.flashformer.data.lib
{
import com.flashformer.data.BinaryLoader;
import com.flashformer.data.BinaryLoaderEvent;

import flash.events.ProgressEvent;

public class SWFLibraryElement extends BinaryLoader
{
  private var _swfFile:String;
  private var _completeFunction:Function;
  private var _progressFunction:Function;
  private var _doNotUseCache:Boolean;
  private var _timeoutSec:Number;
  private var _loaded:Boolean;

  public function SWFLibraryElement( swfFile:String, completeFunction:Function, progressFunction:Function, doNotUseCache:Boolean, timeoutSec:Number )
  {
    super();

    _swfFile = swfFile;
    _completeFunction = completeFunction;
    _progressFunction = progressFunction;
    _doNotUseCache = doNotUseCache;
    _timeoutSec = timeoutSec;
    _loaded = false;

    addEventListener( BinaryLoaderEvent.LOAD_COMPLETE, onLoaded );
    addEventListener( ProgressEvent.PROGRESS, onProgress );
  }

  public function loadLibrary():void
  {
    if( !_loaded )
    {
      load( _swfFile, _doNotUseCache, _timeoutSec );
    }
  }

  public function onLoaded( event:BinaryLoaderEvent ):void
  {
    _loaded = true;

    try
    {
      _completeFunction.call( null, _swfFile, content["build"] );
    }
    catch( e1:Error )
    {
      try
      {
        _completeFunction.call( null, _swfFile );
      }
      catch( e2:Error )
      {
        try
        {
          _completeFunction.call( null );
        }
        catch( e3:Error )
        {
        }
      }
    }
  }

  private function onProgress( event:ProgressEvent ):void
  {
    try
    {
      _progressFunction.call( null, _swfFile, event.bytesLoaded, event.bytesTotal );
    }
    catch( argError:Error )
    {
    }
  }

  public function get swfFile():String
  {
    return _swfFile;
  }

  public function get loaded():Boolean
  {
    return _loaded;
  }
}
}
