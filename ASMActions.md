# Pep9 Actions
An inventory of all the actions that a user can perform in the Pep9 Desktop App.  
Note that all items in *italics* are also featured on the toolbar.    

#### File Menu
- *New*
- *Open*

All these `save` actions can be grouped into one "Save" button (UIBarButtonItem).

- *Save Source*
- Save Object
- Save Listing

The equivalent of a `print` action on mobile devices might be some export actions.  Email export (with attachments) is straightforward to implement.  Good first step.     

- Print Source
- Print Object
- Print Listing

#### Edit Menu ####

Undo, Redo, Cut, Copy, and Paste are provided by the OS.

- *Undo*
- *Redo*
- Cut
- Copy
- Paste

We can find a place for these.

- Format From Listing
- Remove Error Messages

#### Build Menu ####

- Assemble
- Load
- Execute
- Run Source
- Run Object
- Start Debugging Source
- Start Debugging Object
- Start Debugging Loader
- Stop Debugging
- Interrupt Execution

#### System Menu ####

These will be embedded in the interface.  Controlling the interface via a menu does not have an equivalent in the mobile paradigm.  Users want to manipulate the views via touch.   

- Code Only
- Code/CPU
- Code/CPU/Memory
- Code Tab
- Trace Tab
- Batch I/O Tab
- Terminal Tab
- Enter Full Screen

#### System Menu ####

We can find a place for these.

- Clear Memory
- Redefine Mnemonics...
- Assembler/Install New OS
- Reinstall Default OS

#### Help Menu ####

This whole section is done!

- Writing Programs
- Debugging Programs
- Writing Trap Handlers
- Pep/9 Reference
- Examples


