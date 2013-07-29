part of todo_mvc_app;

/**
 * Implementation of UL element.
 */
class UnorderedList extends ui.ComplexPanel {
  
	/**
	 * Create an instance of UnorderedList.
	 */
  UnorderedList.wrap(UListElement ui) { 
    setElement(ui); 
  } 
  
  /**
   * Add widget to list.
   */
  void addItem(ui.Widget w) { 
    super.addWidget(w, getElement()); 
  } 
  
  /**
   * Insert Widget in position.
   */
  void insertItem(ui.Widget w, int beforeIndex) { 
    super.insert(w, getElement(), beforeIndex, true); 
  } 
}

/**
 * Implementation of LI element.
 */
class ListItem extends ui.ComplexPanel {
  
	/**
	 * Create an instance of LI.
	 */
  ListItem() { 
    setElement(new LIElement()); 
  } 
  
  /**
   * Add content to LI element.
   */
  void addContent(ui.Widget w) { 
    super.addWidget(w, getElement()); 
  } 
  
  /**
   * Insert content into LI in special position.
   */
  void insertContent(ui.Widget w, int beforeIndex) { 
    super.insert(w, getElement(), beforeIndex, true); 
  } 
} 