# EXAM FEEDBACK {{STUDENT_ACCOUNT_NAME}}
## 1. Refactoring/debugging [5pt]
- All MUST and SHOULD requirements implemented
**README.md**
- -2 Name not found
- -1 Location of name not correct
- -1 Name not formatted correctly
- -1 Removed the old author(s)
**News page typo**
- -1 typeo in news page is not sufficiently corrected
**Orders index error**
- -2 error is `orders.index` view is not fixed properly
- -1 error is `orders.index` view is attempted to fix but not solved properly

MAY requirements [-0pt]:

`YOUR SCORE: 5 - 0 = 5`

---
## 2. Database & Application scaffolding [15pt]
- All MUST and SHOULD requirements implemented
**Migration**
- -6 Migration not found
- -3 Migration caused some error(s) which was in total easy to fix: [list or name]
- -5 Migration does not create a table 
- -1 Column definitions in the migration lack one or more of the standard Laravel columns
- -1 one of the required attributes is missing in the migration, is not of the correct datatype and/or follow the given constraints
- -2 2 of the required attributes is missing in the migration, is not of the correct datatype and/or follow the given constraints
- -3 3 or more of the required attributes is missing in the migration, is not of the correct datatype and/or follow the given constraints
- -1-# Migration has # extra unspecified attributes (perhaps misunderstood derived attributes?)
**Factory**
- -2 There is no factory implemented
- -2 The factory had too many errors
- -1 Factory does not generate appropriate fake values for 1 or more of the required attributes
- -1 Factory is not used in the seeder
**Seeder**
- -2 Seeder had too many errors
- -1 Seeder had one error which could easily be fixed
- -2 No seeder found
- -1 Seeder doesn't create the required amount instances of the model in the database
- -1 your seeder is not called in the `php artisan db:seed` command
- -1 Seeding generated an error: ``
**Model**
- -1 Model class not found
**Controller**
- -3 Controller class not found
- -1 Missing 1-4 of the RESTful controller methods
- -2 Missing 5-7 of the RESTful controller methods

MAY requirements [-0pt]:
- +1 Other:

`YOUR SCORE: 15 - 0 = 15`

---
## 3. Index [10pt]
- All MUST and SHOULD requirements implemented
**Navigation and layout**
- -1 Navigation is not according the functional design and/or lacks internal consistency
- -7 index method and/or route is not implemented
- -7 Index route contains one or more errors, which were NOT easy to fix: [name or list]
- -7 index route does not show the required index page
- -1 Layout is not according the functional design and/or lacks internal consistency
- -2 Index route contains an error, which was easy to fix: [name or list errors]
**Rows and columns**
- -5 Data is not fetched from the database and passed to the view
- -2 Not all rows are rendered due to bad implementataion of pagination
- -1 Only 3 out of the required 4 attributes are displayed
- -2 Only 2 out of the required 4 attributes are displayed
- -3 Less than 2 of the required 4 attributes are displayed
- -1 1 irrelevant/unspecified attributes is displayed
- -2 2 or more irrelevant/unspecified attributes are displayed
**Business logic & dynamic styling**
- -1 1 or more of the specified business logic value(s) is/are not displayed
- -1 the required Dynamic styling is not applied

MAY requirements [-2pt]:
- +1 Pagination
- +1 Use accessors for business logic
- +1 Other:

`YOUR SCORE: 10 - 0 = 10`
`YOUR SCORE: 10 - 2 = 8`

---
## 4.1 CRUD - Show [7pt]
- All MUST and SHOULD requirements implemented
**Navigation and layout**
- -1 There is no link to the Show route
- -1 Navigation to the show routes are not conform functional design
- -5 show method and/or route is not implemented
- -5 show route does not show the required page
- -2 Show route contains an error, which was easy to fix: [name or list errors]
- -1 Layout is not according the functional design and/or lacks internal consistency
**Page content**
- -4 Show page does not show any atttributes
- -3 Page renders only 1 out of 4 required attributes
- -2 Page renders only 2 out of 4 required attributes
- -1 Page renders only 3 out of 4 required attributes
- -1 Page tries to render 1 unspecified attribute
- -2 Page tries to render more than 1 unspecified attribute
**Business logic & dynamic styling**
- -1 1 or more of the specified business logic value(s) is/are not displayed
- -1 the required Dynamic styling is not applied

MAY requirements [-1pt]:
- +1 Use accessors for business logic
- +1 Other:

