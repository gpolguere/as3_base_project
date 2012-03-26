package com.sosappy.text
{

	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	
	public class TextDisplay
	{
		public static var styles:StyleSheet;
		
		private var _field:TextField;
		private var _text:String = "";
		private var _cssClass:String = "";
		private var _className:String = "";
		private var _area:Rectangle;
		
		public static var langFormat:String = "";
		
		public function TextDisplay(text:String, cssClass:String = "", field:TextField = null)
		{	
			_field = field || new TextField();
			_field.styleSheet = styles;
			
			setContent(text, cssClass);
		}
		
		
		/**
		 * permet de redéfinir le contenu du champ
		 * @param	text
		 * @param	cssClass
		 */
		public function setContent(text:String = null, cssClass:String = "", useHtml:Boolean = true):void
		{
			if(text != null) _text = text;
			if (cssClass)
			{
				_cssClass = cssClass;
				_className = _cssClass;
				if(_className.indexOf(".") == 0)_className = _className.substr(1);
//				trace("className", _className);
				var cssClassObj:Object = styles.getStyle(_cssClass);
//				TraceUtils.traceObject(cssClassObj);
				for(var key:String in cssClassObj)
				{
//					trace("cssClassObj[" + key + "]", cssClassObj[key]);
//					trace("_field.hasOwnProperty(" + key + ")", _field.hasOwnProperty(key))
					if(_field.hasOwnProperty(key))
						_field[key] = (cssClassObj[key] == "false") ? false : cssClassObj[key];
				}
//				trace(_field.embedFonts);
			}
			if(_field.type == TextFieldType.INPUT)
			{
				_field.styleSheet = null;
				_field.defaultTextFormat =styles.transform(styles.getStyle(_cssClass));
			}
			
			
			if(useHtml)
				_field.htmlText = "<span class=\"" + _className + "\">" + _text + "</span>";
			else _field.text = _text;
			
			
			
			if (_area) setArea(_area.x, _area.y, _area.width, _area.height);
		}
		
		
		/**
		 * permet de récupérer le contenu du champ de texte
		 * @param	html
		 * @return
		 */
		public function getContent(html:Boolean = false):String
		{
			return html ? _field.htmlText : _field.text;
		}
		
		
		/**
		 * définit la position et les dimensions du champ
		 * @param	x
		 * @param	y
		 * @param	w
		 * @param	h
		 */
		public function setArea(x:int = 0, y:int = 0, w:int = -1, h:int = -1):void
		{
			if (!_area) _area = new Rectangle();
			
			_area.x = x;
			_area.y = y;
			_area.width = w;
			_area.height = h;
			
			_field.x = _area.x;
			_field.y = _area.y;
			if (w != -1)
			{	
				_field.autoSize = TextFieldAutoSize.NONE;
				_field.width = w / field.scaleX;
				if (h == -1)_field.height = _field.textHeight + 5;
			}
			if (h != -1)
			{
				_field.autoSize = TextFieldAutoSize.NONE;
				_field.height = h / field.scaleY;
			}
		}


		public function setType(type:String):void
		{
			_field.type = type;
			
			if(_field.type == TextFieldType.INPUT)
			{
				_field.styleSheet = null;
				_field.defaultTextFormat = styles.transform(styles.getStyle("." + _cssClass));
			}
		}

		
		
		/**
		 * TODO:formate le champ en fonction de la langue
		 * 
		 * LA FONCTION NE MARCHE PAS
		 * 
		 * @param	lang
		 * @param	force
		 * @param	fontSize
		 * @param	decalFont
		 * @return
		 */
		public function langFormat(force:Boolean = false, fontSize:Number = -1, decalFont:Number = 0):TextDisplay
		{
			/*if(langFormat == "jp" || langFormat == "cn" || force)
			{
				var format:TextFormat = _field.getTextFormat();
				
				//si c'est un texte bitmap on change la size de la police
				if(_field.antiAliasType == "normal" && format.font == "Munica Regular_8pt_st")
				{
					format.size = 11;
					_field.y += 3;
				}
				if(_field.antiAliasType == "advanced" && format.font == "Myriad Pro"){}
				if(_field.antiAliasType == "advanced" && format.font == "Myriad Pro Light"){}
				
				if(fontSize != -1)
				{
					format.size = fontSize;
					if(fontSize == 12) _field.y += 4;
				}
					
				if(decalFont != 0) _field.y += decalFont;
    			
    			//textFormat.font = "_sans";
				format.font = "MS Gothic";
				_field.embedFonts = false;
				format.bold = false;
				
				_field.defaultTextFormat = format;
				_field.setTextFormat(format);
				
				//on applique un blur neutre pour pouvoir animer le textField malgres qu'il ne soit pas embedé
				//tester avec un useBitmap
    			//TweenMax.to(field, 0, {blurFilter:{blurX:0,blurY:0,quality:3}});
			}*/
			return this;
		}


		public function get field():TextField { return _field; }

		public function get cssClass():String { return _cssClass; }

		public function get text():String { return _text; }

		public function get area():Rectangle { return _area; }
	}
}