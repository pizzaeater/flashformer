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
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.system.System;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.getTimer;

// TODO Block add records during change scroller.
// TODO Remove scrolling when limit is reaching, now it's not possible to read lines when scroll.

public class FFLogger
{
  private static const VERSION:Number = 0.95;
  private static const LINE_HEIGHT:uint = 18;
  //
  private static var _stage:Stage;
  private static var _maxLines:uint;
  private static var _mirrorLogging:Object;
  private static var _addTimestampToClipboard:Boolean;
  private static var _addTypeToClipboard:Boolean;
  private static var _data:Array;
  private static var _textFormat:TextFormat;
  private static var _mainContainer:Sprite;
  private static var _linesContainer:Sprite;
  private static var _scroller:FFLoggerScroller;
  private static var _clearButton:FFLoggerButton;
  private static var _closeButton:FFLoggerButton;
  private static var _copyButton:FFLoggerButton;
  private static var _actualHeight:Number;
  private static var _linesCount:uint;
  private static var _currentIndex:int;
  private static var _ctrlKey:Boolean;
  private static var _show:Boolean;
  private static var _devMode:Boolean;

  public static function init( stage:Stage, maxLines:uint = 0, topOffset:uint = 0, mirrorLogging:Object = null ):void
  {
    if( _stage != null )
    {
      throw new Error( "FFLogger :: Multi-initialization isn't possible!" );
    }

    _stage = stage;
    _stage.addEventListener( Event.RESIZE, stageResizeHandler );
    _stage.addEventListener( KeyboardEvent.KEY_DOWN, stageKeyboardHandler );
    _stage.addEventListener( KeyboardEvent.KEY_UP, stageKeyboardHandler );

    _maxLines = maxLines;
    _mirrorLogging = mirrorLogging;
    _addTimestampToClipboard = true;
    _addTypeToClipboard = true;

    _mainContainer = new Sprite();
    _mainContainer.visible = false;
    _mainContainer.x = 5;
    _mainContainer.y = 5 + topOffset;
    _stage.addChild( _mainContainer );

    _scroller = new FFLoggerScroller();
    _scroller.addEventListener( Event.CHANGE, scrollerChangeHandler );
    _mainContainer.addChild( _scroller );

    _linesContainer = new Sprite();
    _linesContainer.x = 26;
    _mainContainer.addChild( _linesContainer );

    _closeButton = new FFLoggerButton( "Close log", 0xffffcc );
    _closeButton.addEventListener( MouseEvent.CLICK, closeButtonHandler );
    _mainContainer.addChild( _closeButton );

    _copyButton = new FFLoggerButton( "Copy log", 0xffffcc );
    _copyButton.addEventListener( MouseEvent.CLICK, copyButtonHandler );
    _copyButton.y = 22;
    _mainContainer.addChild( _copyButton );

    _clearButton = new FFLoggerButton( "Clear log", 0xcc0000, 0xffffff );
    _clearButton.addEventListener( MouseEvent.CLICK, clearButtonHandler );
    _clearButton.visible = false;
    _clearButton.y = 44;
    _mainContainer.addChild( _clearButton );

    _textFormat = new TextFormat();
    _textFormat.font = "Verdana, Monaco, sans-serif"; // TODO Use family for fixed fonts.
    _textFormat.size = 11;

    if( _data == null )
    {
      clear();

      _scroller.position = 1.0;
      scrollerChangeHandler( null );
    }
  }

  public static function set devMode( value:Boolean ):void
  {
    _devMode = value;
  }

  public static function quickTrace( object:* ):void
  {
    log( object, -1 );
  }

  public static function log( object:* = null, type:int = 0 ):void
  {
    // TODO Add context & types.

    if( _data == null )
    {
      clear();
    }

    if( object === null && _data[_data.length - 1][0] === null )
    {
      // Do not add more than one empty line:
      return;
    }

    if( object is Array )
    {
      object = "[" + ( object as Array ).join( ", " ) + "]";
    }
    else if( object is String )
    {
      object = ( object as String ).split( "\n" ).join( " / " );
    }

    _data.push( [object !== null ? String( object ) : null, FFLoggerTypes.getStyleByType( type ), getTimer()] );

    if( _mirrorLogging && object !== null )
    {
      var mirrorText:String = "(" + Number( getTimer() / 1000 ).toFixed( 3 ) + "s) [" + FFLoggerTypes.getStyleByType( type )[0].toUpperCase() + "] " + String( object );

      if( _mirrorLogging.hasOwnProperty( type.toString() ) )
      {
        ( _mirrorLogging[type] as Function )( mirrorText );
      }
      else if( _mirrorLogging.hasOwnProperty( FFLoggerTypes.DEBUG.toString() ) )
      {
        ( _mirrorLogging[FFLoggerTypes.DEBUG] as Function )( mirrorText );
      }
    }

    if( _devMode && ( type == FFLoggerTypes.QUICK_TRACE || type == FFLoggerTypes.ERROR || type == FFLoggerTypes.WARNING || type == FFLoggerTypes.RESULT_FAILED ) )
    {
      show();
    }

    if( _maxLines > 0 && _data.length > _maxLines )
    {
      _data.splice( 0, 1 );

      if( _show )
      {
        renderLines( _currentIndex );
      }
    }
    else if( _show )
    {
      _scroller.contentRatio = _linesCount / _data.length;

      if( _data.length <= _linesCount )
      {
        renderLines( _currentIndex );
      }
      else if( _scroller.position == 1.0 )
      {
        _scroller.position = 1.0;
        scrollerChangeHandler( null );
      }
    }
  }

