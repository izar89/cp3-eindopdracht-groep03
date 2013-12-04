package {

import be.devine.cp3.billsplit.Application;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;

import starling.core.Starling;

public class Main extends Sprite {

    private var starling:Starling

    public function Main() {

        stage.align = StageAlign.TOP_LEFT;
        stage.scaleMode = StageScaleMode.NO_SCALE;

        starling = new Starling(Application, stage);
        starling.start();

        stage.addEventListener(Event.RESIZE, stageResizeHandler);
    }

    private function stageResizeHandler(e:Event):void {
        var rect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
        starling.viewPort = rect;
        starling.stage.stageWidth = stage.stageWidth;
        starling.stage.stageHeight = stage.stageHeight;
    }
}
}
