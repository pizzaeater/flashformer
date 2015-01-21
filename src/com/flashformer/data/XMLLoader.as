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
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.utils.setTimeout;

public class XMLLoader extends EventDispatcher
{
  static public var DEBUG_INFO:Boolean = true;

  private var _id:int;
  private var _dataLoader:URLLoader;
  private var _dataFileUrl:String;

  public function XMLLoader( id:int = -1 )
  {
    super();

    _id = id;

    _dataLoader = new URLLoader();
    _dataLoader.dataFormat = URLLoaderDataFormat.TEXT;
    _dataLoader.addEventListener( Event.COMPLETE, onXMLLoaded );
    _dataLoader.addEventListener( IOErrorEvent.IO_ERROR, onXMLError );
  }

  public function load( dataFileUrl:String, doNotUseCache:Boolean = true, timeoutSec:Number = 0 ):void
  {
    setTimeout( _load, timeoutSec * 1000, dataFileUrl, doNotUseCache );
  }

  private function _load( dataFileUrl:String, doNotUseCache:Boolean ):void
  {
    if( dataFileUrl )
    {
      _dataFileUrl = dataFileUrl;
      _dataLoader.load( new URLRequest( _dataFileUrl + (doNotUseCache ? "?u=" + Math.random().toFixed( 5 ) : "") ) );
    }
    else
    {
      trace( "Can't load null url!" );
    }
  }

  private function onXMLLoaded( event:Event ):void
  {
    if( DEBUG_INFO )
    {
//			debug("XML file '" + _dataFileUrl + "' is loaded", DebugLineType.YELLOW);
    }

    dispatchEvent( new XMLLoaderEvent( XMLLoaderEvent.LOAD_COMPLETE, _id, xml ) );
  }

  private function onXMLError( event:IOErrorEvent ):void
  {
//		debugError("XML file '" + _dataFileUrl + "' not found!");
    trace( _dataFileUrl + " file not found" );

    dispatchEvent( new XMLLoaderEvent( XMLLoaderEvent.LOAD_ERROR, _id ) );
  }

  private function get xml():XML
  {
    try
    {
      return new XML( _dataLoader.data );
    }
    catch( e:TypeError )
    {
      trace( _dataFileUrl + " is not correct: " + e );
    }
    return null;
  }
}
}