  public static function split():void
  {
    log( new Array( 80 ).join( "-" ) );
  }

  public static function show():void
  {
    if( _stage && _show == false )
    {
      _show = true;
      _mainContainer.visible = true;

      stageResizeHandler( null );

      _currentIndex = -1;

      _scroller.position = 1.0;
      scrollerChangeHandler( null );
    }
  }

  public static function hide():void
  {
    if( _show )
    {
      _show = false;
      _mainContainer.visible = false;
    }
  }

  public static function clear():void
  {
    _data = [];

    log( "FFLogger v." + VERSION, FFLoggerTypes.INFO );
    log( "Press [control key] to show clear button", FFLoggerTypes.INFO );
    log( null );
  }

  public static function copyToClipboard():String
  {
    var str:String = "";

    var data:Array;
    for( var i:uint = 0; i < _data.length; i++ )
    {
      data = _data[i] as Array;

      if( data[0] !== null )
      {
        if( _addTimestampToClipboard )
        {
          str += "(" + Number( data[2] / 1000 ).toFixed( 3 ) + "s) ";
        }
        if( _addTypeToClipboard )
        {
          str += "[" + String( data[1][0] ).toUpperCase() + "] ";
        }
        str += data[0] + "\n";
      }
      else
      {
        str += "\n";
      }
    }
    str = str.substr( 0, str.length - 1 );

    System.setClipboard( str );

    return str;
  }

  private static function stageResizeHandler( event:Event ):void
  {
    if( _show )
    {
      var rightBorder:int = _stage.stageWidth - 2 * _mainContainer.x;

      _closeButton.x = rightBorder - _closeButton.width;
      _copyButton.x = rightBorder - _copyButton.width;
      _clearButton.x = rightBorder - _clearButton.width;

      _actualHeight = _stage.stageHeight - _mainContainer.y;

      _linesCount = uint( _actualHeight / LINE_HEIGHT );
      if( _linesCount != _linesContainer.numChildren )
      {
        // clearTimeout(_resizeTimeout);

        while( _linesContainer.numChildren > 0 )
        {
          _linesContainer.removeChildAt( 0 );
        }

        var line:TextField;
        var linePos:uint = 0;

        for( var i:uint = 0; i < _linesCount; i++ )
        {
          line = createLine();
          line.y = linePos;
          _linesContainer.addChild( line );

          linePos += LINE_HEIGHT;
        }

        _scroller.height = _linesCount * LINE_HEIGHT;
        _scroller.contentRatio = _linesCount / _data.length;

        if( event )
        {
          _currentIndex = Math.max( 0, Math.min( _currentIndex, _data.length - _linesCount ) );
          renderLines( _currentIndex );

          _scroller.position = _currentIndex / ( _data.length - _linesCount );
        }
      }
    }
  }

  private static function scrollerChangeHandler( event:Event ):void
  {
    var index:uint = Math.max( 0, _data.length - _linesCount ) * _scroller.position;

    if( event == null || index != _currentIndex )
    {
      renderLines( index );
    }
  }

  private static function renderLines( index:uint ):void
  {
    _currentIndex = index;

    var line:TextField;
    var data:Array;
    var objectStr:String;
    var typeCfg:Array;
    var ts:uint;

    for( var i:uint = 0; i < _linesContainer.numChildren; i++ )
    {
      line = _linesContainer.getChildAt( i ) as TextField;

      if( _currentIndex + i < _data.length )
      {
        data = _data[_currentIndex + i] as Array;
        if( data[0] !== null )
        {
          objectStr = String( data[0] );
          typeCfg = data[1] as Array;
          ts = data[2] as uint;

          _textFormat.color = typeCfg[2];
          _textFormat.bold = typeCfg[3];

          line.defaultTextFormat = _textFormat;
          line.backgroundColor = typeCfg[1];
          line.text = Number( ts / 1000 ).toFixed( 3 ) + " sec :: " + objectStr;
          line.visible = true;
        }
        else
        {
          line.visible = false;
        }
      }
      else
      {
        line.visible = false;
      }
    }
  }

  private static function stageKeyboardHandler( event:KeyboardEvent ):void
  {
    if( _show )
    {
      if( event.type == KeyboardEvent.KEY_UP && event.keyCode == 123 ) // Key F12
      {
        hide();
      }

      if( event.ctrlKey != _ctrlKey )
      {
        _ctrlKey = event.ctrlKey;
        _clearButton.visible = _ctrlKey;
      }
    }
    else if( event.type == KeyboardEvent.KEY_UP && event.ctrlKey && event.shiftKey && event.keyCode == 123 ) // Key F12
    {
      show();
    }
  }

