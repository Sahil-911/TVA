-- set search_path to dbms_project;
-- SELECT * FROM timeline;
-- SELECT * FROM "User";
-- SELECT * FROM project;
-- SELECT * FROM collaborator;
-- select * from local_files;
-- select * from "File";
-- select * from "Line";
-- Update a line
UPDATE "Line"
SET "Content" = "There was a change in this line"
WHERE "Line_id" = 1
     AND "File_id" = 1
     AND "local_id" = 1
     AND "Project_id" = 1;
-- delete a line
UPDATE "Line"
SET "Content" = ""
WHERE "Line_id" = 5
     AND "File_id" = 1
     AND "local_id" = 1
     AND "Project_id" = 1;
-- clear a file
DELETE FROM "Line"
WHERE "File_id" = "<file>"
     AND "local_id" = "<local>"
     AND "Project_id" = "<project>";
-- See who authored the given version
SELECT User_id,
     User_name
FROM "User"
WHERE User_id IN (
          SELECT Updater_id
          FROM "Version"
          WHERE Version_id = 2
               AND Timeline_id = 1
               AND Project_id = 1
     );
-- pull
-- Copy files from one local to another
INSERT INTO "File" (File_id, Local_id, File_name, Project_id)
SELECT File_id,
     2 as Local_id,
     File_name,
     Project_id
FROM "File"
WHERE Local_id = 1
     AND Project_id = 1;
INSERT INTO "Line" (
          Line_id,
          File_id,
          Local_id,
          Project_id,
          Content
     )
SELECT Line_id,
     File_id,
     2 as Local_id,
     Project_id,
     Content
FROM "Line"
WHERE Local_id = 1
     AND Project_id = 1;
-- clear a local
DELETE FROM "Line"
WHERE "local_id" = "<local>"
     AND "Project_id" = "<project>";
DELETE FROM "File"
WHERE "local_id" = "<local>"
     AND "Project_id" = "<project>";
--compare lines of local_files 1 to 2 with project id 
SELECT "Local_1".Line_id,
     "Local_1".File_id,
     "Local_1".Project_id,
     "Local_1".Content AS "Old",
     "Local_2".Content AS "New"
FROM (
          (
               SELECT Line_id,
                    File_id,
                    Project_id,
                    Content
               FROM "Line"
               WHERE Local_id = 1
                    AND Project_id = 1
          ) AS "Local_1"
          FULL OUTER JOIN (
               SELECT Line_id,
                    File_id,
                    Project_id,
                    Content
               FROM "Line"
               WHERE Local_id = 2
                    AND Project_id = 1
          ) AS "Local_2" ON "Local_1".Line_id = "Local_2".Line_id
          AND "Local_1".File_id = "Local_2".File_id
     )
WHERE "Local_1".Content != "Local_2".Content;
-- add changes to the changes table using the upper query
INSERT INTO Change(
          Version_id,
          Timeline_id,
          Project_id,
          File_id,
          Line_id,
          Previous_content,
          New_content
     )
SELECT 1 AS Version_id,
     1 AS Timeline_id,
     "Local_2".Project_id,
     "Local_2".Line_id,
     "Local_2".File_id,
     "Local_1".Content AS Previous_content,
     "Local_2".Content AS New_content
FROM (
          (
               SELECT Line_id,
                    File_id,
                    Project_id,
                    Content
               FROM "Line"
               WHERE Local_id = 1
                    AND Project_id = 1
          ) AS "Local_1"
          FULL OUTER JOIN (
               SELECT Line_id,
                    File_id,
                    Project_id,
                    Content
               FROM "Line"
               WHERE Local_id = 2
                    AND Project_id = 1
          ) AS "Local_2" ON "Local_1".Line_id = "Local_2".Line_id
          AND "Local_1".File_id = "Local_2".File_id
     )
WHERE "Local_1".Content != "Local_2".Content;
-- Revert to the previous version
UPDATE "Line"
SET "Content" = "Change".Previous_content
FROM "Change"
WHERE "Line".Line_id = "Change".Line_id
     AND "Line".File_id = "Change".File_id
     AND "Change".Version_id = 1
     AND "Change".Timeline_id = 1
     AND "Change".Project_id = 1;
--version compare
set search_path to dbms_project;
select *
from timeline;
select *
from "User";
select *
from local_files;
SELECT *
FROM COLLABORATOR;
select *
from "Version";
SELECT *
FROM CHANGE;
SELECT *
FROM "Line";
SELECT ch.line_id,
     ch.file_id,
     prev_content
FROM (
          change
          JOIN (
               select MIN(version_id) as first_version,
                    MAX(version_id) as last_version,
                    line_id,
                    file_id
               from (
                         select *
                         from CHANGE as ch
                              natural join (
                                   SELECT *
                                   from "Version"
                                   where version_id >= 1
                                        and version_id <= 3
                                        and project_id = 1
                                        and timeline_id = 1
                              ) as ver
                    ) as que
               group by line_id,
                    file_id
          ) as ch ON ch.line_id = change.line_id
          and ch.file_id = change.file_id
          and ch.first_version = change.version_id
     ) as t;

     
-- Merge two timelines ( 0 and 1)
-- copy all files and lines which are not in timeline 0
INSERT INTO "File" (File_id, Local_id, File_name, Project_id)
SELECT File_id,
     0 as Local_id,
     File_name,
     Project_id
FROM "File"
WHERE Local_id = 1
     AND Project_id = 1
     AND File_id NOT IN (
          SELECT File_id
          FROM "File"
          WHERE Local_id = 0
               AND Project_id = 1
     );
INSERT INTO "Line" (
          Line_id,
          File_id,
          Local_id,
          Project_id,
          Content
     )
SELECT Line_id,
     File_id,
     0 as Local_id,
     Project_id,
     Content
FROM "Line"
WHERE Local_id = 1
     AND Project_id = 1
     AND Line_id NOT IN (
          SELECT Line_id
          FROM "Line"
          WHERE Local_id = 0
               AND Project_id = 1
     );
     
-- remove latest_local of timeline 1
DELETE FROM "Local_files"
WHERE "Project_id" = 1
     AND "Timeline_id" = 1;

-- remove timeline 1
DELETE FROM "Timeline"
WHERE "Project_id" = 1
     AND "Timeline_id" = 1;