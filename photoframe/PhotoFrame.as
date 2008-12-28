
class PhotoFrame extends MovieClip {

  var status_tf:TextField;
  var status_tf_rect:MovieClip;

  var debug_tf:TextField;
  var debug_tf_rect:MovieClip;
  var debug_show = false;

  var images_xml:XML = new XML();
  var images_xml_loading = false;
  var images_xml_loaded = false;
  var images:Array = new Array();

  // var url = "http://www.discarded-ideas.org/files/photoframe-test";
  // var url = "http://10.1.0.106/image";
  var url = "http://localhost/photoframe/example";

  var delay = 6000;
  var displayFilename = "yes";

  var mc:MovieClip;
  var image:MovieClip;
  var image_url_prev:MovieClip;
  var img_i = 0;
  var img:Array = new Array(2);
  var img_0:MovieClip;
  var img_1:MovieClip;

  // Current time (in microseconds), and timestamp of the previous refresh.
  var now  = 0;
  var then = 0;

  //Class Constructor/Entry Point
  function PhotoFrame() {
    if (_root.config_url != undefined) url = _root.config_url;
    if (_root.config_delay != undefined) delay = _root.config_delay;
    if (_root.config_display != undefined) displayFilename = _root.config_display;

    Object.registerClass("bgImage", MovieClip);
    attachMovie("bgImage", "background", 0);

    if ( ! (url != undefined) && (delay != undefined) ) {
      setStatusText("Please configure the widget first.");
    }
  }

  function setStatusText(text:String) {
    if ( ! status_tf ) {
      createTextField("status_tf", 3, 0, -2, 320, 15);
      var fmt:TextFormat = new TextFormat();
      fmt.color = 0x000000;
      fmt.size = 9;
      fmt.font = "Arial";
      fmt.align = "right";
      status_tf.setTextFormat(fmt);

      createEmptyMovieClip("status_tf_rect", 2);
      status_tf_rect.beginFill(0xFFFFFF, 60);
      status_tf_rect.moveTo(0, 0);
      status_tf_rect.lineTo(320, 0);
      status_tf_rect.lineTo(320, 10);
      status_tf_rect.lineTo(0, 10);
      status_tf_rect.endFill();
    }
    if ( text == undefined ) {
      status_tf._visible = false;
      status_tf_rect._visible = false;
    } else {
      status_tf.text = text;
      status_tf._visible = false;
      status_tf_rect._visible = false;
    }
  }

  function setDebugText(text:String) {
    if ( ! debug_show ) {
      return;
    }

    if ( ! debug_tf ) {
      createTextField("debug_tf", 3, 0, 225, 320, 15);
      var fmt:TextFormat = new TextFormat();
      fmt.color = 0x000000;
      fmt.size = 9;
      fmt.font = "Arial";
      fmt.align = "right";
      debug_tf.setTextFormat(fmt);

      createEmptyMovieClip("debug_tf_rect", 2);
      debug_tf_rect.beginFill(0xFFFFFF, 60);
      debug_tf_rect.moveTo(0, 225);
      debug_tf_rect.lineTo(320, 225);
      debug_tf_rect.lineTo(320, 240);
      debug_tf_rect.lineTo(0, 240);
      debug_tf_rect.endFill();
    }
    if ( text == undefined ) {
      debug_tf._visible = false;
      debug_tf_rect._visible = false;
    } else {
      debug_tf.text = text;
      debug_tf._visible = true;
      debug_tf_rect._visible = true;
    }
  }


  // Called on each frame
  function onEnterFrame() {
    if ( images.length > 0 ) {
      var date = new Date();
      now = date.getTime();
      if (now - then > delay) {
	then = now;
        showImage();
      }
      setDebugText(images.length + " images left.");
    } else {
      loadImages();
    }
  };

  function showImage() {
    var image = nextImage();
    if ( image ) {
      var imageUrl = url + "/" + image;

      if (displayFilename != "no") {
	setStatusText("Image: " + imageUrl);
      } else {
	setStatusText(undefined);
      }

      var img_i_next = (img_i + 1) % 2;
      mc = createEmptyMovieClip("img_" + img_i_next, 0);
      mc.loadMovie(imageUrl);
      scaleImage(320, 240);
      mc.swapDepths(1);
      img_i = img_i_next;
    }
  }

  function scaleImage(width:Number, height:Number) {
    var scaleX:Number = Math.min(1, width / mc._width);
    var scaleY:Number = Math.min(1, height / mc._height);
    var scale:Number = Math.min(scaleX,scaleY);
    if ( scale != 1 ) {
      mc._xscale  = scale * 100;
      mc._yscale = scale * 100;
    }
    //setStatusText("w/h/s: "+mc._width+"/"+mc._height+"/"+scale);
    //photo._x = (width - photo._width);
    //photo._y = (height - photo._height);
  }

  function nextImage() {
    if ( images.length == 0 ) {
      // Start loading.
      if ( loadImages() ) {
	return;
      }
    }

    var image_url = images.shift();
    /* Avoid repeating the previous image. */
    if ( images.length > 0 && image_url == image_url_prev ) {
      image_url = images.shift();
    }
    image_url_prev = image_url;

    return image_url;
  }


  function loadImages() {
    // Loading has not yet started or it is active?
    if ( startLoadImages() ) {
      return true;
    }

    var nodes:Object = images_xml.firstChild;
    var nodesChildren:Object = nodes.childNodes;

    setDebugText("Images " + nodesChildren.length);

    images = new Array();
    for ( var i = 0; i < nodesChildren.length; i ++ ) {
      var img_url = nodes.childNodes[i].attributes.filename;
      images.push(img_url);
    }

    setDebugText("Images loaded: " + images.length);

    // Ready for loading next time.
    images_xml_loaded = false;
    images_xml_loading = false;

    // Randomize images Array.
    for ( var i = 0; i < images.length; ++ i ) {
      var r = Math.floor(Math.random() * images.length);
      // setDebugText("i=" + i + ", r=" + r)
      var temp = images[i];
      images[i] = images[r];
      images[r] = temp;
    }

    // Continue.
    return false;
  }

 
  function startLoadImages() {
    // If the images_xml is already loaded, continue processing it.
    if ( images_xml_loaded ) {
      return false;
    }

    // If images.xml is loading, 
    //   Check to see if its finished.
    //   If so, continue processing it.
    //   Otherwise, it is still being loaded.
    if ( images_xml_loading ) {
      if ( images_xml.loaded ) {
	images_xml_loaded = true;
	return false;
      }
      
      return true;
    }

    images_xml_loading = true;
    images_xml_loaded = false;

    images_xml.ignoreWhite = true;
    var xml_url = url + "/images.xml";
    setStatusText("Loading " + xml_url);
    images_xml.load(xml_url);

    return true;
  }

}
