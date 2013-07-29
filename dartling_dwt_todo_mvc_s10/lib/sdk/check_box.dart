part of todo_mvc_app;

/**
 * CheckBox component based on [ui.SimpleCheckBox] supports HasValueChangeHandlers and HasValues.
 */
class CheckBox extends ui.SimpleCheckBox implements event.HasValue<bool> {
  
  bool _valueChangeHandlerInitialized = false;
  
  /**
   * Creates a CheckBox widget that wraps an existing &lt;input
   * type='checkbox'&gt; element.
   *
   * This element must already be attached to the document. If the element is
   * removed from the document, you must call
   * [RootPanel#detachNow(Widget)].
   *
   * @param element the element to be wrapped
   */
  factory CheckBox.wrap(InputElement element) {
    // Assert that the element is attached.
    //assert Document.get().getBody().isOrHasChild(element);

    CheckBox checkBox = new CheckBox(element);

    // Mark it attached and remember it for cleanup.
    checkBox.onAttach();
    ui.RootPanel.detachOnWindowClose(checkBox);

    return checkBox;
  }
  
  /**
   * Creates a new simple checkbox.
   */
  CheckBox([InputElement element = null]) : super(element);
  
  //****************************************
  // Impementation of HasValueChangeHandlers
  //****************************************

  event.HandlerRegistration addValueChangeHandler(event.ValueChangeHandler<bool> handler) {
    // Is this the first value change handler? If so, time to add handlers
    if (!_valueChangeHandlerInitialized) {
      ensureDomEventHandlers();
      _valueChangeHandlerInitialized = true;
    }
    return addHandler(handler, event.ValueChangeEvent.TYPE);
  }
  
  //*******
  // Events
  //*******
  void ensureDomEventHandlers() {
    addClickHandler(new event.ClickHandlerAdapter((event.ClickEvent evt) {
      // Checkboxes always toggle their value, no need to compare
      // with old value. Radio buttons are not so lucky, see
      // overrides in RadioButton
      event.ValueChangeEvent.fire(this, getValue());
    }));
  }

  // Unlike other widgets the CheckBox sinks on its inputElement, not
  // its wrapper
  void sinkEvents(int eventBitsToAdd) {
    if (isOrWasAttached()) {
      event.IEvent.sinkEvents(getInputElement(), eventBitsToAdd | event.IEvent.getEventsSunk(getInputElement()));
    } else {
      super.sinkEvents(eventBitsToAdd);
    }
  }
  
  InputElement getInputElement() {
    return getElement() as InputElement;
  }
  
  //************************
  // HasValue implementation
  //************************
  
  /**
   * Determines whether this check box is currently checked.
   * <p>
   * Note that this <em>does not</em> return the value property of the checkbox
   * input element wrapped by this widget. For access to that property, see
   * {@link #getFormValue()}
   *
   * @return <code>true</code> if the check box is checked, false otherwise.
   *         Will not return null
   */
  bool getValue() {
    if (isAttached()) {
      return getInputElement().checked;
    } else {
      return getInputElement().defaultChecked;
    }
  }

  /**
   * Checks or unchecks the check box, firing {@link ValueChangeEvent} if
   * appropriate.
   * <p>
   * Note that this <em>does not</em> set the value property of the checkbox
   * input element wrapped by this widget. For access to that property, see
   * {@link #setFormValue(String)}
   *
   * @param value true to check, false to uncheck; null value implies false
   * @param fireEvents If true, and value has changed, fire a
   *          {@link ValueChangeEvent}
   */
  void setValue(bool val, [bool fireEvents = false]) {
    if (val == null) {
      val = false;
    }

    bool oldValue = getValue();
    getInputElement().checked = val;
    getInputElement().defaultChecked = val;
    if (val != oldValue && fireEvents) {
      event.ValueChangeEvent.fire(this, val);
    }
  }
}