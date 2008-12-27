
class PhotoFrame extends MovieClip {

  var mytf:TextField;

  var images:Array = new Array();

  var url = "http://www.discarded-ideas.org/files/photoframe-test";
  var delay = 6000;
  var displayFilename = "yes";

  var mc:MovieClip;
  var rect:MovieClip;

  // Current time (in microseconds), and timestamp of the previous refresh.
  var now  = 0;
  var then = 0;

  var imageList:XML;
  var processed;

  //Class Constructor/Entry Point
  function PhotoFrame() {
    if (_root.config_url != undefined) url = _root.config_url;
    if (_root.config_delay != undefined) delay = _root.config_delay;
    if (_root.config_display != undefined) displayFilename = _root.config_display;
    processed = false;
    Object.registerClass("bgImage", MovieClip);
    attachMovie("bgImage", "background", 0);

    drawRectangle();

    if ((_root.config_url != undefined) && (_root.config_delay != undefined)) {
      delay = _root.config_delay;
      url = _root.config_url;
      mc = new MovieClip();
      imageList = new XML();
      imageList.ignoreWhite = true;
      setText("Loading " + url + "/images.xml");
      imageList.load(url+"/images.xml");
    }
    else {
      setText("Please configure the widget first.");
    }
  }

  function processXML() {
    var XMLString:String = new String();
    XMLString = imageList.toString();

    var imgXML:XML = new XML(XMLString);
    imgXML.parseXML(XMLString);

    var nodes:Object = imgXML.firstChild;
    var nodesChildren:Object = nodes.childNodes;

    for(var i=0;i<nodesChildren.length;i++) {
      images.push(nodes.childNodes[i].attributes.filename);
    }
    processed = true;
    if (displayFilename == "no") {
      rect._visible = false;
      mytf._visible = false;
    }
  }

  function setText(text:String) {
    createTextField("mytf", 2, 0, -2, 320, 15);
    mytf = this["mytf"];
    mytf.text = text;
    var my_fmt:TextFormat = new TextFormat();
    my_fmt.color = 0x000000;
    my_fmt.size = 9;
    my_fmt.font = "Arial";
    my_fmt.align = "right";
    mytf.setTextFormat(my_fmt);
  }

  // Called on each frame
  function onEnterFrame() {
    if (imageList.loaded && !processed) {
      setText("Processing XML");
      processXML(imageList);
    }
    else if (processed) {
      //setText(images.length + " images loaded.");
      var date = new Date();
      now = date.getTime();
      if (now - then > delay) {
        var r:Number = Math.floor(Math.random() * images.length);

        if (displayFilename != "no") {
          setText("Image "+r + ": " + url + "/" + images[r]);
        }
        mc = createEmptyMovieClip("image",0);
        mc.loadMovie(url + "/" + images[r]);
        then = now;

      }
      scaleImage(320,240);
    }

  };

  function scaleImage(width:Number, height:Number) {
    var scaleX:Number = Math.min(1, width / mc._width);
    var scaleY:Number = Math.min(1, height / mc._height);
    var scale:Number = Math.min(scaleX,scaleY);
    if(scale != 1) {
      mc._xscale  = scale * 100;
      mc._yscale = scale * 100;
    }
    //setText("w/h/s: "+mc._width+"/"+mc._height+"/"+scale);
    //photo._x = (width - photo._width);
    //photo._y = (height - photo._height);
  }

  function drawRectangle() {
    createEmptyMovieClip("rect", 1);
    rect.beginFill(0xFFFFFF, 60);
    rect.moveTo(0,0);
    rect.lineTo(320,0);
    rect.lineTo(320,10);
    rect.lineTo(0,10);
    rect.endFill();
  }
}
