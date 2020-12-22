
#  Novence

Using Core Data, I created this app that saves a list of user inputed products next to their respective expiration date.

## Steps to create the app

### Created numberOfRowsInSection and cellForRowAt functions.

Found in Controller/ListViewController

![First](Documentation/1.png)


### Created an IBAction function so that the user can add new items to the list.

Found in Controller/ListViewController

![Second](Documentation/2.png)

### Created a doDatePicker function so that the user can choose the product's expiration date.

Found in Controller/ListViewController

![Third](Documentation/3.png)

### Created a xib file to store the custom Cell.

Found in View/ProductCell.xib

![Third](Documentation/4.png)

### Created functions to save and load the user inputed data from context.

Found in Controller/ListViewController

![Third](Documentation/5.png)

### Created a function to delete a cell by swiping the screen.

Found in Controller/ListViewController

![Third](Documentation/6.png)

### Made it so the cell changes color depending on how far away the expiration date is.

Found in Model/CellManager

![Third](Documentation/7.png)