  private static function closeButtonHandler( event:MouseEvent ):void
  {
    hide();
  }

  private static function copyButtonHandler( event:MouseEvent ):void
  {
    copyToClipboard();
  }

  private static function clearButtonHandler( event:MouseEvent ):void
  {
    clear();

    _scroller.position = 1.0;
    scrollerChangeHandler( null );
  }

  private static function createLine():TextField
  {
    var tf:TextField = new TextField();
    tf.selectable = false;
    tf.background = true;
    tf.backgroundColor = 0xffffff;
    tf.autoSize = TextFieldAutoSize.LEFT;
    tf.defaultTextFormat = _textFormat;
    tf.visible = false;

    return tf;
  }

  public static function set addTimestampToClipboard( value:Boolean ):void
  {
    _addTimestampToClipboard = value;
  }

  public static function set addTypeToClipboard( value:Boolean ):void
  {
    _addTypeToClipboard = value;
  }
}
}

import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

class FFLoggerScroller extends Sprite
{
  private var _height:uint;
  private var _bg:Sprite;
  private var _bgGraphics:Graphics;
  private var _seeker:Sprite;
  private var _seekerGraphics:Graphics;
  private var _seekerMouseY:int;
  private var _seekerHeight:uint;
  private var _contentRatio:Number;
  private var _position:Number = 0.0;

  public function FFLoggerScroller()
  {
    _bg = new Sprite();
    addChild( _bg );

    _seeker = new Sprite();
    _seeker.addEventListener( MouseEvent.MOUSE_DOWN, seekerMouseDownHandler );
    _seeker.buttonMode = true;
    addChild( _seeker );

    _bgGraphics = _bg.graphics;
    _seekerGraphics = _seeker.graphics;
  }

  override public function set height( value:Number ):void
  {
    _height = value;

    _bgGraphics.clear();
    _bgGraphics.lineStyle( 1, 0x0 );
    _bgGraphics.beginFill( 0xffffff );
    _bgGraphics.drawRect( 0, 0, 20, _height );
    _bgGraphics.endFill();

    contentRatio = _contentRatio;
    position = _position;
  }

  public function set contentRatio( value:Number ):void
  {
    _contentRatio = Math.min( value, 1.0 );
    _seekerHeight = Math.max( 20, _contentRatio * _height );

    _seekerGraphics.clear();

    if( _contentRatio < 1.0 )
    {
      _seekerGraphics.lineStyle( 0, 0x0, 0.0 );
      _seekerGraphics.beginFill( 0x999999 );
      _seekerGraphics.drawRect( 3, 3, 15, _seekerHeight - 5 );
      _seekerGraphics.endFill();
    }
  }

  public function get position():Number
  {
    return _position;
  }

  public function set position( position:Number ):void
  {
    _position = position;
    _seeker.y = _position * ( _height - _seekerHeight );
  }

  private function seekerMouseDownHandler( event:MouseEvent ):void
  {
    _seekerMouseY = _seeker.mouseY;

    stage.addEventListener( MouseEvent.MOUSE_MOVE, seekerMouseMoveHandler );
    stage.addEventListener( MouseEvent.MOUSE_UP, seekerMouseUpHandler );
  }

  private function seekerMouseMoveHandler( event:MouseEvent ):void
  {
    _seeker.y = Math.max( 0, Math.min( mouseY - _seekerMouseY, _height - _seekerHeight ) );
    _position = _seeker.y / ( _height - _seekerHeight );

    dispatchEvent( new Event( Event.CHANGE ) );

    event.updateAfterEvent();
  }

  private function seekerMouseUpHandler( event:MouseEvent ):void
  {
    _seekerMouseY = 0;

    stage.removeEventListener( MouseEvent.MOUSE_MOVE, seekerMouseMoveHandler );
    stage.removeEventListener( MouseEvent.MOUSE_UP, seekerMouseUpHandler );
  }
}

class FFLoggerButton extends Sprite
{
  private var _width:uint;

  public function FFLoggerButton( label:String, bgColor:uint = 0xffffff, textColor:uint = 0x0 )
  {
    buttonMode = true;
    mouseChildren = false;

    var textFormat:TextFormat = new TextFormat();
    textFormat.font = "Verdana, Monaco, sans-serif";
    textFormat.color = textColor;
    textFormat.bold = true;
    textFormat.size = 12;

    var labelField:TextField = new TextField();
    labelField.border = true;
    labelField.background = true;
    labelField.backgroundColor = bgColor;
    labelField.autoSize = TextFieldAutoSize.LEFT;
    labelField.defaultTextFormat = textFormat;
    labelField.text = label;
    addChild( labelField );

    _width = labelField.width;
  }

  override public function get width():Number
  {
    return _width;
  }
}
