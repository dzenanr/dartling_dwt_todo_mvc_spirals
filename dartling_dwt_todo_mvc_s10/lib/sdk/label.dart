part of todo_mvc_app;

/**
 * Simple label based on [LabelElement] and [event.HasDoubleClickHandlers] support.
 */
class Label extends ui.Widget implements event.HasDoubleClickHandlers {
  
	/**
	 * Create new Label component based on [LabelElement] element.
	 */
  Label() {
    setElement(new LabelElement());
  }
  
  /**
   * Set text to LabelElement.
   */
  void set text(String txt) {
    getLabelElement().text = txt;
  }
  
  /**
   * Return text from LabelElement.
   */
  String get text {
    return getLabelElement().text;
  }
  
  /**
   * Return element as LabelElement.
   */
  LabelElement getLabelElement() {
    return getElement() as LabelElement;
  }
  
  /**
   * Add DoubleClickEVentHandler.
   */
  event.HandlerRegistration addDoubleClickHandler(event.DoubleClickHandler handler) {
    return addDomHandler(handler, event.DoubleClickEvent.TYPE);
  }
}