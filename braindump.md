

### Area
Name
Hierarchy
IsDefault (for new goal/project)
FK user

### Tag
Name
FK user

### Goal
Name
Description
LifeArea
Hierarchy
Status:
- active
- important (star)
- suspended
- someday
- archived (closed?)
FK user
FK area

### Project
Name
Description
Area (null)
Goal (null)
Tags
Start date
Due date
Status:
- active
- suspended
- scheduled (start date / or waiting for other goal?/project/task)
- maybe
- archived
FK user
FK area
FK goal (null)

### Task
Name
Description
Status:
- inbox
- standalone
- waiting
- schedule start (start date)
- next
- next with star
  Due (enum)
  Time (enum)
FK user
FK area
FK project (null ??? - what about standalone task)

### Tag
name
FK user

### Functionality
simple overview (yearly, monthly, weekly), check goal which overview, add summaries, view achievement from last review
