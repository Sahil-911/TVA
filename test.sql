SET search_path TO dbms_project;

INSERT INTO "Version" VALUES(2,1,1,4);

UPDATE "Line" SET content = 'The sky was painted in shades of orange and pink as the sun set over the horizon.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 11;
UPDATE "Line" SET content = 'The EndddShe picked up the book and started reading, losing herself in the story.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 12;
UPDATE "Line" SET content = 'The sound of the waves crashing against the shore was soothing.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 13;
UPDATE "Line" SET content = 'He couldnt believe his eyes when he saw the size of the fish he had caught.He couldnt believe his eyes when he saw the size of the fish he had caught.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 14;
UPDATE "Line" SET content = 'The aroma of freshly baked bread filled the air.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 15;

INSERT INTO "Change"(Version_id,  Timeline_id,Project_id, File_id, Line_id, Previous_content, New_content)
SELECT 1 AS Version_id, 2 AS Timeline_id, "Local_2".Project_id,  "Local_2".Line_id, "Local_2".File_id,
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


DELETE FROM "File" WHERE Local_id = 2;
INSERT INTO "File"(File_id, Local_id, File_name, Project_id) SELECT File_id,1 as Local_id, File_name, Project_id
FROM "File" WHERE Local_id = 4 AND Project_id = 1;

DELETE FROM "Line" WHERE Local_id = 2;
INSERT INTO "Line"(Line_id,File_id,Local_id,Project_id,Content) SELECT Line_id, File_id, 1 as Local_id, Project_id, Content
FROM "Line" WHERE Local_id = 4 AND Project_id = 1;

SET search_path TO dbms_project;

INSERT INTO "Version" VALUES(2,1,3,4);

UPDATE "Line" SET content = 'The sky was painted in shades of orange and pink as the sun set over the horizon.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 11;
UPDATE "Line" SET content = 'The EndddShe picked up the book and started reading, losing herself in the story.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 12;
UPDATE "Line" SET content = 'The sound of the waves crashing against the shore was soothing.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 13;
UPDATE "Line" SET content = 'He couldnt believe his eyes when he saw the size of the fish he had caught.He couldnt believe his eyes when he saw the size of the fish he had caught.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 14;
UPDATE "Line" SET content = 'The aroma of freshly baked bread filled the air.' WHERE local_id = 4 AND project_id = 1 AND file_id = 3 AND line_id = 15;

INSERT INTO "Change"(Version_id,  Timeline_id,Project_id, File_id, Line_id, Previous_content, New_content)
SELECT 1 AS Version_id, 2 AS Timeline_id, "Local_2".Project_id,  "Local_2".Line_id, "Local_2".File_id,
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


DELETE FROM "File" WHERE Local_id = 2;
INSERT INTO "File"(File_id, Local_id, File_name, Project_id) SELECT File_id,1 as Local_id, File_name, Project_id
FROM "File" WHERE Local_id = 4 AND Project_id = 1;

DELETE FROM "Line" WHERE Local_id = 2;
INSERT INTO "Line"(Line_id,File_id,Local_id,Project_id,Content) SELECT Line_id, File_id, 1 as Local_id, Project_id, Content
FROM "Line" WHERE Local_id = 4 AND Project_id = 1;