`YOUR SCORE: 7 - 0 = 7`
`YOUR SCORE: 7 - 1 = 6`

---
## 4.2 CRUD - Create [13pt]
- All MUST and SHOULD requirements implemented
**CAPS AT 1 - Form page navigation and layout**
- -1 There is no link to the Create route
- -1 Navigation to the Create route is not conform functional design
- -1 Layout of the Create page is not according the functional design and/or lacks internal consistency
**Existence of Create feature**
SKIP OTHER CHECKS UNTIL STORE CONTROLLER METHOD
- -6 Create method and/or route is not implemented
- -6 Create route does not show the required page
- -6 Create page does not show a form
- -6 Create page contains one or more errors, which were NOT easy to fix: [name or list errors]
**Form page content**
- -2 Create page contains one or two errors, which were easy to fix: [name or list errors]
- -2 missing 2 or more required inputs in the form
- -1 missing 1 required inputs in the form
- -1 there are inputs for irrelevant/unspecified attributes
**Happy path**
- -2 Submitting valid user inputs results in one or more errors, which can be fixed easily: [list or name errors]
- -4 Submitting valid user inputs results in one or more errors, which can NOT be fixed easily: [list or name errors]
- -4 Form doesn't submit with valid user input
__CHECK NEXT ONE IN COMBINATION WITH NAVIGATION & LAYOUT ISSUES ABOVE. IT CAPS AT 1__
- -1 Navigation after submit not conform the functional design
**Validation (form input code)**
- -2 Missing more than 1 validation highlighting, error messages and/or repopulation of old values
- -1 Missing 1 validation highlighting, error messages and/or repopulation of old values
- -1 Validation feedback does not fully match the Input Feedback UI pattern
**Store controller method - validation**
- -2 missing the 'at least required' validation rule for more than 1 inputs
- -1 missing the 'at least required' validation rule for 1 input
**Store controller method - item creation and redirect**
- -2 Item is not created
- -1 One or more of the required attribute values is not set
- -1 Post-Redirect-Get pattern not used

MAY requirements [-3pt]:
- +1 Advanced validation
- +1 Client side validation
- +1 Session Flashing
- +1 Other:

`YOUR SCORE: 13 - 0 = 13`
`YOUR SCORE: 13 - 3 = 10`

---
## 4.3 CRUD - Edit [17pt]
- All MUST and SHOULD requirements implemented
**CAPS AT 2 - Form page navigation and layout**
- -1 There are no links to the Edit route
- -1 Navigation to the Edit routes is not conform functional design
- -1 Layout of the Edit page is not according the functional design and/or lacks internal consistency
**Existence of Create feature**
SKIP OTHER CHECKS UNTIL STORE CONTROLLER METHOD
- -13 Edit method and/or route is not implemented
- -13 Edit route does not show the required page
- -13 Edit page does not show a form
- -13 Edit page contains one or more errors, which were NOT easy to fix: [name or list errors]
- -12 Edit page does show a form but it has no (relevant) inputs
**CAPS AT 3 Form page content**
- -2 Edit page contains one or two errors, which were easy to fix: [name or list errors]
- -3 2 of the required inputs in the form is missing
- -2 1 of the required inputs in the form is missing
- -1 there are inputs for irrelevant/unspecified attributes
**Happy path**
- -2 Submitting valid user inputs results in one or more errors, which can be fixed easily: [list or name errors]
- -4 Submitting valid user inputs results in one or more errors, which can NOT be fixed easily: [list or name errors]
- -4 Form doesn't submit with valid user input
__CHECK NEXT ONE IN COMBINATION WITH NAVIGATION & LAYOUT ISSUES ABOVE. IT CAPS AT 2__
- -1 Navigation after submit not conform the functional design
**Validation (form input code)**
__NOTE: following rule CAPS AT 5__
- -# Missing # implementations of validation highlighting, error messages and/or properly (pre)filled with a combination of current and old values
- -1 Validation feedback does not fully match the Input Feedback UI pattern
**Update controller method - validation**
- -2 missing the 'at least required' validation rule for more than 1 inputs
- -1 missing the 'at least required' validation rule for 1 input
**Update controller method - item creation and redirect**
- -3 Existing item is not updated
- -2 Instead of updating an existing item, a new item is created
- -1 One or more of the required attribute values is not set
- -1 Post-Redirect-Get pattern not used

