set search_path to dbms_project;

INSERT INTO "Version" VALUES(2,1,2,4);

-- Compare local 1 and local 3 of project 1 and add changes into change table with version 1
INSERT INTO "Change"(Version_id,  Timeline_id,Project_id, File_id, Line_id, Previous_content, New_content)
SELECT 1 AS Version_id,  1 AS Timeline_id, "Local_2".Project_id,  "Local_2".Line_id, "Local_2".File_id,
     "Local_1".Content AS Previous_content, "Local_2".Content AS New_content
FROM (
( SELECT Line_id, File_id, Project_id, Content FROM "Line" WHERE Local_id = 2 AND Project_id = 1) AS "Local_1"
          FULL OUTER JOIN 
( SELECT Line_id, File_id, Project_id, Content  FROM "Line" WHERE Local_id = 4 AND Project_id = 1) AS "Local_2"
          ON "Local_1".Line_id = "Local_2".Line_id
          AND "Local_1".File_id = "Local_2".File_id
     )
WHERE "Local_1".Content != "Local_2".Content
     OR "Local_1".Content IS NULL
     OR "Local_2".Content IS NULL;


-- Update Local_1
DELETE FROM "File" WHERE Local_id = 2;
INSERT INTO "File"(File_id, Local_id, File_name, Project_id) SELECT File_id,2 as Local_id, File_name, Project_id
FROM "File" WHERE Local_id = 4 AND Project_id = 1;

DELETE FROM "Line" WHERE Local_id = 2;
INSERT INTO "Line"(Line_id,File_id,Local_id,Project_id,Content) SELECT Line_id, File_id,2 as Local_id, Project_id, Content
FROM "Line" WHERE Local_id = 4 AND Project_id = 1;

