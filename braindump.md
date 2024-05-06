

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
Hierarchy
Start date
Due date
Status:
- active
- suspended
- scheduled (start date / or waiting for other goal?/project/task)
- someday
- archived
Star bool
FK user
FK area (null)
FK goal (null)
FK Tags (multi)

### Task
Name
Description
Status:
- inbox
- next
- standalone
- waiting
- schedule start (start date required)
Star (bool)
Start Date
Due Date
Due (enum) ???
Time (enum)
  - 5m
  - 10m
  - 15m
  - 20m
  - 30m
  - 45m
  - 1h
  - 1,5h
  - 2h
  - 3h
  - 4h
  - 5h
  - 6h
  - 8h
FK user
FK area
FK project (null ??? - what about standalone task)

### Tag
name
FK user

### Functionality
- simple overview, retrospection (yearly, monthly, weekly), check goal which overview, add summaries, view achievement from last review
- comments (for goals, projects, tasks)