MAY requirements [-3pt]:
- +1 Advanced validation
- +1 Client side validation
- +1 Session Flashing
- +1 Other:

`YOUR SCORE: 17 - 0 = 17`
`YOUR SCORE: 17 - 3 = 14`

---
## 4.4 CRUD - Destroy [8pt]
- All MUST and SHOULD requirements implemented
**Navigation and layout**
- -6 There are no links to the Delete routes
- -1 Navigation to the Destroy routes is not conform functional design
**Existence of Create feature**
SKIP OTHER CHECKS UNTIL DESTROY CONTROLLER METHOD
- -5 Delete route results in one or more errors, which can NOT be fixed easily: [list or name errors]
**Confirmation**
- -2 The user cannot confirm the delete action
- -1 Trying to show the Confirmation results in one or more errors, which can be fixed easily: [list or name errors]
**Happy path**
- -1 Submitting to the delete route results in one or more errors, which can be fixed easily: [list or name errors]
- -2 Submitting to the delete route results in one or more errors, which can NOT be fixed easily: [list or name errors]
- -2 Cannot submit to the delete route
__CHECK NEXT ONE IN COMBINATION WITH NAVIGATION & LAYOUT ISSUES ABOVE. IT CAPS AT 2__
- -1 Navigation after destroy not conform the functional design
**Destroy controller method - item deletion and redirect**
- -1 Existing item is not deleted
- -1 Post-Redirect-Get pattern not used

MAY requirements [-2pt]:
- +1 Modals
- +1 Session Flashing
- +1 Other:

`YOUR SCORE: 8 - 0 = 8`
`YOUR SCORE: 8 - 2 = 6`

---
## 5. Relationships [15pt]
__WHEN NOT IMPLEMENTED__
- -10 Not implemented

MAY requirements [-5]:

`YOUR SCORE: 15 - 15 = 0`
__ELSE__
- All MUST and SHOULD requirements implemented
- **-50%** The entire relationship is defined in reverse direction
- **-50%** There is a relationship defined, but it is not the correct one
**Migration**
- -4 Foreign key definition not found
- -2 Foreign key definition resulted into an error `Failed to open the referenced table` caused by bad migration order
- -2 There is an extra unspecified FK defintion found
- -1 No referential actions specified
- -1 Referential actions are not complete. Missing an `onDelete` and/or `onUpdate` declaration
- -1 Existing migration order is/needs to be modified
- -1 `->nullable()` in the Foreign key definition is not as specified for this relationship
- -1 `->default(...)` in the Foreign key definition is not as specified for this relationship
**Models**
- -2 `hasMany` relationship is not defined (correctly) in the required model
- -2 `belongsTo` relationship is not defined (correctly) in the required model
**Related data presentation**
**version C**
- -2 The Category index page doesn't display the count of related Product objects for each category.
--2 The Category index page does (try to) the count of related Product objects for each category, but it is incorrect or throws an error
--1 The Category index page does (try to) the count of related Product objects for each category, but it is not completely correct
- -1 the Product index page doesn't show the name of each related Category
**version D**
- -2 The Delivery show page doesn't display a list where at least two attributes of the related ProductOrder objects are shown.
- -1 The Delivery show page does (try to) display a list of related ProductOrders, but it is not complete or has errors 
- -1 ProductOrder index page doesn't show the name of each related Delivery
**version S**
- -2 The Supplier show page doesn't display a list where at least two attributes of the related Product objects are shown.
- -1 The Supplier show page does (try to) display a list of related Products, but it is not complete or has errors 
- -1 Product index page doesn't show the name of each related Supplier

MAY requirements [-4]:
- +1 Rollback doesn't properly return the database to the previous state
- +1 Seeders and Factories (when applicable) are updated to create related data
- +1 The model's Create page is expanded to implement the relationship
- +1 The model's Edit page is expanded to implement the relationship
- +1 Other:

`YOUR SCORE: 15 - 0 = 15`
`YOUR SCORE: 15 - 4 = 11`

---
## 6. Handing in [10pt]
- All MUST and SHOULD requirements implemented
- -5 Code not handed in via GitHub

`YOUR SCORE: 10 - 5 = 5`
`YOUR SCORE: 10 - 0 = 10`

---
## VIOLATIONS 

`TOTAL COUNT: # + # = `

### MANUALLY DISCOVERED

### PHPCS ANALYSIS
```
