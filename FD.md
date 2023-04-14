## Project(Project_id,Project_name,Manager_id)

Project_id -> Project_name,Manager_id


## User(User_id,User_name)

User_id -> User_name


## Collaborator(Project_id, User_id, Role)

Project_id, User_id -> Role


## Local_Files(Local_id, Project_id, User_id, Timeline_id)

Local_id , Project_id -> User_id, Timeline_id


## File(File_id, Local_id, File_name, length)

File_id , Local_id -> File_name, length


## Timeline(Timeline_id,Project_id,Latest_Version, Latest_Files)

Timeline_id, Project_id -> Latest_Version

Timeline_id, Project_id -> Latest_Files

Latest_Files -> Timeline_id, Project_id


## Version(Version_id,Timeline_id,Project_id,Updater_id)

Version_id, Timeline_id, Project_id -> Updater_id


## Change(Version_id,Timeline_id,Project_id,Line_id,File_id,Previous_content,New_content)

Version_id, Timeline_id, Project_id,Line_id, File_id -> Previous_content, New_content
