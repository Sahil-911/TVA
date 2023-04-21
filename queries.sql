-- ------------------------------------
-- Not for you...
-- ------------------------------------
-- set search_path to dbms_project;
-- UPDATE PROJECT 
-- SET project_name='Cricbuzz' where project_name='CRICBUZZ';
-- INSERT INTO "File" VALUES(1,1,1,'erdiagram');
-- INSERT INTO "Line" VALUES(1,1,1,1,'This is first line');
-- SELECT * FROM timeline;
-- SELECT * FROM "User";
-- SELECT * FROM project;
-- SELECT * FROM collaborator;
-- select * from local_files;
-- select * from "File";
-- select * from "Line";
--update a line
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