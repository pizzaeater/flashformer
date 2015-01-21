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
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;
import flash.utils.setTimeout;

public class BinaryLoader extends EventDispatcher
{
  public var rawData:Object;
  protected var _dataLoader:Loader;
  protected var _dataFileUrl:String;
  private var _id:int;
  private var _totalBytes:uint;

  public function BinaryLoader( id:int = -1 )
  {
    super();

    _id = id;

    _dataLoader = new Loader();
  }

  public function load( dataFileUrl:String, doNotUseCache:Boolean = false, timeoutSec:Number = 0 ):void
  {
    setTimeout( _load, timeoutSec * 1000, dataFileUrl, doNotUseCache );
  }

  private function _load( dataFileUrl:String, doNotUseCache:Boolean ):void
  {
    if( dataFileUrl )
    {
      _dataFileUrl = dataFileUrl;

      _dataLoader.contentLoaderInfo.addEventListener( Event.COMPLETE, onBinaryLoaded );
      _dataLoader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onBinaryLoading );
      _dataLoader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onBinaryError );
      _dataLoader.load( new URLRequest( dataFileUrl + ( doNotUseCache ? '?u=' + Math.random().toFixed( 5 ) : '' ) ), new LoaderContext( true, ApplicationDomain.currentDomain ) );
    }
    else
    {
      trace( 'Unable to load null url.' );
    }
  }

  protected function onBinaryLoaded( event:Event ):void
  {
    dispatchEvent( new BinaryLoaderEvent( BinaryLoaderEvent.LOAD_COMPLETE, _id, content ) );
  }

  private function onBinaryLoading( event:ProgressEvent ):void
  {
    _totalBytes = event.bytesTotal;

    dispatchEvent( event.clone() );
  }

  protected function onBinaryError( event:IOErrorEvent ):void
  {
    trace( _dataFileUrl + ' file not found' );

    dispatchEvent( new BinaryLoaderEvent( BinaryLoaderEvent.LOAD_ERROR, _id ) );
  }

  public function unload():void
  {
    if( _dataLoader )
    {
      _dataLoader.unload();

      _dataLoader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onBinaryLoaded );
      _dataLoader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onBinaryLoading );
      _dataLoader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onBinaryError );
    }
  }

  public function get loader():Loader
  {
    return _dataLoader;
  }

  public function set loader( loader:Loader ):void
  {
    _dataLoader = loader;
  }

  public function get content():DisplayObject
  {
    return _dataLoader.content;
  }

  public function get id():int
  {
    return _id;
  }

  public function get dataFileUrl():String
  {
    return _dataFileUrl;
  }
}
}
