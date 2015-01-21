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

package com.flashformer.display
{
import com.flashformer.display.mask.GradientMask;

import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.LineScaleMode;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.BlurFilter;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

public class UIElement extends Sprite
{
  public var margin:UIElementMargin = new UIElementMargin();
  protected var _UIE_outline:Sprite;
  private var _UIE_width:Number;
  private var _UIE_height:Number;
  private var _UIE_children:Sprite;
  private var _UIE_nameField:TextField;
  private var _UIE_inited:Boolean;
  private var _UIE_roundPosAndSize:Boolean = true;
  private var _UIE_mouseOver:Boolean = false;

  public function UIElement()
  {
    super();

    _UIE_inited = false;

    tabEnabled = false;
    width = 0;
    height = 0;

    _UIE_children = new Sprite();
    _UIE_children.name = "_UIE_children";

    addChildToGlobalStack( _UIE_children );

//			createCaptionField();
    drawOutline( 0, 0 );
  }

//  protected function dispatchDrawEvent( bubbles:Boolean = true ):void
//  {
//    dispatchEvent( new GuiEvent( GuiEvent.DRAW, null, bubbles ));
//  }

  public function focus():void
  {
  }

  protected function addChildToGlobalStack( child:DisplayObject, index:int = -1 ):DisplayObject
  {
    if( index > -1 )
    {
      return super.addChildAt( child, index );
    }
    else
    {
      return super.addChild( child );
    }
  }

  protected function removeChildFromGlobalStack( child:DisplayObject ):DisplayObject
  {
    return super.removeChild( child );
  }

  public function init():void
  {
    _UIE_inited = true;
  }

  public function useMouseOverCatch():void
  {
    addEventListener( MouseEvent.MOUSE_OVER, _UIE_onMouseCatchOver );
    addEventListener( MouseEvent.MOUSE_OUT, _UIE_onMouseCatchOut );
  }

  private function _UIE_onMouseCatchOver( event:MouseEvent ):void
  {
    _UIE_mouseOver = true;
  }

  private function _UIE_onMouseCatchOut( event:MouseEvent ):void
  {
    _UIE_mouseOver = false;
  }

  public function destroy():void
  {
    var child:DisplayObject;
    for( var i:uint = 0; i < numChildren; i++ )
    {

      child = getChildAt( i );

      if( child is Bitmap )
      {
        if( ( child as Bitmap ).bitmapData )
        {
          ( child as Bitmap ).bitmapData.dispose();
        }
      }
      else if( child is UIElement )
      {
        ( child as UIElement ).destroy();
      }

      child = null;
    }

    _UIE_inited = false;
  }

  public function updateByMsg( messageType:String = null, messageParams:Object = null ):void
  {
    for( var i:uint = 0; i < numChildren; i++ )
    {
      if( getChildAt( i ) is UIElement )
      {
        ( getChildAt( i ) as UIElement ).updateByMsg( messageType, messageParams );
      }
    }
  }

  public function drawName( newName:String = '' ):void
  {
    if( newName.length > 0 )
    {
      if( !_UIE_nameField )
      {
        createCaptionField();
      }

      name = newName;
    }
    else
    {
      // TODO Remove caption field.
    }
  }

  public function drawOutline( color:Number = 0xff0000, alpha:Number = 0.2 ):void
  {
    if( _UIE_outline && super.contains( _UIE_outline ) )
    {
      removeChildFromGlobalStack( _UIE_outline );
    }

    _UIE_outline = new Sprite();
    _UIE_outline.mouseChildren = false;
    _UIE_outline.mouseEnabled = false;
    with( _UIE_outline.graphics )
    {
      lineStyle( 0, color, alpha * 1.2, false, LineScaleMode.NONE );
      beginFill( color, alpha );
      drawRect( 0, 0, 10, 10 );
      endFill();
    }
    super.addChildAt( _UIE_outline, 0 );

    if( _UIE_nameField )
    {
      _UIE_nameField.borderColor = color;
      _UIE_nameField.backgroundColor = color;
    }
  }

  override public function addChild( child:DisplayObject ):DisplayObject
  {
    return _UIE_children.addChild( child );
  }

  override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
  {
    return _UIE_children.addChildAt( child, index );
  }

  override public function removeChild( child:DisplayObject ):DisplayObject
  {
    return _UIE_children.removeChild( child );
  }

  override public function removeChildAt( index:int ):DisplayObject
  {
    return _UIE_children.removeChildAt( index );
  }

  override public function getChildAt( index:int ):DisplayObject
  {
    return _UIE_children.getChildAt( index );
  }

  override public function getChildByName( name:String ):DisplayObject
  {
    return _UIE_children.getChildByName( name );
  }

  override public function getChildIndex( child:DisplayObject ):int
  {
    return _UIE_children.getChildIndex( child );
  }

  override public function swapChildren( child1:DisplayObject, child2:DisplayObject ):void
  {
    _UIE_children.swapChildren( child1, child2 );
  }

  override public function swapChildrenAt( index1:int, index2:int ):void
  {
    _UIE_children.swapChildrenAt( index1, index2 );
  }

  override public function get numChildren():int
  {
    return _UIE_children.numChildren;
  }

  public function forEach( eachFunction:Function ):void
  {
    var el:DisplayObject;
    for( var i:int = 0; i < numChildren; i++ )
    {
      el = getChildAt( i );
      eachFunction( el );
    }
  }

  public function removeAllChildren( eachFunction:Function = null ):void
  {
    if( eachFunction != null )
    {
      var el:DisplayObject;
      while( numChildren > 0 )
      {
        el = getChildAt( 0 );

        eachFunction( el );
        removeChild( el );
      }
    }
    else
    {
      while( numChildren > 0 )
      {
        removeChildAt( 0 );
      }
    }
  }

  public function draw():void
  {
    if( _UIE_outline )
    {
      _UIE_outline.width = width - 1;
      _UIE_outline.height = height - 1;
    }
  }

  public function getSnapshotElement():DisplayObject
  {
    return this;
  }

  private function createCaptionField():void
  {
    var format:TextFormat = new TextFormat();
    format.color = 0;
    format.font = "Verdana";
    format.size = 9;

    _UIE_nameField = new TextField();
    _UIE_nameField.autoSize = TextFieldAutoSize.LEFT;
    _UIE_nameField.defaultTextFormat = format;
    _UIE_nameField.mouseEnabled = false;
    _UIE_nameField.selectable = false;
    _UIE_nameField.border = true;
    _UIE_nameField.background = true;
    _UIE_nameField.filters = [new BlurFilter( 0, 0, 0 )];
    addChildToGlobalStack( _UIE_nameField );
  }

  public override function set name( name:String ):void
  {
    super.name = name;

    if( _UIE_nameField )
    {
      _UIE_nameField.text = name;
    }
  }

  public override function set x( x:Number ):void
  {
    super.x = _UIE_roundPosAndSize ? Math.round( x ) : x;
//			super.x = ~~ (0.5 + x);
  }

  public override function set y( y:Number ):void
  {
    super.y = _UIE_roundPosAndSize ? Math.round( y ) : y;
//			super.y = ~~ (0.5 + y);
  }

  public override function get width():Number
  {
    return _UIE_width;
  }

  public override function set width( width:Number ):void
  {
    _UIE_width = Math.max( 0, _UIE_roundPosAndSize ? Math.round( width ) : width );
//			_UIE_width = width < 0 ? 0 : ~~ (0.5 + width);
  }

  public override function get height():Number
  {
    return _UIE_height;
  }

  public override function set height( height:Number ):void
  {
    _UIE_height = Math.max( 0, _UIE_roundPosAndSize ? Math.round( height ) : height );
//			_UIE_height = height < 0 ? 0 : ~~ (0.5 + height);
  }

  public override function set mask( object:DisplayObject ):void
  {
    super.mask = object;

    if( object is GradientMask )
    {
      cacheAsBitmap = true;
    }
  }

  override public function set mouseEnabled( enabled:Boolean ):void
  {
    super.mouseEnabled = enabled;

    if( _UIE_children )
    {
      _UIE_children.mouseEnabled = enabled;
    }
  }

  override public function set mouseChildren( enable:Boolean ):void
  {
    super.mouseChildren = enable;

    if( _UIE_children )
    {
      _UIE_children.mouseChildren = enable;
    }
  }

  protected function get children():Sprite
  {
    return _UIE_children;
  }

  public function set inited( value:Boolean ):void
  {
    _UIE_inited = value;
  }

  public function get inited():Boolean
  {
    return _UIE_inited;
  }

  public function get isMouseOver():Boolean
  {
    return _UIE_mouseOver;
  }

  public function get right():Number
  {
    return x + width;
  }

  public function get bottom():Number
  {
    return y + height;
  }

  public function set roundPosAndSize( roundPosAndSize:Boolean ):void
  {
    _UIE_roundPosAndSize = roundPosAndSize;
  }
}
}
