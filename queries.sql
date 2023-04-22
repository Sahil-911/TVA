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
--version compare
select sm,
     mx,
     li as line_id,
     fi as file_id,
     firs.previous_content,
     cha.new_content
from (
          select *
          from (
                    select min(version_id) as sm,
                         max(version_id) as mx,
                         line_id as li,
                         file_id as fi
                    from change
                    where project_id = 1
                         and timeline_id = 1
                    group by line_id,
                         file_id
               ) as que
               join change as ch on que.li = ch.line_id
               and que.fi = ch.file_id
               and sm = ch.version_id
          where project_id = 1
               and timeline_id = 1
     ) as firs
     join change as cha on firs.li = cha.line_id
     and firs.fi = cha.file_id
     and mx = cha.version_id
where cha.project_id = 1
     and cha.timeline_id = 1
     and sm >= 2
     and mx <= 4;
--💥 Show file history line-wise ❗ 
select version_id,
     timeline_id,
     file_id,
     line_id,
     previous_content,
     new_content,
     user_name as updater_name
from (
          (
               select *
               from (
                         select max(version_id) as mx,
                              line_id as li
                         from change
                         where project_id = 1
                              and timeline_id = 1
                              and file_id = 1
                         group by line_id
                    ) as que
                    join change as ch on que.li = ch.line_id
                    and mx = ch.version_id
               where project_id = 1
                    and timeline_id = 1
                    and file_id = 1
          ) as fir
          natural join "Version"
     ) as sec
     join "User" on updater_id = user_id;
--Analyse each contributor's gross contribution using aggregation operations
select user_id,
     user_name,
     change
from (
          select COUNT(*) as change,
               user_id
          from (
                    change
                    natural join "Version"
               ) as ch
               join "User" on user_id = updater_id
          where project_id = 1
          group by user_id
     ) as e
     natural join "User";
-- merge conflicts (compare latest versions of two timelines)

select t1.line_id,
     t1.file_id,
     t1.content as t1_content,
     t2.content as t2_content
from (
          (
               select *
               from "Line"
               where local_id = 1
                    and project_id = 1
          ) as t1
          JOIN (
               select *
               from "Line"
               where local_id = 2
                    and project_id = 1
          ) as t2 ON t1.line_id = t2.line_id
          and t1.file_id = t2.file_id
     )
where t1.content != t2.content;