Timeline(Timeline_id,Project_id,Latest_Version)
Timeline_id, Project_id -> Latest_Version

Version(Version_id,Timeline_id,Project_id,Updater_id)
Version_id, Timeline_id, Project_id -> Updater_id

Change(Version_id,Timeline_id,Project_id,Line_id,File_id,Previous_content,New_content)
Version_id, Timeline_id, Project_id,Line_id, File_id -> Previous_content, New_content


