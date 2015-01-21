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
import com.flashformer.data.BinaryLoaderEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.EventDispatcher;
import flash.system.ApplicationDomain;

public class SWFLibrary extends EventDispatcher
{
  private static var _queue:/*SWFLibraryElement*/Array;
  private static var _completeFunction:Function;
  private static var _progressFunction:Function;
  private static var _loadedCount:uint;
  private static var _loaded:Boolean;

  public function SWFLibrary()
  {
    throw new Error( "Error: SWFLibrary instantiation failed!" );
  }

  static public function addFileToQueue( swfFile:String, completeFunction:Function = null, progressFunction:Function = null, doNotUseCache:Boolean = false, timeoutSec:Number = 0 ):void
  {
    if( !_queue )
    {
      _queue = [];
    }

    if( isLibLoaded( swfFile ) )
    {
//			if (BinaryLoader.DEBUG_INFO) {
//				debug("Binary file '" + swfFile + "' is skipped");
//			}
    }
    else
    {
      _queue.push( new SWFLibraryElement( swfFile, completeFunction, progressFunction, doNotUseCache, timeoutSec ) );
    }
  }

  static public function loadAll( completeFunction:Function = null ):void
  {
    _completeFunction = completeFunction;

    if( _queue.length > 0 )
    {
      _loadedCount = 0;

      loadNext();
    }
  }

  static public function isLibLoaded( swfFile:String ):Boolean
  {
    for each( var library:SWFLibraryElement in _queue )
    {
      if( library.swfFile == swfFile && library.loaded )
      {
        return true;
      }
    }

    return false;
  }

  static private function loadNext():void
  {
    var library:SWFLibraryElement = _queue[_loadedCount];

    if( library.loaded )
    {
      onLibraryLoaded( null );
    }
    else
    {
      library.addEventListener( BinaryLoaderEvent.LOAD_COMPLETE, onLibraryLoaded );
      library.loadLibrary();
    }
  }

  static private function onLibraryLoaded( event:BinaryLoaderEvent ):void
  {
    _loadedCount++;

    if( _loadedCount == _queue.length )
    {
      if( _completeFunction != null )
      {
        _loaded = true;

        _completeFunction();
        _completeFunction = null;
      }
    }
    else
    {
      loadNext();
    }
  }

  static public function getSymbolClass( symbolName:String, optional:Boolean = false ):Class
  {
    try
    {
      return ApplicationDomain.currentDomain.getDefinition( symbolName ) as Class;
    }
    catch( e:Error )
    {
      if( optional )
      {
        return null;
      }

      throw new Error( "Symbol '" + symbolName + "' is not found!" );
    }

    if( optional )
    {
      return null;
    }

    throw new Error( "Symbol '" + symbolName + "' is not found!" );

    return null;
  }

  static public function getNewInstanceOf( symbolName:String, optional:Boolean = false ):Object
  {
    var symbolClass:Class = getSymbolClass( symbolName, optional );

    if( symbolClass )
    {
      return new symbolClass;
    }
    else if( optional )
    {
      return null;
    }

    return null;
  }

  static public function getNewInstanceOfBitmapData( symbolName:String, optional:Boolean = false ):BitmapData
  {
    var bmp:Bitmap = getNewInstanceOfBitmap( symbolName, optional );

    if( bmp )
    {
      return bmp.bitmapData;
    }
    else if( optional )
    {
      return null;
    }

    return null;
  }

  static public function getNewInstanceOfBitmap( symbolName:String, optional:Boolean = false ):Bitmap
  {
    var symbolClass:Class = getSymbolClass( symbolName, optional );

    if( symbolClass )
    {
      return new Bitmap( new symbolClass( 0, 0 ) );
    }
    else if( optional )
    {
      return null;
    }

    return null;
  }

  static public function get loadedCount():uint
  {
    return _loadedCount;
  }

  static public function get totalCount():uint
  {
    return _queue.length;
  }

  public static function get loaded():Boolean
  {
    return _loaded;
  }
}
}
